package nl.assai.fqt.web.queries;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;

import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.domain.service.QueryService;
import nl.assai.fqt.domain.model.fqt.Action;
import nl.assai.fqt.web.ui.AbstractWindow;
import nl.assai.fqt.web.ui.RequiredTextField;

import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.vaadin.data.Property;
import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.event.ShortcutAction;
import com.vaadin.event.Action.Handler;
import com.vaadin.terminal.FileResource;
import com.vaadin.ui.Button;
import com.vaadin.ui.CheckBox;
import com.vaadin.ui.ComboBox;
import com.vaadin.ui.Component;
import com.vaadin.ui.Field;
import com.vaadin.ui.Form;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.PopupDateField;
import com.vaadin.ui.Select;
import com.vaadin.ui.Table;
import com.vaadin.ui.TextField;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.Table.ColumnGenerator;
import com.vaadin.ui.themes.Reindeer;
import org.springframework.beans.factory.annotation.Qualifier;

public class QueryWindow extends AbstractWindow {

    private static final int REPORT_PARAMS_SIZE = 3; // regular runreport parameters are ['runreport' | 'reportclob' | 'showreport', query, reportname]

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

	private Form queryForm;
    private Table resultsTable;
	private Query query;
	private Result result;
    private Connection explicitConnection;
    private CheckBox exportToCSV;
    private CheckBox showDescription;
    private Button downloadButton;
    private String path;
    private String uniqueFileName;
    private String description;
    private String queryLinkName;
    private String queryName;
    private String connectionName;
    private final ShortcutAction enterKey = new ShortcutAction("Execute",
        ShortcutAction.KeyCode.ENTER, null);

    @Autowired
    private QueryService queryService;

    @Autowired
    private Properties config;

    private static final Logger logger = LoggerFactory.getLogger(QueryWindow.class);

	public QueryWindow(Query query) {
    	this.query = query;
    }
	
	public QueryWindow(Query query, Connection connection) {
		this(query);
        explicitConnection = connection;
    }

    public QueryWindow(String queryName, String connectionName) {
        this.queryName = queryName;
        this.connectionName = connectionName;
    }

    private void getQueryAndConnection() {
        query = fqtRepository.getQueryByName(queryName);
        if (connectionName != null) {
            explicitConnection = fqtRepository.getConnectionByName(connectionName);
        }
    }

    @Override
    protected void initLayout() {

        if (query == null) {
            getQueryAndConnection();
        }

    	VerticalLayout layout = new VerticalLayout();
    	layout.addComponent(createQueryForm());
    	layout.addComponent(createButtons());
    	Table table = createResultsTable();
    	layout.addComponent(table);
    	layout.setExpandRatio(table, 0.9f);

    	layout.setSpacing(true);
    	layout.setMargin(true);
    	layout.setSizeFull();

    	setCaption("Execute Report : " + query.getName());
    	setResizable(true);
    	setContent(layout);
    	setModal(true);
    	center();
    	setWidth("80%");
    	setHeight("100%");
    	
        addActionHandler(new Handler() {
            public com.vaadin.event.Action[] getActions(Object target, Object sender) {
                return new com.vaadin.event.Action[] { enterKey };
            }

            public void handleAction(com.vaadin.event.Action action, Object sender, Object target) {
                execute();
            }
        });
  	}

    private Table createResultsTable() {

        resultsTable = new Table();
        resultsTable.setSizeFull();
        resultsTable.setVisible(false);

        return resultsTable;
    }

	private Form createQueryForm() {

        queryForm = new Form();
		
        description = (query.getDescription() == null ? "" : query.getDescription());
        boolean noInputParams = false;
        if (query.getParams().length == 0 
          || (query.getParams().length == 1 && "connection".equals(query.getParams()[0]))) {
            noInputParams = true;
        }
        if (noInputParams) {
            description += "<br>Query has no parameters, hit exceute for running report";
		} else {
			for (final String param : query.getParams()) {
                if (param.startsWith("datum_")) {
                    PopupDateField field = new PopupDateField() {
                        //This is needed to show Dutch error message
                        @Override
                        protected Date handleUnparsableDateString(String dateString)
                                throws Property.ConversionException {
                            throw new Property.ConversionException(param + " is not in the proper format");
                        }
                    };
                    field.setCaption(param);
					field.setResolution(PopupDateField.RESOLUTION_DAY);
					field.setDateFormat("yyyyMMdd");
					//Set current date as default value
					field.setValue(new Date());
					//TODO are dates always required?
					field.setRequired(true);
					field.setRequiredError(param + " is mandatory");

					queryForm.addField(param, field);
                } else {
					boolean required = param.endsWith("_verplicht");
					TextField field = (required) ? new RequiredTextField(param) : new TextField(param);
					field.setWidth("300px");
					//Show parameter value of drill-down query [ABKR-166]
					String paramValue = query.getParam(param);
					if (paramValue != null) field.setValue(paramValue);
					//Prevent connection field from being added twice [ABKR-164]
					if (!param.equals("connection")) queryForm.addField(param, field);
				}
			}
		}
        queryForm.setDescription("");

        ComboBox connectionsComboBox = hasExplicitConnection()
                ? createSingleConnectionComboBox(explicitConnection)
                : createConnectionsComboBox();

        queryForm.addField("connection", connectionsComboBox);

		return queryForm;
	}

