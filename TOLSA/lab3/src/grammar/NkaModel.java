package grammar;

import java.util.*;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class NkaModel {

    private Set<Character> startStates;

    private Set<Character> endStates;

    private Set<Character> allStates;

    private Set<Character> terminals;

    private Map<Character, TransitionFunction> transitions;

    public class TransitionFunction {

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

        public char getState() {
            return state;
        }
    }

    public NkaModel() {
        startStates = new HashSet<>();
        endStates = new HashSet<>();
        allStates = new HashSet<>();
        terminals = new HashSet<>();
        transitions = new HashMap<>();
    }

    public Map<Character, Character> getFullFunctionOf(char state) {
        return transitions.get(state) == null ? new HashMap<>() : transitions.get(state).transitionFunction;
    }

    public void addFunctionPair(char nonTerminalArgument, char terminalArgument, char nonTerminalValue) {
        if (!transitions.containsKey(nonTerminalArgument)) {
            transitions.put(nonTerminalArgument, new TransitionFunction(nonTerminalArgument));
        }
        transitions.get(nonTerminalArgument).addFunction(terminalArgument, nonTerminalValue);
    }

    public void setAllStates(Set<Character> allStates) {
        for (Character state : allStates)
            this.allStates.add(state);
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
        String states = allStates.toString();
        String inputAlphabet = terminals.toString();
        String transitionFunction = buildTransitionFunction();
        String startStates = this.startStates.toString();
        String endStates = this.endStates.toString();
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


    public Set<Character> getStartStates() {
        return startStates;
    }

    public void setStartStates(Set<Character> startStates) {
        this.startStates = startStates;
    }

    public Set<Character> getEndStates() {
        return endStates;
    }

    public void setEndStates(Set<Character> endStates) {
        this.endStates = endStates;
    }

    public Set<Character> getAllStates() {
        return allStates;
    }

    public Set<Character> getTerminals() {
        return terminals;
    }

    public void setTerminals(Set<Character> terminals) {
        this.terminals = terminals;
    }
}
