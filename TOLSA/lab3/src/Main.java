import grammar.NonDeterministicFiniteStateMachine;
import grammar.NonDeterministicFiniteStateMachineBuilder;
import grammar.RegularGrammar;

import java.util.Arrays;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class Main {

    public static void main(String[] args) {
        RegularGrammarValidator validator = new RegularGrammarValidator();
        String regGrammar = "{S,A,B,C,D}\n{a,b,c,d,~}\n{S=>aA|bB; A=>cC|~; C=>cC|cA; B=>dD|~; D=>dD|dB;}\nS";
//        String regGrammar = "{K,L,M,N,P}\n{0,1,&,%,a,b}\n{K=>1M|ε; M=>0L|&N|&P; L=>1L|0L|%P; N=>aN|bN|%P; P=>1P|aP|0}\nK";
        System.out.println("regGrammar.split() = " + Arrays.toString(regGrammar.split("\n")));
        RegularGrammar grammar = validator.validateAndBuildRegularGrammar(regGrammar.split("\n"));
        System.out.println("grammar = " + grammar.toString());
        System.out.println();
        System.out.println();
        NonDeterministicFiniteStateMachineBuilder builder = new NonDeterministicFiniteStateMachineBuilder();
        NonDeterministicFiniteStateMachine machine = builder.buildNonDeterministicFiniteStateMachine(grammar);
        System.out.println(machine.toString());


    }
}
