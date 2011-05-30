package nl.assai.fqt.web.configuration;

import com.vaadin.ui.FormFieldFactory;
import nl.assai.fqt.web.ui.TablePanel;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;
import java.util.Properties;

/**
 * TablePanel for showing the application's configuration.
 */
public class ConfigurationPanel extends TablePanel<Property> {

	private static final long serialVersionUID = -5922780595210954703L;

	private Properties config;

	public ConfigurationPanel(String caption) {
		super(caption);
		super.setAscending(true);
	}

    @Autowired
    public void setConfig(Properties config) {
        this.config = config;
    }

	@Override
	protected void init() {
		
		hideButtons();
	}

    @Override
    public List<Property> getTableItems() {

        List<Property> properties = new ArrayList<Property>();

        for (Entry<?, ?> entry : config.entrySet()) {

            String key = (String) entry.getKey();
            String value = (String) entry.getValue();

            properties.add(new Property(key, value));
        }

        return properties;
    }


    @Override
    public List<Property> getSearchTableItems(String search) {

        List<Property> properties = new ArrayList<Property>();

        for (Entry<?, ?> entry : config.entrySet()) {

            String key = (String) entry.getKey();
            String value = (String) entry.getValue();

            properties.add(new Property(key, value));
        }

        return properties;
    }

	@Override
	public String[] getTableProperties() {
		return new String[]{"key", "value"};
	}

	@Override
	public FormFieldFactory createFormFieldFactory() {
		return null;
	}

	@Override
	public Property createTableItem() {
		return null;
	}

	@Override
	public String[] getFormProperties() {
		return null;
	}

	@Override
	public void onDelete(Property item) throws Exception {
	}

	@Override
	public void onDeselect() {
	}

	@Override
	public void onInsert(Property item) throws Exception {
	}

	@Override
	public void onSelect(Property item) {
	}

	@Override
	public void onUpdate(Property item) throws Exception {
	}

	@Override
	protected Class<? extends Property> getTableItemClass() {
	   	return Property.class;
	}
}
