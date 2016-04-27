/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 20.04.2016.
 */
public class SynchroniseMonitor {

    private int inputFlag;

    private int outputFlag;

    private int threadCount;

    private boolean scalarCalcsIsFinished = false;

    public SynchroniseMonitor(int threadCount) {
        this.threadCount = threadCount;
    }

    public synchronized void waitInputFinish() throws InterruptedException {
        if (inputFlag < 4)
            wait();
    }

    public synchronized void waitCalculationFinish() throws InterruptedException {
        if (outputFlag < threadCount - 1)
            wait();
    }

    public synchronized void waitScalarMultCalculationFinish() throws InterruptedException {
        if (!scalarCalcsIsFinished)
            wait();
    }

    public synchronized void scalarMultiplicationIsFinishedSignal() {
        scalarCalcsIsFinished = true;
        notifyAll();
    }

    public synchronized void inputIsFinished() {
        if (++inputFlag == 4)
            notifyAll();
    }

    public synchronized void calculationIsFinished() {
        if (++outputFlag == 4)
            notifyAll();
    }
}
