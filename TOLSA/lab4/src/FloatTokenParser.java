/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class FloatTokenParser extends AbstractTokenParser {

    public FloatTokenParser(TokenClass tokenClass) {
        super(tokenClass);
    }

    @Override
    protected Token buildToken(String token) {
        return new Token<Float>(Float.parseFloat(token), tokenClassParsingResponsibility);
    }
}
