import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class DkaModel {

    Map<String, Character> states = new HashMap<>();

    Map<Character, Character> alphabet = new HashMap<>();

    Map<String, Set<String>> transitions = new HashMap<>();
}
