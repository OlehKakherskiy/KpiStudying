------------------------------------------------------------------
--  File: MatrixOperations.adb                                  --
--  Author: Kakherskyi Oleh, group IP-31                        --
--  Date: 12.09.2015                                            --
------------------------------------------------------------------
with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body MatrixOperations is

   function Input_Vector return DynamicVector is
      V: DynamicVector(1..N);
         begin
         for I in V'Range loop
            V(I) := 1;
         end loop;
      return V;
   end Input_Vector;

   function Input_Constant return Integer is
      begin
       return 1;
   end Input_Constant;

   function Input_Matrix return DynamicMatrix is
      Result_Matrix: DynamicMatrix(1 .. N);
       begin
           for I in Result_Matrix'Range loop
               for J in 1..N loop
                  Result_Matrix(I)(J) := 1;
               end loop;
           end loop;
      return Result_Matrix;
   end Input_Matrix;

   -------------------
   -- Output_Vector --
   -------------------

   procedure Output_Vector (V : in DynamicVector) is
      begin
         New_Line;
         for I in V'Range loop
            Put(Item => V(I), Width => 5);
         end loop;
         New_Line;
      end Output_Vector;


   procedure Matrix_Matrix_Multiply
      (Left  : in DynamicMatrix;
      Right : in DynamicMatrix;
      Result_Matrix: out DynamicMatrix) is
      begin
         for i in Left'Range loop
            for J in 1..N loop
               Result_Matrix(I)(J) := 0;
               for K in Right'Range loop
               Result_Matrix(I)(J) := Result_Matrix(I)(J) + Left(I)(K) * Right(K)(J);
            end loop;
         end loop;
      end loop;
   end Matrix_Matrix_Multiply;


   procedure Vector_Matrix_Multiply
     (Left  : in DynamicVector;
      Right : in DynamicMatrix;
      Result_Vector: out DynamicVector) is
      begin
         for J in Result_Vector'Range loop
            Result_Vector(j) := 0;
            begin
               for K in 1..N loop
                  Result_Vector(J) := Result_Vector(J) + Left(K) * Right(J)(K);
               end loop;
            end;
         end loop;
      end Vector_Matrix_Multiply;

      procedure addVectors(Left: DynamicVector; Right: DynamicVector; Result_Vector: out DynamicVector; d : Integer) is
      begin
         for J in Right'Range loop
            Result_Vector(J) := d * Left(J) + Right(J);
         end loop;
      end addVectors;

      procedure Vector_Vector_Add(Left: DynamicVector; Right: DynamicVector; Result_Vector: out DynamicVector; d,startIndex,EndIndex : Integer) is
      begin
         for J in startIndex..EndIndex loop
            Result_Vector(J) := d * Left(J) + Right(J);
         end loop;
      end Vector_Vector_Add;

end MatrixOperations;