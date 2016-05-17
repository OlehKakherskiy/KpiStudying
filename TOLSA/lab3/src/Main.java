import grammar.RegularGrammar;

import java.util.Arrays;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class Main {

    public static void main(String[] args) {
        RegularGrammarValidator validator = new RegularGrammarValidator();
        String regGrammar = "{S,A,B,C,D}\n{a,b,c,d,~}\n{S=>aA|bB; A=>cC|~; C=>cC|cA; B=>dD|~; D=>dD|dB;}\nS";
        System.out.println("regGrammar.split() = " + Arrays.toString(regGrammar.split("\n")));
        RegularGrammar grammar = validator.validateAndBuildRegularGrammar(regGrammar.split("\n"));
        System.out.println("grammar = " + grammar.toString());
    }
}
