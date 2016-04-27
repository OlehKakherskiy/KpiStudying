/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 20.04.2016.
 */
public class ResourceMonitor {

    private int e;

    private int d;

    private int x;

    private int[] R;

    private int[][] MK;

    public synchronized int getE() {
        return e;
    }

    public synchronized void setE(int e) {
        this.e = e;
    }

    public synchronized int getD() {
        return d;
    }

    public synchronized void setD(int d) {
        this.d = d;
    }

    public synchronized int getX() {
        return x;
    }

    public synchronized void setX(int x) {
        this.x = x;
    }

    public synchronized int[] getR() {
        return MatrixOperations.copyVector(R);
    }

    public synchronized void setR(int[] r) {
        R = r;
    }

    public synchronized int[][] getMK() {
        return MatrixOperations.copyMatrix(MK);
    }

    public void setMK(int[][] MK) {
        this.MK = MK;
    }
}
