generic package Matrix_Pack.IO is
   procedure Vector_Input (vec: out TVector);

   procedure Vector_Output (vec: in TVector);

   procedure Matrix_Input (m: out TMatrix);

   procedure Matrix_Output (m: in TMatrix);

private
  -- procedure getValue(x: out integer);
end Matrix_Pack.IO;
