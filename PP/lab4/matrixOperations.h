typedef int* vector;
typedef int** matrix;

matrix generateMatrix(int N);
vector generateVector(int N);
int generateConstant();
matrix multMatr(matrix matrA, matrix matrB, int startIndex, int endIndex, int N);
vector mergeVectors(vector left, vector right, int leftLen, int rightLen);
void sortVector(vector vect, int N);
vector multVectMatr(vector vectA, matrix matrB, int startIndex, int endIndex, int N);
void multConstVect(int c, vector vect, int startIndex, int endIndex);
vector copyVector(vector vectA, int startIndex, int endIndex);
matrix copyMatrix(matrix matrA, int N);
void printVector(vector vect, int N);
void addVectorsMultConstans(vector vect1, vector vect2, vector result, int copy_d, int copy_e, int startIndex, int endIndex);