package nl.assai.fqt.web.queries;

import nl.assai.fqt.domain.service.FqtRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import nl.assai.fqt.domain.model.fqt.Query;


public class DrillDown {

    private static final Logger logger = LoggerFactory.getLogger(DrillDown.class);
    
	private String[] queryInfo;
	private FqtRepository fqtRepository;

	public enum DrillDownAction {
    	TABLEDETAILS,
    	CLOB,
    	RUNREPORT,
    	SHOWREPORT,
    	REPORTCLOB
    }

    public DrillDown(String[] queryInfo, FqtRepository fqtRepository) {
    	this.queryInfo = queryInfo;
    	this.fqtRepository = fqtRepository;
    }

    public Query generateQuery() {
    	DrillDownAction action = DrillDownAction.valueOf(queryInfo[0].toUpperCase());
    	Query query = null;

    	switch (action) {
	    	case TABLEDETAILS:
	    		query = getTableDetailsQuery();
	    		break;

	    	case CLOB:
		    	query = getClobQuery();
				break;

		    case RUNREPORT:
		    	query = getRunReportQuery();
				break;

		    case SHOWREPORT:
		    	query = getShowReportQuery();
				break;

		    case REPORTCLOB:
		    	query = getReportClobQuery();
				break;
    	}

    	return query;
    }

	private Query getReportClobQuery() {
		return getPreparedQueryWithParam(queryInfo[1]);
	}

	private Query getShowReportQuery() {
		return getPreparedQuery(queryInfo[1]);
	}

	private Query getRunReportQuery() {
		return getPreparedQueryWithParam(queryInfo[1]);
	}

	private Query getClobQuery() {
	    String columnName = queryInfo[1];
        String tableName = queryInfo[2];
        String keyname = queryInfo[3];
        String keyvalue = queryInfo[4];
        String content_type = "text/plain";
        String linktext = tableName + "." + columnName;
        if (queryInfo.length > 5) {
            content_type = queryInfo[5];
        }
        if (queryInfo.length > 6) {
            linktext = queryInfo[6];
        }

        String statement = "SELECT " + columnName + " CLOBREPORT FROM " + tableName + " WHERE " + keyname + " = '" + keyvalue + "'";
        logger.debug("Clob statement = " + statement);

        Query query = new Query();
        query.setName(linktext);
        query.setStatement(statement);

        return query;
	}

	private Query getTableDetailsQuery() {
		String tableName = queryInfo[1];
		String columnName = queryInfo[2];
		String columnValue = queryInfo[3];

		//TODO: remove this line as soon as the journaling tables have been created
		//if (tableName.endsWith("_JN")) tableName = tableName.substring(0, tableName.length() - 3);

		String statement = "SELECT * FROM " + tableName + " WHERE " + columnName + " = " + columnValue;

		Query query = new Query();
		query.setName("table details of " + tableName);
		query.setStatement(statement);

		return query;
	}

	private Query getQueryByName(String name) {
        return fqtRepository.getQueryByName(name);
	}

	private Query getPreparedQuery(String request) {
		String queryName = request.split("=")[1];

		return getQueryByName(queryName);
	}

	private Query getPreparedQueryWithParam(String request) {
		String[] params = request.split("&");
		String queryName = params[0].split("=")[1];
		Query query = getQueryByName(queryName);
				
		for (int i = 1; i < params.length; i++) {
			String key = params[i].split("=")[0];
			String value = params[i].split("=")[1];
			query.setParam(key, value);
		}
		
		return query;
	}
}
