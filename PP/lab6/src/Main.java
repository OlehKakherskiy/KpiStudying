import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ForkJoinPool;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 19.04.2016.
 */
public class Main {

    public static int[] B, C, Z, A;
    public static int[][] MO;

    public static void main(String[] args) {
        System.out.println("program is started");
        Worker.N = Integer.parseInt(args[0]);
        A = new int[Worker.N];
        Worker.P = Integer.parseInt(args[1]);
        SummTask.granular = Integer.parseInt(args[2]);
        Worker.H = Worker.N / Worker.P;
        ForkJoinPool forkJoinPool = new ForkJoinPool(Worker.P);

        ResourceMonitor resourceMonitor = new ResourceMonitor();
        SynchroniseMonitor synchroniseMonitor = new SynchroniseMonitor(Worker.P);

        ExecutorService service = Executors.newFixedThreadPool(Worker.P);

        for (int i = 0; i < Worker.P; i++) {
            service.execute(new Worker(synchroniseMonitor, resourceMonitor, i));
        }

        try {
            synchroniseMonitor.waitInputFinish();

            resourceMonitor.setX(forkJoinPool.invoke(new SummTask(B, C, 0, B.length)));
            System.out.println("x = " + resourceMonitor.getX());
            synchroniseMonitor.scalarMultiplicationIsFinishedSignal();
            forkJoinPool.shutdown();

            synchroniseMonitor.waitCalculationFinish();
            service.shutdown();
            System.out.println("program is finished");

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
