package nl.assai.fqt.domain.model.fqt;

import nl.assai.fqt.service.util.DynamicSearchAndReplace;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import java.io.Serializable;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Query implements Serializable {
    private static final long serialVersionUID = 6872199418516147549L;

    private Long id;
    private Long rv;
    private String name;
	private String shortDescription;
	private String description;
	private String statement;
	private String reportFormat;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRv() {
        return rv;
    }

    public void setRv(Long rv) {
        this.rv = rv;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatement() {
        return statement;
    }

    public void setStatement(String statement) {
        this.statement = statement;
        if (StringUtils.isNotEmpty(statement)) {
            setParams();
        }
    }

    public String getReportFormat() {
        return reportFormat;
    }

    public void setReportFormat(String reportFormat) {
        this.reportFormat = reportFormat;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("id = " + id);
        sb.append(", rv = " + rv);
        sb.append(", name = " + StringUtils.abbreviate(name, 20));
        sb.append(", shortDescription = " + StringUtils.abbreviate(shortDescription, 20));
        sb.append(", description = " + StringUtils.abbreviate(description, 20));
        sb.append(", statement = " + StringUtils.abbreviate(statement, 20));
        sb.append(", reportFormat = " + StringUtils.abbreviate(reportFormat, 20));
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final int hashCode() {
        return id != null ? (int) (37 * id) : super.hashCode();
    }

    @Override
    public final boolean equals(Object other) {
        return (id != null && other != null) ? id.equals(((Query) other).getId()) : super.equals(other);
    }

    // Query logic
    private static final Logger logger = Logger.getLogger(Query.class);
    private static final Pattern parameterPattern = Pattern.compile(":([a-z0-9_]+)", Pattern.CASE_INSENSITIVE);
    private static final List<String> falseMatches = Arrays.asList("mi", "ss");
    protected LinkedHashMap<String, String > params = new LinkedHashMap<String, String>();

    public PreparedStatement prepareStatement() {

        Replacements replacements = new Replacements();
        String preparedStatement = new DynamicSearchAndReplace(
                parameterPattern.pattern(), replacements).replaceAll(getStatement());

        return new PreparedStatement(preparedStatement, replacements.getStatementArguments());
    }

    public String getParam(String name) {
		return params.get(name);
	}

    public boolean hasParam(String name) {
        return params.containsKey(name);
    }

    public void setParam(String name, String value) {
		params.put(name, value);
	}

    public String[] getParams() {
		String[] names = new String[params.size()];
		return params.keySet().toArray(names);
	}

    public void clearParams() {
        setParams();
    }

    public void setParams() {
        logger.debug("setParams");
        params.clear();

		Matcher matcher = parameterPattern.matcher(getStatement());

		while (matcher.find()) {

            String paramName = matcher.group().substring(1);
            logger.debug("paramName: " + paramName);

            if (!falseMatches.contains(paramName.toLowerCase())) {
                logger.debug("adding paramName: " + paramName);
                params.put(paramName, "");
            }
		}
	}

    private class Replacements implements DynamicSearchAndReplace.Replacements {

        private final List<String> statementArguments = new ArrayList<String>();

        public String getReplacement(String... groups) {

            String parameterName = groups[0];

            if (hasParam(parameterName)) {
                String replacement = getParam(parameterName);
                statementArguments.add(replacement);
                return "?";
            }
            else {
                return ":" + parameterName;
            }
        }

        List<String> getStatementArguments() {
            return statementArguments;
        }
    }
    public static class PreparedStatement {

        public final String statement;
        public final List<String> parameters;

        public PreparedStatement(String statement, List<String> parameters) {
            this.statement = statement;
            this.parameters = Collections.unmodifiableList(parameters);
        }
    }

}
