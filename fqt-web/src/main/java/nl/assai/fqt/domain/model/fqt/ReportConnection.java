package nl.assai.fqt.domain.model.fqt;

import java.io.Serializable;

public class ReportConnection implements Serializable {
    private static final long serialVersionUID = -7474768464231475138L;
    public static final String[] ORDERBYS = new String[] {"01","02","03","04","05","06","07","08","09","10"
                                                        ,"11","12","13","14","15","16","17","18","19","20"
                                                         };

	private Long id;
    private Long rv;
    private String name;
    private String type;
    private String menuName;
	private Long menuId;
	private Long sqlId;
    private Long conId;
    private Long roleId;
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

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
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

    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    @Override
    public String toString() {
        return name + " (" + menuName+ ")";
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((ReportConnection) other).getId()) : super.equals(other);
    }

}

