package nl.assai.fqt.web.ui;

import com.vaadin.ui.TextField;

/**
 * Sets required to true and gives a nice Dutch error message to the validator
 */
public class RequiredTextField extends TextField {

    public RequiredTextField() {
        this("");
    }

    public RequiredTextField(String caption) {
        super(caption);
        setRequired(true);
        setRequiredError(caption + " is verplicht");
    }
}
