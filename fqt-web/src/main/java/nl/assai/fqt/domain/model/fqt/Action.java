package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Action implements Serializable  {
    private static final long serialVersionUID = -7114520195978715807L;

    private Long id;
    private String username;
    private String action;
    private Date timestamp;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", username = " + StringUtils.abbreviate(username, 20));
        sb.append(", action = " + StringUtils.abbreviate(action, 20));
        sb.append(", timestamp = " + (timestamp == null ? "null" : new SimpleDateFormat("yyyyMMdd HH:mm:ss").format(timestamp)));
        sb.append("}");
        return sb.toString();
    }
    
    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Action) other).getId()) : super.equals(other);
    }

}
