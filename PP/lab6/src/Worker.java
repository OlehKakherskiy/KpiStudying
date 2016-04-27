import java.util.Arrays;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 20.04.2016.
 */
public class Worker implements Runnable {

    public static int N, P, H;
    private SynchroniseMonitor synchMonitor;

    private ResourceMonitor resourceMonitor;

    private int tid;

    public Worker(SynchroniseMonitor synchMonitor, ResourceMonitor resourseMonitor, int tid) {
        this.synchMonitor = synchMonitor;
        this.resourceMonitor = resourseMonitor;
        this.tid = tid;
    }

    @Override
    public void run() {
        int startIndex = tid * H;
        int endIndex = tid == P - 1 ? N : (tid + 1) * H;
        //ввод данных
        switch (tid) {
            case 0: {
                resourceMonitor.setMK(MatrixOperations.inputMatrix(N));
                synchMonitor.inputIsFinished();
                break;
            }
            case 1: {
                resourceMonitor.setE(MatrixOperations.inputConstant());
                Main.Z = MatrixOperations.inputVector(N);
                synchMonitor.inputIsFinished();
                break;
            }
            case 2: {
                resourceMonitor.setD(MatrixOperations.inputConstant());
                resourceMonitor.setR(MatrixOperations.inputVector(N));
                Main.B = MatrixOperations.inputVector(N);
                synchMonitor.inputIsFinished();
                break;
            }
            case 3: {
                Main.C = MatrixOperations.inputVector(N);
                Main.MO = MatrixOperations.inputMatrix(N);
                synchMonitor.inputIsFinished();
                break;
            }
        }
        try {
            synchMonitor.waitInputFinish();

            synchMonitor.waitScalarMultCalculationFinish();

            int[][] MKi = resourceMonitor.getMK();
            int[] Ri = resourceMonitor.getR();
            int ei = resourceMonitor.getE();
            int di = resourceMonitor.getD();
            int xi = resourceMonitor.getX();
            MatrixOperations.addVectors(Main.Z, MatrixOperations.
                    multVectorMatrix(Ri, MatrixOperations.multMatrix(Main.MO, MKi, startIndex, endIndex)), Main.A, ei, di * xi, startIndex, endIndex);
            synchMonitor.calculationIsFinished();

            if (tid == 1) {
                synchMonitor.waitCalculationFinish();
                if (N <= 30)
                    System.out.println(Arrays.toString(Main.A));
            }
            System.out.println(String.format("Thread %d is finished calculations", tid));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
