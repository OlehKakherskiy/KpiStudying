import mpi.Graphcomm;
import mpi.MPI;

import java.util.Arrays;

/**
 * Created by Oleh Kakherskyi, student of the KPI, FICT, IP-31 group (olehkakherskiy@gmail.com) on 21.04.2016.
 */
public class Main {

    private static int N;

    private static int H;

    private static int[][] MO, MR, MT, MA;

    private static int[] Z;

    private static int e, maxZ;

    public static void main(String[] args) {

        //размерность матриц и векторов
        N = Integer.parseInt(args[args.length - 1]);
        int p = 9;
        H = N / p;

        //инициализация библиотеки
        MPI.Init(args);

        //ранг процесса
        int rank = MPI.COMM_WORLD.Rank();

        //инициализация данных для топологии
        int[] graphIndexes = new int[]{3, 5, 6, 7, 8, 9, 10, 11, 12};
        int[] graphEdges = new int[]{1, 4, 5, 0, 2, 3, 1, 1, 0, 0, 6, 7, 8, 5, 5, 5};

        //создание топологии на основе коммуникатора COMM_WORLD
        Graphcomm graphcomm = MPI.COMM_WORLD.Create_graph(graphIndexes, graphEdges, false);

        //кол-во элементов в массивах и строк в матрицах, которые используются каждым рангом
        int[] indexCount = getEachCount(p);

        //смещение, с которого отсчитываются indexCount элементов для каждого ранга
        int[] displacement = getEachOffset(p);

        //ввод данных
        if (rank == 0) {
            MO = MatrixOperations.inputMatrix(N);
            MR = MatrixOperations.inputMatrix(N);
            MT = MatrixOperations.inputMatrix(N);
            Z = MatrixOperations.inputVector(N);
            e = MatrixOperations.inputConstant();

            //установка метаданных для упаковщика
            DataPackBuilder.setMetadata(p, indexCount, displacement);
        }

        //если ранг = 0, то упаковываются все матрицы, вектора и константы для отправки каждому процессу,
        //в ином случае создается буфер, в который будет помещен принятый пакет
        DataPack[] packs = rank == 0 ? DataPackBuilder.packData(MO, MT, MR, Z, e) : new DataPack[1];

        //отправка пакетов всем процессам с процесса 0 согласно топологии
        graphcomm.Scatter(packs, 0, 1, MPI.OBJECT, packs, 0, 1, MPI.OBJECT, 0);

        //распаковка данных
        MO = packs[0].getMO();
        MR = packs[0].getMR();
        MT = packs[0].getMT();
        Z = packs[0].getVector();
        e = packs[0].getE();

        //вычисление локального максимума
        int[] localMax = {MatrixOperations.max(Z, 0, Z.length)};

        //принятие/передача локальных максимумов с автоматическим максимального значения
        graphcomm.Reduce(localMax, 0, localMax, 0, 1, MPI.INT, MPI.MAX, 0);

        //отправка/получение максимального значения всеми с процесса 0 всем процессам
        graphcomm.Bcast(localMax, 0, 1, MPI.INT, 0);
        maxZ = localMax[0];

        //вычисление математического выражения
        MA = MatrixOperations.addMatrix(MO, MatrixOperations.multMatrix(MT, MR), maxZ, e);
        int[][] buf = new int[N][];

        //отравка частичного результата процессу 0 всеми процессами с последущей автоматической упаковкой по номеру процесса
        graphcomm.Gather(MA, 0, indexCount[rank], MPI.OBJECT, buf, displacement[rank], indexCount[rank], MPI.OBJECT, 0);
        MA = buf;
        if (rank == 0 && MA.length <= 18)
            System.out.println(MatrixOperations.formattedDeepToString(MA));

        System.out.println("Process " + rank + " is finished");
        MPI.Finalize();
    }

    /**
     * Вычисление количества элементов в векторах и кол-во строк в матрицах, которые будут переданы каждому процессу
     * для вычисления мат. выражения
     *
     * @param processCount количество процессов
     * @return количество элементов
     */
    private static int[] getEachCount(int processCount) {
        int[] result = new int[processCount];
        Arrays.fill(result, 1, result.length, H);
        //первый процесс получит больше элементов, если их неравное количество на каждый процесс
        result[0] = N - (result.length - 1) * H;
        return result;
    }

    /**
     * Вычисление смещения в векторах и матрицах, начиная с которого будет передано {@link #getEachCount(int)}(rank)
     * элементов векторов и строк матриц процессу с номером rank
     *
     * @param processCount количество процессов
     * @return смещение в векторах и матрицах
     */
    private static int[] getEachOffset(int processCount) {
        int[] result = new int[processCount];
        result[0] = 0;
        result[1] = N - (result.length - 1) * H;
        for (int i = 2; i < result.length; i++) {
            result[i] = result[i - 1] + H;
        }
        return result;
    }

}
