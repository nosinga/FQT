package nl.assai.fqt.web.permissions;

import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.model.fqt.MenuNode;
import nl.assai.fqt.domain.model.fqt.Permission;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;

public class PermissionPanel extends TablePanel<Permission> {

    @Autowired
    @Qualifier("fqtRepository")
	private FqtRepository fqtRepository;

    public PermissionPanel(String caption) {
		super(caption);
		super.setSortProperty("name");
		super.setAscending(true);
	}

    @Override
    protected void init() {}

	@Override
	public Permission createTableItem() {
		Permission permission = new Permission();
		permission.setName("");
		permission.setType("");
		permission.setValue("");
		return permission;
	}

    @Override
    public List<Permission> getTableItems() {
        return fqtRepository.findAllPermissions();
    }

    @Override
    public List<Permission> getSearchTableItems(String search) {
        return fqtRepository.findAllSearchPermissions(search);
    }

	@Override
	public String[] getTableProperties() {
		return new String[] {"name", "type", "value"};
	}

	@Override
	public String[] getFormProperties() {
		return new String[] {"name", "type", "value", "menuId", "sqlId", "conId", "orderBy"};
	}

	@Override
	public FormFieldFactory createFormFieldFactory() {
		return new DefaultFieldFactory() {
	        @Override
			public Field createField(Item item, Object propertyId, Component uiContext) {
				if (propertyId.equals("name")) {
					return UiUtils.getRequiredTextField("Name");
				}  else if (propertyId.equals("type")) {
                    return getTypesComboBox("Type");
				}  else if (propertyId.equals("value")) {
                    return UiUtils.getTextField("Value");
				}  else if (propertyId.equals("menuId")) {
                    return getMenuComboBox("Menu");
				}  else if (propertyId.equals("sqlId")) {
                    return getQueryComboBox("Query");
				}  else if (propertyId.equals("conId")) {
                    return getConnectionComboBox("Connection");
				}  else {
					return super.createField(item, propertyId, uiContext);
				}
			}
		};
	}
    private ComboBox getTypesComboBox(String caption) {
        ComboBox field = UiUtils.getRequiredComboBox(caption);
        for (String type : Permission.TYPES) {
            field.addItem(type);
            field.setItemCaption(type, type);
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

	@Override
	public void onInsert(Permission permission) throws Exception {
		fqtRepository.insertPermission(permission);
	}

	@Override
	public void onUpdate(Permission permission) throws Exception {
		fqtRepository.updatePermission(permission);
	}

	@Override
	public void onDelete(Permission permission) throws Exception {
		fqtRepository.deletePermission(permission);
	}

	@Override
	public void onSelect(Permission permission) {
		// Auto-generated method stub

	}

	@Override
	public void onDeselect() {
		// Auto-generated method stub

	}

	@Override
	protected Class<? extends Permission> getTableItemClass() {
		return Permission.class;
	}

}
