package nl.assai.fqt.domain.model.fqt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class QueryResult {

	private List<Map<String, Object>> results;
	private List<Column> columns;

	public QueryResult() {
		columns = new ArrayList<Column>();
	}

	public List<Map<String, Object>> getResults() {
		return results;
	}

	public void setResults(List<Map<String, Object>> results) {
		this.results = results;
	}

	public void addColumn(String name, String type, int width) {
		columns.add(new Column(name, type, width));
	}

	public List<Column> getColumns() {
		return columns;
	}

    public int size() {
        return results.size();
    }

	public class Column {
		private String name;
		private String type;
		private int width;

		public Column(String name, String type, int width) {
			this.name = name;
			this.type = type;
			this.width = width;
		}

		public String getName() {
			return name;
		}

		public String getType() {
			return type;
		}

		public int getWidth() {
			return width;
		}
	}
}
