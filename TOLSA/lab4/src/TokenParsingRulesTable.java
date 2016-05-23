import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class TokenParsingRulesTable {

    public static Map<TokenClass, Pattern> parsingTable = new LinkedHashMap<>();

    public static Pattern getParsingRule(TokenClass tokenClass) {
        return parsingTable.get(tokenClass);
    }

    public static void addParsingRule(TokenClass tokenClass, Pattern pattern) {
        parsingTable.put(tokenClass, pattern);
    }
}
