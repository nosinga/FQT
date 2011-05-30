package nl.assai.fqt.web.links;

import com.vaadin.terminal.ExternalResource;
import com.vaadin.terminal.Resource;
import com.vaadin.ui.Button;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Component;
import com.vaadin.ui.Embedded;
import com.vaadin.ui.VerticalLayout;
import nl.assai.fqt.domain.model.fqt.UrlLink;
import nl.assai.fqt.web.ui.AbstractWindow;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Properties;

/**
 *
 */
public class LinkRedirectWindow extends AbstractWindow {

    private final UrlLink link;
    private Properties config;

    public LinkRedirectWindow(UrlLink link) {
        this.link = link;
    }

    @Autowired
    public void setConfig(Properties config) {
        this.config = config;
    }

    private String getRedirectUrl() {
        return (String) config.get("FQT_URL_REDIRECT");
    }

    private String getGucBaseUrl() {
        String url = (String) config.get("GUC_CONFIG_BASE_URL");
        return (url == null ? "GUC_CONFIG_BASE_URL" : url);
    }
    
    @Override
    protected void initLayout() {

        setCaption("Link: " + link.getName());

        VerticalLayout layout = new VerticalLayout();
        Component linkContent = createLinkContentComponent();
        layout.addComponent(linkContent);
        layout.addComponent(createCloseButton());
        
        layout.setExpandRatio(linkContent, 0.9f);
        layout.setSizeFull();
        center();
        setWidth("90%");
        setHeight("100%");

        setContent(layout);

    }

    private Component createLinkContentComponent() {

        String url = link.getUrl().replace("GUC_CONFIG_BASE_URL", getGucBaseUrl());
        Resource resource = new ExternalResource(getRedirectUrl() + "?url=" + url, "text/html");
        
        Embedded linkContent = new Embedded(link.getName(), resource);

        linkContent.setType(Embedded.TYPE_BROWSER);
        linkContent.setSizeFull();

        return linkContent;
    }

    private Button createCloseButton() {

        return new Button("Sluiten", new Button.ClickListener() {

            public void buttonClick(ClickEvent event) {
                close();
            }
        });
    }
}
