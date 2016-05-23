/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class IntegerTokenParser extends AbstractTokenParser {

    public IntegerTokenParser(TokenClass tokenClass) {
        super(tokenClass);
    }

    @Override
    protected Token buildToken(String token) {
        return new Token<Integer>(Integer.parseInt(token), tokenClassParsingResponsibility);
    }
}
