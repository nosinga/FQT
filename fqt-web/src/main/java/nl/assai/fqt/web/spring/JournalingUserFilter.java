package nl.assai.fqt.web.spring;

import com.vaadin.Application;
import com.vaadin.service.ApplicationContext;
import com.vaadin.terminal.gwt.server.WebApplicationContext;
import nl.assai.fqt.service.util.JournalingUserProvider;
import nl.assai.fqt.domain.model.fqt.User;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collection;

/**
 *
 */
@Component
public class JournalingUserFilter implements Filter, JournalingUserProvider {

    private static ThreadLocal<String> journalingUser = new ThreadLocal<String>();

    public void init(FilterConfig filterConfig) throws ServletException {
        // ignore
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        journalingUser.set(null);

        if (request instanceof HttpServletRequest) {

            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpSession session = httpRequest.getSession(false);

            if (session != null) {

                ApplicationContext vaadinAppContext = WebApplicationContext.getApplicationContext(session);
                Collection<Application> vaadinApplications = vaadinAppContext.getApplications();

                if (!vaadinApplications.isEmpty()) {

                    // all applications belong to the same user so we can use the first
                    Application vaadinApplication = vaadinApplications.iterator().next();
                    User user = (User) vaadinApplication.getUser();

                    if (user != null) {
                        journalingUser.set(user.getName());
                    }
                }
            }
        }

        try {
            chain.doFilter(request, response);
        }
        finally {
            journalingUser.set(null);
        }
    }

    public void destroy() {
        // ignore
    }

    public String getJournalingUser() {
        return journalingUser.get();
    }

    static public String getJournalingUserName() {
        return journalingUser.get();
    }
}
