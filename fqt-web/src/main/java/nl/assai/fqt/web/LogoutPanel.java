package nl.assai.fqt.web;

import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.web.FqtApplication.Screen;

import com.vaadin.ui.Button;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.Panel;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.themes.Reindeer;

import static nl.assai.fqt.web.FqtApplication.change_password;
import static nl.assai.fqt.web.FqtApplication.username;
import static nl.assai.fqt.web.FqtApplication.log_off;


public class LogoutPanel extends Panel {
	private Label userLabel;
	private boolean customAuthentication;
	
	public LogoutPanel(boolean customAuthentication) {
		this.customAuthentication = customAuthentication;
		userLabel = new Label();
		userLabel.setContentMode(Label.CONTENT_XHTML);
		
		addComponent(userLabel);
		setStyleName(Reindeer.PANEL_LIGHT);
		
		if (customAuthentication) {
			addComponent(createButtons());
		}

	}

	public void setUser(User user) {
		if (customAuthentication) { 
			userLabel.setValue(username +" = <b>" + user.getName() + "</b>");
		} else {
			userLabel.setValue(username +" = <b>" + user.getIdmId() + "</b>");
		}
	}
	

	private HorizontalLayout createButtons() {
		Button logout = new Button(log_off);
		logout.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				getApplication().close();
			}
		});



        Button change = new Button(change_password);
		change.setStyleName(Reindeer.BUTTON_LINK);
		change.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				((FqtApplication) getApplication()).showScreen(Screen.CHANGEPASSWORD, "");
			}
		});

		HorizontalLayout buttons = new HorizontalLayout();
		buttons.addComponent(logout);
		buttons.addComponent(change);
		buttons.setSpacing(true);

		return buttons;
	}



}
