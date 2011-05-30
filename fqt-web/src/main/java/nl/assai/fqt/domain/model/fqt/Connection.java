package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class Connection implements Serializable {
    private static final long serialVersionUID = 6118799500908771749L;

    private Long id;
    private Long rv;
    private String name;
	private String username;
	private String password;
	private String servicename;
	private String tnsName;
	private String description;

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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getServicename() {
        return servicename;
    }

    public void setServicename(String servicename) {
        this.servicename = servicename;
    }

    public String getTnsName() {
        return tnsName;
    }

    public void setTnsName(String tnsName) {
        this.tnsName = tnsName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", name = " + StringUtils.abbreviate(name, 20));
        sb.append(", username = " + StringUtils.abbreviate(username, 20));
        sb.append(", servicename = " + StringUtils.abbreviate(servicename, 20));
        sb.append(", tnsName = " + StringUtils.abbreviate(tnsName, 20));
        sb.append(", description = " + StringUtils.abbreviate(description, 20));
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Connection) other).getId()) : super.equals(other);
    }

}
