package nl.assai.fqt.domain.model.fqt;

import org.apache.commons.lang.StringUtils;

import java.io.Serializable;

public class UrlLink implements Serializable {
    private static final long serialVersionUID = 3563909075529234435L;

    private String url;
    private String name;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("name = " + StringUtils.abbreviate(name, 20));
        sb.append(", url = " + StringUtils.abbreviate(url, 20));
        sb.append("}");
        return sb.toString();
    }

}
