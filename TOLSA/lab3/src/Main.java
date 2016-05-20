import grammar.NkaBuilder;
import grammar.NkaModel;
import grammar.RegularGrammar;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Arrays;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class Main {

    public static void main(String[] args) {
        RegularGrammarValidator validator = new RegularGrammarValidator();
        RegularGrammar grammar = null;
        try {
            AbstractGrammarLoader grammarLoader = new FileGrammarLoader(new BufferedReader(new FileReader("D:\\Документы\\FICT\\6_семестр\\TOLSA\\lab3\\grammar.txt")));
            String[] grammarParts = grammarLoader.getRegularGrammar();
            System.out.println("grammarParts = " + Arrays.toString(grammarParts));
            grammar = validator.validateAndBuildRegularGrammar(grammarParts);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
//        String regGrammar = "{S,A,B,C,D}\n{a,b,c,d,~}\n{S=>aA|bB; A=>cC|~; C=>cC|cA; B=>dD|~; D=>dD|dB;}\nS";
//        String regGrammar = "{K,L,M,N,P}\n{0,1,&,%,a,b}\n{K=>1M|ε; M=>0L|&N|&P; L=>1L|0L|%P; N=>aN|bN|%P; P=>1P|aP|0}\nK";
//        String regGrammar = "{S,A,B}\n{a,b}\n{S=>aB|aA; B=>bB|a; A=>aA|b}\nS";
//        System.out.println("regGrammar.split() = " + Arrays.toString(regGrammar.split("\n")));
//        RegularGrammar grammar = validator.validateAndBuildRegularGrammar(regGrammar.split("\n"));
        System.out.println("grammar = " + grammar.toString());
        System.out.println();
        System.out.println();
        NkaBuilder builder = new NkaBuilder();
        NkaModel machine = builder.buildNonDeterministicFiniteStateMachine(grammar);
        System.out.println(machine.toString());
        DkaBuilder dkaBuilder = new DkaBuilder();
        System.out.println(dkaBuilder.buildDkaFromNka(machine));
    }
}
