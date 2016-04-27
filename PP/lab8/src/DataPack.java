import java.io.Serializable;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 18.04.2016.
 */
public class DataPack implements Serializable {

    private int[][] MO;

    private int[][] MR;

    private int[][] MT;

    private int[] vector;

    private int e;

    public DataPack() {
        MO = new int[0][0];
        MR = new int[0][0];
        MT = new int[0][0];
        vector = new int[0];
    }

    public int[][] getMO() {
        return MO;
    }

    public void setMO(int[][] MO) {
        this.MO = MO;
    }

    public int[][] getMR() {
        return MR;
    }

    public void setMR(int[][] MR) {
        this.MR = MR;
    }

    public int[][] getMT() {
        return MT;
    }

    public void setMT(int[][] MT) {
        this.MT = MT;
    }

    public int[] getVector() {
        return vector;
    }

    public void setVector(int[] vector) {
        this.vector = vector;
    }

    public int getE() {
        return e;
    }

    public void setE(int e) {
        this.e = e;
    }
}