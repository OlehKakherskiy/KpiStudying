/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class DefaultTokenParser extends AbstractTokenParser {

    public DefaultTokenParser(TokenClass tokenClass) {
        super(tokenClass);
    }

    @Override
    protected Token buildToken(String token) {
        return new Token<String>(token, tokenClassParsingResponsibility);
    }
}
