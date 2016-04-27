import java.util.concurrent.RecursiveTask;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 20.04.2016.
 */
public class SummTask extends RecursiveTask<Integer> {

    private int[] a;
    private int[] b;
    private int startIndex;
    private int endIndex;

    public static int granular;

    public SummTask(int[] a, int[] b, int startIndex, int endIndex) {
        this.a = a;
        this.b = b;
        this.startIndex = startIndex;
        this.endIndex = endIndex;
    }

    @Override
    protected Integer compute() {

        if (granular >= endIndex - startIndex) {
            return getScalarMultiplicationResult();
        } else {
            int mid = (startIndex + endIndex) / 2;
            SummTask subtask1 = new SummTask(a, b, startIndex, mid);
            subtask1.fork();
            SummTask subtask2 = new SummTask(a, b, mid, endIndex);
            subtask2.fork();
            return subtask1.join() + subtask2.join();
        }
    }


    private int getScalarMultiplicationResult() {
        int result = 0;
        for (int i = startIndex; i < endIndex; i++) {
            result += a[i] * b[i];
        }
        return result;
    }
}
