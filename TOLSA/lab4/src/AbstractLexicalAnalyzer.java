import java.util.Map;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public abstract class AbstractLexicalAnalyzer {

    public abstract Token processNextToken();

    public abstract boolean hasNextToken();

    public abstract Map<Integer, Token> processAllTokens();

    public abstract void initAnalyzing(String text);
}
