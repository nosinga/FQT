package nl.assai.fqt.web.ui;

import java.util.List;

import com.vaadin.event.ShortcutAction;
import com.vaadin.ui.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vaadin.data.Item;
import com.vaadin.data.Property;
import com.vaadin.data.Property.ValueChangeEvent;
import com.vaadin.data.util.BeanItem;
import com.vaadin.data.util.BeanItemContainer;
import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.Button.ClickListener;
import com.vaadin.ui.themes.Reindeer;

public abstract class TablePanel<T> extends AbstractPanel {
    public GridLayout gridLayout;
    public GridLayout gridLayoutSearch;
	public HorizontalLayout buttonLayout;
	protected String caption;
	public Table table;
	protected Button insert;
	protected Button update;
	protected Button delete;
    protected Mode mode;
	private String sortProperty;
	private boolean ascending;
	private boolean hasFormExecuteButton;

    public Form   searchForm;
    public Button searchButton;
    protected String search;

    private static final Logger logger = LoggerFactory.getLogger(TablePanel.class);

    public TablePanel(String caption) {
    	this.caption = caption;
    }
    
	protected void setSortProperty(String sortProperty) {
		this.sortProperty = sortProperty;
	}
	
	protected String getSortProperty() {
		
		if (sortProperty != null) {
			return sortProperty;
		}
		else {
			return getTableProperties()[0];
		}
	}
	
    public void setAscending(boolean ascending) {
		this.ascending = ascending;
	}

	public boolean isAscending() {
		return ascending;
	}
	
	public void addFormExecuteButton(boolean value) {
		hasFormExecuteButton = value;
	}
	
	public boolean hasFormExecuteButton() {
		return hasFormExecuteButton;
	}

    public void initLayout() {

        buttonLayout = new HorizontalLayout();
        buttonLayout.setSpacing(true);
        
		gridLayout = new GridLayout(2, 2);
		gridLayout.addComponent(buttonLayout, 1, 1);
		gridLayout.setComponentAlignment(buttonLayout, Alignment.MIDDLE_RIGHT);
		
		gridLayout.addComponent(createTable(), 0, 0, 1, 0);
		gridLayout.addComponent(createButtons(null), 0, 1);
		gridLayout.setSpacing(true);
		gridLayout.setSizeFull();

        VerticalLayout layout = new VerticalLayout();
        layout.addComponent(new Title(caption));

        gridLayoutSearch = new GridLayout(2, 1);
        gridLayoutSearch.addComponent(createSearchForm(),0,0);
        gridLayoutSearch.addComponent(createSearchButton(),1,0);
        gridLayoutSearch.setComponentAlignment(searchButton, Alignment.MIDDLE_RIGHT);

        layout.addComponent(gridLayoutSearch);

        searchButton.setEnabled(true);


        layout.addComponent(gridLayout);
        layout.setSpacing(true);
        layout.setMargin(true);

        setContent(layout);
        setStyleName(Reindeer.PANEL_LIGHT);
        setSizeFull();
        sortTable(getSortProperty(), isAscending());

        init();
    }


    public void initSearchLayout(String search) {

        buttonLayout = new HorizontalLayout();
        buttonLayout.setSpacing(true);

		gridLayout = new GridLayout(2, 2);
		gridLayout.addComponent(buttonLayout, 1, 1);
		gridLayout.setComponentAlignment(buttonLayout, Alignment.MIDDLE_RIGHT);

		gridLayout.addComponent(createSearchTable(search), 0, 0, 1, 0);
		gridLayout.addComponent(createButtons(null), 0, 1);

		gridLayout.setSpacing(true);
		gridLayout.setSizeFull();

        VerticalLayout layout = new VerticalLayout();
        layout.addComponent(new Title(caption));

        gridLayoutSearch = new GridLayout(2, 1);
        gridLayoutSearch.addComponent(createSearchForm(),0,0);
        gridLayoutSearch.addComponent(createSearchButton(),1,0);
        gridLayoutSearch.setComponentAlignment(searchButton, Alignment.MIDDLE_RIGHT);

        layout.addComponent(gridLayoutSearch);

        searchButton.setEnabled(true);

        layout.addComponent(gridLayout);
        layout.setSpacing(true);
        layout.setMargin(true);

        setContent(layout);
        setStyleName(Reindeer.PANEL_LIGHT);
        setSizeFull();

        init();
    }

    
	
