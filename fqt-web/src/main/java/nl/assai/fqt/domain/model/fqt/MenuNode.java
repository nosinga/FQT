package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class MenuNode implements Serializable {
    private static final long serialVersionUID = -2304167282230249139L;

    private Long id;
    private Long rv;
    private Long parentId;
    private String menuName;
    private String parentMenuName;
    private String menuDescription;
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

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getMenuDescription() {
        return menuDescription;
    }

    public void setMenuDescription(String menuDescription) {
        this.menuDescription = menuDescription;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public String getParentMenuName() {
        return parentMenuName;
    }

    public void setParentMenuName(String parentMenuName) {
        this.parentMenuName = parentMenuName;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", parentMenuName = " + parentMenuName);
        sb.append(", menuName = " + StringUtils.abbreviate(menuName, 20));
        sb.append(", menuDescription = " + StringUtils.abbreviate(menuDescription, 20));
        sb.append(", orderBy = " + StringUtils.abbreviate(orderBy, 20));
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((MenuNode) other).getId()) : super.equals(other);
    }

}
