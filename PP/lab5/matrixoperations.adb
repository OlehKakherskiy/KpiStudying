with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
------------------------------------------------------------------
--  File: matrixOperations.adb                                  --
--                                                              --
--  Автор: Олег Кахерський, група ІП-31                         --
--  Дата: 12.03.2016                                            --
------------------------------------------------------------------
package body MatrixOperations is 

procedure Output_Vector (A : Vector) is
	begin
    	New_Line;
    	for I in 1..N loop
    		Put(Item => A(i), Width => 5);
        end loop;
end Output_Vector;

procedure Matrix_Matrix_Multiply
    (Left  : Matrix;
    Right  : Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    Result_Matrix: out Matrix) is
    begin
        for i in Start_Index..End_Index loop
            for J in 1..N loop
               Result_Matrix(I)(J) := 0;
               for K in 1..N loop
            Result_Matrix(I)(J) := Result_Matrix(I)(J) + Left(I)(K) * Right(K)(J);
            end loop;
        end loop;
    end loop;
end Matrix_Matrix_Multiply;

function Scalar_Multiply
    (V1: Vector; 
    V2:Vector;
    Start_Index:Integer;
    End_Index:Integer) return Integer is
    Result: Integer := 0;
    begin
        for I in Start_Index..End_Index loop
            Result := Result + V1(I)*V2(I);
        end loop;
    return Result;
end Scalar_Multiply;

procedure Vector_Vector_Add
    (V1: Vector;
    V2: Vector; 
    Result_Vector: out Vector;
    Const1: Integer;
    Const2: Integer;
    Start_Index: Integer;
    End_Index: Integer) is
    begin
        for I in Start_Index..End_Index loop
            Result_Vector(I) := Const1*V1(I) + Const2*V2(I);
        end loop;
end Vector_Vector_Add;

procedure Vector_Matrix_Multiply
    (V: Vector;
    MT:Matrix;
    Result: out Vector;
    Start_Index:Integer;
    End_Index:Integer) is
    begin
        for I in Start_Index..End_Index loop
            Result(I) := 0;
            for J in 1..N loop
                Result(I) := Result(I) + V(J) * MT(I)(J);
            end loop; 
        end loop;
end Vector_Matrix_Multiply;

function Input_Vector return Vector is
	V: Vector;
   	begin
    	for I in 1..N loop
    		V(I) := 1;
		end loop;
	return V;
end Input_Vector;

function Input_Constant return Integer is
	begin
    return 1;
end Input_Constant;

function Input_Matrix return Matrix is
	Result_Matrix: Matrix;
    begin
        for I in 1..N loop
            for J in 1..N loop
               Result_Matrix(I)(J) := 1;
            end loop;
        end loop;
	return Result_Matrix;
end Input_Matrix;

end MatrixOperations;