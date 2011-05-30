package nl.assai.fqt.domain.ibatis.dao;

import com.ibatis.sqlmap.client.extensions.ParameterSetter;
import com.ibatis.sqlmap.client.extensions.ResultGetter;
import com.ibatis.sqlmap.client.extensions.TypeHandlerCallback;

import java.sql.SQLException;

/**
 *
 */
public abstract class EnumTypeHandler<E extends Enum> implements TypeHandlerCallback {

    private final Class<E> enumClass;

    protected EnumTypeHandler(Class<E> enumClass) {
        this.enumClass = enumClass;
    }

    @SuppressWarnings({"unchecked"})
    public void setParameter(ParameterSetter setter, Object parameter) throws SQLException {
        E enumValue = (E) parameter;
        setter.setString(enumValue != null ? enumValue.name() : null);
    }

    public Object getResult(ResultGetter getter) throws SQLException {
        return valueOf(getter.getString());
    }

    public Object valueOf(String s) {
        return s != null ? Enum.valueOf(enumClass, s) : null;
    }
}
