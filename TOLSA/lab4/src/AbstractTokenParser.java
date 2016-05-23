/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public abstract class AbstractTokenParser {

    //класс, за который отвечает данный парсер
    public TokenClass tokenClassParsingResponsibility;

    public AbstractTokenParser(TokenClass tokenClass) {
        tokenClassParsingResponsibility = tokenClass;
    }

    public Token parseTokenValue(String token) {
        return belongToClass(token) ? buildToken(token) : null;
    }

    private boolean belongToClass(String token) {
        return TokenParsingRulesTable.getParsingRule(tokenClassParsingResponsibility).matcher(token).matches();
    }

    protected abstract Token buildToken(String token);
}
