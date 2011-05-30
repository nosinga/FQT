package nl.assai.fqt.web.ui.masterdetail;

import com.vaadin.ui.Component;

/**
 *
 */
public interface DetailComponent<MASTER_ENTITY> extends Component {

    void setMasterComponent(MasterComponent masterComponent);
    MasterComponent getMasterComponent();

    void onMasterSelect(MASTER_ENTITY item);
    void onMasterDeselect();
}
