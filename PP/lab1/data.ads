------------------------------------------------------------------
--  File: data.ads                                              --
--                                                              --
--  Author: Oleh Kakherskyi, group IP-31                        --
--  Date: 12.09.2015                                            --
------------------------------------------------------------------

generic
    N: in Natural; -- dimension of Vector and Matrix(N * N)
package Data is

    type Vector is private;
    type Matrix is private;

    procedure Input_Vector(V : out Vector);

   ------------------
   -- Input_Matrix --
   ------------------
    procedure Input_Matrix(MA : out Matrix);

   -------------------
   -- Input_Constant--
   -------------------
    procedure Input_Constant(A: out Integer);

   -------------------
   -- Output_Vector --
   -------------------
    procedure Output_Vector(V : in Vector);

   -------------------
   -- Output_Matrix --
   -------------------
    procedure Output_Matrix(MA : in Matrix);

    procedure Matrix_Matrix_Multiply
      (Left  : in Matrix;
      Right : in Matrix;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Matrix: out Matrix);

    procedure Vector_Matrix_Multiply
     (Left  : in Vector;
      Right : in Matrix;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Vector: out Vector);

    procedure Vector_Vector_Add
     (Left  : in Vector;
      Right : in Vector;
      Start_Index: in Integer;
      End_Index: in Integer;
      Result_Vector: out Vector);

    procedure Constant_Vector_Multiply
      (Left  : in Integer;
       Right : in Vector;
       Start_Index: in Integer;
       End_Index: in Integer;
       Result_Vector: out Vector);
      
    private
      subtype Index is Integer range 1..N;
      type Vector is array (Index) of Integer;
      type Matrix is array (Index) of Vector;

end Data;