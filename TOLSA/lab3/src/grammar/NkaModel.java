package grammar;

import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.Map;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class NkaModel {

    private Map<Character, Character> startStates;

    private Map<Character, Character> endStates;

    private Map<Character, Character> allStates;

    private Map<Character, Character> terminals;

    private Map<Character, TransitionFunction> transitions;

    private class TransitionFunction {

        private char state; //для которого определена данная функция (нетерминальный символ)

        public TransitionFunction(char state) {
            this.state = state;
        }

        private Map<Character, Character> transitionFunction = new IdentityHashMap<>(); //терминальный символ - ключ, нетерминальный - значение.
        //Хранит в себе все возможные переходы с вершины state в другие.

        void addFunction(char terminalSymbol, char nonTerminalSymbol) {
            transitionFunction.put(new Character(terminalSymbol), nonTerminalSymbol); //не менять на автоупаковку -
            // будут одинаковые объекты, а нужны разные при одном и том же символе
        }

        char getFunctionOf(char terminalSymbol) {
            return transitionFunction.get(terminalSymbol);
        }

        public char getState() {
            return state;
        }
    }

    public NkaModel() {
        startStates = new HashMap<>();
        endStates = new HashMap<>();
        allStates = new HashMap<>();
        terminals = new HashMap<>();
        transitions = new IdentityHashMap<>();
    }

    public void addFunctionPair(char nonTerminalArgument, char terminalArgument, char nonTerminalValue) {
        if (!transitions.containsKey(nonTerminalArgument)) {
            transitions.put(nonTerminalArgument, new TransitionFunction(nonTerminalArgument));
        }
        transitions.get(nonTerminalArgument).addFunction(terminalArgument, nonTerminalValue);
    }

    public Map<Character, Character> getStartStates() {
        return startStates;
    }

    public void setStartStates(Map<Character, Character> startStates) {
        this.startStates = startStates;
    }

    public Map<Character, Character> getEndStates() {
        return endStates;
    }

    public void setEndStates(Map<Character, Character> endStates) {
        this.endStates = endStates;
    }

    public Map<Character, Character> getAllStates() {
        return allStates;
    }

    public void setAllStates(Map<Character, Character> allStates) {
        for (Map.Entry<Character, Character> state : allStates.entrySet())
            this.allStates.put(state.getKey(), state.getValue());
    }

    public Map<Character, Character> getTerminals() {
        return terminals;
    }

    public void setTerminals(Map<Character, Character> terminals) {
        this.terminals = terminals;
    }

    public Map<Character, TransitionFunction> getTransitions() {
        return transitions;
    }

    public void setTransitions(Map<Character, TransitionFunction> transitions) {
        this.transitions = transitions;
    }

    @Override
    public String toString() {
        String resultTemplate = "Множество вершин: %s; \nВходной алфавит: %s; " +
                "\nМножество команд:\n%s; \nМножество начальных состояний: %s; \nМножество конечных состояний: %s";
        String states = allStates.keySet().toString();
        String inputAlphabet = terminals.keySet().toString();
        String transitionFunction = buildTransitionFunction();
        String startStates = this.startStates.keySet().toString();
        String endStates = this.endStates.keySet().toString();
        return String.format(resultTemplate, states, inputAlphabet, transitionFunction, startStates, endStates);
    }

    private String buildTransitionFunction() {
        String functionTemplate = "F(%c,%c)=%c";
        StringBuilder result = new StringBuilder();
        for (char nonTerminalArgument : transitions.keySet()) {
            TransitionFunction transitionFunction = transitions.get(nonTerminalArgument);
            for (Character terminalArgument : transitionFunction.transitionFunction.keySet()) {
                result.append(String.format(functionTemplate, nonTerminalArgument, terminalArgument,
                        transitionFunction.transitionFunction.get(terminalArgument)));
                result.append("\n");
            }
        }
        return result.deleteCharAt(result.length() - 1).toString();
    }

}