    private boolean hasExplicitConnection() {
        return explicitConnection != null;
    }

    private ComboBox createSingleConnectionComboBox(Connection connection) {

        ComboBox comboBox = createComboBox(Collections.singletonList(connection));
        comboBox.setEnabled(false);

        return comboBox;
    }

    private ComboBox createConnectionsComboBox() {
        List<Connection> connections;
        connections = fqtRepository.findConnectionsForQueryAndUser(query, getUser());
        return createComboBox(connections);
    }

    private ComboBox createComboBox(List<Connection> connections) {

    	//In order to get it to show the names of the connections you have to do all this.
    	//See http://vaadin.com/book/-/page/components.selecting.html
    	BeanItemContainer<Connection> beanItemContainer = new BeanItemContainer<Connection>(Connection.class);
    	for (Connection connection : connections) {
			beanItemContainer.addItem(connection);
		}
        ComboBox comboBox = new ComboBox("Connection", beanItemContainer);
        comboBox.setItemCaptionMode(Select.ITEM_CAPTION_MODE_PROPERTY);
        comboBox.setItemCaptionPropertyId("name");

        comboBox.setRequired(true);
        comboBox.setNullSelectionAllowed(false);

        if (!connections.isEmpty()) {
            comboBox.select(connections.get(0));
            
        }
        
        return comboBox;
    }
        

