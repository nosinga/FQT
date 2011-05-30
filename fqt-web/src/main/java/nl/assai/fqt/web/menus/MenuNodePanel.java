package nl.assai.fqt.web.menus;

import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.MenuNode;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;

public class MenuNodePanel extends TablePanel<MenuNode> {

    @Autowired
    @Qualifier("fqtRepository")
	private FqtRepository fqtRepository;

    private MenuNode selectedMenuNode;

    public MenuNodePanel(String caption) {
		super(caption);
		super.setSortProperty("name");
		super.setAscending(true);
	}

    @Override
    protected void init() {}

	@Override
	public MenuNode createTableItem() {
		MenuNode MenuNode = new MenuNode();
		MenuNode.setMenuName("");
		MenuNode.setMenuDescription("");
		MenuNode.setOrderBy("");
		return MenuNode;
	}

    @Override
    public List<MenuNode> getTableItems() {
        return fqtRepository.findAllMenuNodes();
    }

    @Override
    public List<MenuNode> getSearchTableItems(String search) {
        return fqtRepository.findAllMenuNodes();
    }

	@Override
	public String[] getTableProperties() {
		return new String[] {"menuName", "menuDescription", "parentMenuName", "orderBy"};
	}

	@Override
	public String[] getFormProperties() {
		return new String[] {"menuName", "menuDescription", "orderBy", "parentId"};
	}

	@Override
	public FormFieldFactory createFormFieldFactory() {
		return new DefaultFieldFactory() {
	        @Override
			public Field createField(Item item, Object propertyId, Component uiContext) {
				if (propertyId.equals("menuName")) {
					return UiUtils.getRequiredTextField("Naam");
                }  else if (propertyId.equals("menuDescription")) {
                    return UiUtils.getTextField("Omschrijving");
                }  else if (propertyId.equals("orderBy")) {
                    return UiUtils.getTextField("Volgorde");
				}  else if (propertyId.equals("parentId")) {
                    // TODO waarom worden al deze entries 2 keer doorlopen ??
                    return getParentComboBox("Parent menu");
				}  else {
					return super.createField(item, propertyId, uiContext);
				}
			}
		};
	}
    private ComboBox getParentComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        MenuNode currentNode = selectedMenuNode;
        if (mode == Mode.INSERT) {
            currentNode = null;
        }
        List<MenuNode> items = fqtRepository.findPossibleParentMenuNodes(currentNode);
        for (MenuNode item : items) {
            field.addItem(item.getId());
            field.setItemCaption(item.getId(), item.getMenuName());
        }
        return field;
    }

	@Override
	public void onInsert(MenuNode menuNode) throws Exception {
		fqtRepository.insertMenuNode(menuNode);
	}

	@Override
	public void onUpdate(MenuNode menuNode) throws Exception {
		fqtRepository.updateMenuNode(menuNode);
	}

	@Override
	public void onDelete(MenuNode menuNode) throws Exception {
		fqtRepository.deleteMenuNode(menuNode);
	}

	@Override
	public void onSelect(MenuNode menuNode) {
        selectedMenuNode = menuNode;
	}

	@Override
	public void onDeselect() {
		selectedMenuNode = null;
	}

	@Override
	protected Class<? extends MenuNode> getTableItemClass() {
		return MenuNode.class;
	}

}
