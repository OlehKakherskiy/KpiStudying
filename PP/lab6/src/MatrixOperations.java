import java.util.Arrays;

/**
 * Created by oleg on 03.10.15.
 */
public class MatrixOperations {

    /**
     * Генерує матрицю, заповнює одиницями
     *
     * @param n розмірність
     */
    public static int[][] inputMatrix(int n) {
        int[][] result = new int[n][n];
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++) {
                result[i][j] = 1;
            }
        return result;
    }

    /**
     * Генерує вектор, заповнює одиницями
     *
     * @param n розмірність
     */
    public static int[] inputVector(int n) {
        int[] result = new int[n];
        for (int i = 0; i < result.length; i++) {
            result[i] = 1;
        }
        return result;
    }

    public static int inputConstant() {
        return 1;
    }

    public static int[] multVectorMatrix(int[] vector, int[][] matrix) {
        int[] result = new int[matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < vector.length; j++) {
                result[i] += vector[j] * matrix[i][j];
            }
        }
        return result;
    }

    /**
     * Додає вектори
     *
     * @param p1 вектор1
     * @param p2 вектор2
     * @return сума векторів
     */
    public static int[] addVectors(int[] p1, int[] p2, int[] result, int const1, int const2, int startIndex, int endIndex) {
        for (int i = startIndex; i < endIndex; i++) {
            result[i] = p1[i] * const1 + p2[i - startIndex] * const2;
        }
        return result;
    }

    /**
     * Перемножає матриці
     *
     * @param param1 матриця-множник
     * @param param2 матриця-множене
     * @return добуток матриць, розмірність - nxn
     */
    public static int[][] multMatrix(int[][] param1, int[][] param2, int startIndex, int endIndex) {
        if (param1[0].length != param2.length) {
            System.out.println("Нельзя умножать матрицы, количество элементов в строке которой не равно кол-ву столбцов в другой");
            return null;
        }
        int[][] result = new int[endIndex - startIndex][param1[0].length];
        for (int k = startIndex; k < endIndex; k++) {
            for (int i = 0; i < param1[0].length; i++) {
                for (int j = 0; j < param2.length; j++) {
                    result[k - startIndex   ][i] += param1[k][j] * param2[j][i];
                }
            }
        }
        return result;
    }

    public static String formattedDeepToString(int[][] matrix) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < matrix.length; i++) {
            result.append(Arrays.toString(matrix[i])).append("\n");
        }
        return result.toString();
    }


    public static int[] copyVector(int[] vector) {
        int[] result = new int[vector.length];
        System.arraycopy(vector, 0, result, 0, vector.length);
        return result;
    }

    public static int[][] copyMatrix(int[][] matrix) {
        int[][] result = new int[matrix.length][];
        for (int i = 0; i < matrix.length; i++) {
            result[i] = copyVector(matrix[i]);
        }
        return result;
    }

//    /**
//     * Метод выполняет обрезку строк матрицы. Возвращает строки в matrixToTruncate начиная с offset количеством rowCount
//     *
//     * @param matrixToTruncate матрица, с которой будут вырезаны строки
//     * @param offset           номер строки, с которой будет выполнена обрезка
//     * @param rowCount         количество строк
//     * @return матрица, количество строк которой = rowCount и строки идентичны строкам в matrixToTruncate начиная с
//     * offset позиции
//     */
//    public static int[][] truncateMatrix(int[][] matrixToTruncate, int offset, int rowCount) {
//        int result[][] = new int[rowCount][];
//        System.arraycopy(matrixToTruncate, offset, result, 0, rowCount);
//        return result;
//    }

}