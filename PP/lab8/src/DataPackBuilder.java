import java.util.Arrays;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 18.04.2016.
 */
public class DataPackBuilder {

    private static DataPack[] preparedPacks;

    public static int[] elementsCount;

    public static int[] dataOffset;

    public static void setMetadata(int processCount, int[] elemCount, int[] offset) {
        preparedPacks = new DataPack[processCount];
        for (int i = 0; i < preparedPacks.length; i++) {
            preparedPacks[i] = new DataPack();
        }
        elementsCount = elemCount;
        dataOffset = offset;
    }

    public static DataPack[] packData(int[][] MO, int[][] MT, int[][] MR, int[] Z, int e) {
        for (int i = 0; i < preparedPacks.length; i++) {
            preparedPacks[i].setMO(Arrays.copyOfRange(MO, dataOffset[i], dataOffset[i] + elementsCount[i]));
            preparedPacks[i].setMR(MR);
            preparedPacks[i].setMT(Arrays.copyOfRange(MT, dataOffset[i], dataOffset[i] + elementsCount[i]));

            preparedPacks[i].setVector(Arrays.copyOfRange(Z, dataOffset[i], dataOffset[i] + elementsCount[i]));
            preparedPacks[i].setE(e);
        }
        return preparedPacks;
    }
}
