package nl.assai.fqt.web.ui;

import com.vaadin.ui.Label;

public class Title extends Label {
	public Title(String caption) {
		super("<font size=+1><b>" + caption + "</b></font>", Label.CONTENT_XHTML);
	}
}
