package nl.assai.fqt.web.ui;

import com.vaadin.ui.DateField;

/**
 * Sets required to true and gives a nice Dutch error message to the validator
 */

public class RequiredDateField extends DateField {

	private static final long serialVersionUID = -7265694465567438686L;

	public RequiredDateField() {
		this("");
	}
	 
	public RequiredDateField(String caption) {
		super(caption);
	    setRequired(true);
	    setRequiredError(caption + " is verplicht");
    }
}
