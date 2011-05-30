package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Role implements Serializable {
    private static final long serialVersionUID = 6563909074429222435L;

	private Long id;
    private Long rv;
    private String name;
    private List<Permission> permissions = new ArrayList<Permission>();

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

    public List<Permission> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<Permission> permissions) {
        this.permissions = permissions;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", name = " + StringUtils.abbreviate(name, 20));
        if (permissions != null) {
            sb.append(", permissions = [");
            for (Permission permission : permissions) {
                sb.append("," + permission);
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
        return (id != null && other != null) ? id.equals(((Role) other).getId()) : super.equals(other);
    }

}
