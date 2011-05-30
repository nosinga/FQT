package nl.assai.fqt.web.ui;

import com.vaadin.ui.Window;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 */
public abstract class AbstractWindow extends Window {

    private ApplicationService applicationService;

    @Override
    public final void attach() {
        super.attach();
        getFqtApplication().inject(this);
        initLayout();
    }

    protected abstract void initLayout();

    @Autowired
    void setApplicationService(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    protected ApplicationService getApplicationService() {
        return applicationService;
    }

    protected FqtApplication getFqtApplication() {
        return (FqtApplication) getApplication();
    }

    protected User getUser() {
        return (User) getApplication().getUser();
    }
}