    @Override
    public void addComponent(Component component) {
    	if (component instanceof Button) {
    		buttonLayout.addComponent(component);
    		component.setEnabled(false);
    	} else {
    		gridLayout.removeComponent(table);
    		gridLayout.addComponent(createTable(), 0, 0);
    		
	        Panel panel = new Panel();
	        panel.setCaption(component.getCaption());
			panel.setHeight("411px");
	        panel.addComponent(component);
			gridLayout.addComponent(panel, 1, 0);
  			component.setCaption(null);
    	}
	}

	public void hideButtons() {
		insert.setVisible(false);
		update.setVisible(false);
		delete.setVisible(false);
	}
	
	@SuppressWarnings("unchecked")
	public final T getValue() {
		return (T) table.getValue();
	}

    protected abstract void init();

	public abstract FormFieldFactory createFormFieldFactory();
	public abstract String[] getFormProperties();
	public abstract String[] getTableProperties();

	public abstract void onSelect(T item);
	public abstract void onDeselect();
	
	public abstract void onInsert(T item) throws Exception;
	public abstract void onUpdate(T item) throws Exception;
	public abstract void onDelete(T item) throws Exception;
	
    public abstract List<T> getTableItems();
    public abstract List<T> getSearchTableItems(String search);
	public abstract T createTableItem();
	
    protected Table createTable() {
        table = new Table();
        table.addListener(new Property.ValueChangeListener() {			
			public void valueChange(ValueChangeEvent event) {
				T item = getValue();
				if (item != null) {
					onSelect(item);
				} else {
					onDeselect();
				}
				boolean selected = (item != null);
				update.setEnabled(selected);
				delete.setEnabled(selected);
			}
		});
        
        BeanItemContainer<T> container = new BeanItemContainer<T>(getTableItemClass());
        
        for (T item : getTableItems()) {
        	container.addBean(item);
        }
        
        table.setContainerDataSource(container);
        table.setVisibleColumns(getTableProperties());
        table.setSelectable(true);
        table.setImmediate(true);
        table.setPageLength(20);
        table.setHeight("411px");
        table.setWidth("100%");

        addGeneratedColumns(table);

        return table;
    }

    protected Table createSearchTable(String search) {
        table = new Table();
        table.addListener(new Property.ValueChangeListener() {
			public void valueChange(ValueChangeEvent event) {
				T item = getValue();
				if (item != null) {
					onSelect(item);
				} else {
					onDeselect();
				}
				boolean selected = (item != null);
				update.setEnabled(selected);
				delete.setEnabled(selected);
			}
		});

        BeanItemContainer<T> container = new BeanItemContainer<T>(getTableItemClass());


        for (T item : getSearchTableItems(search)) {
        	container.addBean(item);
        }

        table.setContainerDataSource(container);
        table.setVisibleColumns(getTableProperties());
        table.setSelectable(true);
        table.setImmediate(true);
        table.setPageLength(20);
        table.setHeight("411px");
        table.setWidth("100%");

        addGeneratedColumns(table);

        return table;
    }
    protected void addGeneratedColumns(Table table) {

    }
    
    protected abstract Class<? extends T> getTableItemClass();
    
    protected BeanItemContainer<T> getTableItemContainer() {
    	return (BeanItemContainer<T>) table.getContainerDataSource();
    }

