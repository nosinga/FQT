package nl.assai.fqt.web.ui.masterdetail;

import com.vaadin.ui.Component;

/**
 *
 */
public interface MasterComponent<MASTER_ENTITY>
        extends Component {

    DetailComponent getDetailComponent();

    void setDetailComponent(DetailComponent detailComponent);

    MASTER_ENTITY getValue();
}
