package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class Permission implements Serializable {
    private static final long serialVersionUID = -7474768464231475139L;
    public static final String[] TYPES = new String[] {"REPORT", "SCREEN", "URL", "PHP"};

	private Long id;
    private Long rv;
	private String name;
	private String type;
	private String value;
	private Long menuId;
	private Long sqlId;
	private Long conId;
    private String orderBy;

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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Long getMenuId() {
        return menuId;
    }

    public void setMenuId(Long menuId) {
        this.menuId = menuId;
    }

    public Long getSqlId() {
        return sqlId;
    }

    public void setSqlId(Long sqlId) {
        this.sqlId = sqlId;
    }

    public Long getConId() {
        return conId;
    }

    public void setConId(Long conId) {
        this.conId = conId;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    @Override
    public String toString() {
        return name + " (" + type + ")";
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Permission) other).getId()) : super.equals(other);
    }

}
