package nl.assai.fqt.service.util;

import java.util.Arrays;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Search and replace with dynamic values in a string.
 */
public class DynamicSearchAndReplace {

    private final Pattern pattern;
    private final Replacements replacements;
    private StringBuilder result = new StringBuilder();
    private String remainingSource;

    /**
     * Interface to access dynamic replacement values.
     */
    public interface Replacements {

        /**
         * Returns the replacement value for the given match.
         * 
         * @param groups all matching groups, if no groups were defined in the
         *      pattern this list will contain 1 item: the whole match
         * @return match replacement, cannot be null
         */
        String getReplacement(String... groups);
    }

    public DynamicSearchAndReplace(String pattern, Replacements replacements) {
        this.pattern = Pattern.compile(pattern, Pattern.CASE_INSENSITIVE);
        this.replacements = replacements;
    }

    public DynamicSearchAndReplace(Pattern pattern, Replacements replacements) {
        this.pattern = pattern;
        this.replacements = replacements;
    }

    public static final String replaceAll(
            String pattern, String source, 
            final Map<String, String> replacements) {

        Replacements mapReplacements = new Replacements() {

            public String getReplacement(String... match) {
                return replacements != null ? replacements.get(match[0]) : null;
            }
        };

        return new DynamicSearchAndReplace(pattern, mapReplacements).replaceAll(source);
    }

    public String replaceAll(String source) {

        if (source == null) {
            throw new IllegalArgumentException("source cannot be null");
        }

        startReplacing(source);

        for(Matcher matcher = pattern.matcher(remainingSource);
                matcher.find();
                matcher = pattern.matcher(remainingSource)) {

            replaceMatch(matcher);
        }

        finishReplacing();

        return getResult();
    }

    private void startReplacing(String source) {
        remainingSource = source;
    }

    private void finishReplacing() {
        result.append(remainingSource);
    }

    private String getResult() {
        return result.toString();
    }

    private void replaceMatch(Matcher matcher) {

        String[] matchGroups = selectMatchGroups(matcher);
        String matchReplace = getReplacement(matchGroups);

        moveMatchToResult(matcher, matchReplace);
    }

    private String[] selectMatchGroups(Matcher matcher) {
        return matcher.groupCount() == 0
                ? extractMatchWithNoGroups(matcher)
                : extractMatchWithGroups(matcher);
    }

    private String getReplacement(String... groups) {

        String replacement = replacements.getReplacement(groups);

        if (replacement == null) {
            throw new IllegalStateException(
                    "replacement for match groups " + Arrays.asList(groups) + " not found");
        }

        return replacement;
    }

    private String[] extractMatchWithNoGroups(Matcher matcher) {
        return new String[] {matcher.group(0)};
    }

    private String[] extractMatchWithGroups(Matcher matcher) {

        String[] groups = new String[matcher.groupCount()];

        for (int i = 0; i < groups.length; i++) {
            groups[i] = matcher.group(i + 1);
        }

        return groups;
    }

    private void moveMatchToResult(Matcher matcher, String matchReplace) {

        int matchStart = matcher.start();
        int matchEnd = matcher.end();

        result.append(remainingSource.substring(0, matchStart));
        result.append(matchReplace);

        remainingSource = remainingSource.substring(matchEnd);
    }
}
