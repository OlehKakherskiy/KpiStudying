with Ada.Text_Io, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;

package body Matrix_Pack.IO is

   procedure Vector_Input (vec : out TVector) is
   begin
      for i in 1 .. N loop
         vec(i) := 1;
      end loop;
     -- Skip_Line;
   end Vector_Input;

--     procedure getValue(x: out integer) is
--     begin
--        Get(x);
--     exception
--        when Data_Error =>
--           Put_Line("Data input error! Insert element again.");
--           New_Line;
--           Skip_Line;
--           getValue(x);
--        when Constraint_Error =>
--           Put_Line("Constraint error! Insert element again.");
--           New_Line;
--           Skip_Line;
--           getValue(x);
--     end getValue;

   procedure Vector_Output (vec: in TVector) is
   begin
      for i in 1..N loop
         put(vec(i),4);
      end loop;
   new_line;
   end Vector_Output;

   procedure Matrix_Input (m: out TMatrix) is
   begin
      for i in 1..N loop
         Vector_Input(m(i));
      end loop;
   end Matrix_Input;

   procedure Matrix_Output (m: in TMatrix) is
   begin
      for i in 1..N loop
         Vector_Output(m(i));
         new_line;
      end loop;
   end Matrix_Output;
end Matrix_Pack.IO;
