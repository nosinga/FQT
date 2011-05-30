package nl.assai.fqt.domain.model.fqt;

import java.io.Serializable;

/**
 * Created by IntelliJ IDEA.
 * User: nanneosinga
 * Date: 5/21/11
 * Time: 10:31 PM
 * To change this template use File | Settings | File Templates.
 */
public class Contact implements Serializable {
    private static final long serialVersionUID = -7482768464231475140L;

	private Long id;
    private String description;
    private String contactDate;
    private Long   vscdId;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getVscdId() {
        return vscdId;
    }

    public void setVscdId(Long vscdId) {
        this.vscdId = vscdId;
    }

    public String getDescription() {

        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContactDate() {
        return contactDate;
    }

    public void setContactDate(String contactDate) {
        this.contactDate = contactDate;
    }



    @Override
    public String toString() {
        return description;
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Contact) other).getId()) : super.equals(other);
    }

}
