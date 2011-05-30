package nl.assai.fqt.web.queries;

import nl.assai.fqt.web.ui.AbstractWindow;

import com.vaadin.ui.Component;
import com.vaadin.ui.TextField;
import com.vaadin.ui.VerticalLayout;

public class ClobWindow extends AbstractWindow {

	private String clob;
	private String caption;
	
	public ClobWindow(String clob, String caption) {
		this.clob = clob;
		this.caption = caption;
	}
	
	@Override
	protected void initLayout() {
		VerticalLayout layout = new VerticalLayout();
    	layout.addComponent(createClobArea());
    	
    	layout.setSizeFull();
    	layout.setSpacing(true);
    	layout.setMargin(true);
    	
    	setCaption(caption);
    	setResizable(true);
    	setClosable(true);
    	setContent(layout);
        setWidth("80%");
        setHeight("100%");

    	setModal(true);
    	center();
	}

	private Component createClobArea() {
		TextField clobArea = new TextField();
		clobArea.setRows(500);
		clobArea.setSizeFull();
		clobArea.setValue(clob);
		clobArea.setReadOnly(true);
		clobArea.addStyleName("fqt-monospace-style");
		
		return clobArea;
	}
}
