package nl.assai.fqt.web.queries;

import com.vaadin.data.Container;
import com.vaadin.data.Item;
import com.vaadin.data.Property;
import com.vaadin.data.util.ObjectProperty;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

/**
 *
 */
public class QueryResultContainer implements Container {

    private final Result result;

    public QueryResultContainer(Result result) {
        this.result = result;
    }

    public Item getItem(Object itemId) {
        return new MapItem(result.getResult().get((Integer) itemId));
    }

    public Collection<?> getContainerPropertyIds() {
        return result.getMetadata().keySet();
    }

    public Collection<?> getItemIds() {
        
        Collection<Integer> itemIds = new ArrayList<Integer>(result.size());

        for (int i = 0; i < result.size(); i++) {
            itemIds.add(i);
        }

        return itemIds;
    }

    public Property getContainerProperty(Object itemId, Object propertyId) {
        return getItem(itemId).getItemProperty(propertyId);
    }

    public Class<?> getType(Object propertyId) {
        return result.getMetadata().get((String) propertyId);
    }

    public int size() {
        return result.size();
    }

    public boolean containsId(Object itemId) {
        return ((Integer) itemId) < result.size();
    }

    public Item addItem(Object itemId) throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    public Object addItem() throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    public boolean removeItem(Object itemId) throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    public boolean addContainerProperty(Object propertyId, Class<?> type, Object defaultValue) throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    public boolean removeContainerProperty(Object propertyId) throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    public boolean removeAllItems() throws UnsupportedOperationException {
        throw new UnsupportedOperationException("Read-only container.");
    }

    private class MapItem implements Item {

        private final Map<String, Object> item;

        public MapItem(Map<String, Object> item) {
            this.item = item;
        }

        public Property getItemProperty(Object vaadinId) {
            String id = (String) vaadinId;
            return new ObjectProperty(item.get(id), result.getMetadata().get(id), true);
        }

        public Collection<?> getItemPropertyIds() {
            return item.keySet();
        }

        public boolean addItemProperty(Object id, Property property) throws UnsupportedOperationException {
            throw new UnsupportedOperationException("Read-only container.");
        }

        public boolean removeItemProperty(Object id) throws UnsupportedOperationException {
            throw new UnsupportedOperationException("Read-only container.");
        }
    }
}
