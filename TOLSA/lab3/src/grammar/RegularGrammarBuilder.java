package grammar;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class RegularGrammarBuilder {

    private static String transitionRuleSplitter = "=>";

    private RegularGrammar grammar;

    public RegularGrammarBuilder() {
        grammar = new RegularGrammar();
    }

    public void addTerminals(String terminalString) { //параметр в формате {termSymbol1,termSymbol2,termSymbol3}
        grammar.setTerminals(buildGrammarSymbolsSet(terminalString));
    }

    public void addNonTerminals(String nonTerminalString) { //параметр в формате {NonTermSymbol1,NonTermSymbol2,NonTermSymbol3}
        grammar.setNonTerminals(buildGrammarSymbolsSet(nonTerminalString));
    }

    //разбивает строку правил на правила. Разграничитель - символ <;>. Последнее правило может быть пустым - игнорируется
    public void addTransitionRules(String rulesRepresentation) {
        //удаляем символы фигурных скобок и разбиваем на правила по символу <;>
        String[] rules = rulesRepresentation.substring(1, rulesRepresentation.length() - 1).split(";");
        int lastRuleIndex = rules[rules.length - 1].equals("") ? rules.length - 1 : rules.length;
        for (int i = 0; i < lastRuleIndex; i++) {
            if (!addTransitionRule(rules[i].trim()))
                throw new IllegalArgumentException("Правило " + rules[i].trim() + "продублировано");
        }
    }

    private boolean addTransitionRule(String ruleRepresentation) { //ruleRepresentation формат: NonTermSymbol=>Rule

        //1 часть - нетерминальный символ, 2 - правило вида <termSymbol><NonTermSymbol>|<termSymbol> (или <NonTermSymbol><termSymbol>|<termSymbol>)
        String[] ruleParts = ruleRepresentation.split(transitionRuleSplitter);

        char nonTermSymbol = ruleParts[0].trim().charAt(0);
        System.out.println("ruleParts = " + Arrays.toString(ruleParts));

        for (int i = 1; i < ruleParts.length; i++) {
            String[] simpleRules = ruleParts[i].split("\\|"); //разбитие правила на простые правила вида <NonTermSymbol><termSymbol> или <termSymbol>
            System.out.println("simpleRules = " + Arrays.toString(simpleRules));
            if (!addSimpleRulesToGrammar(nonTermSymbol, simpleRules))
                return false;
        }
        return true;
    }

    //добавляем все простые правила в грамматику
    private boolean addSimpleRulesToGrammar(char nonTerminal, String[] simpleRules) {
        for (String simpleRule : simpleRules) {
            if (!grammar.addTransitionRule(nonTerminal, simpleRule.trim())) {
                return false;
            }
        }
        return true;
    }

    public boolean addStartSymbol(String startSymbol) {
        return grammar.setStartSymbol(startSymbol.trim().charAt(0));
    }

    public RegularGrammar getResultGrammar() {
        return grammar;
    }

    private Map<Character, Character> buildGrammarSymbolsSet(String grammarSymbolSet) throws IllegalArgumentException { //параметр в формате {Symbol1,Symbol2,Symbol3}
        String terminals = grammarSymbolSet.substring(1, grammarSymbolSet.length() - 1); //убираем {} => termSymbol1,termSymbol1,termSymbol1
        String[] splittedTerminals = terminals.split(",");
        Map<Character, Character> preparedTerminals = new HashMap<>();

        for (String terminalSymbol : splittedTerminals) {
            char preparedTerminal = terminalSymbol.trim().charAt(0);
            if (preparedTerminals.containsKey(preparedTerminal)) {
                throw new IllegalArgumentException("Дублирование символа грамматики: " + preparedTerminal);
            }
            preparedTerminals.put(preparedTerminal, preparedTerminal);
        }
        return preparedTerminals;
    }
}
