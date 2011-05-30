package nl.assai.fqt.web.ui.masterdetail;

import com.vaadin.ui.Component;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.VerticalLayout;
import nl.assai.fqt.web.ui.AbstractComponent;
import nl.assai.fqt.web.ui.Title;

/**
 *
 */
public abstract class MasterDetailComponent
        extends AbstractComponent {

    protected final String caption;
    private MasterComponent masterComponent;
    private DetailComponent detailComponent;

    protected MasterDetailComponent(String caption) {
        this.caption = caption;
    }

    public final void initLayout() {

        setupComponents();

        HorizontalLayout contentLayout = new HorizontalLayout();
        contentLayout.addComponent(getMasterComponent());
        contentLayout.addComponent(getDetailComponent());
        contentLayout.setSizeFull();

        VerticalLayout mainLayout = new VerticalLayout();
        mainLayout.addComponent(new Title(caption));
        mainLayout.addComponent(contentLayout);
        mainLayout.setWidth("100%");
        mainLayout.setHeight("100%");

        setCompositionRoot(mainLayout);
    }

    private void setupComponents() {

        masterComponent = createMasterComponent();
        detailComponent = createDetailComponent();

        masterComponent.setDetailComponent(detailComponent);
        detailComponent.setMasterComponent(masterComponent);
    }

    public Component getMasterComponent() {
        return masterComponent;
    }

    public Component getDetailComponent() {
        return detailComponent;
    }

    protected abstract MasterComponent createMasterComponent();

    protected abstract DetailComponent createDetailComponent();
}
