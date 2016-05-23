import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class RegexpLexicalAnalyzer extends AbstractLexicalAnalyzer {

    StringTokenizer tokenizer;

    private Set<AbstractTokenParser> tokenParsers;

    private Matcher matcher;

    public RegexpLexicalAnalyzer(Set<AbstractTokenParser> parsers) {
        this.tokenParsers = parsers;
    }

    @Override
    public boolean hasNextToken() {
        return tokenizer.hasMoreTokens();
    }

    @Override
    public Token processNextToken() {
        Token result = null;
        String currentToken = tokenizer.nextToken().trim();
        while (currentToken.equals("")) {
            currentToken = tokenizer.nextToken().trim();
        }
        for (AbstractTokenParser parser : tokenParsers) {
            result = parser.parseTokenValue(currentToken);
            if (result != null) {
                return result;
            }
        }

        throw new RuntimeException("не удалось проанализировать токен " + currentToken);
    }

    @Override
    public Map<Integer, Token> processAllTokens() {
        Map<Integer, Token> result = new HashMap<>();
        int i = 0;
        while (hasNextToken())
            result.put(i++, processNextToken());
        return result;
    }

    @Override
    public void initAnalyzing(String text) {
        String pattern = TokenParsingRulesTable.getParsingRule(TokenClass.Operator).pattern() + "|" +
                TokenParsingRulesTable.getParsingRule(TokenClass.Delimiter).pattern() + "|\\s| ";
        tokenizer = new StringTokenizer(text.replaceAll(":=", "=").replaceAll("==", "~").replaceAll("!=", "!"), "\\s| |\n" +
                TokenParsingRulesTable.getParsingRule(TokenClass.Delimiter).pattern(), true);
    }
}
