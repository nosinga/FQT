package nl.assai.fqt.web.proxyservlet;

import nl.assai.fqt.service.util.JournalingUserProvider;
import nl.assai.fqt.service.util.StaticJournalingUserProvider;
import nl.assai.fqt.domain.model.fqt.User;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.vaadin.Application;
import com.vaadin.service.ApplicationContext;
import com.vaadin.terminal.gwt.server.WebApplicationContext;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Collection;
import java.util.Properties;

public class ProxyServlet extends HttpServlet {

    private Properties config;

    private static final Logger logger = LoggerFactory.getLogger(ProxyServlet.class);

    private JournalingUserProvider getJournalingUserProvider(HttpServletRequest request) {
        JournalingUserProvider journalingUserProvider = new StaticJournalingUserProvider(null);
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            ApplicationContext vaadinAppContext = WebApplicationContext.getApplicationContext(session);
            Collection<Application> vaadinApplications = vaadinAppContext.getApplications();

            if (!vaadinApplications.isEmpty()) {
                Application vaadinApplication = vaadinApplications.iterator().next();
                User user = (User) vaadinApplication.getUser();

                if (user != null) {
                    journalingUserProvider = new StaticJournalingUserProvider(user.getName());
                    logger.debug("getJournalingUserProvider: " + journalingUserProvider.getJournalingUser());
                }
            }
        }
        return journalingUserProvider;
    }
    
    public void init(ServletConfig servletConfig) throws ServletException {
        super.init(servletConfig);
        AutowireCapableBeanFactory beanFactory = WebApplicationContextUtils.getRequiredWebApplicationContext(
                servletConfig.getServletContext()).getAutowireCapableBeanFactory();
        config = (Properties) beanFactory.getBean("ataConfig");
        logger.debug("Proxy servlet using config: " + config);
        
        String httpProxy = config.getProperty("FQT_HTTP_SET_PROXY");
        if (StringUtils.isNotEmpty(httpProxy)) {
            String[] proxyParts = httpProxy.split(":");
            if (proxyParts.length == 2) {
                System.setProperty("http.proxyHost", proxyParts[0]);
                System.setProperty("http.proxyPort", proxyParts[1]);
                System.setProperty("http.nonProxyHosts", "localhost|127.0.0.1");
                logger.info("Proxy servlet using HTTP proxy: " + httpProxy);
            } else {
                logger.error("Expected HTTP proxy formatted like host:port, instead got: " + httpProxy);
            }
        }
        
    }
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        URL url = extractURL(request);
        String userName = getJournalingUserProvider(request).getJournalingUser();
        
        if (userName == null) {
            response.sendError(401, "you are not authorized to view the requested resource");
            return;
        }

        logAction(userName, url);

        URLConnection connection = null;
        InputStream in = null;
        try {
            connection = url.openConnection();
            in = connection.getInputStream();
        } catch (Exception e) {
            logger.error("Failed to connect to: " + url.toExternalForm(), e);
            throw new ServletException("Failed to connect to: " + url.toExternalForm() + ", " + e.getMessage());
        }

        try {
            String contentType = connection.getContentType();
            logger.debug("contentType = " + contentType);
            if (StringUtils.isEmpty(contentType)) {
                contentType = "text/html";
            }
            response.setContentType(contentType);
            modifyLinksToRedirect(url, in, response.getOutputStream());
            response.flushBuffer();
        }
        finally {
            try {
                in.close();
            }
            catch (IOException e) {
                logger.warn("failed to close stream to: " + url.toExternalForm());
            }
        }
    }

    private void logAction(String userName, URL url) {
        logger.info("user " + userName + " requests " + url.toExternalForm());
    }

    private URL extractURL(HttpServletRequest request) throws MalformedURLException {

        String urlParam = request.getParameter("url");

        return new URL(urlParam);
    }

    private void modifyLinksToRedirect(URL baseUrl, InputStream in, OutputStream out) throws IOException {

        HrefModifier modifier = new HrefModifier(baseUrl, new UrlModifier());
        modifier.run(new InputStreamReader(in), new OutputStreamWriter(out));
    }

    private String getRedirectUrl() {
        return (String) config.get("FQT_URL_REDIRECT");
    }

    private class UrlModifier implements HrefModifier.UrlModifier {

        public URL modify(URL url) throws MalformedURLException {
            return new URL(getRedirectUrl() + "?url=" + url.toExternalForm());
        }
    }
}
