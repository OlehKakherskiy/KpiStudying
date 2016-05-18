package grammar;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class RegularGrammar {

    private Map<Character, Character> terminals = new HashMap<>();

    private Map<Character, Character> nonTerminals = new HashMap<>();

    private Map<Character, Set<String>> transitionRules = new HashMap<>();

    private char startSymbol;

    public boolean rightOrientedGrammar = true; //TODO: пока что всегда праволинейная, но нужно и леволинейную сделать

    public Character getTerminalSymbol(Character key) {
        return terminals.get(key);
    }

    public Character getNonTerminalSymbol(Character key) {
        return nonTerminals.get(key);
    }

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

    public Map<Character, Character> getTerminals() {
        return terminals;
    }

    void setTerminals(Map<Character, Character> terminals) {
        this.terminals = terminals;
    }

    public Map<Character, Character> getNonTerminals() {
        return nonTerminals;
    }

    void setNonTerminals(Map<Character, Character> nonTerminals) {
        this.nonTerminals = nonTerminals;
    }

    public Map<Character, Set<String>> getTransitionRules() {
        return transitionRules;
    }

    public char getStartSymbol() {
        return startSymbol;
    }

    boolean setStartSymbol(char startSymbol) {
        if (nonTerminals.containsKey(startSymbol)) {
            this.startSymbol = startSymbol;
            return true;
        } else return false;
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
