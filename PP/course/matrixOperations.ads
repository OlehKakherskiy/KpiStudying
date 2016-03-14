generic
	N: in Integer;
package MatrixOperations is

	type Vector is private;
	type Matrix is private;

	-------------------
	-- Output_Matrix --
	-------------------
	procedure Output_Matrix (MA : Matrix);

	procedure Constant_Matrix_Multiply
    (Const  : Integer;     
    Right : in out Matrix;
    Start_Index: Integer;
    End_Index: Integer);

    procedure Matrix_Matrix_Multiply
    (Left  : Matrix;
    Right  : Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    Result_Matrix: out Matrix);

    procedure Matrix_Matrix_Add
    (Left: Matrix;
    Right:  Matrix;
    Start_Index: Integer;
    End_Index: Integer;
    Result_Matrix: out Matrix);

    function Min 
	(Vect: Vector;
    Start_Index: Integer;
    End_Index: Integer) return Integer;

    function Input_Vector return Vector;

    function Input_Constant return Integer;

    ------------------
	-- Input_Matrix --
	------------------
	function Input_Matrix return Matrix;

	private
    	subtype Index is Integer range 1..N;
      	type Vector is array (Index) of Integer;
      	type Matrix is array (Index) of Vector;
end MatrixOperations;
