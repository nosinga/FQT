package nl.assai.fqt.web.proxyservlet;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 *
 */
public class HrefModifierTest {
    
    private HrefModifier hrefModifier;

    private static final URL baseUrl;

    static {
        try {
            baseUrl = new URL("http://localhost:8080/");
        }
        catch (MalformedURLException e) {
            throw new IllegalStateException(e);
        }
    }

    @Before
    public void setupHrefModifier() {
        
        hrefModifier = new HrefModifier(baseUrl, new HrefModifier.UrlModifier() {

            public URL modify(URL url) throws MalformedURLException {
                return new URL(url, "/URL" + url.getPath());
            }
        });
    }

    @Test
    public void noHrefsShouldReturnSameString() {
        
        assertUnreplaced("FOO\n");
        assertReplaced("FOO", "FOO\n");
    }

    private void assertUnreplaced(String source) {
        assertReplaced(source, source);
    }

    @Test
    public void singleQuoteHrefShouldBeReplaced() {
        assertReplaced("href='FOO'", "href='http://localhost:8080/URL/FOO'");
    }

    @Test
    public void doubleQuoteHrefShouldBeReplaced() {
        assertReplaced("href=\"FOO\"", "href=\"http://localhost:8080/URL/FOO\"");
    }

    @Test
    public void multipleHrefShouldBeReplaced() {
        assertReplaced("href=\"FOO\" href=\"FOO\"", "href=\"http://localhost:8080/URL/FOO\" href=\"http://localhost:8080/URL/FOO\"");
    }
    
    @Test
    public void singleAndDoubleQuoteMixedShouldNotBeReplaced() {
        assertUnreplaced("href=\"FOO'");
        assertUnreplaced("href='FOO\"");
    }

    @Test
    public void mixedCaseHrefShouldBePreserved() {
        assertReplaced("hReF='FOO'", "hReF='http://localhost:8080/URL/FOO'");
    }

    private void assertReplaced(String source, String expected) {

        String expectedWithNewline = expected.endsWith("\n")
                ? expected
                : expected + "\n";

        try {
            Assert.assertEquals(expectedWithNewline, replaceHrefs(source));
        }
        catch (IOException e) {
            e.printStackTrace();
            Assert.fail("unexpected exception: "  + e.getMessage());
        }
    }

    private String replaceHrefs(String content) throws IOException {

        StringWriter out = new StringWriter();
        hrefModifier.run(new StringReader(content), out);
        return out.toString();
    }
}
