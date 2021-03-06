package nl.assai.fqt.web.ui;

import com.vaadin.ui.ComboBox;

/**
 * Sets required to true and gives a nice Dutch error message to the validator
 */
public class RequiredComboBox extends ComboBox {
	
	public RequiredComboBox() {
		this("");
	}
	
	public RequiredComboBox(String caption) {
		super(caption);
		setRequired(true);
        setRequiredError(caption + " is verplicht");
        setNullSelectionAllowed(false);
	}
}
