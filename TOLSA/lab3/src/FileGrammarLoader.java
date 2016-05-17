import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Oleh Kakherskyi (olehkakherskiy@gmail.com)
 */
public class FileGrammarLoader extends AbstractGrammarLoader {

    private BufferedReader fileReader;

    public FileGrammarLoader(BufferedReader fileReader) {
        this.fileReader = fileReader;
    }

    @Override
    public String[] getRegularGrammar() {
        List<String> grammarElements = new ArrayList<>();
        String nextLine;
        try {
            while ((nextLine = fileReader.readLine()) != null) {
                grammarElements.add(nextLine);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        String[] result = new String[grammarElements.size()];
        for (int i = 0; i < result.length; i++) {
            result[i] = grammarElements.get(i);
        }
        return result;
    }
}
