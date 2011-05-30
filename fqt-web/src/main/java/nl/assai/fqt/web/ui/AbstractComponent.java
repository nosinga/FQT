package nl.assai.fqt.web.ui;

import com.vaadin.ui.CustomComponent;
import com.vaadin.ui.Panel;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 */
public abstract class AbstractComponent extends CustomComponent implements FqtComponent {

    private ApplicationService applicationService;

    @Override
    public final void attach() {
        super.attach();
        getFqtApplication().inject(this);
        initLayout();
    }

	public Panel createPanel(String caption) {
		Panel panel =  new Panel();
		panel.setCaption(caption);
		panel.addComponent(this);
		return panel;
	}

    @Autowired
    void setApplicationService(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    public ApplicationService getApplicationService() {
        return applicationService;
    }

    public FqtApplication getFqtApplication() {
        return (FqtApplication) getApplication();
    }

    public User getUser() {
        return (User) getApplication().getUser();
    }
}
