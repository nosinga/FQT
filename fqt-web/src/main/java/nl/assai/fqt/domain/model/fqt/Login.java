package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Login implements Serializable {
    private static final long serialVersionUID = 6848472321911748244L;

	private Long id;
    private String username;
    private String password;
    private String result;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
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
        sb.append(", result = " + StringUtils.abbreviate(result, 20));
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
        return (id != null && other != null) ? id.equals(((Login) other).getId()) : super.equals(other);
    }

}
