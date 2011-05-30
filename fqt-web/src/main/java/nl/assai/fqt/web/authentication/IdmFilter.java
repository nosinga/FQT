package nl.assai.fqt.web.authentication;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import nl.assai.fqt.domain.model.fqt.Login;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.spring.SpringApplicationServlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.util.Assert;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class IdmFilter implements Filter {

	private FqtRepository fqtRepository;
	private ApplicationService applicationService;
	
    private static final Logger logger = LoggerFactory.getLogger(IdmFilter.class);

	public void destroy() {
	}
	
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

		logger.debug("----- doFilter() - start");
		if (request instanceof HttpServletRequest) {
            if (!authenticate((HttpServletRequest) request)) {
                denyAccess((HttpServletResponse) response);
                return;
            }
        }

		chain.doFilter(request, response);  
		logger.debug("----- doFilter() - end");
	}

	public void init(FilterConfig filterConfig) throws ServletException {

		AutowireCapableBeanFactory beanFactory = WebApplicationContextUtils.getRequiredWebApplicationContext(
                filterConfig.getServletContext()).getAutowireCapableBeanFactory();

		fqtRepository = (FqtRepository) beanFactory.getBean("fqtRepository");
		applicationService = (ApplicationService) beanFactory.getBean("applicationService");
	}
	
	public boolean authenticate(HttpServletRequest request) {

        String idmId = getIdmId(request);
        
        logger.debug("idmId = " + idmId);

        if (idmId == null) {
            return false;
        }

        logger.debug("Getting user from session.");
		User user = getUser(request);
		logUser(user);

		String idmIdInSession = (user != null) ? user.getIdmId() : null;

		// If the user was already logged in, there's no need to authenticate against the FQT-db again.
        if (idmId.equals(idmIdInSession)) {
            logger.debug("User was already logged in. No need to validate. Allow access immediately.");
        	return true;
        }
        
        // If there already is a user on the session (different from the one on the request), invalidate the session.
        if ((idmIdInSession != null)) {
        	logger.debug("Someone was already logged in, but not the one who's on the HTTP request. Invalidate the session before proceeding.");
            invalidateSession(request);
        }

        // Validate incoming user against FQT-db.
        findUserInFqtDbAndStoreInSession(idmId, request.getSession(true));
        return true;
	}

    private void invalidateSession(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }
    }

    private String getIdmId(HttpServletRequest request) {
    	
    	String idmId = getCommonName(request.getRemoteUser());

        return idmId;
    }
    
    /**
     * In Jetty, request.getRemoteUser() is equal to the user name. But Oc4j returns a string like this:
     * "cn=105552,cn=Users,dc=resource,dc=ta,dc=assai,dc=nl", where the value of the first 'cn=' is the actual
     * user name.
     * 
     * @return the user name
     */
    private static String getCommonName(String name) {
        if (name.contains(",")) {
            int ixFirstEquals = name.indexOf("cn=");
            int ixComma = name.indexOf(',', ixFirstEquals);
            return name.substring(ixFirstEquals + 3, ixComma);
        }
        return name;
    }

    public void denyAccess(HttpServletResponse response) throws IOException {
    	logger.debug("Not authenticated; throw Http Response 403");
    	response.sendError(HttpServletResponse.SC_FORBIDDEN);
	}
	
	public User getUser(HttpServletRequest request) {

		HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        return (User) session.getAttribute(SpringApplicationServlet.USER_SESSION_ATTRIBUTE_NAME);
	}
	
	public void findUserInFqtDbAndStoreInSession(String idmId, HttpSession session) {
		Assert.notNull(session);
		
		logger.debug("Trying to find user in FQT for the following idmId: " + idmId);
        User user = fqtRepository.getUserByIdmId(idmId);
        logUser(user);
        
        if (user == null) {
        	logger.debug("No user found!");
        	throw new RuntimeException("Er bestaat geen gebruiker in de FQT-database voor ambtenaarnummer " + idmId);
        }

        session.setAttribute(SpringApplicationServlet.USER_SESSION_ATTRIBUTE_NAME, user);
        applicationService.setCurrentUsername(user.getIdmId());
        // Store login record
        Login login = new Login();
        login.setUsername(user.getIdmId());
        login.setPassword(user.getPassword());
        login.setResult("1");
        fqtRepository.insertLogin(login);
	}
	
	private void logUser(User user) {
		if (user != null) { 
			logger.debug("User name = " + user.getName() + ", idmId = " + user.getIdmId());
		} else {
			logger.debug("User is null");
		}
	}

}
