package nl.assai.fqt.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;

import com.vaadin.ui.*;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.model.fqt.UserMenu;
import nl.assai.fqt.web.configuration.ConfigurationPanel;
import nl.assai.fqt.web.connections.ConnectionPanel;
import nl.assai.fqt.web.documents.DocumentAdminPanel;
import nl.assai.fqt.web.documents.DocumentPanel;

import nl.assai.fqt.web.menus.MenuNodePanel;
import nl.assai.fqt.web.permissions.PermissionPanel;
import nl.assai.fqt.web.queries.QueryPanel;
import nl.assai.fqt.web.reportconnectors.ReportConnectorPanel;
import nl.assai.fqt.web.reports.ReportPanel;
import nl.assai.fqt.web.roles.RolePanel;
import nl.assai.fqt.web.ui.MenuPanel;
import nl.assai.fqt.web.users.UserPanel;

import nl.assai.fqt.web.vscd.VSCDPanel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.vaadin.Application;

public class FqtApplication extends Application implements ApplicationContextAware {

// alle multilingual titles, dit moet mooier kunnen
// TODO
    public static String title;
    public static String login;
    public static String log_off;
    public static String username;
    public static String password;
    public static String change_password;

    private static final Logger logger = LoggerFactory.getLogger(FqtApplication.class);
    private static final CustomizedSystemMessages customizedSystemMessages = new CustomizedSystemMessages();


    private ResourceBundle i18nBundle;
    public static final String MSG_BUNDLE = "config.messages";

    private Window window;
    private SplitPanel splitPanel;
    private AutowireCapableBeanFactory beanFactory;
    private boolean customAuthentication;

    @Autowired
    private Properties config;

    public enum Screen {
        LOGIN,
        MAIN,
        CHANGEPASSWORD,
        USERS,
        ROLES,
        PERMISSIONS,
        REPORTMENUCONNECTORS,
        MENUS,
        QUERIES,
        CONNECTIONS,
        DOCUMENTS,
        DOCUMENTSADMIN,
        REPORTS,
        CONFIGURATION,
        LINKS,
        VSCD
    }

