using System;
using System.Text;

namespace lab4
{
	public class MatrixOperations
	{
		/*
     * Генерує матрицю, заповнює одиницями
     *
     * @param n розмірність
     */
		public static int[][] generateMatrix(int n) {
			int[][] result = new int[n][];
			for (int i = 0; i < n; i++) {
				result[i] = new int[n];
				for(int j = 0; j < n; j++){
					result [i][j] = 1;
				}
			}
			return result;
		}

		//генерирует вектор размерности b
		public static int[] generateVector(int n) {
			int[] result = new int[n];
			for (int i = 0; i < n; i++)
				result [i] = 1;
			return result;
		}

		//суммирует векторы
		public static int[] addVectors(int[] p1, int[] p2, int startIndex, int endIndex){
			int[] result = new int[p1.Length];
			for (int i = startIndex; i < endIndex; i++) {
				result[i] = p1[i] + p2[i];
			}
			return result;
		}

		//выполняет умножение матрици на матрицу
		public static int[][] multiplyMatrixMatrix(int[][] param1, int[][] param2, int startIndex, int endIndex) {
			int[][] result = new int[param1.Length][];
			for (int k = startIndex; k < endIndex; k++) {
				result[k] = new int[param1.Length];
				for (int i = 0; i < param1.Length; i++) {
					for (int j = 0; j < param2.Length; j++) {
						result[k][i] += param1[i][j] * param2[j][i];
					}
				}
			}
			return result;
		}

		//выполняет умножение вектора на константу и на матрицу
		public static int[] multiplyVectorMatrix(int[] v, int[][] m, int constant, int startIndex, int endIndex) {
			int[] result = new int[v.Length];
			for (int i = startIndex; i < endIndex; i++) {
				for (int j = 0; j < m.Length; j++) {
					result[i] += constant * v[i] * m[j][i];
				}
			}
			return result;
		}

		public static int min(int[] vector, int startIndex, int endIndex){
			int result = vector[startIndex];
			for(int i = startIndex+1; i < endIndex; i++)
				if(result > vector[startIndex])
					result = vector[startIndex];
			return result;
		}

		//выводит вектор на экран
		public static String ToString(int[] vector){
			StringBuilder b = new StringBuilder ();
			for (int i = 0; i < vector.Length; i++)
				b.Append (vector [i] + "  ");
			return b.ToString ();
		}
		                                         
	}
}

