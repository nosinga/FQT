package nl.assai.fqt.service.util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Wrapper around a JDBC operation which takes care of exception handling
 * and closing.
 *
 * @param <R> result type
 */
public abstract class JdbcOperation<R> {

    private static final Logger logger = LoggerFactory.getLogger(JdbcOperation.class);
    private Connection connection;
    private DataSource dataSource;
    private boolean responsibleForClosingConnection;

    /**
     * Executes the operation.
     *
     * @return result from the operation
     * @throws SQLException when the operation fails at any stage
     */
    public final R execute() throws SQLException {

        if (isNoConnectionSet()) {
            openConnection();
        }

        init();

        try {
            return executeOperation();
        }
        finally {
            closeOperation();
        }
    }

    private boolean isNoConnectionSet() {
        return connection == null;
    }

    private void openConnection() throws SQLException {

        connection = getDataSource().getConnection();
        responsibleForClosingConnection = true;

        if (connection == null) {
            throw new IllegalStateException(
                    "failed to obtain connection, pool empty?");
        }
    }

    public final DataSource getDataSource() {
        return dataSource;
    }

    public final void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public final void setConnection(Connection connection) {
        this.connection = connection;
    }

    public final void setConnectionAndCloseAfterwards(Connection connection) {
        this.connection = connection;
        this.responsibleForClosingConnection = true;
    }

    private void closeOperation() {

        try {
            close();
        }
        catch (SQLException e) {
            logger.warn("failed to close operation: " + e.getMessage(), e);
        }
        finally {
            try {
                if (responsibleForClosingConnection) {
                    getConnection().close();
                }
            }
            catch (SQLException e) {
                logger.warn("failed to close connection: " + e.getMessage(), e);
            }
        }
    }

    protected final Connection getConnection() {
        return connection;
    }

    /**
     * Initializes this operation with the given connection.
     *
     * @param connection connection
     * @throws SQLException when initialization fails
     */
    protected abstract void init() throws SQLException;

    /**
     * Executes the operation.
     *
     * @return
     * @throws SQLException
     */
    protected abstract R executeOperation() throws SQLException;

    /**
     * Closes this operation.
     * <p/>
     * This method will only be called after a succesfull call to
     * {@link #init}.
     * <p/>
     * If this method fails with an {@link SQLException} it will only
     * be rethrown if the {@link #executeOperation()} method did not
     * throw an exception.
     *
     * @throws SQLException when closing fails
     */
    protected abstract void close() throws SQLException;
}
