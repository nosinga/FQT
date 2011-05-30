package nl.assai.fqt.web.queries;

import java.util.List;
import java.util.Map;

/**
 *
 */
public class Result {

    private final List<Map<String, Object>> result;
    private final Map<String, Class<?>> metadata;

    public Result(Map<String, Class<?>> metadata, List<Map<String, Object>> result) {
        this.result = result;
        this.metadata = metadata;
    }

    public Map<String, Class<?>> getMetadata() {
        return metadata;
    }

    public List<Map<String, Object>> getResult() {
        return result;
    }

    public int size() {
        return result.size();
    }
}
