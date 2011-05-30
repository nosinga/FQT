package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;
import java.util.*;

public class User implements Serializable {
    private static final long serialVersionUID = 7147282280971062555L;

    private Long id;
    private Long rv;
	private String name;
	private String password;
	private String idmId;

	private List<Role> roles = new ArrayList<Role>();
	private List<Permission> permissions = new ArrayList<Permission>();
	private List<Query> queries = new ArrayList<Query>();
    private List<UserMenu> menus = new ArrayList<UserMenu>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRv() {
        return rv;
    }

    public void setRv(Long rv) {
        this.rv = rv;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getIdmId() {
        return idmId;
    }

    public void setIdmId(String idmId) {
        this.idmId = idmId;
    }

    public List<Role> getRoles() {
        return roles;
    }

    public void setRoles(List<Role> roles) {
        this.roles = roles;
    }

    public List<Permission> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<Permission> permissions) {
        this.permissions = permissions;
    }

    public List<Query> getQueries() {
        return queries;
    }

    public void setQueries(List<Query> queries) {
        this.queries = queries;
    }

    public List<UserMenu> getMenus() {
        return menus;
    }

    public void setMenus(List<UserMenu> menus) {
        this.menus = menus;
    }

    public boolean hasPermissions(String... permissionNames) {

        SortedSet<String> checkList = new TreeSet<String>(Arrays.asList(permissionNames));

        for (Permission permission : getPermissions()) {
            checkList.remove(permission.getName());
        }

        return checkList.isEmpty();
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", name = " + StringUtils.abbreviate(name, 20));
        sb.append(", idmId = " + StringUtils.abbreviate(idmId, 20));
        if (roles != null) {
            sb.append(", roles = [");
            for (Role role : roles) {
                sb.append("," + role);
            }
            sb.append("]");
        }
        if (permissions != null) {
            sb.append(", permissions = [");
            for (Permission permission : permissions) {
                sb.append("," + permission);
            }
            sb.append("]");
        }
        if (queries != null) {
            sb.append(", queries = [");
            for (Query query : queries) {
                sb.append("," + query);
            }
            sb.append("]");
        }
        if (menus != null) {
            sb.append(", menus = [");
            for (UserMenu menu : menus) {
                sb.append("," + menu);
            }
            sb.append("]");
        }
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((User) other).getId()) : super.equals(other);
    }

}
