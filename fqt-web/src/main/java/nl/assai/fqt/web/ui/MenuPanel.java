package nl.assai.fqt.web.ui;

import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.UserMenu;

import com.vaadin.ui.themes.Reindeer;
import nl.assai.fqt.web.ui.menu.MenuTree;

import java.util.List;

public class MenuPanel extends Panel {
	private MenuTree tree;
	
	public MenuPanel() {
    	Label label = new Label("<font size=+1><b>Menu</b></font>");
		label.setContentMode(Label.CONTENT_XHTML);

		tree = new MenuTree();

		VerticalLayout layout = new VerticalLayout();
		layout.addComponent(label);
        layout.addComponent(tree);
        layout.setSpacing(true);
        layout.setMargin(true);

        setContent(layout);
        setStyleName(Reindeer.PANEL_LIGHT);
        setHeight("500px");
        setWidth("100%");
        setScrollable(true);
	}

	public void addMenu(List<UserMenu> userMenus) {
        UserMenu[] menuNodes = new UserMenu[getMaxLevel(userMenus)];

        for (UserMenu menu : userMenus) {
            System.out.println(menu.getItemName());
            tree.addItem(menu);
            tree.setItemCaption(menu, menu.getItemName());
            if (menu.getHasMenuLeafChild() == 0) {
                tree.setChildrenAllowed(menu, false);
            } else {
                tree.setChildrenAllowed(menu, true);
            }
            int currentLevel = menu.getMenuLevel().intValue();
            menuNodes[currentLevel] = menu;
            if (currentLevel > 1) {
                tree.setParent(menu, menuNodes[currentLevel - 1]);
            }
        }
	}

    private int getMaxLevel(List<UserMenu> userMenus) {
        int maxLevel = 0;
        for (UserMenu menu : userMenus) {
            maxLevel = Math.max(maxLevel, menu.getMenuLevel().intValue());
        }
        return maxLevel + 1;
    }
}
