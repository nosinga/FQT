package nl.assai.fqt.web.ui;

import com.vaadin.terminal.Sizeable;
import com.vaadin.ui.ComboBox;
import com.vaadin.ui.TextField;

/**
 * Globally available constants and methods.
 */
public class UiUtils {
    public static final int NORMAL_FIELD_WIDTH = 25;
    public static final int NORMAL_MULTI_ROWS = 4;

    public static TextField getTextField(String caption) {
        TextField field = new TextField(caption);
        field.setWidth(NORMAL_FIELD_WIDTH, Sizeable.UNITS_EM);
        field.setNullRepresentation("");
        return field;
    }

    public static TextField getRequiredTextField(String caption) {
        TextField field = getTextField(caption);
        field.setRequired(true);
        field.setRequiredError(caption + " is verplicht");
        return field;
    }

    public static TextField getMultiRowTextField(String caption) {
        TextField field = getTextField(caption);
        field.setRows(NORMAL_MULTI_ROWS);
        return field;
    }

    public static TextField getRequiredMultiRowTextField(String caption) {
        TextField field = getRequiredTextField(caption);
        field.setRows(NORMAL_MULTI_ROWS);
        return field;
    }

    public static ComboBox getComboBox(String caption) {
        ComboBox field = new ComboBox(caption);
        field.setWidth(NORMAL_FIELD_WIDTH, Sizeable.UNITS_EM);
        return field;
    }

    public static ComboBox getRequiredComboBox(String caption) {
        ComboBox field = getComboBox(caption);
        field.setRequired(true);
        field.setNullSelectionAllowed(false);
        field.setRequiredError(caption + " is verplicht");
        return field;
    }

}
