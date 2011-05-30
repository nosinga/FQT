package nl.assai.fqt.web.spring;

import com.vaadin.Application;
import com.vaadin.terminal.gwt.server.AbstractApplicationServlet;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.web.FqtApplication;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

/**
 * Binds Vaadin to Spring.
 */
public class SpringApplicationServlet extends AbstractApplicationServlet {

    public static final String USER_SESSION_ATTRIBUTE_NAME ="nl.assai.fqt.web.User";

    private AutowireCapableBeanFactory beanFactory;

    @Override
    protected Class<FqtApplication> getApplicationClass() throws ClassNotFoundException {
        return FqtApplication.class;
    }

    @Override
    protected Application getNewApplication(HttpServletRequest request) throws ServletException {

        User user = (User) request.getSession(true).getAttribute(USER_SESSION_ATTRIBUTE_NAME);
        FqtApplication application = (FqtApplication) getBeanFactory(request.getSession().getServletContext()).createBean(FqtApplication.class);

        application.setUser(user);

        return application;
    }

    private AutowireCapableBeanFactory getBeanFactory(ServletContext servletContext) {

        if (beanFactory == null) {
            beanFactory = WebApplicationContextUtils
                    .getRequiredWebApplicationContext(servletContext)
                    .getAutowireCapableBeanFactory();
        }

        return beanFactory;
    }
}