    /**
     * 
     * @param executeButton this is passed in because the onClick is specified outside this method
     * @return
     */
    protected HorizontalLayout createButtons(Button executeButton) {
        insert = new Button("Add");
        insert.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
                mode = Mode.INSERT;
				showFormWindow(Mode.INSERT);
			}
		});

        update = new Button("Modify");
        update.setEnabled(false);
        update.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
                mode = Mode.UPDATE;
				showFormWindow(Mode.UPDATE);
			}
		});
        
        delete = new Button("Remove");
        delete.setEnabled(false);
        delete.addListener(new ClickListener() {
			public void buttonClick(ClickEvent event) {
				T item = getValue();
				try {
					onDelete(item);
					table.removeItem(item);
				} catch (Exception e) {
				    throw new RuntimeException(e);
				}
			}
		});

        HorizontalLayout buttons = new HorizontalLayout();
        buttons.addComponent(insert);
        buttons.addComponent(update);
        buttons.addComponent(delete);
        if (executeButton != null) {
        	buttons.addComponent(executeButton);
        }
        buttons.setSpacing(true);

        return buttons;
    }	


    private Form createSearchForm() {

        searchForm = new Form();

        TextField field =  new TextField("");
        searchForm.addField("search",field);
        return searchForm;
    }

    private Button createSearchButton() {
        searchButton = new Button("Search");
        searchButton.setEnabled(false);
        searchButton.setClickShortcut(ShortcutAction.KeyCode.ENTER);
        searchButton.addListener(new Button.ClickListener() {
            public void buttonClick(Button.ClickEvent event) {
                  search = searchForm.getField("search").getValue().toString();
                  initSearchLayout(search);
//                  initLayout();
                  searchForm.getField("search").setValue(search);
                  gridLayout.removeComponent(table);
                  gridLayout.addComponent(createSearchTable(search), 0, 0, 1, 0);
            }
        });
        return searchButton;
    }


    private void showFormWindow(Mode mode) {
    	getApplication().getMainWindow().addWindow(new FormWindow(table.getItem(table.getValue()), mode));    	
    }

	public enum Mode {
		INSERT,
		UPDATE;
	}
	
	public void sortTable(String property, boolean ascending) {
		((BeanItemContainer) table.getContainerDataSource()).sort(new Object[] {property}, new boolean[] {ascending});
	}
	
    private class FormWindow extends Window {
    	private Item item;
    	private Form form;
    	private Mode mode;
    	//private Button executeButton;

    	private FormWindow(Mode mode) {
    		this.mode = mode;
    		switch (mode) {
    		case INSERT:
    			setCaption("Add");
    			break;
    			
    		case UPDATE:
    			setCaption("Modify");
    			break;
    		}
		}
    	
    	public FormWindow(Item item, Mode mode) {
    		this(mode);
    		this.item = item;
        	if (mode == Mode.INSERT) {
        		this.item = new BeanItem<T>(createTableItem());
        	}
    		
        	FormLayout layout = new FormLayout();
        	Form form = createForm();
        	layout.addComponent(form);
        	Button executeButton = new Button("Execute");
        	layout.addComponent(createButtons(executeButton));
        	appendAdditionalActions(form, executeButton);
        	layout.setSpacing(true);
        	layout.setMargin(true);

        	setResizable(false);
        	setModal(true);
        	setContent(layout);
        	setWidth("750px");
        	center();
    	}
    	
    	private Form createForm() {
    		form = new Form();
    		form.setFormFieldFactory(createFormFieldFactory());
    		form.setItemDataSource(item);
    		form.setVisibleItemProperties(getFormProperties());
    		form.setWriteThrough(false);
    		return form;	
    	}
    	
    	private HorizontalLayout createButtons(Button uitvoerenButton) {
        	Button saveButton = new Button("Save");
        	saveButton.addListener(new ClickListener() {    			
    			public void buttonClick(ClickEvent event) {
                    form.setValidationVisible(true);
                    if (!form.isValid()) {
                        return; // don't execute query
                    }
    				doSave();
    			}
    		});

        	Button cancelButton = new Button("Cancel");
        	cancelButton.addListener(new ClickListener() {
    			public void buttonClick(ClickEvent event) {
    				form.discard();
    				close();
    			}
    		});

        	HorizontalLayout buttons = new HorizontalLayout();
        	buttons.addComponent(saveButton); 
        	buttons.addComponent(cancelButton);
        	if (hasFormExecuteButton()) {
        		buttons.addComponent(uitvoerenButton);
        	}
        	buttons.setSpacing(true);

        	return buttons;
    	}

		@SuppressWarnings("unchecked")
		private void doSave() {
    		try {
    			form.commit();
    			if (form.isValid()) {		
    				switch (mode) {
    				case INSERT:

    					T bean = ((BeanItem<T>) form.getItemDataSource()).getBean();
    					onInsert(bean);

    					table.addItem(bean);
    					table.select(bean);

    					sortTable(getSortProperty(), isAscending());
    					table.setCurrentPageFirstItemId(bean);

    					onSelect(bean);

    					break;
    					
    				case UPDATE:
    					onUpdate(getValue());
    					sortTable(getSortProperty(), isAscending());
    					onSelect(getValue());
    					break;
    				}
    				close();
    			}
    		} catch (Exception e) {
                form.discard();
                throw new RuntimeException(e);
    		}
    	}
    }

    protected void appendAdditionalActions(Form form, Button executeButton) {
        // do nothing
    }
}
