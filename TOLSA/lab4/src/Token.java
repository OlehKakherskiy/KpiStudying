/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class Token<T> {

    public T tokenValue;

    public TokenClass tokenClass;

    public Token(T tokenValue, TokenClass tokenClass) {
        this.tokenValue = tokenValue;
        this.tokenClass = tokenClass;
    }


    @Override
    public String toString() {
        return "Token{" +
                "tokenValue=" + tokenValue +
                ", tokenClass=" + tokenClass +
                '}';
    }
}
