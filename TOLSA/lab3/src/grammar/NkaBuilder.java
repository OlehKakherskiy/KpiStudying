package grammar;

import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class NkaBuilder {

    private static final char finalMachineState = 'Z';

    public NkaModel buildNonDeterministicFiniteStateMachine(RegularGrammar grammar) {
        NkaModel stateMachine = new NkaModel();

        stateMachine.setAllStates(grammar.getNonTerminals()); //нетерминальные символы - множество вершин НКА
        stateMachine.getEndStates().add(finalMachineState); //конечное состояние НКА
        stateMachine.getAllStates().add(finalMachineState); //конечное состояние - символ множества состояний


        stateMachine.getStartStates().add(grammar.getStartSymbol()); //начальное состояние НКА - стартовый символ грамматики
        stateMachine.setTerminals(grammar.getTerminals()); //терминальные символы - аргументы функции переходов.

        Set<Character> nonTerminalSymbols = grammar.getNonTerminals();
        for (char nonTerminal : nonTerminalSymbols) {
            addFunctionPairForOneState(stateMachine, nonTerminal, grammar.getTransitionRules(nonTerminal), grammar);
        }
        return stateMachine;
    }

    private void addFunctionPairForOneState(NkaModel stateMachine, char nonTerminal,
                                            Set<String> stateRules, RegularGrammar grammar) {
        for (String rule : stateRules) { //правило вида <termSymbol><NonTermSymbol>(может быть местами поменяно) или <termSymbol>
            if (rule.length() == 1) { //терминальный символ или эпсилон. Если эпсилон - добавляем вершину в конечные.
                char terminal = rule.charAt(0);
                if (terminal == 'ε') {
                    stateMachine.getEndStates().add(nonTerminal); //добавили вершину в множество конечных вершин
                } else { //просто терминальный символ - добавляем функцию вида F(nonTerminal, terminal) = finalMachineState
                    stateMachine.addFunctionPair(nonTerminal, terminal, finalMachineState);
                }

            } else { //правило состоит из терминала и нетерминала. Обрабатываем праволинейную грамматику (терминал_нетерминал)
                stateMachine.addFunctionPair(nonTerminal, rule.charAt(0), rule.charAt(1));
            }
        }
    }

    private void addFunctionPair(NkaModel stateMachine, char nonTerminalArg, char terminalArg, char nonTerminalValue) {
        stateMachine.addFunctionPair(nonTerminalArg, terminalArg, nonTerminalValue);
    }

}
