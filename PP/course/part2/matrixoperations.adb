with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
------------------------------------------------------------------
--  File: matrixOperations.adb                                  --
--                                                              --
--  Автор: Олег Кахерський, група ІП-31                         --
--  Дата: 12.03.2016                                            --
------------------------------------------------------------------
package body MatrixOperations is 

procedure Output_Matrix (MA : Matrix) is
	begin
    	New_Line;
    	for I in Index loop
			for J in Index loop
    			Put(Item => MA(i)(j), Width => 5);
            end loop;
            New_line;
        end loop;
   	end Output_Matrix;

procedure Matrix_Matrix_Multiply
    (Left  : Matrix;
    Right  : Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    const: Integer;
    Result_Matrix: out Matrix) is
    begin
        for i in Start_Index..End_Index loop
            for J in Index loop
               Result_Matrix(I)(J) := 0;
               for K in Index loop
            Result_Matrix(I)(J) := Result_Matrix(I)(J) + Left(I)(K) * Right(K)(J);
            end loop;
            Result_Matrix(I)(J) := Result_Matrix(I)(J) * const;
        end loop;
    end loop;
end Matrix_Matrix_Multiply;

procedure Matrix_Matrix_Add
    (Left: Matrix;
    Right:  Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    const: Integer;
    Result_Matrix: out Matrix) is
    begin
        for I in Start_Index .. End_Index loop
            for J in Index loop
               Result_Matrix(I)(J) := Left(I)(J) + Right(I)(J)*const;
            end loop;
        end loop;
end Matrix_Matrix_Add;

function Min 
	(Vect: Vector;
    Start_Index: Integer;
    End_Index: Integer) return Integer is
    min: Integer;
	begin
        min := Vect(Start_Index);
        for I in Start_Index .. End_Index loop
            if min > Vect(I) then
               min := Vect(I);
            end if;
        end loop;
    return min;
end Min;

function Input_Vector return Vector is
	V: Vector;
   	begin
    	for I in Index loop
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
        for I in Index loop
            for J in Index loop
               Result_Matrix(I)(J) := 1;
            end loop;
        end loop;
	return Result_Matrix;
end Input_Matrix;

end MatrixOperations;