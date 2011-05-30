package nl.assai.fqt.web.vscd;


import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.*;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.queries.QueryWindow;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;


public class VSCDPanel extends TablePanel<VSCD> {

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;
    private Button contactsButton;

    public VSCDPanel(String caption) {
        super(caption);
        super.setSortProperty("name");
        super.setAscending(true);
    }

    @Override
    protected void init() {
        addComponent(createContactsButton());
    }

    @Override
    public VSCD createTableItem() {
        VSCD vscd = new VSCD();
        vscd.setName("");
        return vscd;
    }

    @Override
    public List<VSCD> getTableItems() {
        return fqtRepository.findAllVSCDs();
    }

    @Override
    public List<VSCD> getSearchTableItems(String search) {
        return fqtRepository.findAllSearchVSCDs(search);
    }

    @Override
    public String[] getTableProperties() {
        return new String[]{"name","manager_lastname"};
    }

    @Override
    public String[] getFormProperties() {
        return new String[]{"csv_id"
, "online_cn"
, "name"
, "categorie"
, "postal_address"
, "postal_zipcode"
, "postal_city"
, "visit_address"
, "visit_zipcode"
, "visit_city"
, "telephone_general"
, "telephone_management"
, "telephone_sales"
, "fax"
, "email"
, "url"
, "persoonsnummer"
, "manager_prefix"
, "manager_firstname"
, "manager_infix"
, "manager_lastname"
, "pr_manager_prefix"
, "pr_manager_firstname"
, "pr_manager_infix"
, "pr_manager_lastname"
, "technician_prefix"
, "technician_firstname"
, "technician_infix"
, "technician_lastname"
, "salesmanager_prefix"
, "salesmanager_firstname"
, "salesmanager_infix"
, "salesmanager_lastname"
, "number_rooms"
, "chairs_room_1"
, "chairs_room_2"
, "chairs_room_3"
, "chairs_total"
, "prod_house_company"};
    }

    @Override
    public FormFieldFactory createFormFieldFactory() {
        return new DefaultFieldFactory() {
            @Override
            public Field createField(Item item, Object propertyId, Component uiContext) {
                if (propertyId.equals("sqlId")) {
                    return getQueryComboBox("Query");
                } else if (propertyId.equals("conId")) {
                    return getConnectionComboBox("Connection");
                } else if (propertyId.equals("menuId")) {
                    return getMenuComboBox("Menu");
                } else if (propertyId.equals("roleId")) {
                    return getRoleComboBox("Role");
                } else {
                    return super.createField(item, propertyId, uiContext);
                }
            }
        };
    }


    private Button createContactsButton() {
        contactsButton = new Button("Contact Details");
        contactsButton.setEnabled(false);
        contactsButton.addListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                addContactsPanel();
            }
        });
        return contactsButton;
    }


    private void addContactsPanel() {
        Window mainWindow = getApplication().getMainWindow();
        mainWindow.addWindow(new ContactsWindow(getValue()));
//        mainWindow.addComponent(new ContactsPanel("Contact Details"));
        }



    private ComboBox getTypesComboBox(String caption) {
        ComboBox field = UiUtils.getRequiredComboBox(caption);
        for (String type : Permission.TYPES) {
            field.addItem(type);
            field.setItemCaption(type, type);
        }
        return field;
    }

    private ComboBox getQueryComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        List<Query> items = fqtRepository.findAllQueries();
        for (Query item : items) {
            field.addItem(item.getId());
            field.setItemCaption(item.getId(), item.getName());
        }
        return field;
    }

    private ComboBox getConnectionComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        List<Connection> items = fqtRepository.findAllConnections();
        for (Connection item : items) {
            field.addItem(item.getId());
            field.setItemCaption(item.getId(), item.getName());
        }
        return field;
    }

    private ComboBox getMenuComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        List<MenuNode> items = fqtRepository.findAllMenuNodes();
        for (MenuNode item : items) {
            field.addItem(item.getId());
            field.setItemCaption(item.getId(), item.getMenuName());
        }
        return field;
    }

    private ComboBox getRoleComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        List<Role> items = fqtRepository.findAllRoles();
        for (Role item : items) {
            field.addItem(item.getId());
            field.setItemCaption(item.getId(), item.getName());
        }
        return field;
    }

    @Override
    public void onInsert(VSCD vscd) throws Exception {
        fqtRepository.insertVSCD(vscd);
    }

    @Override
    public void onUpdate(VSCD vscd) throws Exception {
        fqtRepository.updateVSCD(vscd);
    }

    @Override
    public void onDelete(VSCD vscd) throws Exception {
        fqtRepository.deleteVSCD(vscd);
    }

    @Override
    public void onSelect(VSCD vscd) {
        contactsButton.setEnabled(true);
    }

    @Override
    public void onDeselect() {
        contactsButton.setEnabled(false);
    }

    @Override
    protected Class<? extends VSCD> getTableItemClass() {
        return VSCD.class;
    }

}
