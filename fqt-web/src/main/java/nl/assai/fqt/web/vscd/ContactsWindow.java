package nl.assai.fqt.web.vscd;

import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.model.fqt.VSCD;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.ui.AbstractWindow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

/**
 * Created by IntelliJ IDEA.
 * User: nanneosinga
 * Date: 5/21/11
 * Time: 8:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class ContactsWindow extends AbstractWindow {

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

	private VSCD vscd;




    public ContactsWindow(VSCD vscd) {
       this.vscd = vscd;
    }

    @Override
    protected void initLayout() {

            setCaption("VSCD Member: " + vscd.getName() );

            VerticalLayout layout = new VerticalLayout();
            layout.addComponent(new ContactsPanel("Contact Details",vscd));

            layout.setSizeFull();
            center();
            setWidth("90%");
            setHeight("80%");

            setContent(layout);

        }
    }
