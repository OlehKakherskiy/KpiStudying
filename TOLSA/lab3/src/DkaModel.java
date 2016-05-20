import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class DkaModel {

    Set<Set<Character>> states = new HashSet<>();

    Map<Character, Character> alphabet = new HashMap<>();

    Map<Set<Character>, Map<Character, Set<Character>>> transitions = new HashMap<>();

    Set<Set<Character>> endStates = new HashSet<>();

    Set<Character> startStates = new HashSet<>();

    @Override
    public String toString() {
        return "DkaModel{" +
                "states=" + states +
                ",\n alphabet=" + alphabet +
                ",\n transitions=" + transitions +
                ",\n endStates=" + endStates +
                ",\n startStates=" + startStates +
                '}';
    }
}
