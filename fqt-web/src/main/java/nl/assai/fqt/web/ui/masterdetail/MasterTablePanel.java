package nl.assai.fqt.web.ui.masterdetail;

import nl.assai.fqt.web.ui.TablePanel;

/**
 *
 */
public abstract class MasterTablePanel<MASTER_ENTITY>
        extends TablePanel<MASTER_ENTITY> implements MasterComponent<MASTER_ENTITY> {

    private DetailComponent detailComponent;

    protected MasterTablePanel(String caption) {
        super(caption);
    }

    public DetailComponent getDetailComponent() {
        return detailComponent;
    }

    public void setDetailComponent(DetailComponent detailComponent) {
        this.detailComponent = detailComponent;
    }

    @Override
    public void onSelect(MASTER_ENTITY item) {
        getDetailComponent().onMasterSelect(item);
    }

    @Override
    public void onDeselect() {
        getDetailComponent().onMasterDeselect();
    }
}
