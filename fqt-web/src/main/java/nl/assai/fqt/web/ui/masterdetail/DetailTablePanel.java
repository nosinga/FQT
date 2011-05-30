package nl.assai.fqt.web.ui.masterdetail;

import nl.assai.fqt.web.ui.TablePanel;

/**
 *
 */
public abstract class DetailTablePanel<MASTER_ENTITY, DETAIL_ENTITY>
        extends TablePanel<DETAIL_ENTITY> implements DetailComponent<MASTER_ENTITY> {

    private MasterComponent masterComponent;

    public DetailTablePanel(String caption) {
        super(caption);
    }

    @SuppressWarnings("unchecked")
    public MasterComponent<MASTER_ENTITY> getMasterComponent() {
        return masterComponent;
    }

    public void setMasterComponent(MasterComponent masterComponent) {
        this.masterComponent = masterComponent;
    }
}
