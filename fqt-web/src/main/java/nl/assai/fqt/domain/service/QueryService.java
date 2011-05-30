package nl.assai.fqt.domain.service;

import nl.assai.fqt.web.spring.JournalingUserFilter;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

import nl.assai.fqt.domain.model.fqt.Connection;
import nl.assai.fqt.domain.model.fqt.Query;
import nl.assai.fqt.service.util.JdbcOperation;
import nl.assai.fqt.service.util.SelectQuery;

@Service
public class QueryService {
    private static final Logger logger = Logger.getLogger(QueryService.class);

    private Properties config;

    @Autowired
    void setConfig(Properties config) {
        this.config = config;
    }

    public <T> T executeQuery(Query query, Connection connection, ResultSetHandler<T> handler) throws SQLException {

        Query.PreparedStatement statement = query.prepareStatement();

        if (logger.isTraceEnabled()) {
            logger.trace(String.format(
                    "executing query %s:\n----\n%s\n----\nwith parameters: %s",
                    query.getName(), statement.statement, statement.parameters));
        }

        T result;
        java.sql.Connection jdbcConnection = openConnection(connection);

        try {

            if (isFqtConnection(connection)) {
                identifyUser(jdbcConnection);
            }

            result = executeSelect(jdbcConnection, statement, handler);
        }
        finally {
            try {
                jdbcConnection.close();
            }
            catch (SQLException e) {
                logger.warn("ignoring exception while closing connection: " + e.getMessage(), e);
            }
        }

        if (logger.isDebugEnabled()) {
            logger.debug(String.format("executed query %s on connection %s",
                    query.getName(), connection.getName()));
        }

        return result;
    }

    private <T> T executeSelect(java.sql.Connection jdbcConnection,Query.PreparedStatement statement, ResultSetHandler<T> handler) throws SQLException {
        ExecuteSelect<T> select = new ExecuteSelect(statement.statement, statement.parameters, handler);
        select.setConnection(jdbcConnection);
        return select.execute();
    }

    private void identifyUser(java.sql.Connection jdbcConnection) throws SQLException {
        IdentifyUser identify = new IdentifyUser(JournalingUserFilter.getJournalingUserName());
        identify.setConnection(jdbcConnection);
        identify.execute();
    }

    private boolean isFqtConnection(Connection connection) {
        return connection.getName().equals(config.get("FQT_CONNECTION_NAME"));
    }

    private java.sql.Connection openConnection(Connection connection) throws SQLException {
        String url = connection.getServicename();
        return DriverManager.getConnection(url, connection.getUsername(), connection.getPassword());
    }

    private static class IdentifyUser extends JdbcOperation<Object> {

        private PreparedStatement statement;
        private final String user;

        IdentifyUser(String user) {
            this.user = user;
        }

        @Override
        protected void init() throws SQLException {
            statement = getConnection().prepareCall("call abkr_journaling.setuser( ? )");
            statement.setString(1, user);
        }

        @Override
        protected Object executeOperation() throws SQLException {
            statement.execute();
            return null;
        }

        @Override
        protected void close() throws SQLException {
            statement.close();
        }
    }

    private static class ExecuteSelect<T> extends SelectQuery<T> {

        private final List<String> parameters;
        private final ResultSetHandler<T> resultSetHandler;

        public ExecuteSelect(String statement, List<String> parameters, ResultSetHandler<T> resultSetHandler) {
            super(statement);
            this.parameters = parameters;
            this.resultSetHandler = resultSetHandler;
        }

        @Override
        protected T convertResult(ResultSet resultSet) throws SQLException {
            return resultSetHandler.handle(resultSet);
        }

        @Override
        protected void setParameters(PreparedStatement query) throws SQLException {
            for (int i = 0; i < parameters.size(); i++) {
                query.setString(i + 1, parameters.get(i));
            }
        }
    }

    public interface ResultSetHandler<T> {
        T handle(ResultSet resultSet) throws SQLException;
    }
}
