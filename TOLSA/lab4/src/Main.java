import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.LinkedHashSet;
import java.util.Scanner;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class Main {

    public static void main(String[] args) {
        TokenParsingRulesTable.addParsingRule(TokenClass.FloatPointConstant, Pattern.compile("\\d+.\\d+"));
        TokenParsingRulesTable.addParsingRule(TokenClass.IntegerConstant, Pattern.compile("\\d+"));
        TokenParsingRulesTable.addParsingRule(TokenClass.Keyword, Pattern.compile("begin|end|record|type|float|integer|var|if|then|else"));
        TokenParsingRulesTable.addParsingRule(TokenClass.Operator, Pattern.compile("[+\\-*/<>]|=|~|!"));
        TokenParsingRulesTable.addParsingRule(TokenClass.Delimiter, Pattern.compile(";|,|(:={0})|\\(|\\)"));
        TokenParsingRulesTable.addParsingRule(TokenClass.Variable, Pattern.compile("^[a-zA-Z][a-zA-Z0-9_]*$"));



        Set<AbstractTokenParser> parsers = new LinkedHashSet<>();
        parsers.add(new DefaultTokenParser(TokenClass.Keyword));
        parsers.add(new OperatorTokenParser(TokenClass.Operator));
        parsers.add(new DefaultTokenParser(TokenClass.IntegerConstant));
        parsers.add(new DefaultTokenParser(TokenClass.FloatPointConstant));
        parsers.add(new DefaultTokenParser(TokenClass.Delimiter));
        parsers.add(new DefaultTokenParser(TokenClass.Variable));
        AbstractLexicalAnalyzer analyzer = new RegexpLexicalAnalyzer(parsers);
        StringBuilder builder = new StringBuilder();
        try {
            Scanner scanner = new Scanner(new FileReader("D:\\Документы\\FICT\\6_семестр\\TOLSA\\lab4\\task.txt"));
            while(scanner.hasNextLine())
                builder.append(scanner.nextLine()).append("\n");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        System.out.println(builder.toString());
        analyzer.initAnalyzing(builder.deleteCharAt(builder.length()-1).toString());

        System.out.println(analyzer.processAllTokens());

    }
}
