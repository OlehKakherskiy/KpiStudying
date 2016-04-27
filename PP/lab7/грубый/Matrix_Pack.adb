with Ada.Text_IO, Ada.Integer_Text_Io;
use  Ada.Text_IO, Ada.Integer_Text_Io;

package body Matrix_Pack is
   function getVector (d : in integer) return Vector is
      result : Vector;
   begin
      for i in 1 .. N loop
         result (i) := d;
      end loop;
      return result;
   end getVector;

   function getMatrix (d : in integer) return Matrix is
      result : Matrix;
   begin
      for i in 1 .. N loop
         for j in 1 .. N loop
            result (i) (j) := d; end loop;
      end loop;
      return result;
   end GetMatrix;
   ----------------------------------------
   procedure putVector (A : in Vector) is
   begin
      --	new_Line;
      for i in 1 .. N loop
            put (A (i) , 5);
      end loop;
      new_line;
   end PutVector;

   procedure putMatrix (MA : in matrix) is
   begin
      --	new_Line;
      for i in 1 .. N loop
         for j in 1 .. N loop
            put (MA (i) (j), 3);
         end loop;
         new_line;
      end loop;
      new_line;
   end PutMatrix;
   -----------------------------------------
   procedure mainCalc (Ah : out Vector_H; a : in integer; B : in Vector; MX : in Matrix; MZ : in Matrix_H; ME : in Matrix_H) is
   Mbuf : Matrix_H;
   begin
      Put_Line("MainCalc started");
      for j in 1 .. H loop
         for i in 1 .. N loop
            Mbuf (j) (i) := 0;
            for k in 1 .. N loop
               Mbuf (j) (i) :=  Mbuf (j) (i) + MX (k) (i) + MZ (j) (k);
            end loop;
            Mbuf (j) (i) :=  Mbuf (j) (i) - a * ME (j) (i);
         end loop;
      end loop;

      for j in 1 .. H loop
         Ah (j) := 0;
         for i in 1 .. N loop
            Ah (j) := Ah (j) + B (i) * Mbuf (j) (i);
         end loop;
      end loop;
   end MainCalc;
end Matrix_Pack;
