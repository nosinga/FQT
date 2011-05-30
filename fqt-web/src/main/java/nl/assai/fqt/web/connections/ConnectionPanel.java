package nl.assai.fqt.web.connections;

import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;

public class ConnectionPanel extends TablePanel<Connection> {

	private static final long serialVersionUID = -1432942367630551782L;
	
    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

    public ConnectionPanel(String caption) {
		super(caption);
		super.setSortProperty("name");
		super.setAscending(true);
	}

    @Override
    protected void init() {}

    @Override
    public List<Connection> getTableItems() {
        return fqtRepository.findAllConnections();
    }

    @Override
    public List<Connection> getSearchTableItems(String Search) {
        return fqtRepository.findAllConnections();
    }

	@Override
	public Connection createTableItem() {
		return new Connection();
	}

	@Override
	public String[] getTableProperties() {
		return new String[] {"name", "username", "servicename", "tnsName", "description"};
	}

	@Override
	public String[] getFormProperties() {
		return new String[] {"name", "username", "password", "servicename", "tnsName", "description"};
	}

	@Override
	public FormFieldFactory createFormFieldFactory() {
		return new DefaultFieldFactory() {
	        @Override
			public Field createField(Item item, Object propertyId, Component uiContext) {
				if (propertyId.equals("name")) {
					return UiUtils.getRequiredTextField("Name");
				} else if (propertyId.equals("username")) {
					return UiUtils.getTextField("Username");
				} else if (propertyId.equals("password")) {
					TextField passwordField = UiUtils.getTextField("Password");
					passwordField.setSecret(true);
					return passwordField;
				} else if (propertyId.equals("servicename")) {
					return UiUtils.getTextField("Servicename");
				} else if (propertyId.equals("tnsName")) {
					return UiUtils.getTextField("TNS name");
				} else if (propertyId.equals("description")) {
					return UiUtils.getTextField("Description");
				}
				else {
					return super.createField(item, propertyId, uiContext);
				}
			}
		};
	}

	@Override
	public void onInsert(Connection item) throws Exception {
		fqtRepository.insertConnection(item);
	}

	@Override
	public void onDelete(Connection item) throws Exception {
		fqtRepository.deleteConnection(item);

	}

	@Override
	public void onUpdate(Connection item) throws Exception {
		fqtRepository.updateConnection(item);
	}

	@Override
	public void onSelect(Connection item) {
	}

	@Override
	public void onDeselect() {
	}

	@Override
	protected Class<? extends Connection> getTableItemClass() {
		return Connection.class;
	}

}
