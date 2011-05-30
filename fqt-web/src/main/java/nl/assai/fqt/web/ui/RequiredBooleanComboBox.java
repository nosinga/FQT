package nl.assai.fqt.web.ui;

import java.util.Arrays;
import java.util.List;

import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.ui.ComboBox;

/**
 * Sets required to true and gives a nice Dutch error message to the validator
 */
public class RequiredBooleanComboBox extends ComboBox {
	
	public RequiredBooleanComboBox() {
		this("");
	}
	
	public RequiredBooleanComboBox(String caption) {
		super(caption);
		Boolean[] booleans = { false, true };
		List<Boolean> booleanList = Arrays.asList(booleans);
		setContainerDataSource(new BeanItemContainer<Boolean>(booleanList));		
		setRequired(true);
        setRequiredError(caption + " is verplicht");
        setNullSelectionAllowed(false);
	}
}