    public FqtApplication() {
        setTheme("fqt");
    }

    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        beanFactory = applicationContext.getAutowireCapableBeanFactory();
    }

    public void inject(Object object) {
        beanFactory.autowireBean(object);
    }

    @Override
    public void init() {
        refresh();
        if (customAuthentication) {
            // Set the URLs to the LogoutServlet that forces a new login
            customizedSystemMessages.setInternalErrorURL(getURL().getPath() + "logout");
            customizedSystemMessages.setSessionExpiredURL(getURL().getPath() + "logout");
            customizedSystemMessages.setCommunicationErrorURL(getURL().getPath() + "logout");
            setLogoutURL(getURL().getPath() + "logout");

            showScreen(Screen.LOGIN, title);
        } else {
            showScreen(Screen.MAIN, title);
        }
    }

    public void refresh() {
    	title = config.getProperty("FQT_TITLE");
        i18nBundle = ResourceBundle.getBundle(MSG_BUNDLE, getLocale());

        login = getMessage("login");
        log_off = getMessage("log_off");
        username = getMessage("username");
        password = getMessage("password");
        change_password = getMessage("change_password");

        // Authentication property is optional. When omitted, custom FQT authentication is disabled.
        customAuthentication = "on".equals(config.getProperty("CUSTOM_AUTHENTICATION"));


        window = new Window(title);

        setMainWindow(window);

        // Customize some common system messages to dutch text
        customizedSystemMessages.setSessionExpiredCaption("Sessie verlopen");
        customizedSystemMessages.setSessionExpiredMessage("De sessie was te lang inactief, klik hier om opnieuw in te loggen.");
        customizedSystemMessages.setCommunicationErrorCaption("Communicatieprobleem");
        customizedSystemMessages.setCommunicationErrorMessage("De verbinding met de server is verbroken, klik hier om opnieuw in te loggen.");
        customizedSystemMessages.setInternalErrorCaption("Er is een fout opgetreden");
        customizedSystemMessages.setInternalErrorMessage("De log file bevat de details, klik hier om opnieuw in te loggen.");

    }

    public void showScreen(Screen screen, String caption) {
        switch (screen) {
            case LOGIN:
                window.addComponent(new LoginPanel(caption));
                break;

            case CHANGEPASSWORD:
                window.addWindow(new ChangePasswordWindow());
                break;

            case USERS:
                splitPanel.setSecondComponent(new UserPanel(caption));
                break;

            case ROLES:
                splitPanel.setSecondComponent(new RolePanel(caption));
                break;

            case PERMISSIONS:
                splitPanel.setSecondComponent(new PermissionPanel(caption));
                break;

            case REPORTMENUCONNECTORS:
                splitPanel.setSecondComponent(new ReportConnectorPanel("Report Menu Connector"));
                break;

            case MENUS:
                splitPanel.setSecondComponent(new MenuNodePanel(caption));
                break;

            case QUERIES:
                splitPanel.setSecondComponent(new QueryPanel(caption));
                break;

            case CONNECTIONS:
                splitPanel.setSecondComponent(new ConnectionPanel(caption));
                break;

            case DOCUMENTS:
                splitPanel.setSecondComponent(new DocumentPanel(caption));
                break;

            case DOCUMENTSADMIN:
                splitPanel.setSecondComponent(new DocumentAdminPanel(caption));
                break;

            case CONFIGURATION:
                splitPanel.setSecondComponent(new ConfigurationPanel(caption));
                break;

            case REPORTS:
                splitPanel.setSecondComponent(new ReportPanel(caption));
                break;

            case VSCD:
                splitPanel.setSecondComponent(new VSCDPanel(caption));
                break;

            case MAIN:
                window.removeAllComponents();
                window.addComponent(createMainPanel());
                if (customAuthentication) {
                    window.showNotification("Logged in as", (getLoggedInUser()).getName());
                } else {
                    window.showNotification("Logged in as", (getLoggedInUser()).getIdmId());
                }
                break;
        }
    }

    private Panel createMainPanel() {
        Panel main = new Panel(title);
        main.addComponent(createSplitPanel());
        ((VerticalLayout) main.getContent()).setMargin(false);
        return main;
    }

    private SplitPanel createSplitPanel() {
        splitPanel = new SplitPanel(SplitPanel.ORIENTATION_HORIZONTAL);
        splitPanel.setFirstComponent(createMenuPanel());
        splitPanel.setSplitPosition(25);
        splitPanel.setHeight("550px");
        splitPanel.setLocked(false);
        return splitPanel;
    }

    private MenuPanel createMenuPanel() {
        List<UserMenu> userMenus = (getLoggedInUser()).getMenus();
        MenuPanel menuPanel = new MenuPanel();
        menuPanel.addMenu(userMenus);

        menuPanel.addComponent(createLogoutPanel(customAuthentication));

        Button changeLanguage = new Button(getMessage("change_language"));
//        changeLanguage.setStyleName(Reindeer.BUTTON_LINK);
        changeLanguage.addListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                Locale locale = getLocale();
                if (locale.getLanguage().contains("en")) {
                    locale = new Locale("nl");
                } else {
                    locale = new Locale("en-UK");
                }
                setLocale(locale);
                getMainWindow().showNotification(getMessage("alert_refresh_to_apply"));
                refresh();
                showScreen(Screen.MAIN, title);
            }
        });

        menuPanel.addComponent(changeLanguage);

        return menuPanel;
    }

    private LogoutPanel createLogoutPanel(boolean customAuthentication) {
        LogoutPanel panel = new LogoutPanel(customAuthentication);
        panel.setUser(getLoggedInUser());

        return panel;
    }

    public static SystemMessages getSystemMessages() {
        return customizedSystemMessages;
    }

    /**
     * @return logged in user if available, meaningful exception if null.
     */
    private User getLoggedInUser() {
        User user = (User) getUser();
        if (user == null) {
            throw new RuntimeException("A logged in user is required here, but no logged in user was found. " +
                    "Probably authentication has not been configured correctly in the application server...");
        }
        return user;
    }

    @Override
    public void setLocale(Locale locale) {
        super.setLocale(locale);
        i18nBundle = ResourceBundle.getBundle(MSG_BUNDLE, getLocale());
    }

    public String getMessage(String key) {
        try {
            return i18nBundle.getString(key);
        } catch (Exception e) {
            logger.warn("No such message key: " + key);
            return key;
        }
    }

}
