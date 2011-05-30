package nl.assai.fqt.service.util;

import nl.assai.fqt.service.util.DynamicSearchAndReplace;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.PatternSyntaxException;
import org.junit.Test;
import static org.junit.Assert.*;
import static org.easymock.EasyMock.*;

/**
 * Tests for the {@link DynamicSearchAndReplace} class.
 */
public class DynamicSearchAndReplaceTest {

    @Test
    public void noMatchesShouldReturnSameString() {
        String replacedString = DynamicSearchAndReplace.replaceAll(
                ":([a-z]+):", "no matches found here",
                createReplacementsMap("foo", "bar"));
        assertEquals("no matches found here", replacedString);
    }

    @Test
    public void moreThanOneMatchShouldReplaceAllMatches() {
        String replacedString = DynamicSearchAndReplace.replaceAll(
                ":([a-z]+):", "the following will match: :foo::foo:",
                createReplacementsMap("foo", "bar"));
        assertEquals("the following will match: barbar", replacedString);
    }

    @Test(expected = IllegalArgumentException.class)
    public void nullSourceShouldThrowException() {
        DynamicSearchAndReplace.replaceAll(
                ":([a-z])+:", null, createReplacementsMap());
    }

    @Test(expected = PatternSyntaxException.class)
    public void illegalPatternShouldThrowException() {
        DynamicSearchAndReplace.replaceAll(
                ":([a-z]+:", "the following should not be matched :This:", null);
    }

    @Test
    public void replacementsInterfaceShouldBeCalledForEveryMatch() {

        DynamicSearchAndReplace.Replacements replacements
                = createStrictMock(DynamicSearchAndReplace.Replacements.class);
        expect(replacements.getReplacement("foo")).andReturn("foo").times(2);

        replay(replacements);
        new DynamicSearchAndReplace(":([a-z]+):", replacements).replaceAll(":foo::foo:");
        verify(replacements);
    }

    @Test(timeout=1000)
    public void whenReplacementMatchesPatternItShouldNotLoop() {
        String replacedString = DynamicSearchAndReplace.replaceAll(
                ":([a-z]+)", "should remain :the same", createReplacementsMap("the", ":the"));
        assertEquals("should remain :the same", replacedString);
    }

    private Map<String, String> createReplacementsMap(String... matchesAndReplacements) {

        if (matchesAndReplacements.length % 2 == 1) {
            throw new IllegalArgumentException(
                    "invalid matchesAndReplacements: " + matchesAndReplacements);
        }

        Map<String, String> replacements = new HashMap<String, String>();

        for (int i = 0; i < matchesAndReplacements.length; i += 2) {
            String match = matchesAndReplacements[i];
            String replacement = matchesAndReplacements[i + 1];
            replacements.put(match, replacement);
        }

        return replacements;
    }
}
