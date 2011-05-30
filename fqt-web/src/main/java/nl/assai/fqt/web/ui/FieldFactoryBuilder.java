package nl.assai.fqt.web.ui;

import com.vaadin.data.Item;
import com.vaadin.data.util.IndexedContainer;
import com.vaadin.ui.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class FieldFactoryBuilder {

    private final Map<String, Field> fields = new HashMap<String, Field>();

    private abstract class FieldBuilder<B extends FieldBuilder, F extends Field> {

        private final F field;
        private final String id;

        protected FieldBuilder(String id, F field) {
            this.id = id;
            this.field = field;

            fields.put(id, field);
        }

        protected F getField() {
            return field;
        }

        public String getId() {
            return id;
        }

        public B withWidth(float width, int unit) {
            getField().setWidth(width, unit);
            return (B) this;
        }

        public B withFullSize() {
            getField().setSizeFull();
            return (B) this;
        }
    }

    public TextFieldBuilder createTextField(String id) {
        return createTextField(id, id);
    }

    public TextFieldBuilder createTextField(String id, String caption) {
        return new TextFieldBuilder(id, caption);
    }

    public class TextFieldBuilder extends FieldBuilder<TextFieldBuilder, TextField> {

        TextFieldBuilder(String id, String caption) {
            super(id, new TextField(caption));
        }

        public TextFieldBuilder withLength(int columns) {
            getField().setColumns(columns);
            return this;
        }

        public TextFieldBuilder beingRequired() {
            getField().setRequired(true);
            return this;
        }
    }

    public DropDownBuilder createDropDown(String id, String caption) {
        return new DropDownBuilder(id, caption);
    }

    public class DropDownBuilder extends FieldBuilder<DropDownBuilder, ComboBox> {

        public DropDownBuilder(String id, String caption) {
            super(id, new ComboBox(caption));
            getField().setFilteringMode(AbstractSelect.Filtering.FILTERINGMODE_CONTAINS);
        }

        public DropDownBuilder beingRequired() {

            getField().setNullSelectionAllowed(false);
            getField().setRequired(true);

            return this;
        }

        public DropDownBuilder withValues(List<String> values) {

            IndexedContainer container = new IndexedContainer();

            for (String value:  values) {
                container.addItem(value);
            }

            getField().setContainerDataSource(container);

            return this;
        }
    }

    public FormFieldFactory createFactory() {
        return new DefaultFieldFactory() {
            @Override
			public Field createField(Item item, Object propertyId, Component uiContext) {

                Field field = fields.get(propertyId);

                if (field == null) {
                    return super.createField(item, propertyId, uiContext);
                }

                return field;
            }
        };
    }
}
