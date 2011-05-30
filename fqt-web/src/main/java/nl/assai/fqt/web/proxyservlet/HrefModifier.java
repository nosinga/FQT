package nl.assai.fqt.web.proxyservlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.regex.Pattern;
import nl.assai.fqt.service.util.DynamicSearchAndReplace;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 */
public class HrefModifier {

    private final URL baseUrl;
    private final UrlReplacement urlReplacement;

    private static final Pattern hrefPattern =
            Pattern.compile("(href)=(['\"])(.*?)\\2", Pattern.CASE_INSENSITIVE);
    private static final Logger logger = LoggerFactory.getLogger(HrefModifier.class);

    public interface UrlModifier {

        URL modify(URL url) throws MalformedURLException;
    }

    public HrefModifier(URL baseUrl, UrlModifier urlModifier) {
        this.baseUrl = baseUrl;
        this.urlReplacement = new UrlReplacement(urlModifier);
    }

    public void run(Reader in, Writer out) throws IOException {
        
        BufferedReader reader = new BufferedReader(in);
        PrintWriter writer = new PrintWriter(out);

        for(String line = reader.readLine();
                line != null;
                line = reader.readLine()) {

            writer.print(modifyLine(line));
            writer.print("\n");
        }
        
        out.flush();
    }

    private String modifyLine(String line) {
        
        DynamicSearchAndReplace searchAndReplace =
                new DynamicSearchAndReplace(hrefPattern, urlReplacement);

        return searchAndReplace.replaceAll(line);
    }

    private class UrlReplacement implements DynamicSearchAndReplace.Replacements {

        private final UrlModifier urlModifier;

        public UrlReplacement(UrlModifier urlModifier) {
            this.urlModifier = urlModifier;
        }
        
        public String getReplacement(String... groups) {

            String href = groups[0];
            String delimiter = groups[1];

            URL modifiedUrl;

            try {
                URL url = new URL(baseUrl, groups[2]);
                modifiedUrl = urlModifier.modify(url);
            }
            catch (MalformedURLException e) {

                if (logger.isDebugEnabled()) {
                    logger.debug("ignoring URL '" + groups[2] + "': " + e.getMessage());
                }

                return href + "=" + delimiter + groups[2] + delimiter;
            }

            return href + "=" + delimiter + modifiedUrl.toExternalForm() + delimiter;
        }
    }
}
