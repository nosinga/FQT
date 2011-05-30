package nl.assai.fqt.web.reportconnectors;

import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.*;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;

public class ReportConnectorPanel extends TablePanel<ReportConnection> {

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

    public ReportConnectorPanel(String caption) {
        super(caption);
        super.setSortProperty("name");
        super.setAscending(true);
    }

    @Override
    protected void init() {
    }

    @Override
    public ReportConnection createTableItem() {
        ReportConnection reportconnection = new ReportConnection();
        reportconnection.setName("");
        reportconnection.setMenuName("");
        return reportconnection;
    }

    @Override
    public List<ReportConnection> getTableItems() {
        return fqtRepository.findAllReportConnections();
    }

    @Override
    public List<ReportConnection> getSearchTableItems(String search) {
        return fqtRepository.findAllReportConnections();
    }

    @Override
    public String[] getTableProperties() {
        return new String[]{"name", "menuName"};
    }

    @Override
    public String[] getFormProperties() {
        return new String[]{"sqlId", "conId", "menuId", "roleId","orderBy"};
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
                } else if (propertyId.equals("orderBy")) {
                    return getOrderByComboBox("OrderBy");
                } else {
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

    private ComboBox getOrderByComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        for (String orderby : ReportConnection.ORDERBYS) {
            field.addItem(orderby);
            field.setItemCaption(orderby, orderby);
        }
        return field;
    }

    private ComboBox getQueryComboBox(String caption) {
        ComboBox field = UiUtils.getComboBox(caption);
        List<Query> items = fqtRepository.findAllQueriesOrderByRecent();
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
        List<MenuNode> items = fqtRepository.findAllMenuNodesOrderByDisplay();
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
    public void onInsert(ReportConnection reportconnection) throws Exception {
        fqtRepository.insertReportConnection(reportconnection);
    }

    @Override
    public void onUpdate(ReportConnection reportconnection) throws Exception {
        fqtRepository.updateReportConnection(reportconnection);
    }

    @Override
    public void onDelete(ReportConnection reportconnection) throws Exception {
        fqtRepository.deleteReportConnection(reportconnection);
    }

    @Override
    public void onSelect(ReportConnection reportconnection) {
        // Auto-generated method stub

    }

    @Override
    public void onDeselect() {
        // Auto-generated method stub

    }

    @Override
    protected Class<? extends ReportConnection> getTableItemClass() {
        return ReportConnection.class;
    }

}
