package nl.assai.fqt.domain.model.fqt;

import java.io.Serializable;

public class Link implements Serializable {
    private static final long serialVersionUID = -6412222735076006405L;

    private Long id;
    private Long rv;
    private Long fromId;
    private Long toId;

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

    public Long getFromId() {
        return fromId;
    }

    public void setFromId(Long fromId) {
        this.fromId = fromId;
    }

    public Long getToId() {
        return toId;
    }

    public void setToId(Long toId) {
        this.toId = toId;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", fromId = " + fromId);
        sb.append(", toId = " + toId);
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Link) other).getId()) : super.equals(other);
    }

}
