import grammar.RegularGrammar;
import grammar.RegularGrammarBuilder;

import java.util.Map;
import java.util.regex.Pattern;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class RegularGrammarValidator {

    private static final Pattern terminalsValidationRule = Pattern.compile("^\\{([a-z0-9!@#$%^&*~ε], *)*[a-z0-9!@#$%^&*~ε]?\\}$");

    private static final Pattern nonTerminalsValidationRule = Pattern.compile("^\\{([A-Z], *)*[A-Z]?\\}$");

    //"^([A-Z]=>(([a-z][A-Z]|[a-z])\\|?)+;? *)+$"
    private static final String transitionRuleValidationRule = "^\\{(%s=>((%s%s|%s)\\|?)+;? *)+}$";

    public RegularGrammar validateAndBuildRegularGrammar(String[] regularGrammarString) {
        RegularGrammarBuilder builder = new RegularGrammarBuilder();

        validateGrammarStringArray(regularGrammarString);

        validateNonTerminals(regularGrammarString[0], builder);

        validateTerminals(regularGrammarString[1], builder);

        validateTransitionRules(regularGrammarString[2], builder);

        validateStartSymbol(regularGrammarString[3], builder);

        return builder.getResultGrammar();
    }

    private void validateTerminals(String terminalsString, RegularGrammarBuilder grammarBuilder) {
        if (!terminalsValidationRule.matcher(terminalsString).matches()) {
            throw new IllegalArgumentException("Множество терминальных символов не прошло валидацию. " +
                    "Проверьте правильность формата: {терм_символ(маленькая лат. буква),терм_символ...}");

        } else {
            grammarBuilder.addTerminals(terminalsString.trim());
        }
    }

    private void validateNonTerminals(String nonTerminalString, RegularGrammarBuilder grammarBuilder) {
        if (!nonTerminalsValidationRule.matcher(nonTerminalString).matches()) {
            throw new IllegalArgumentException("Множество нетерминальных символов не прошло валидацию. " +
                    "Проверьте правильность формата: {неТерм_символ(большая лат. буква),неТерм_символ...}");

        } else {
            grammarBuilder.addNonTerminals(nonTerminalString);
        }
    }

    private void validateTransitionRules(String transitionRules, RegularGrammarBuilder grammarBuilder) {
        RegularGrammar grammar = grammarBuilder.getResultGrammar();
        String nonTerminalsRegexpClass = buildTerminalOrNonTerminalRegexpClass(grammar.getNonTerminals());
        String terminalsRegexpClass = buildTerminalOrNonTerminalRegexpClass(grammar.getTerminals());

        String transitionRulesRegexp = String.format(transitionRuleValidationRule, nonTerminalsRegexpClass,
                terminalsRegexpClass, nonTerminalsRegexpClass, terminalsRegexpClass);

        if (!Pattern.matches(transitionRulesRegexp, transitionRules)) {
            throw new IllegalArgumentException("Правила грамматики не соответствуют регулярному " +
                    "выражению: " + transitionRulesRegexp);
        }
        grammarBuilder.addTransitionRules(transitionRules);
    }

    private void validateStartSymbol(String startSymbol, RegularGrammarBuilder builder) {
        if (startSymbol.length() > 1) {
            throw new IllegalArgumentException("Начальный символ грамматики должен состоять из 1 буквы. " +
                    "Полученный результат: " + startSymbol);
        }

        String regexp = buildTerminalOrNonTerminalRegexpClass(builder.getResultGrammar().getNonTerminals());
        if (!Pattern.matches(regexp, startSymbol)) {
            throw new IllegalArgumentException("Начальный символ не входит в множество нетерминальных символов.\n" +
                    "Множество нетерминальных символов: " + regexp + "\nНачальный символ: " + startSymbol);
        }
        builder.addStartSymbol(startSymbol);
    }

    private String buildTerminalOrNonTerminalRegexpClass(Map<Character, Character> grammarSymbols) {
        StringBuilder regexpClassBuilder = new StringBuilder("[");
        for (Character key : grammarSymbols.keySet())
            regexpClassBuilder.append(key);
        return regexpClassBuilder.append("ε]").toString();
    }

    private void validateGrammarStringArray(String[] regularGrammarString) {
        if (regularGrammarString == null || regularGrammarString.length < 4) {
            throw new IllegalArgumentException("Количество элементов грамматики должно быть >=4");
        }
        for (int i = 0; i < regularGrammarString.length; i++) {
            if (regularGrammarString[i] == null)
                throw new IllegalArgumentException((i + 1) + " элемент грамматики == null");

            regularGrammarString[i] = regularGrammarString[i].trim();
            if (regularGrammarString[i].equals(""))
                throw new IllegalArgumentException((i + 1) + " элемент грамматики - пустой");
        }
    }

}
