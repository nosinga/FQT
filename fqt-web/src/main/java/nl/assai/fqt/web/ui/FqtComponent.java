package nl.assai.fqt.web.ui;

import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;

/**
 *
 */
public interface FqtComponent {

    ApplicationService getApplicationService();

    FqtApplication getFqtApplication();

    User getUser();

    void initLayout();

}
