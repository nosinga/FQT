package nl.assai.fqt.web.users;

import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.model.fqt.*;

import java.util.List;

public class TableItemUser {

	private final User delegateUser;
	private TableItemUser templateUser;
	private String password = "";

	public TableItemUser(User delegateUser) {
		this.delegateUser = delegateUser;
	}

    @Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((delegateUser == null) ? 0 : delegateUser.hashCode());
		return result;
	}

    @Override
	public boolean equals(Object otherObject) {

		if (otherObject instanceof TableItemUser) {
			User otherDelegate = ((TableItemUser) otherObject).getDelegateUser();
			return delegateUser.equals(otherDelegate);
		}

		return false;
	}

	public String getName() {
        return delegateUser.getName();
    }

    public void setName(String name) {
        delegateUser.setName(name);
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
	public String getIdmId() {
		return delegateUser.getIdmId();
	}

	public void setIdmId(String idmId) {
		delegateUser.setIdmId(idmId);		
	}

    public List<Role> getRoles() {
        return delegateUser.getRoles();
    }

    public List<Permission> getPermissions() {
        return delegateUser.getPermissions();
    }

    public boolean hasPermissions(String... permissionNames) {
        return delegateUser.hasPermissions(permissionNames);
    }

    public List<Query> getQueries() {
        return delegateUser.getQueries();
    }

    public List<UserMenu> getMenus() {
        return delegateUser.getMenus();
    }

    public Long getId() {
        return delegateUser.getId();
    }

    @Override
	public String toString() {
		return delegateUser.toString();
	}

    public void setTemplateUser(TableItemUser templateUser) {
        this.templateUser = templateUser;
    }

    public TableItemUser getTemplateUser() {
		return templateUser;
	}

	public User getDelegateUser() {
		return delegateUser;
	}

	public void applyChangesOnDelegate() {

		if (! "".equals(getPassword())) {
			getDelegateUser().setPassword(getPassword());
		}
	}
}
