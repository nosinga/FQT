package nl.assai.fqt.web.vscd;

import com.vaadin.data.Item;
import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.*;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.TablePanel;
import nl.assai.fqt.web.ui.UiUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: nanneosinga
 * Date: 5/21/11
 * Time: 9:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class ContactsPanel extends TablePanel<Contact> {

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;
    private VSCD vscd;

    public ContactsPanel(String caption, VSCD vscd) {
        super(caption);
        super.setSortProperty("contactDate");
        super.setAscending(false);
        this.vscd = vscd;
    }

    @Override
    protected void init() {
    }

    @Override
    public Contact createTableItem() {


        String DATE_FORMAT_NOW = "yyyy-MM-dd HH:mm:ss";

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);


        Contact contact = new Contact();
        contact.setDescription("");
        contact.setVscdId(this.vscd.getId());
        contact.setContactDate(sdf.format(cal.getTime()));
        return contact;
    }

    @Override
    public List<Contact> getTableItems() {
        return fqtRepository.findAllVSCDContacts(vscd);
    }

    @Override
    public List<Contact> getSearchTableItems(String search) {
        return fqtRepository.findAllVSCDContacts(vscd);
    }

    @Override
    public String[] getTableProperties() {
        return new String[]{"description", "contactDate"};
    }

    @Override
    public String[] getFormProperties() {
        return new String[]{"description"};
    }

    @Override
    public FormFieldFactory createFormFieldFactory() {
        return new DefaultFieldFactory() {
            @Override
            public Field createField(Item item, Object propertyId, Component uiContext) {
                if (propertyId.equals("description")) {
                    TextField descriptionField = UiUtils.getRequiredTextField("Description");
                    descriptionField.setColumns(45);
                    descriptionField.setRows(10);
                    return descriptionField;
                } else {
                    return super.createField(item, propertyId, uiContext);
                }
            }
        };
    }

    @Override
    public void onInsert(Contact contact) throws Exception {
        fqtRepository.insertContact(contact);
    }

    @Override
    public void onUpdate(Contact contact) throws Exception {
        fqtRepository.updateContact(contact);
    }

    @Override
    public void onDelete(Contact contact) throws Exception {
        fqtRepository.deleteContact(contact);
    }

    @Override
    public void onSelect(Contact contact) {
    }

    @Override
    public void onDeselect() {
    }

    @Override
    protected Class<? extends Contact> getTableItemClass() {
        return Contact.class;
    }

}
