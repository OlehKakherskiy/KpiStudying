typedef int* vector;
typedef int** matrix;

matrix generateMatrix(int N);
vector generateVector(int N);
int generateConstant();
matrix multMatr(matrix matrA, matrix matrB, int startIndex, int endIndex, int N);
int maxInVector(vector vect, int startIndex, int endIndex);
vector multVectMatr(vector vectA, matrix matrB, int startIndex, int endIndex, int N);
void multConstVect(int c, vector vect, int startIndex, int endIndex);
vector copyVector(vector vectA, int N);
matrix copyMatrix(matrix matrA, int N);
void printVector(vector vect, int N);
void addVectors(vector vect1, vector vect2, vector result, int startIndex, int endIndex);