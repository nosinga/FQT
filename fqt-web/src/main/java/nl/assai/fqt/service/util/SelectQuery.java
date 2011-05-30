package nl.assai.fqt.service.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Select JDBC operation.
 *
 * @param R type the {@link ResulSet} will be converted to
 */
public abstract class SelectQuery<R> extends JdbcOperation<R> {
    private static final Logger logger = LoggerFactory.getLogger("SelectQuery<R>");

    private PreparedStatement preparedQuery;
    private String query;

    protected SelectQuery(String query) {
        super();
        setQuery(query);
    }

    protected SelectQuery() {
        super();
    }

    public String getQuery() {
        return query;
    }

    public final void setQuery(String query) {
        this.query = query;
        logger.debug("query = " + query);
    }

    @Override
    protected final void init() throws SQLException {
        preparedQuery = getConnection().prepareStatement(getQuery());
        setParameters(preparedQuery);
    }

    /**
     * Set parameters on the given query.
     * 
     * @param query query 
     * @throws SQLException when a parameter cannot be set
     */
    protected abstract void setParameters(PreparedStatement query)
            throws SQLException;

    /**
     * Converts the given JDBC result into the final result.
     * 
     * @param result result
     * @return converted result
     * @throws SQLException when result cannot be converted
     */
    protected abstract R convertResult(ResultSet result) throws SQLException;

    @Override
    protected final R executeOperation() throws SQLException {
        ResultSet result = preparedQuery.executeQuery();
        return convertResult(result);
    }

    @Override
    protected final void close() throws SQLException {
        preparedQuery.close();
    }
}
