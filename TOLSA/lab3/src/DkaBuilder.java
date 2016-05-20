import grammar.NkaModel;

import java.util.*;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class DkaBuilder {

    private NkaModel nka;

    public DkaModel buildDkaFromNka(NkaModel nka) {
        this.nka = nka;
        Stack<Set<Character>> preparedStates = new Stack<>();
        preparedStates.push(nka.getStartStates().keySet()); //добавляем множество стартовых вершин для просмотра

        Set<Set<Character>> passedStates = new HashSet<>();

        Map<Set<Character>, Map<Character, Set<Character>>> transitionFunction = new HashMap<>(); //функция перехода с множества состояний
        // в другое множество состояний по определенному терминальному символу
        while (!preparedStates.empty()) {
            //берем очередное множество вершин, с которых будем строить другое множество по переходам
            Set<Character> currentStateSet = preparedStates.pop();
            //выбираем все достижимые вершини для каждой вершини с множества выбранных вершин
            Map<Character, Set<Character>> reachableStates = getAllReachableStates(currentStateSet);
            //для каждого перехода выбираем те множества вершин, которые не были просмотрены
            for (Character transitionSymbol : reachableStates.keySet()) {
                Set<Character> transitionSymbolReachableStates = reachableStates.get(transitionSymbol);
                if (transitionSymbolReachableStates.size() == 0)
                    continue;
                if (!passedStates.contains(transitionSymbolReachableStates))
                    preparedStates.push(transitionSymbolReachableStates);
                //добавляем правила переходов между множествами вершин по данному терминальному символу
                addTransitionToFunction(transitionFunction, currentStateSet, transitionSymbol, transitionSymbolReachableStates);
            }
            //удаляем данное множество вершин с готовых к просмотру - переносим его в множество просмотренных множеств вершин
            passedStates.add(currentStateSet);
        }

        DkaModel model = new DkaModel();
        model.alphabet = nka.getTerminals();
        model.transitions = transitionFunction;
        model.startStates = nka.getStartStates().keySet();
        model.states = passedStates;
        processEndStates(model, nka);
        return model;
    }

    private void processEndStates(DkaModel dka, NkaModel nka) {
        for (Set currentState : dka.states) {
            if (checkIfHaveNkaEndStates(currentState, nka.getEndStates().keySet()))
                dka.endStates.add(currentState);
        }
    }

    private boolean checkIfHaveNkaEndStates(Set<Character> currentDkaState, Set<Character> nkaEndStates) {
        for (Character nkaEndState : nkaEndStates) {
            if (currentDkaState.contains(nkaEndState)) {
                return true;
            }
        }
        return false;
    }

    private void addTransitionToFunction(Map<Set<Character>, Map<Character, Set<Character>>> transitionFunction,
                                         Set<Character> currentTransitionState, char terminal,
                                         Set<Character> nextTransitionStates) {
        if (!transitionFunction.containsKey(currentTransitionState)) {
            transitionFunction.put(currentTransitionState, new HashMap<>());
        }
        transitionFunction.get(currentTransitionState).put(terminal, nextTransitionStates);
    }

    private Map<Character, Set<Character>> getAllReachableStates(Set<Character> states) {
        Map<Character, Set<Character>> result = new HashMap<>();

        for (Character state : states) {
            Map<Character, Character> reachableStates = getAllReachableStates(state);
            for (Character transitionSymbol : reachableStates.keySet()) {
                if (!result.containsKey(transitionSymbol)) {
                    result.put(transitionSymbol, new HashSet<>());
                }
                result.get(transitionSymbol).add(reachableStates.get(transitionSymbol));
            }
        }
        return result;
    }

    private Map<Character, Character> getAllReachableStates(char state) {
        return nka.getFullFunctionOf(state);
    }
}
