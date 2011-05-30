package nl.assai.fqt.web.ui.menu;

import com.vaadin.event.ItemClickEvent;
import com.vaadin.ui.Tree;
import nl.assai.fqt.domain.model.fqt.UrlLink;
import nl.assai.fqt.domain.model.fqt.UserMenu;
import nl.assai.fqt.web.FqtApplication;
import nl.assai.fqt.web.links.LinkRedirectWindow;
import nl.assai.fqt.web.queries.QueryWindow;

public class MenuTree extends Tree implements ItemClickEvent.ItemClickListener {

    public MenuTree() {
        super();
        setImmediate(true);
        setSelectable(true);
        setNullSelectionAllowed(false);
        addListener((ItemClickEvent.ItemClickListener) this);
    }
    
    public void itemClick(ItemClickEvent event) {
         if(event.getSource() == this) {
             Object itemId = event.getItemId();
             if (itemId != null) {
                 UserMenu menu = (UserMenu) itemId;
                 if (menu.getHasMenuLeafChild() == 0) {
                     System.out.println(menu.getMenuSubtype());
                     FqtApplication fqtApplication = (FqtApplication) getApplication();
                     if ("SCREEN".equals(menu.getMenuSubtype())) {
                         fqtApplication.showScreen(FqtApplication.Screen.valueOf(menu.getMenuResourcelocation()), menu.getMenuResourcelocation());
                     } else if ("URL".equals(menu.getMenuSubtype())) {
                         UrlLink link = new UrlLink();
                         link.setName(menu.getItemName());
                         link.setUrl(menu.getMenuResourcelocation());
                         fqtApplication.getMainWindow().addWindow(new LinkRedirectWindow(link));
                     } else if ("REPORT".equals(menu.getMenuSubtype())) {
                         fqtApplication.getMainWindow().addWindow(new QueryWindow(menu.getQueryName(), menu.getConnectionName()));
                     }
                 } else {
                     if (isExpanded(itemId)) {
                         collapseItem(itemId);
                     } else {
                         expandItem(itemId);
                     }
                 }
             }
         }
     }

}
