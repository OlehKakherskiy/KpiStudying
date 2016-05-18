import grammar.NkaModel;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class DkaBuilder {

    private NkaModel nka;

    public DkaModel buildDkaFromNka(NkaModel nka) {
        this.nka = nka;
        Set<Set<Character>> preparedStates = new HashSet<>();
        preparedStates.add(nka.getStartStates().keySet());

        Set<Set<Character>> passedStates = new HashSet<>();

        Map<Set<Character>, Map<Character, Set<Character>>> transitionFunction = new HashMap<>(); //функция перехода с множества состояний
        // в другое множество состояний по определенному терминальному символу
        for (Set<Character> currentStateSet : preparedStates) {
            for (char terminal : nka.getTerminals().keySet()) {
                Set<Character> reachableStates = getAllReachableStates(currentStateSet, terminal);
                if (!passedStates.contains(reachableStates)) {
                    preparedStates.add(reachableStates);
                }
                addTransitionToFunction(transitionFunction, currentStateSet, terminal, reachableStates);
            }
            preparedStates.remove(currentStateSet);
            passedStates.add(currentStateSet);
        }
    }

    private void addTransitionToFunction(Map<Set<Character>, Map<Character, Set<Character>>> transitionFunction,
                                         Set<Character> currentTransitionState, char terminal,
                                         Set<Character> nextTransitionStates) {
        if (!transitionFunction.containsKey(currentTransitionState)) {
            transitionFunction.put(currentTransitionState, new HashMap<>());
        }
        transitionFunction.get(currentTransitionState).put(terminal, nextTransitionStates);
    }

    private Set<Character> getAllReachableStates(Set<Character> states, char terminal) {

    }

    private Set<Character> getAllReachableStates(char state, char terminal) {
        nka.getTransitions()
    }
}
