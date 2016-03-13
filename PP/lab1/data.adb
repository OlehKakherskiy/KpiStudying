------------------------------------------------------------------
--  File: data.adb                                              --
--  Author: Kakherskyi Oleh, group IP-31                        --
--  Date: 12.09.2015                                            --
------------------------------------------------------------------
with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body Data is

   ------------------
   -- Input_Vector --
   ------------------

   procedure Input_Vector (V : out Vector) is
   begin
      for I in Index loop
         V(I) := 1;
      end loop;
   end Input_Vector;

   procedure Input_Constant(A: out Integer) is
   begin
      A := 1;
   end Input_Constant;
   ------------------
   -- Input_Matrix --
   ------------------

   procedure Input_Matrix (MA : out Matrix) is
      begin
         for I in Index loop
            for J in Index loop
               MA(I)(J) := 1;
            end loop;
         end loop;
      end Input_Matrix;

   -------------------
   -- Output_Vector --
   -------------------

   procedure Output_Vector (V : in Vector) is
      begin
         New_Line;
         for I in Index loop
            Put(Item => V(I), Width => 5);
         end loop;
         New_Line;
      end Output_Vector;

   -------------------
   -- Output_Matrix --
   -------------------

   procedure Output_Matrix (MA : in Matrix) is
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
      (Left  : in Matrix;
      Right : in Matrix;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Matrix: out Matrix) is
      begin
         for i in Start_Index..End_Index loop
            for J in Index loop
               Result_Matrix(I)(J) := 0;
               for K in Index loop
               Result_Matrix(I)(J) := Result_Matrix(I)(J) + Left(I)(K) * Right(K)(J);
            end loop;
         end loop;
      end loop;
   end Matrix_Matrix_Multiply;


   procedure Vector_Matrix_Multiply
     (Left  : in Vector;
      Right : in Matrix;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Vector: out Vector) is
      begin
         for J in Start_Index..End_Index loop
            Result_Vector(j) := 0;
            begin
               for K in Index loop
                  Result_Vector(J) := Result_Vector(J) + Left(K) * Right(J)(K);
               end loop;
            end;
         end loop;
      end Vector_Matrix_Multiply;

   procedure Vector_Vector_Add
     (Left  : in Vector;
      Right : in Vector;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Vector: out Vector) is
   begin
      for J in Start_Index..End_Index loop
         Result_Vector (J) :=  Left (J) + Right (J);
      end loop;
   end Vector_Vector_Add;

   procedure Constant_Vector_Multiply
      (Left  : in Integer;				     
       Right : in Vector;
       Start_Index: in Integer;
       End_Index: in Integer;
       Result_Vector: out Vector) is
   begin
      for I in Start_Index..End_Index loop
         Result_Vector (I) := Left * Right (I);
      end loop;
   end Constant_Vector_Multiply;

end Data;
