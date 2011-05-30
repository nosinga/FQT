package nl.assai.fqt.web.reports;

import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.domain.service.FqtRepository;
import nl.assai.fqt.web.queries.QueryPanel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import java.util.List;

public class ReportPanel extends QueryPanel {

    @Autowired
    @Qualifier("fqtRepository")
    private FqtRepository fqtRepository;
    
    private String report;

	public ReportPanel(String caption) {
		super(caption);
		this.report = caption;
	}

	@Override
	protected void init() {
		super.init();
		hideButtons();
	}

	@Override
	public List<Query> getTableItems() {
        return fqtRepository.findReports(getUser(), report);
	}

}
