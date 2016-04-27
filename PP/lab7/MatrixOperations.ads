------------------------------------------------------------------
--  File: matrixOperations.ads                                  --
--                                                              --
--  Автор: Олег Кахерський, група ІП-31                         --
--  Дата: 12.03.2016                                            --
------------------------------------------------------------------
generic
  N: in Integer; --розмірність масивів та матриць
package MatrixOperations is

    type DynamicVector is array (positive range<>)of integer;
    --subtype Vector is DynamicVector (1 .. N);
    type DynamicMatrix is array (positive range<>) of DynamicVector(1 .. N);
    --subtype Matrix is DynamicMatrix(1 .. N);

    --Вивід матриці на екран
  procedure Output_Vector (V : in DynamicVector);     

    --Множення матриці на матрицю(діапазон рядків StartIndex..EndIndex),
    --результат множення множиться на константу
    procedure Matrix_Matrix_Multiply
    (Left  : DynamicMatrix;
    Right  : DynamicMatrix;
    Result_Matrix: out DynamicMatrix);

    procedure Vector_Matrix_Multiply
     (Left  : in DynamicVector;
      Right : in DynamicMatrix;
      Result_Vector: out DynamicVector);

     procedure addVectors(Left: DynamicVector; Right: DynamicVector; Result_Vector: out DynamicVector; d : Integer);
     procedure Vector_Vector_Add(Left: DynamicVector; Right: DynamicVector; Result_Vector: out DynamicVector; 
      d,startIndex,EndIndex : Integer);
    --Ввід вектора
    function Input_Vector return DynamicVector;

    --Ввід константи
    function Input_Constant return Integer;

    --Ввід матриці
  function Input_Matrix return DynamicMatrix;

end MatrixOperations;