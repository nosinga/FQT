package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class Menu implements Serializable {
    private static final long serialVersionUID = -2102167281130249118L;

    public enum Type {
        MAIN, RPT, URL
    }

    public enum SubType {
        STATIC, RPT, URL, DOC, DCA
    }

	private Long id;
    private String name;
    private Type type;
    private String description;
    private String order;
    private SubType subType;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public SubType getSubType() {
        return subType;
    }

    public void setSubType(SubType subType) {
        this.subType = subType;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", name = " + StringUtils.abbreviate(name, 20));
        sb.append(", type = " + type);
        sb.append(", description = " + StringUtils.abbreviate(description, 20));
        sb.append(", order = " + StringUtils.abbreviate(order, 20));
        sb.append(", type = " + subType);
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Menu) other).getId()) : super.equals(other);
    }

}
