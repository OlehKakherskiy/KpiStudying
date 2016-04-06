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

    --Вивід матриці на екран
	procedure Output_Matrix (MA : Matrix);     

    --Множення матриці на матрицю(діапазон рядків StartIndex..EndIndex),
    --результат множення множиться на константу
    procedure Matrix_Matrix_Multiply
    (Left  : Matrix;
    Right  : Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    const: Integer; --константа, на яку множиться результат множення
    Result_Matrix: out Matrix);

    --Додавання матриць, Right(I)(J) перед додаванням множиться на константу
    procedure Matrix_Matrix_Add
    (Left: Matrix;
    Right:  Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    const: Integer;
    Result_Matrix: out Matrix);

    --Знаходження мінімального значення в діапазоні StartIndex, EndIndex
    function Min 
	(Vect: Vector;
    Start_Index: Integer;
    End_Index: Integer) return Integer;

    --Ввід вектора
    function Input_Vector return Vector;

    --Ввід константи
    function Input_Constant return Integer;

    --Ввід матриці
	function Input_Matrix return Matrix;

	private
    	subtype Index is Integer range 1..N;
      	type Vector is array (Index) of Integer;
      	type Matrix is array (Index) of Vector;
end MatrixOperations;
