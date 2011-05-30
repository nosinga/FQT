package nl.assai.fqt.web.users;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.Role;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.vaadin.data.Item;
import com.vaadin.data.util.BeanItem;
import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;

public class UserPanel extends TablePanel<TableItemUser> {

    private static OptionGroup roleOptionGroup;
    private Button rolesButton;
    private Panel  panel;

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

    public UserPanel(String caption) {
        super(caption);
        super.setSortProperty("name");
        super.setAscending(true);
    }


    void addTableComponent(Component component) {
            gridLayout.removeComponent(table);

            String localsearch = "" + search;
            if ((localsearch.equals("null")) || (localsearch.length()==0) ) {
                gridLayout.addComponent(createTable(), 0, 0);
                System.out.println("1 " + localsearch + localsearch.length());
            } else {
                gridLayout.addComponent(createSearchTable(localsearch), 0, 0);
                System.out.println("2 " + localsearch + localsearch.length());
            }

            panel = new Panel();
	        panel.setCaption(component.getCaption());
			panel.setHeight("411px");
            panel.addComponent(component);
			gridLayout.addComponent(panel, 1, 0);
  			component.setCaption(null);
	}


    @Override
    public void init() {
          initRoleOptionGroup();
          buttonLayout.addComponent(createRolesButton());
          rolesButton.setEnabled(false);
    }

    @Override
    protected Class<? extends TableItemUser> getTableItemClass() {
        return TableItemUser.class;
    }

    @Override
    public List<TableItemUser> getTableItems() {

        List<User> users = fqtRepository.findAllUsers();
        List<TableItemUser> tableItemUsers = new ArrayList<TableItemUser>();

        for (User user : users) {
            tableItemUsers.add(new TableItemUser(user));
        }

        return tableItemUsers;
    }

    @Override
    public List<TableItemUser> getSearchTableItems(String search) {

        List<User> users = fqtRepository.findAllSearchUsers(search);
        List<TableItemUser> tableItemUsers = new ArrayList<TableItemUser>();

        for (User user : users) {
            tableItemUsers.add(new TableItemUser(user));
        }

        return tableItemUsers;
    }

    @Override
    public TableItemUser createTableItem() {
        User user = new User();
        user.setName("");
        user.setIdmId("");
        return new TableItemUser(user);
    }

    @Override
    public String[] getTableProperties() {
        return new String[]{"name"};
    }

    @Override
    public String[] getFormProperties() {
        return new String[]{"name", "templateUser"};
    }

    @Override
    public FormFieldFactory createFormFieldFactory() {
        return new DefaultFieldFactory() {

            public Field createField(Item item, Object propertyId, Component uiContext) {
                if (propertyId.equals("name")) {
                    return UiUtils.getRequiredTextField("Naam");
                } else if (propertyId.equals("templateUser")) {
                    ListSelect userProfileSelect = new ListSelect("Copy User Profile",
                            new BeanItemContainer<TableItemUser>(getTableItems()));
                    userProfileSelect.setItemCaptionMode(ListSelect.ITEM_CAPTION_MODE_PROPERTY);
                    userProfileSelect.setItemCaptionPropertyId("name");
                    userProfileSelect.setRows(1);
                    userProfileSelect.setNullSelectionAllowed(true);
                    userProfileSelect.setImmediate(true);
                    return userProfileSelect;
                } else {
                    return super.createField(item, propertyId, uiContext);
                }
            }
        };
    }

    @Override
    public void onInsert(TableItemUser tableItemUser) throws Exception {
        tableItemUser.applyChangesOnDelegate();
        fqtRepository.insertUser(tableItemUser.getDelegateUser());
        copyUserProfile(tableItemUser);
    }

    @Override
    public void onUpdate(TableItemUser tableItemUser) throws Exception {
        tableItemUser.applyChangesOnDelegate();
        fqtRepository.updateUser(tableItemUser.getDelegateUser());
        copyUserProfile(tableItemUser);
    }

    @Override
    public void onDelete(TableItemUser tableItemUser) throws Exception {
        fqtRepository.deleteUser(tableItemUser.getDelegateUser());
    }

    @Override
    public void onSelect(TableItemUser user) {

        roleOptionGroup.setEnabled(true);
        rolesButton.setEnabled(true);
        for (Object itemId : roleOptionGroup.getItemIds()) {
            roleOptionGroup.unselect(itemId);
            for (Role role : user.getRoles()) {
                if (role.getName().equals(roleOptionGroup.getItemCaption(itemId))) {
                    roleOptionGroup.select(itemId);
                    break;
                }
            }
        }
    }

    @Override
    public void onDeselect() {
        roleOptionGroup.setEnabled(false);
        rolesButton.setEnabled(false);

        for (Object itemId : roleOptionGroup.getItemIds()) {
            roleOptionGroup.unselect(itemId);
        }

    }

    private void initRoleOptionGroup() {
        roleOptionGroup = new OptionGroup("Roles");
        roleOptionGroup.setContainerDataSource(new BeanItemContainer<Role>(loadRoles()));
        roleOptionGroup.setItemCaptionMode(ListSelect.ITEM_CAPTION_MODE_PROPERTY);
        roleOptionGroup.setItemCaptionPropertyId("name");
        roleOptionGroup.setMultiSelect(true);
        roleOptionGroup.setEnabled(false);
        roleOptionGroup.setImmediate(true);
    }

    private Button createRolesButton() {
        rolesButton = new Button("Show Roles");
        rolesButton.setEnabled(false);
        rolesButton.addListener(new ClickListener() {
            public void buttonClick(ClickEvent event) {
                if (rolesButton.getCaption().equals("Show Roles")) {
                    addTableComponent(roleOptionGroup);
                    rolesButton.setCaption("Save Roles");
                    rolesButton.setEnabled(false);
                } else {
                    getValue().getRoles().clear();
                    getValue().getRoles().addAll(getSelectedRoles());
                    getValue().applyChangesOnDelegate();
                    fqtRepository.updateUserRoles(getValue().getDelegateUser());
                }
            }
        });
        return rolesButton;
    }

    private List<Role> loadRoles() {
        return fqtRepository.findAllRoles();
    }

    @SuppressWarnings("unchecked")
    private List<Role> getSelectedRoles() {
        List<Role> selectedRoles = new ArrayList<Role>();
        Set selectedItems = (Set) roleOptionGroup.getValue();
        for (Iterator iterator = selectedItems.iterator(); iterator.hasNext();) {
            Item item = roleOptionGroup.getItem(iterator.next());
            Role role = (Role) ((BeanItem) item).getBean();
            selectedRoles.add(role);
        }
        return selectedRoles;
    }

    private void copyUserProfile(TableItemUser tableItemUser) {

        User user = tableItemUser.getDelegateUser();
        User templateUser = tableItemUser.getTemplateUser() != null
                ? tableItemUser.getTemplateUser().getDelegateUser() : null;

        if (templateUser != null) {
            user.getRoles().clear();
            user.getRoles().addAll(templateUser.getRoles());
        }

        fqtRepository.updateUserRoles(user);
    }
}
