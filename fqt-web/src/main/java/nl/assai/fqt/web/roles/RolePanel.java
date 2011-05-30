package nl.assai.fqt.web.roles;

import com.vaadin.data.Item;
import com.vaadin.data.util.BeanItem;
import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.Permission;
import nl.assai.fqt.domain.model.fqt.Role;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;


public class RolePanel extends TablePanel<Role> {

    private OptionGroup permissionOptionGroup;
    private Button permissionsButton;
    private Panel panel;

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

    public RolePanel(String caption) {
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


//    void addTableComponent(Component component) {
//        gridLayout.removeComponent(table);
//        gridLayout.addComponent(createSearchTable(search), 0, 0);
//
//        panel = new Panel();
//        panel.setCaption(component.getCaption());
//        panel.setHeight("411px");
//        panel.addComponent(component);
//        gridLayout.addComponent(panel, 1, 0);
//        component.setCaption(null);
//    }

    @Override
    protected void init() {
        initPermissionOptionGroup();
        buttonLayout.addComponent(createPermissionsButton());
        permissionsButton.setEnabled(false);
    }

    @Override
    public List<Role> getTableItems() {
        return fqtRepository.findAllRoles();
    }

    @Override
    public List<Role> getSearchTableItems(String search) {
        return fqtRepository.findAllSearchRoles(search);
    }

    @Override
    public Role createTableItem() {
        Role role = new Role();
        role.setName("");
        return role;
    }

    @Override
    public String[] getTableProperties() {
        return new String[]{"name"};
    }

    @Override
    public String[] getFormProperties() {
        return new String[]{"name"};
    }

    @Override
    public FormFieldFactory createFormFieldFactory() {
        return new DefaultFieldFactory() {
            @Override
            public Field createField(Item item, Object propertyId, Component uiContext) {
                if (propertyId.equals("name")) {
                    return UiUtils.getRequiredTextField("Role name");
                } else {
                    return super.createField(item, propertyId, uiContext);
                }
            }
        };
    }

    @Override
    public void onInsert(Role item) throws Exception {
        fqtRepository.insertRole(item);
    }

    @Override
    public void onUpdate(Role item) throws Exception {
        fqtRepository.updateRole(item);
    }

    @Override
    public void onDelete(Role item) throws Exception {
        fqtRepository.deleteRole(item);
    }

    @Override
    public void onSelect(Role role) {
        permissionOptionGroup.setEnabled(true);
        permissionsButton.setEnabled(true);
        for (Object itemId : permissionOptionGroup.getItemIds()) {
            permissionOptionGroup.unselect(itemId);
            for (Permission permission : role.getPermissions()) {
                if (permission.equals((Permission) itemId)) {
                    permissionOptionGroup.select(itemId);
                    break;
                }
            }
        }
    }

    @Override
    public void onDeselect() {
        permissionOptionGroup.setEnabled(false);
        permissionsButton.setEnabled(false);
        for (Object itemId : permissionOptionGroup.getItemIds()) {
            permissionOptionGroup.unselect(itemId);
        }
    }

    private void initPermissionOptionGroup() {
        permissionOptionGroup = new OptionGroup("Permissions");
        permissionOptionGroup.setContainerDataSource(new BeanItemContainer<Permission>(loadPermissions()));
        permissionOptionGroup.setItemCaptionMode(ListSelect.ITEM_CAPTION_MODE_ID);
        permissionOptionGroup.setMultiSelect(true);
        permissionOptionGroup.setEnabled(false);
    }


    private Button createPermissionsButton() {
        permissionsButton = new Button("Show Permissions");
        permissionsButton.setEnabled(false);
        permissionsButton.addListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                if (permissionsButton.getCaption().equals("Show Permissions")) {
                    addTableComponent(permissionOptionGroup);
                    permissionsButton.setCaption("Save Permissions");
                    permissionsButton.setEnabled(false);
                } else {
                    savePermissions();
                }
            }
        });
        return permissionsButton;
    }


    private Button createSaveButton() {
        permissionsButton = new Button("Save");
        permissionsButton.setEnabled(false);
        permissionsButton.addListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                savePermissions();
            }
        });
        return permissionsButton;
    }

    private List<Permission> loadPermissions() {
        return fqtRepository.findAllPermissions();
    }

    private void savePermissions() {
        Role role = getValue();
        role.getPermissions().clear();
        role.getPermissions().addAll(getSelectedPermissions());
        fqtRepository.updateRole(role);
    }

    @SuppressWarnings("unchecked")
    private List<Permission> getSelectedPermissions() {
        List<Permission> selectedPermissions = new ArrayList<Permission>();
        Set selectedItems = (Set) permissionOptionGroup.getValue();
        for (Iterator iterator = selectedItems.iterator(); iterator.hasNext();) {
            Item item = permissionOptionGroup.getItem(iterator.next());
            Permission permission = (Permission) ((BeanItem) item).getBean();
            selectedPermissions.add(permission);
        }
        return selectedPermissions;
    }

    @Override
    protected Class<? extends Role> getTableItemClass() {
        return Role.class;
    }
}
