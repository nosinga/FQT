package nl.assai.fqt.service.util;

public class StaticJournalingUserProvider implements JournalingUserProvider {

    private final String auditUser;

    public StaticJournalingUserProvider(String auditUser) {
        this.auditUser = auditUser;
    }

    public String getJournalingUser() {
        return auditUser;
    }
}
