
#include<iostream>

typedef int* vector;
typedef int** matrix;

using namespace std;

/**
* метод повертає згенеровану матрицю розмірністю N*N
*/
matrix generateMatrix(int N){
    matrix m = new vector[N];
    for (int i = 0; i < N; i++){
        m[i] = new int[N];
        for (int j = 0; j < N; j++){
            m[i][j] = 1;
        }
    }
    return m;
}

/**
* метод повертає згенерований вектор розмірністю N
*/
vector generateVector(int N){
    vector vector = new int[N];
    for (int i = 0; i < N; i++){
        vector[i] = 1;
    }
    return vector;
}

/**
* метод повертає згенеровану константу
*/
int generateConstant(){
    return 1;
}

/**
* перемножає рядки matrA з діапазона [startIndex, endIndex) на matrB. Результат записується в result
*/
matrix multMatr(matrix matrA, matrix matrB, int startIndex, int endIndex, int N){
	matrix result = new vector[N];
    for (int i = startIndex; i < endIndex; i++) {
		result[i] = new int[N];
        for (int j = 0; j < N; j++) {
			result[i][j] = 0;
            for (int k = 0; k < N; k++) {
                result[i][j] += matrA[i][k] * matrB[k][j];
            }
        }
    }
	return result;
}

/**
* Знаходить максимум з діапазона [startIndex, endIndex) вектора
*/
int maxInVector(vector vect, int startIndex, int endIndex){
    int result = vect[startIndex];
    for (int i = startIndex+1; i < endIndex; i++){
        if (result < vect[i])
            result = vect[i];
    }
    return result;
}

/**
* Перемножає вектор на рядки матриці в діапазоні [startIndex, endIndex)
*/
vector multVectMatr(vector vectA, matrix matrB, int startIndex, int endIndex, int N){
	vector result = new int[N];
    for (int i = startIndex; i < endIndex; ++i){
		result[i] = 0;
        for (int j = 0; j < N; ++j){
            result[i] += vectA[j] * matrB[i][j];
        }
    }
	return result;
}

void multConstVect(int c, vector vect, int startIndex, int endIndex){
    for(int i = startIndex; i < endIndex; i++)
        vect[i] *= c;
}

vector copyVector(vector vectA, int N){
    vector result = new int[N];
    for (int i = 0; i < N; ++i)
    {
        result[i] = vectA[i];
    }
    return result;
}

matrix copyMatrix(matrix matrA, int N){
    matrix result = new vector[N];
    for (int i = 0; i < N; ++i)
    {
        result[i] = new int[N];
        for (int j = 0; j < N; ++j)
        {
            result[i][j] = matrA[i][j];
        }
    }
    return result;
}

void printVector(vector vect, int n){
    for (int i = 0; i < n; i++)
        cout << vect[i] <<" ";
    cout << endl;
}

void addVectors(vector vect1, vector vect2, vector result, int startIndex, int endIndex){
    for (int i = startIndex; i < endIndex; ++i){
        result[i] = vect1[i] + vect2[i];
    }
}
