package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class UserMenu implements Serializable {
    private static final long serialVersionUID = 1377078732655963353L;

	private Long id;
	private Long parentId;
	private Long menuLevel;
	private Long isCycle;
	private Long hasMenuLeafChild;
	private String userName;
	private String itemName;
    private String menuType;
    private String menuSubtype;
    private String menuResourcelocation;
	private String queryName;
	private String connectionName;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public Long getMenuLevel() {
        return menuLevel;
    }

    public void setMenuLevel(Long menuLevel) {
        this.menuLevel = menuLevel;
    }

    public Long getCycle() {
        return isCycle;
    }

    public void setCycle(Long cycle) {
        isCycle = cycle;
    }

    public Long getHasMenuLeafChild() {
        return hasMenuLeafChild;
    }

    public void setHasMenuLeafChild(Long hasMenuLeafChild) {
        this.hasMenuLeafChild = hasMenuLeafChild;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getMenuType() {
        return menuType;
    }

    public void setMenuType(String menuType) {
        this.menuType = menuType;
    }

    public String getMenuSubtype() {
        return menuSubtype;
    }

    public void setMenuSubtype(String menuSubtype) {
        this.menuSubtype = menuSubtype;
    }

    public String getMenuResourcelocation() {
        return menuResourcelocation;
    }

    public void setMenuResourcelocation(String menuResourcelocation) {
        this.menuResourcelocation = menuResourcelocation;
    }

    public String getQueryName() {
        return queryName;
    }

    public void setQueryName(String queryName) {
        this.queryName = queryName;
    }

    public String getConnectionName() {
        return connectionName;
    }

    public void setConnectionName(String connectionName) {
        this.connectionName = connectionName;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", parentId = " + parentId);
        sb.append(", menuLevel = " + menuLevel);
        sb.append(", isCycle = " + isCycle);
        sb.append(", hasMenuLeafChild = " + hasMenuLeafChild);
        sb.append(", userName = " + StringUtils.abbreviate(userName, 20));
        sb.append(", itemName = " + StringUtils.abbreviate(itemName, 20));
        sb.append(", menuType = " + StringUtils.abbreviate(menuType, 20));
        sb.append(", menuSubtype = " + StringUtils.abbreviate(menuSubtype, 20));
        sb.append(", menuResourcelocation = " + StringUtils.abbreviate(menuResourcelocation, 20));
        sb.append(", queryName = " + StringUtils.abbreviate(queryName, 20));
        sb.append(", connectionName = " + StringUtils.abbreviate(connectionName, 20));
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((UserMenu) other).getId()) : super.equals(other);
    }

}
