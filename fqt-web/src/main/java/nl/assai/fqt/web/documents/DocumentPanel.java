package nl.assai.fqt.web.documents;

import com.vaadin.data.util.FilesystemContainer;
import com.vaadin.event.ItemClickEvent;
import com.vaadin.terminal.FileResource;
import com.vaadin.ui.*;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.themes.Reindeer;

import nl.assai.fqt.domain.model.fqt.Action;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.io.File;
import java.io.FilenameFilter;
import java.util.Properties;

public class DocumentPanel extends Panel {
	private Table documentsTable;
	private String root;
	private String folder;
    private Properties config;
    private ApplicationService applicationService;

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;
    
	public DocumentPanel(String folder) {
		this.folder = folder;
    }

    @Autowired
    public void setConfig(Properties config) {
        this.config = config;
    }

    @Autowired
    void setApplicationService(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @Override
    public void attach() {

        ((FqtApplication) getApplication()).inject(this);
        root = config.getProperty("FQT_DOCUMENTATIEROOT_OS_DIR");

		VerticalLayout layout = new VerticalLayout();
        layout.addComponent(new Label("<font size=+1><b>" + folder + "</b></font>", Label.CONTENT_XHTML));
        layout.addComponent(createFileTable());
        layout.addComponent(createOpenButton());
        layout.setSpacing(true);
        layout.setMargin(true);

        setContent(layout);
        setStyleName(Reindeer.PANEL_LIGHT);
        setSizeFull();
    }

    private Button createOpenButton() {
		Button open = new Button("Open");
		open.addListener(new ClickListener() {

			public void buttonClick(ClickEvent event) {
				if (documentsTable.getValue() != null) {
					onSelect(documentsTable.getValue());
				}
			}
		});

		return open;
    }

private Table createFileTable() {
    	documentsTable = new Table();
    	documentsTable.setContainerDataSource(new FilesystemContainer(new File(root, folder), new FilenameFilter() {
            public boolean accept(File dir, String fileName) {
                if (fileName.startsWith(".")) {
                    return false;
                }
                return true;
            }
    	}, false));
    	documentsTable.setVisibleColumns(new String[] {"Name", "Size", "Last Modified"});
    	documentsTable.setSelectable(true);
    	documentsTable.setPageLength(20);
    	documentsTable.setHeight("411px");
    	documentsTable.setWidth("100%");
    	documentsTable.setImmediate(true);

    	documentsTable.addListener(new ItemClickEvent.ItemClickListener() {
    		public void itemClick(ItemClickEvent event) {
    			if (event.isDoubleClick()) {
    				Object item = documentsTable.getValue();
    				if (item != null) {
    					onSelect(item);
    				}
    			}
			}
    	});

		return documentsTable;
    }

	private void onSelect(Object item) {
	    File file = (File) item;
        Action action = new Action();
        String actionValue = file.getAbsolutePath();
        action.setAction("download document: " + actionValue);
        action.setUsername(applicationService.getCurrentUsername());
        fqtRepository.insertAction(action);
        
        getApplication().getMainWindow().open(new FileResource(file, getApplication()), "_new");
 	}

}


