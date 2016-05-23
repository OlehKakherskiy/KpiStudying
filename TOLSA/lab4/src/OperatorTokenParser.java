/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class OperatorTokenParser extends AbstractTokenParser {

    public OperatorTokenParser(TokenClass tokenClass) {
        super(tokenClass);
    }

    @Override
    protected Token buildToken(String token) {
        String resultToken;
        switch (token) {
            case "~": {
                resultToken = "==";
                break;
            }
            case "=": {
                resultToken = ":=";
                break;
            }
            case "!": {
                resultToken = "!=";
                break;
            }
            default:
                resultToken = token;
        }
        return new Token(resultToken, tokenClassParsingResponsibility);
    }
}
