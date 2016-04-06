------------------------------------------------------------------
--  File: matrixOperations.ads                                  --
--                                                              --
--  Автор: Олег Кахерський, група ІП-31                         --
--  Дата: 12.03.2016                                            --
------------------------------------------------------------------
generic
	N: in Integer; --розмірність масивів та матриць
package MatrixOperations is
	type Vector is private;
	type Matrix is private;

    --Вивід вектора на екран
	procedure Output_Vector (A : Vector);     

    --Множення матриці на матрицю(діапазон рядків StartIndex..EndIndex),
    --результат множення множиться на константу
    procedure Matrix_Matrix_Multiply
    (Left  : Matrix;
    Right  : Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    Result_Matrix: out Matrix);

    --скалярний добуток векторів в діапазоні [StartIndex, EndIndex)
    function Scalar_Multiply
    (V1: Vector; 
    V2:Vector;
    Start_Index:Integer;
    End_Index:Integer) return Integer;

    procedure Vector_Matrix_Multiply
    (V: Vector;
    MT:Matrix;
    Result: out Vector;
    Start_Index:Integer;
    End_Index:Integer);

    procedure Vector_Vector_Add
    (V1: Vector;
    V2: Vector; 
    Result_Vector: out Vector;
    Const1: Integer;
    Const2: Integer;
    Start_Index: Integer;
    End_Index: Integer);

    --Ввід вектора
    function Input_Vector return Vector;

    --Ввід константи
    function Input_Constant return Integer;

    --Ввід матриці
	function Input_Matrix return Matrix;

	private
      	type Vector is array (1..N) of Integer;
      	type Matrix is array (1..N) of Vector;
end MatrixOperations;
