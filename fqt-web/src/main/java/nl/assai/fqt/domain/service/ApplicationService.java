package nl.assai.fqt.domain.service;

import ar.com.fdvs.dj.core.DynamicJasperHelper;
import ar.com.fdvs.dj.core.layout.ListLayoutManager;
import ar.com.fdvs.dj.domain.DynamicReport;
import ar.com.fdvs.dj.domain.builders.FastReportBuilder;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import nl.assai.fqt.domain.model.fqt.QueryResult;
import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.model.fqt.Login;
import nl.assai.fqt.domain.model.fqt.User;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.io.File;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ApplicationService {

    @Autowired
    @Qualifier("fqtRepository")
	private FqtRepository fqtRepository;

	private QueryService queryService;
	private String currentUsername;

    @Autowired
    public void setQueryService(QueryService queryService) {
        this.queryService = queryService;
    }

	// === LOGIN ===

	public User login(String username, String password) throws SQLException {
	    Login login = new Login();
	    login.setUsername(username);
	    login.setPassword(password);
		User user = fqtRepository.getUserByName(username.toLowerCase());
//        String hashPassword = fqtRepository.hashPassword(password);
        long userId = 0;
        if (user != null) {
            user.setPassword(password);
            userId = fqtRepository.getUserIdByUserNamePassword(user);
        }
		if (user != null && user.getId().equals(userId)) {
		    login.setResult("1");
            fqtRepository.insertLogin(login);
		    currentUsername = username;
			return user;
		} else {
		    login.setResult("0");
            fqtRepository.insertLogin(login);
		    currentUsername = null;
			return null;
		}
	}

    public String getCurrentUsername() {
        return currentUsername;
    }
    
    public void setCurrentUsername(String currentUsername) {
		this.currentUsername = currentUsername;
	}

    // === Change Password ===

	/**
	 * Returns false when current and new password are not equal, otherwise true.
	 */
    public boolean changePassword(User user, String currentPassword, String newPassword) throws SQLException {
    	if (!user.getPassword().equals(currentPassword)) {
    		return false;
    	} else {
    		user.setPassword(newPassword);
            fqtRepository.changePassword(user);
    		return true;
    	}
    }

    public File generateReport(Query query, Connection connection) throws Exception {

    	QueryResult queryResult = queryService.executeQuery(query, connection, new ResultSetToQueryResult());

		FastReportBuilder builder = new FastReportBuilder();

		for (QueryResult.Column column : queryResult.getColumns()) {
			builder.addColumn(column.getName(), column.getName(), column.getType(), column.getWidth());
		}

        DynamicReport report = builder
            .setTitle(query.getDescription())
            .setPrintBackgroundOnOddRows(true)
            .setUseFullPageWidth(true)
            .build();

        List<Map<String, Object>> results = queryResult.getResults();

        JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(results);
		JasperPrint print = DynamicJasperHelper.generateJasperPrint(report, new ListLayoutManager(), dataSource);
		JasperExportManager.exportReportToPdfFile(print, "report.pdf");

        return new File("report.pdf");
    }

    private static class ResultSetToQueryResult implements QueryService.ResultSetHandler<QueryResult> {

        public QueryResult handle(ResultSet resultSet) throws SQLException {

        	final SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");

        	MapListHandler handler = new MapListHandler(new BasicRowProcessor() {

                @Override
        		public Map<String, Object> toMap(ResultSet resultSet) throws SQLException {

        			HashMap<String, Object> map = new HashMap<String, Object>();
                	ResultSetMetaData metaData = resultSet.getMetaData();

                	for (int columnIndex = 1; columnIndex <= metaData.getColumnCount(); columnIndex++) {

                		String columnName = metaData.getColumnName(columnIndex);
                		Object value = resultSet.getObject(columnIndex);

                		if (value instanceof java.sql.Date) {
                			map.put(columnName, dateFormat.format(value));
                		}
                        else {
                			map.put(columnName, value != null ? value.toString() : null);
                		}
                	}
                	return map;
        		}
        	});

        	List<Map<String, Object>> list = handler.handle(resultSet);

        	QueryResult queryResult = new QueryResult();
        	queryResult.setResults(list);

        	ResultSetMetaData metaData = resultSet.getMetaData();

        	for (int columnIndex = 1; columnIndex <= metaData.getColumnCount(); columnIndex++) {

        		String columnName = metaData.getColumnName(columnIndex);
        		String columnType = metaData.getColumnClassName(columnIndex);
        		int columnWidth = metaData.getColumnDisplaySize(columnIndex);

        		if (columnType.equals("java.sql.Timestamp")) {
        			columnWidth *= 2;
        		}

        		queryResult.addColumn(columnName, "java.lang.String", columnWidth);
        	}

            return queryResult;
        }
    }
}

