package grammar;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class RegularGrammar {

    private Set<Character> terminals = new HashSet<>();

    private Set<Character> nonTerminals = new HashSet<>();

    private Map<Character, Set<String>> transitionRules = new HashMap<>();

    private char startSymbol;

    public Set<String> getTransitionRules(Character key) {
        return transitionRules.get(key);
    }

    boolean addTransitionRule(char key, String rule) {
        if (rule == null || rule.equals(""))
            return false;
        if (!transitionRules.containsKey(key)) { //у данного нетерминального символа пока нет правил
            Set<String> keyRules = new HashSet<>();
            keyRules.add(rule);
            transitionRules.put(key, keyRules);
            return true; // 100% что правило добавиться в пустое множество правил
        } else { //у данного нетерминального символа уже есть правила.
            return transitionRules.get(key).add(rule); //false, если правило уже есть
        }
    }


    public Map<Character, Set<String>> getTransitionRules() {
        return transitionRules;
    }

    public char getStartSymbol() {
        return startSymbol;
    }

    boolean setStartSymbol(char startSymbol) {
        if (nonTerminals.contains(startSymbol)) {
            this.startSymbol = startSymbol;
            return true;
        } else return false;
    }

    public Set<Character> getTerminals() {
        return terminals;
    }

    public void setTerminals(Set<Character> terminals) {
        this.terminals = terminals;
    }

    public Set<Character> getNonTerminals() {
        return nonTerminals;
    }

    public void setNonTerminals(Set<Character> nonTerminals) {
        this.nonTerminals = nonTerminals;
    }

    @Override
    public String toString() {
        return "RegularGrammar{" +
                "terminals=" + terminals +
                ", nonTerminals=" + nonTerminals +
                ", transitionRules=" + transitionRules +
                ", startSymbol=" + startSymbol +
                '}';
    }
}
