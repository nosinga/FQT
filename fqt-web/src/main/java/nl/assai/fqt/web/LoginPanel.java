package nl.assai.fqt.web;

import com.vaadin.event.ShortcutAction.KeyCode;
import com.vaadin.terminal.UserError;
import com.vaadin.ui.Button;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Form;
import com.vaadin.ui.Panel;
import com.vaadin.ui.TextField;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication.Screen;
import nl.assai.fqt.web.ui.RequiredTextField;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Properties;

public class LoginPanel extends Panel {
	private Form loginForm;
    private ApplicationService applicationService;
    private Properties config;
    private String prefilledUserName = "";
    private String prefilledPassword = "";

	public LoginPanel(String caption) {
    	setCaption(caption);
    	setHeight("250px");
    	setWidth("500px");
	}

    @Autowired
    public void setConfig(Properties config) {
        this.config = config;
    }

    @Override
    public void attach() {
        ((FqtApplication) getApplication()).inject(this);
        //for development
        String usernameFromProperty = config.getProperty("PREFILLED_USERNAME");
        String passwordFromProperty = config.getProperty("PREFILLED_PASSWORD");
        prefilledUserName = (usernameFromProperty != null)
        		? usernameFromProperty
				: "";
        prefilledPassword = (passwordFromProperty != null) 
        		? passwordFromProperty 
				: "";
        addComponent(createLoginForm());
        addComponent(createLoginButton());
    }

    @Autowired
    public void setApplicationService(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

	public void doLogin(ClickEvent event) {

        ensureInitialized();
        loginForm.setComponentError(null); //clear previous errors
        loginForm.setValidationVisible(true);
		try {
			if (loginForm.isValid()) {
				String userID = (String) loginForm.getField("name").getValue();
				String password = (String) loginForm.getField("password").getValue();
				User user = applicationService.login(userID, password);
				if (user == null) {
					loginForm.setComponentError(new UserError("Username or password not correct!"));
				} else {
					getApplication().setUser(user);
					((FqtApplication) getApplication()).showScreen(Screen.MAIN, "");
				}
			}
		} catch (Exception e) {
	    	throw new RuntimeException(e);
		}
	}

    private void ensureInitialized() {
        // we need to do this lazy, since getApplication() returns null when called before doLogin()
        if (applicationService == null) {
            ((FqtApplication) getApplication()).inject(this);
        }
    }

	private Button createLoginButton() {
    	Button loginButton = new Button("Login");
    	loginButton.setClickShortcut(KeyCode.ENTER);
    	loginButton.addListener(Button.ClickEvent.class, this, "doLogin");
    	return loginButton;
	}

	private Form createLoginForm() {
    	TextField userField = new RequiredTextField(FqtApplication.username);
    	userField.setColumns(15);
    	userField.setValue(prefilledUserName);
    	TextField passwordField = new RequiredTextField(FqtApplication.password);
    	passwordField.setSecret(true);
    	passwordField.setColumns(15);
        passwordField.setValue(prefilledPassword);

    	loginForm = new Form();
    	loginForm.addField("name", userField);
    	loginForm.addField("password", passwordField);
    	loginForm.setValidationVisible(false);
    	loginForm.setCaption("Login");

    	return loginForm;
	}

}
