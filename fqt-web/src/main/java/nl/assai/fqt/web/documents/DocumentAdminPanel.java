package nl.assai.fqt.web.documents;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.OutputStream;
import java.util.Properties;

import nl.assai.fqt.domain.model.fqt.Action;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.domain.service.ApplicationService;
import nl.assai.fqt.web.FqtApplication;

import org.springframework.beans.factory.annotation.Autowired;

import com.vaadin.data.util.FilesystemContainer;
import com.vaadin.event.ItemClickEvent;
import com.vaadin.terminal.FileResource;
import com.vaadin.ui.Button;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.Panel;
import com.vaadin.ui.Table;
import com.vaadin.ui.Upload;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.Upload.Receiver;
import com.vaadin.ui.Upload.SucceededEvent;
import com.vaadin.ui.Window.Notification;
import com.vaadin.ui.themes.Reindeer;
import org.springframework.beans.factory.annotation.Qualifier;

public class DocumentAdminPanel extends Panel implements Receiver {
	private Table documentsTable;
	private String root;
	private String folder;
    private Properties config;
    private Upload upload;
    private File file;
    private ApplicationService applicationService;

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;

	public DocumentAdminPanel(String folder) {
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
        String slash = System.getProperty("file.separator");
        if (!root.endsWith(slash)) {
        	root += slash;
        }

		VerticalLayout layout = new VerticalLayout();
        layout.addComponent(new Label("<font size=+1><b>" + folder + "</b></font>", Label.CONTENT_XHTML));
        layout.addComponent(createFileTable());
        layout.addComponent(createUpload());
        layout.addComponent(createButtons());
        layout.setSpacing(true);
        layout.setMargin(true);

        setContent(layout);
        setStyleName(Reindeer.PANEL_LIGHT);
        setSizeFull();
    }

    private Upload createUpload() {
		upload = new Upload("Document uploaden", this);

    	upload.addListener(new Upload.SucceededListener() {			
			public void uploadSucceeded(SucceededEvent event) {
				getWindow().showNotification("Document geupload: " + file.getName());
				fillFileTable();
			}
        });

		return upload;
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

    private HorizontalLayout createButtons() {
    	HorizontalLayout hLayout = new HorizontalLayout();
        hLayout.setSpacing(true);
        hLayout.addComponent(createOpenButton());
        hLayout.addComponent(createDeleteButton());

        return hLayout;
    }

    private Button createDeleteButton() {
		Button delete = new Button("Verwijder");
		delete.addListener(new ClickListener() {

			public void buttonClick(ClickEvent event) {
				if (documentsTable.getValue() != null) {
					File selectedFile = (File) documentsTable.getValue();
					if (selectedFile.delete()) {
						getWindow().showNotification("Document verwijderd: " + selectedFile.getName());
					}
					fillFileTable();
				}
			}
		});

		return delete;
    }

    private Table createFileTable() {
    	documentsTable = new Table();
    	fillFileTable();
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

    private void fillFileTable() {
        documentsTable.setContainerDataSource(new FilesystemContainer(new File(root, folder), new FilenameFilter() {
            public boolean accept(File dir, String fileName) {
                if (fileName.startsWith(".")) {
                    return false;
                }
                return true;
            }
        }, false));
    	documentsTable.setVisibleColumns(new String[] {"Name", "Size", "Last Modified"});
    }

	private void onSelect(Object item) {
        getApplication().getMainWindow().open(new FileResource((File) item, getApplication()), "_new");
 	}

	public OutputStream receiveUpload(String filename, String MIMEType) {
		FileOutputStream fos = null;
		File uploadDir = new File(root + folder);
		if (!uploadDir.exists()) {
		    uploadDir.mkdirs();
		}
		
		file = new File(uploadDir, filename);
        Action action = new Action();
        String actionValue = filename;
        actionValue += ", " + file.getAbsolutePath();
        action.setAction("upload document: " + actionValue);
        action.setUsername(applicationService.getCurrentUsername());
        fqtRepository.insertAction(action);
        try {
        	fos = new FileOutputStream(file);
        } catch (final java.io.FileNotFoundException e) {
        	getApplication().getMainWindow().showNotification(
                    "Een fout is opgetreden:",
                    e.toString(),
                    Notification.TYPE_ERROR_MESSAGE
                    );
            return null;
        }
        return fos;
	}
}	

