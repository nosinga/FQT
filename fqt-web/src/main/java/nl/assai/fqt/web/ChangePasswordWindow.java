package nl.assai.fqt.web;

import com.vaadin.terminal.UserError;
import com.vaadin.ui.*;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import nl.assai.fqt.domain.model.fqt.User;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.ui.RequiredTextField;
import org.springframework.beans.factory.annotation.Autowired;

public class ChangePasswordWindow extends Window {

	private Form changePasswordForm;
    private ApplicationService applicationService;

    @Override
    public void attach() {

        super.attach();

        ((FqtApplication) getApplication()).inject(this);

    	addComponent(createChangePasswordForm());
    	setCaption("Change Password");
    	setResizable(false);
    	setModal(true);
    	setHeight("250px");
    	setWidth("500px");
    	center();
	}

    @Autowired
    public void setApplicationService(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    public void doChangePassword(ClickEvent event) {
        changePasswordForm.setComponentError(null); //clear previous errors
        changePasswordForm.setValidationVisible(true);
		try {
            if (changePasswordForm.isValid()) {
                String currentPassword = (String) changePasswordForm.getField("currentPassword").getValue();
                String newPassword = (String) changePasswordForm.getField("newPassword").getValue();
                String confirmPassword = (String) changePasswordForm.getField("confirmPassword").getValue();
                if (!newPassword.equals(confirmPassword)) {
                    changePasswordForm.setComponentError(new UserError("New password and confirmed password differ !"));
                } else {
               		if (!applicationService.changePassword(
                            (User) getApplication().getUser(), currentPassword, newPassword)) {
                        changePasswordForm.setComponentError(new UserError("Old password not correct, Password has not been changed"));
               		} else {
               			getApplication().getMainWindow().showNotification("Your password has changed");
               			close();
               		}
                }
            }
		} catch (Exception e) {
		    throw new RuntimeException(e);
		}
	}

	private Form createChangePasswordForm() {
    	TextField currentPasswordField = new RequiredTextField("Enter your Current password");
        currentPasswordField.setSecret(true);

    	TextField newPasswordField = new RequiredTextField("Enter your New password");
    	newPasswordField.setSecret(true);

    	TextField confirmPasswordField = new RequiredTextField("Confirm your New password");
    	confirmPasswordField.setSecret(true);

    	changePasswordForm = new Form();
    	changePasswordForm.addField("currentPassword", currentPasswordField);
    	changePasswordForm.addField("newPassword", newPasswordField);
    	changePasswordForm.addField("confirmPassword", confirmPasswordField);
    	changePasswordForm.getFooter().addComponent(createButtons());
     	changePasswordForm.setValidationVisible(false);

    	return changePasswordForm;
	}

	private HorizontalLayout createButtons() {
    	Button saveButton = new Button("Save");
    	saveButton.addListener(Button.ClickEvent.class, this, "doChangePassword");

    	Button cancelButton = new Button("Cancel");
    	cancelButton.addListener(new ClickListener() {

			public void buttonClick(ClickEvent event) {
				close();
			}
		});

    	HorizontalLayout layout = new HorizontalLayout();
    	layout.addComponent(saveButton);
    	layout.addComponent(cancelButton);
    	layout.setSpacing(true);

    	return layout;
	}

}
