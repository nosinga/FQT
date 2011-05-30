package nl.assai.fqt.web.queries;

import java.util.List;

import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.domain.model.fqt.Role;
import nl.assai.fqt.web.ui.TablePanel;

import nl.assai.fqt.web.ui.UiUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.vaadin.data.Item;
import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.ui.Button;
import com.vaadin.ui.ComboBox;
import com.vaadin.ui.Component;
import com.vaadin.ui.DefaultFieldFactory;
import com.vaadin.ui.Field;
import com.vaadin.ui.Form;
import com.vaadin.ui.FormFieldFactory;
import com.vaadin.ui.Select;
import com.vaadin.ui.TextField;
import com.vaadin.ui.Window;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import org.springframework.beans.factory.annotation.Qualifier;


public class QueryPanel extends TablePanel<Query> {
    private static final Logger logger = LoggerFactory.getLogger(QueryPanel.class);
    
    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

	private Button executeButton;
    private TextField queryField;
    private MyComboBox<Connection> connComboBox;
    private MyComboBox<Role> rolesComboBox;
    private MyComboBox<Role> menusComboBox;

    public QueryPanel(String caption) {
    	super(caption);
    	super.setSortProperty("name");
		super.setAscending(true);
		super.addFormExecuteButton(true);
	}

    @Override
    protected void init() {
		addComponent(createExecuteButton());
	}

    @Override
    public List<Query> getTableItems() {
        return fqtRepository.findAllQueries();
    }

    @Override
    public List<Query> getSearchTableItems(String search) {
        return fqtRepository.findAllSearchQueries(search);
    }

	@Override
	public Query createTableItem() {
		Query query = new Query();
		query.setName("");
		query.setShortDescription("");
		query.setDescription("");
		query.setStatement("");
		query.setReportFormat("");
		return query;
	}

	@Override
	public String[] getTableProperties() {
		return new String[] {"name", "shortDescription"};
	}

	@Override
	public String[] getFormProperties() {
		return new String[] {"name", "shortDescription", "description", "statement", "reportFormat"};
	}

	@Override
	public FormFieldFactory createFormFieldFactory() {
		return new DefaultFieldFactory() {
	        @Override
			public Field createField(Item item, Object propertyId, Component uiContext) {
				if (propertyId.equals("name")) {
					TextField nameField = UiUtils.getRequiredTextField("Name");
					nameField.setColumns(45);
					return nameField;
				} else if (propertyId.equals("shortDescription")) {
					TextField textField = UiUtils.getRequiredTextField("Short description");
					textField.setColumns(45);
					return textField;
				} else if (propertyId.equals("description")) {
				    TextField descriptionField = UiUtils.getTextField("Description");
				    descriptionField.setColumns(45);
				    descriptionField.setRows(10);
				    return descriptionField;
				} else if (propertyId.equals("statement")) {
					queryField = UiUtils.getRequiredTextField("Query");
					queryField.setColumns(45);
					queryField.setRows(15);
					return queryField;
				} else if (propertyId.equals("reportFormat")) {
				    TextField reportFormatField = UiUtils.getTextField("Report format");
				    reportFormatField.setColumns(45);
				    reportFormatField.setRows(10);
				    return reportFormatField;	
				} else {
					return super.createField(item, propertyId, uiContext);
				}
			}
		};
	}

	@Override
	public void onInsert(Query item) throws Exception {
//	    if (connComboBox.getValue() != null) {
//	        Permission permission = createPermission(item);
//	        if (rolesComboBox.getValue() != null) {
//	            logger.debug("selected role: " + rolesComboBox.getValue());
//	            Role role = (Role) rolesComboBox.getValue();
//	            role.getPermissions().add(permission);
//	        }
//	        if (rolesComboBox.getValue() != null) {
//	            logger.debug("selected menu: " + menusComboBox.getValue());
//	            Role menu = (Role) menusComboBox.getValue();
//	            menu.getPermissions().add(permission);
//	        }
//	    }
//	    
		fqtRepository.insertQuery(item);
	}
//
//    private Permission createPermission(Query item) {
//        Connection conn = (Connection) connComboBox.getValue();
//        logger.debug("selected conn: " + conn);
//        Permission permission = permissionRepository.create();
//        permission.setName("sqm#" + item.getName() + "#" + conn.getName());
//        permissionRepository.save(permission);
//        return permission;
//    }

	@Override
	public void onDelete(Query item) throws Exception {
		fqtRepository.deleteQuery(item);
	}

	@Override
	public void onUpdate(Query item) throws Exception {
		fqtRepository.updateQuery(item);

	}

	@Override
	public void onSelect(Query item) {
		executeButton.setEnabled(true);
	}

	@Override
	public void onDeselect() {
		executeButton.setEnabled(false);
	}

	private Button createExecuteButton() {
    	executeButton = new Button("Uitvoeren");
    	executeButton.setEnabled(false);
    	executeButton.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				showQueryWindow();
			}
		});
    	return executeButton;
	}

	private void showQueryWindow() {
    	Window mainWindow = getApplication().getMainWindow();
    	mainWindow.addWindow(new QueryWindow(getValue()));
	}

    @Override
    protected void appendAdditionalActions(Form form, Button executeButton) {

        connComboBox = new MyComboBox<Connection>("Connection", fqtRepository.findAllConnections(), false);
        form.addField("connectionsComboBox",connComboBox);
        
//        rolesComboBox = new MyComboBox<Role>("Role", roleRepository.getRealRoles(), false);
//        form.addField("menusComboBox",menusComboBox);
//        
//        menusComboBox = new MyComboBox<Role>("Menu", roleRepository.getReportMenus(), false);
//        form.addField("rolesComboBox",rolesComboBox);

        executeButton.addListener(new ClickListener() {

            public void buttonClick(ClickEvent event) {                	
            	String statement = queryField.toString();
            	if (!statement.equals("")) {
            		Query query = (getValue() != null) ? getValue() : new Query();
            		query.setStatement(statement);
	            	getApplication().getMainWindow().addWindow(
	                        new QueryWindow(query, (Connection) connComboBox.getValue()));
            	}
         	}            	
        });
    }    

    /**
     * Generate a combobox for a given list of options.
     * If it is required, it will automatically select the first item.
     * Otherwise it will initially be empty.
     * 
     * @param <T> the type of item this comboBox holds.
     */
	private class MyComboBox<T> extends ComboBox {
	    public MyComboBox(String caption, List<T> options, boolean isRequired) {
	        super(caption);
	        setContainerDataSource(new BeanItemContainer<T>(options));
	        setItemCaptionMode(Select.ITEM_CAPTION_MODE_PROPERTY);
	        setItemCaptionPropertyId("name");
	        setRequired(isRequired);
	        setNullSelectionAllowed(false);
	        if (isRequired && !options.isEmpty()) {
	            select(options.get(0));
	        }
	        
	        setWidth("42em"); // is about the same as the "45 columns" of the text fields.
	    }
	}
	
    @Override
    protected Class<? extends Query> getTableItemClass() {
        return Query.class;
    }
}