	private HorizontalLayout createButtons() {
    	Button executeButton = new Button("Execute");
    	executeButton.setImmediate(true);
    	executeButton.focus();
    	executeButton.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
			    execute();
			}
		});

    	Button cancelButton = new Button("Close");
    	cancelButton.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				close();
			}
		});

    	downloadButton = new Button("Download CSV file");
    	downloadButton.setVisible(false);
    	downloadButton.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				download(new File(path, uniqueFileName));
			}
		});
    	
    	
    	exportToCSV = new CheckBox("Export to CSV");
    	
    	showDescription = new CheckBox("Show description");
    	showDescription.setImmediate(true);
    	showDescription.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				boolean checked = event.getButton().booleanValue();
				if (checked) queryForm.setDescription(description.replaceAll("\n", "<br>"));
				else queryForm.setDescription("");
			}
		});

    	HorizontalLayout buttons = new HorizontalLayout();
    	buttons.addComponent(executeButton);
    	buttons.addComponent(cancelButton);
    	buttons.addComponent(exportToCSV);
    	buttons.addComponent(showDescription);
    	buttons.addComponent(downloadButton);
    	buttons.setSpacing(true);

    	return buttons;
	}

	private void exportToCSV() {

		try {
			String newLine = System.getProperty("line.separator");
			String slash = System.getProperty("file.separator");
			path = config.getProperty("FQT_EXCEL_DL_ROOT_OS_DIR");
			
			// Create directory if it does not yet exist
			File dirPath = new File(path);
			if (!dirPath.exists()) {
			    dirPath.mkdirs();
			}
			
			if (!path.endsWith(slash)) path += slash;
	        uniqueFileName = getUniqueFileName() + ".csv";

			FileWriter writer = new FileWriter(path + uniqueFileName);
			
			appendColumnHeadersToCSV(writer, newLine);
			appendColumnsToCSV(writer, newLine);			
			appendMetaDataToCSV(writer, newLine);

			writer.flush();
		    writer.close();
		    getWindow().showNotification("CSV file created", Notification.TYPE_TRAY_NOTIFICATION);
		} catch (IOException e) {
		    logger.error("Failed to export to CSV", e);
		    throw new RuntimeException(e);
		}
	}
	
	private void appendColumnHeadersToCSV(FileWriter writer, String newLine) 
	        throws IOException {
		boolean first = true;
		Map<String, Class<?>> columnHeaders = result.getMetadata();
		for (String columnHeader : columnHeaders.keySet()) {
		    if (!first) {
		        writer.append(';');
		    }
			writer.append(columnHeader);
			first = false;
		}		
		writer.append(newLine);
	}
	
	private void appendColumnsToCSV(FileWriter writer, String newLine) 
	        throws IOException {
		boolean first;
		LinkedHashSet<String> columnHeaders = 
			    new LinkedHashSet<String>(result.getMetadata().keySet());
		List<Map<String, Object>> rows = result.getResult();
        for (int i = 0; i < rows.size(); i++) {
        	first = true;
        	Map<String, Object> columns = rows.get(i);
        	//Iterate over the columns using the same order as the column headers
        	for (String columnHeader : columnHeaders) { 
        		Object column = columns.get(columnHeader);
        	    if (!first) {
                    writer.append(';');
                }
                if (column != null) {
                    writer.append(column.toString());
                } else {
                    writer.append("");
                }
                first = false;
        	}
        	writer.append(newLine);
        }			
	}
	
	private void appendMetaDataToCSV(FileWriter writer, String newLine) throws IOException {
		writer.append(newLine);
		writer.append("Vraagsteller," + getUser().getName() + newLine);
		writer.append("Tijdstip, " + new SimpleDateFormat("yyyyMMdd'T'HH':'mm':'ss").format(new Date()) + newLine);
		writer.append(newLine);
		writer.append("Vraag," + query.getName() + newLine);
		writer.append("Omschrijving," + query.getShortDescription() + newLine);
		writer.append(newLine);
		for (String param : query.getParams()) {
			if(!param.equals("connection")) {
			writer.append(param + "," + query.getParam(param) + newLine);
			}
		}
		writer.append(newLine);
		writer.append("Database" + newLine);
		writer.append("Connectionname," + getSelectedConnection().getName() + newLine);
		writer.append("Schemaname," + getSelectedConnection().getUsername() + newLine);
		writer.append("Servicename," + getSelectedConnection().getServicename() + newLine);
		writer.append("Description," + getSelectedConnection().getDescription() + newLine);
	}

	private String getUniqueFileName() {
		String userName = getUser().getName();
        String prefix   = userName;
        Integer name_length = userName.indexOf('@');
        if (name_length <= 0) {
            prefix = userName;
        }  else {
            prefix = userName.substring(0, userName.indexOf('@'));
        }
        String timestamp = new SimpleDateFormat("yyyyMMdd'T'HHmmss").format(new Date());
		String queryName = (query.getName() != null) ? query.getName().replaceAll(" ", "_") : "tmpQuery";

		return prefix + "_" + timestamp + "_" + queryName;
	}

	public void setExportToCSV(boolean value) {
		exportToCSV.setValue(value);
	}
	
	private void download(File file) {
		getApplication().getMainWindow().open(new FileResource(file, getApplication()), "_new");
	}

	private void execute() {
		queryForm.setValidationVisible(true);
	    if (!queryForm.isValid()) {
	        return; //don't execute query
	    }
	    
	    String lowerCaseStatement = query.getStatement().toLowerCase(Locale.ENGLISH).trim();
	    if (!lowerCaseStatement.startsWith("select")) {
		    	getWindow().showNotification("Niet een valide select statement");
		    	return; 
	    }
	    
		setParametersOnQuery();
		executeQuery();
	}
	
	private void executeQuery() {

	    Action action = new Action();
	    String actionValue = query.getName();
	    actionValue += " @ " + getSelectedConnection().getName();
	    actionValue += ", " + getSelectedConnection().getUsername();
	    action.setAction("runReport: " + actionValue); 
	    action.setUsername(getApplicationService().getCurrentUsername());
	    fqtRepository.insertAction(action);
	    
        setCaption("Rapport uitvoeren: " + query.getName());
		//final Result result;

        try {
            result = queryService.executeQuery(query, getSelectedConnection(), new ResultHandler());
        }
        catch (SQLException e) {
            logger.warn("failed to execute query '" + query.getName() + "': " + e.getMessage(), e);
            getWindow().showNotification(e.getMessage(), Notification.TYPE_ERROR_MESSAGE);
            resultsTable.setVisible(false);
            return;
        }
        
        //Don't fill/show table when export is chosen
        if (checkAndPerformExport()) {
        	return;
        }
        
        //If it's a clob, just show it on click (don't show a link that shows it on click)
        if (result.getResult().size() > 0 && result.getResult().get(0).containsKey("CLOBREPORT")) {
            getApplication().getMainWindow().addWindow(new ClobWindow(extractClobValue(result), queryLinkName));
            return;
        }
        else {
            //If this is a drill down Query it is not yet visible
            this.setVisible(true);
        }

        resultsTable.setContainerDataSource(new QueryResultContainer(result));
        resultsTable.setVisible(true);        
        removeGeneratedColumns();

        for (Object columnHeader : resultsTable.getVisibleColumns()) {
        	addGeneratedColumn(columnHeader, result);
        }
	}
	
	private String extractClobValue(Result result) {
	    StringBuilder clob = new StringBuilder();
	    
	    List<Map<String, Object>> records = result.getResult();
	    for (Map<String, Object> record : records) {
	        Object clobValue = record.get("CLOBREPORT");
	        if (clobValue != null) {
	            clob.append(clobValue.toString());
	        }
	    }
	    
	    return clob.toString();
	}

	private void removeGeneratedColumns() {
		for (Object columnHeader : resultsTable.getVisibleColumns()) {
        	resultsTable.removeGeneratedColumn(columnHeader);
        }
	}

	private void addGeneratedColumn(Object columnHeader, final Result result) {

		resultsTable.addGeneratedColumn(columnHeader, new ColumnGenerator() {

			public Component generateCell(Table source, Object itemId, Object columnId) {
			    List<Map<String, Object>> resultList = result.getResult();
			    Integer itemIdAsInteger = (Integer) itemId;
			    //This was a bug (issue ABKR-139) but it seemed to disappear (due to a DB change?)
			    //TODO remove this if statement it seems stable
			    if (itemIdAsInteger >= resultList.size()) {
                    StringBuilder errorMsg = new StringBuilder("Probeert out of bounds array element op te halen");
			        errorMsg.append("\nsource is " + source);
			        errorMsg.append("\nitemId is " + itemId);
			        errorMsg.append("\nresultList.size() is " + resultList.size());
			        errorMsg.append("\ncolId is " + columnId);
			        logger.error(errorMsg.toString());
			        return null;
			    }
			    Map<String, Object> resultMap = resultList.get(itemIdAsInteger);
			    if (resultMap == null || resultMap.get(columnId) == null) {
			        logger.debug("empty resultMap = " + resultMap);
			        logger.debug("empty value = " + (resultMap == null ? "not applicable" : resultMap.get(columnId)));
			        return null;
			    }
			    
			    final String value = resultMap.get(columnId).toString();
				final String[] params = value.substring(1).split("#");
				if (value.startsWith("#tabledetails#") ||
					value.startsWith("#clob#") ||
					value.startsWith("#showreport#") ||
					value.startsWith("#ReportClob#")) {

					return createQueryLink(columnId.toString(), value, params);
				}
				//Use a different caption (ABKR-244)
				else if (value.startsWith("#runreport#")) {
					if (params.length >= 3) {
						return createQueryLink(params[2], value, params);						
					}
					else {
						return createQueryLink(columnId.toString(), value, params);
					}					
				}
				else return new Label(value);
            }
        });

	}

	private Button createQueryLink(final String caption, String description, final String[] params) {
		Button queryLink = new Button(caption);
        queryLink.setStyleName(Reindeer.BUTTON_LINK);
        queryLink.setDescription(description);

        queryLink.addListener(new Button.ClickListener() {
			public void buttonClick(ClickEvent event) {
			    //Show query in new popup
			    Query query = createDrillDownQuery(params);
			    Connection connection = getDrillDownConnection(params);
			    
			    QueryWindow drillDownQueryWindow = new QueryWindow(query, connection);
			    getParent().addWindow(drillDownQueryWindow);
			    //Needed for the caption of a clob popup (ABKR-224)
			    drillDownQueryWindow.setQueryLinkName(caption);
			    // Don't show this until we know it's not a clob popup 
			    // (clob popups don't need to show a QueryWindow)
			    drillDownQueryWindow.setVisible(false);
			    //Pass the export checkbox value to the new window (ABKR-220)
			    if (exportToCSV.booleanValue()) drillDownQueryWindow.setExportToCSV(true);
			    drillDownQueryWindow.executeQuery();	
			}
		});

        return queryLink;
	}
	
	private Connection getDrillDownConnection(String[] params) {
	    String lastParam = null;
	    Connection connection = getSelectedConnection();
        if (params.length > REPORT_PARAMS_SIZE && 
                (params[0].equalsIgnoreCase("runreport") || 
                 params[0].equalsIgnoreCase("reportclob") ||
                 params[0].equalsIgnoreCase("showreport")
                 )) {
            lastParam = params[params.length - 1];
            connection = fqtRepository.getConnectionByName(lastParam);
            if (connection != null) {
                logger.debug("Change drilldown connection to: " + lastParam);
            }
        }
        return connection;
	}

	private boolean checkAndPerformExport() {
		if (exportToCSV.booleanValue()) {
			exportToCSV();
			downloadButton.setVisible(true);
			return true;
		}
		else {
			downloadButton.setVisible(false);
			return false;
		}
	}
	
	private Query createDrillDownQuery(String[] params) {
		DrillDown drillDown = new DrillDown(params, fqtRepository);
        return drillDown.generateQuery();	
	}

    private Connection getSelectedConnection() {
        return (Connection) queryForm.getField("connection").getValue();
    }

    @SuppressWarnings("unchecked")
    private void setParametersOnQuery() {

        for (String propertyId : (Collection<String>) queryForm.getItemPropertyIds()) {

            Field field = queryForm.getField(propertyId);
            String fieldValue;

            if (field instanceof PopupDateField) {
                SimpleDateFormat dateFormat = new SimpleDateFormat(((PopupDateField) field).getDateFormat());
                fieldValue = dateFormat.format(field.getValue());
            }
            else if (field.getValue() != null) {
                fieldValue = field.getValue().toString();
            }
            else {
                fieldValue = null;
            }

            query.setParam(propertyId, fieldValue);
        }
    }

    public void setQueryLinkName (String queryLinkName) {
    	this.queryLinkName = queryLinkName;
    }
    
    private static class ResultHandler implements QueryService.ResultSetHandler<Result> {

        public Result handle(ResultSet resultSet) throws SQLException {

            List<Map<String, Object>> result = new MapListHandler(new StringRowProcessor()).handle(resultSet);
            LinkedHashMap<String, Class<?>> columnClasses = new LinkedHashMap<String, Class<?>>();

            for (int i = 1; i <= resultSet.getMetaData().getColumnCount(); i++) {
                String columnLabel = resultSet.getMetaData().getColumnLabel(i);
                columnClasses.put(columnLabel, String.class);
            }

            return new Result(columnClasses, result);
        }
    }

    // StringRowProcessor is needed since ResultSetMetaData says a column has type TimeStamp,
    // but the ResultSet returns a Date instance. Vaadin ObjectProperty then tries to create
    // a TimeStamp from the Date using new TimeStamp(String) which does not exist.
    private static class StringRowProcessor implements RowProcessor {

        public Object[] toArray(ResultSet rs) throws SQLException {
            return toMap(rs).values().toArray();
        }

        public <T> T toBean(ResultSet rs, Class<T> type) throws SQLException {
            throw new UnsupportedOperationException("Not supported.");
        }

        @SuppressWarnings("unchecked")
        public <T> List<T> toBeanList(ResultSet rs, Class<T> type) throws SQLException {
            return new ArrayList<T>((Collection<T>) toMap(rs).values());
        }

        public Map<String, Object> toMap(ResultSet resultSet) throws SQLException {
            SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat timestampFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss (SSS)");

            ResultSetMetaData meta = resultSet.getMetaData();

            Map<String, Object> row = new TreeMap<String, Object>();

            for (int i = 1; i <= meta.getColumnCount(); i++) {
                Object objectValue = resultSet.getObject(i);
                if (objectValue != null && 
                       (objectValue instanceof oracle.sql.TIMESTAMP || 
                        objectValue instanceof java.sql.Timestamp)) {
                    java.sql.Timestamp timestamp = resultSet.getTimestamp(i);
                    row.put(meta.getColumnLabel(i), timestampFormatter.format(timestamp));
                }else if (objectValue != null && 
                       (objectValue instanceof oracle.sql.DATE || 
                        objectValue instanceof java.sql.Date || 
                        objectValue instanceof java.util.Date)) {
                    java.sql.Date date = resultSet.getDate(i);
                    row.put(meta.getColumnLabel(i), dateFormatter.format(date));
                } else {
                    row.put(meta.getColumnLabel(i), resultSet.getString(i));
                }
            }

            return row;
        }
    }
}