package nl.assai.fqt.domain.ibatis.dao;

import com.ibatis.sqlmap.client.extensions.ParameterSetter;
import com.ibatis.sqlmap.client.extensions.ResultGetter;
import com.ibatis.sqlmap.client.extensions.TypeHandlerCallback;

import java.sql.SQLException;

/**
 *
 */
public class BooleanTypeHandler implements TypeHandlerCallback {

    private static final String TRUE_VALUE = "J";
    private static final String FALSE_VALUE = "N";

    public Object getResult(ResultGetter getter) throws SQLException {
        return valueOf(getter.getString());
    }

    public void setParameter(ParameterSetter setter, Object parameter) throws SQLException {
        boolean value = parameter != null ? (Boolean) parameter : false;
        setter.setString(value ? TRUE_VALUE : FALSE_VALUE);
    }

    public Object valueOf(String value) {
        return value != null && value.equalsIgnoreCase(TRUE_VALUE);
    }
}
