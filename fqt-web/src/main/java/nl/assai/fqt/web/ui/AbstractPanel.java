package nl.assai.fqt.web.ui;

import com.vaadin.ui.Panel;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 */
public abstract class AbstractPanel extends Panel implements FqtComponent {

    private ApplicationService applicationService;

    @Override
    public final void attach() {
        super.attach();
        getFqtApplication().inject(this);
        initLayout();
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
