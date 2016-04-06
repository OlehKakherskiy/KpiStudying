#include "omp.h"
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
* Сортировка вставками вектора в діапазоні [startIndex, endIndex)
*/
void sortVector(vector vect, int N){
    for (int i = 1; i < N; ++i)
    {
        int buf = vect[i];
        for (int j = i - 1; j >= 0; --j)
        {
            if(vect[j] > buf){
                vect[j+1] = vect[j];
                vect[j] = buf;
            }
        }
    }
}


//слияние векторов (однопоточное)
vector mergeVectors(vector left, vector right, int leftLen, int rightLen){

    vector result = new int[leftLen + rightLen];
    int leftIndex = 0;
    int rightIndex = 0;
    int i = 0;
    while(leftIndex < leftLen && rightIndex < rightLen){

        if(left[leftIndex] < right[rightIndex]){
            result[i++] = left[leftIndex++];
        }

        else{
            result[i++] = right[rightIndex++];
        }
    }

    if(leftIndex >= leftLen)
        while(rightIndex < rightLen)
            result[i++] = right[rightIndex++];
    else
        while(leftIndex < leftLen)
            result[i++] = left[leftIndex++];
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


vector copyVector(vector vectA, int startIndex, int endIndex){
    vector result = new int[endIndex - startIndex];
    for (int i = startIndex; i < endIndex; ++i)
    {
        result[i - startIndex] = vectA[i];
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

void addVectorsMultConstans(vector vect1, vector vect2, vector result, int copy_d, int copy_e, int startIndex, int endIndex){
    for (int i = startIndex; i < endIndex; ++i){
        result[i] = copy_d * vect1[i] + copy_e * vect2[i];
    }
}