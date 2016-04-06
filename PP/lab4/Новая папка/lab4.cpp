#include "matrixOperations.h"
#include<windows.h>
#include<iostream>
#include "omp.h"
#include <cmath>   

#ifdef _DEBUG
#undef _DEBUG
#include <omp.h>
#define _DEBUG
#else
#include <omp.h>
#endif

using namespace std;

#define arraySize(a) (sizeof(a)/sizeof((a)[0]))

typedef int* vector;
typedef int** matrix;

int d, e;
int N,P,H;
vector A,B,Z;
matrix MO, MK;

void copySharedResources(int &copy_d, int &copy_e, matrix &copy_MO){
	copy_d = d;
	copy_e = e;
	copy_MO = copyMatrix(MO, N);
}

void calculateEquation(int copy_d, int copy_e, matrix copy_MO, int startIndex, int endIndex){
	matrix Buf = multMatr(copy_MO, MK, startIndex, endIndex, N);
	vector BufVect1 = multVectMatr(Z, Buf, startIndex, endIndex, N);
	addVectorsMultConstans(B, BufVect1, A, copy_d, copy_e, startIndex, endIndex);
}


vector mergeParts(matrix vectorParts, int partsCount, int vectorPartSize, int lastVectorPartSize){
	if (partsCount == 1)
		return vectorParts[0];

	int fullIters = partsCount / 2;
	int nextPartsCount = (int)ceil(partsCount / 2.0);
	matrix nextIteration = new vector[nextPartsCount];
	cout << "parts count: " << partsCount << endl;
	cout << "fullIters: " << fullIters << endl;
	cout << "nextPartsCount: " << nextPartsCount << endl;
	
	omp_set_num_threads(fullIters);
	#pragma omp parallel for 
	for (int i = 0; i < fullIters; i++){
		cout << omp_get_thread_num() << " doing " << i << " iteration"<<endl;
		cout << arraySize(vectorParts[i]) << endl;
		cout << arraySize(vectorParts[i + 1]) << endl;
		if (i == fullIters-1) //последняя итерация полная - может быть 1 вектор больше другого в два раза
			nextIteration[i] = mergeVectors(vectorParts[2 * i], vectorParts[2 * i + 1], vectorPartSize, lastVectorPartSize);
		else
			nextIteration[i] = mergeVectors(vectorParts[2 * i], vectorParts[2 * i + 1], vectorPartSize, vectorPartSize);
	}
	vectorPartSize *= 2;
	//#pragma omp barrier
		if (fullIters < nextPartsCount)
			nextIteration[fullIters + 1] = vectorParts[partsCount - 1];
		else {
				lastVectorPartSize = vectorPartSize;
		}
		return mergeParts(nextIteration, nextPartsCount, vectorPartSize, lastVectorPartSize);
}

void task(){
	matrix sortedVectors = new vector[P];
	omp_set_num_threads(P);
	
	#pragma omp parallel
	{
		int tID = omp_get_thread_num();

		#pragma omp critical 
			cout << "Task " << tID << " started" << endl;

		switch(tID){

			case 0:
				cout << "Task " << tID << " input B" << endl;
				B = generateVector(N);
				break;

			case 1: 
				d = generateConstant();
				Z = generateVector(N);
				break;

			case 2:
				e = generateConstant();
				MK = generateMatrix(N);
				break;

			case 3:
				MO = generateMatrix(N);
				break;
		}

		#pragma omp barrier

		int d_i, e_i;
		matrix MO_i = NULL;

		copySharedResources(d_i, e_i, MO_i);

		int endIndex = -1;
		int startIndex = -1;
		
		
		#pragma omp for private(startIndex, endIndex) 
			for (int i = 0; i < P; i++){

				startIndex = i*H;
				endIndex = (i == P - 1) ? N : (i + 1)*H;

				calculateEquation(d_i, e_i, MO_i, startIndex, endIndex); 
				sortedVectors[i] = copyVector(A, startIndex, endIndex);
				sortVector(sortedVectors[i]);
			}
		}

	A = mergeParts(sortedVectors, P, H, H);

		//#pragma omp critical
		//	cout << "task " << tID << " finished" << endl;

		if (N <= 36)
			printVector(A, N);
}

int main(int argc, char const *argv[])
{
	cout << "Lab4 started" << endl;
	cout << "input N" << endl;
    cin >> N;
    cout << "input P" << endl;
    cin >> P;
	//cout << N;
	//cout << P;
    H = N / P;
	A = new int[N];

	B = NULL;
	Z = NULL;
	MO = NULL;
	MK = NULL;

	task();
	vector v1 = new int[4];
	vector v2 = new int[4];
	v1[0] = 1; v1[1] = 3; v1[2] = 5; v1[3] = 7;
	v2[0] = 2; v2[1] = 4; v2[2] = 6; v2[3] = 8;
	printVector(mergeVectors(v1, v2, 4, 4), 8);
	cout << "Lab4 finished" << endl;
	system("pause");
	return 0;
}