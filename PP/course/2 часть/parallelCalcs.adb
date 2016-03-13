with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;


------------------------------------------------------------------
--                                                              --
--              Паралельні і розподілені обчислення             --
--                      Лабораторна робота №2.                  --
--                                                              --
--  Файл: lab1.ada                                              --
--  Завдання:                                                   --
--        А = B*(MO*MZ)+a*C 				                   	--
--                               								--
--        								                    	--
--                                                              --
--  Автор: Кахерський Олег, група IП-31                         --
--  Дата: 02.03.2015                                            --
--                                                              --
------------------------------------------------------------------

procedure Main is
	n: Integer := 8;
	p: Integer := 4;
	h: Integer;
	task type ThreadTask(TaskNumber: Integer);
	subtype Index is Integer range 1..n;
    type Vector is array (Index) of Integer;
    type Matrix is array (Index) of Vector;

    MA,MO,MC,MK: Matrix;
	Z: Vector;
	protected ProtectedModule is
		entry Wait_Input;
		entry Wait_All_T1; --все ждут Т1
		entry Wait_T1_All; --Т1 ждет всех
		entry Wait_Calcs_Finish;
		function readAlpha return Integer;
		function readMinZ return Integer;
		function readMB return Matrix;
		procedure sendInputSignal;
		procedure sendFinishCalcsSignal;
		procedure sendSignall_All_T1;
		procedure sendSignall_T1_All;
		procedure setMinZ(b: Integer);
		procedure initMB(Buff: Matrix);
		procedure initA(const: Integer);
	private
		Input_Flag: integer := 0;
		Wait_All_Flag : integer := 0;
		Wait_T1_Flag : integer := 0;
		Finish_Flag : integer := 0;
		a, minZ: Integer;
		MB : Matrix;
	end ProtectedModule;

	protected body ProtectedModule is

		entry Wait_Input when Input_Flag = 2 is
		begin
			null;
		end Wait_Input;

		entry Wait_All_T1 when Wait_T1_Flag = 1 is
		begin
			null;
		end Wait_All_T1;

		entry Wait_T1_All when Wait_All_Flag = p-1 is
		begin
			null;
		end Wait_T1_All;

		entry Wait_Calcs_Finish when Finish_Flag = p-1 is
		begin
			null;
		end Wait_Calcs_Finish;

		function readAlpha return Integer is
		begin
			return a;
		end readAlpha;

		function readMinZ return Integer is
		begin
			return minZ;
		end readMinZ;

		function readMB return Matrix is
		begin
			return MB;
		end readMB;

		procedure sendInputSignal is
		begin
			Input_Flag := Input_Flag + 1;
		end sendInputSignal;

		procedure sendSignall_T1_All is
		begin
			Wait_T1_Flag := 1;
		end sendSignall_T1_All;

		procedure sendSignall_All_T1 is
		begin
			Wait_All_Flag := Wait_All_Flag + 1;
		end sendSignall_All_T1;

		procedure sendFinishCalcsSignal is
		begin
			Finish_Flag := Finish_Flag + 1;
		end sendFinishCalcsSignal;

		procedure setMinZ(b: in Integer) is
		begin
			minZ := b;
		end setMinZ;

		procedure initA(const: Integer) is
		begin
			a := const;
		end initA;

		procedure initMB(Buff: Matrix) is
		begin
			MB := Buff;
		end initMB;

	end ProtectedModule;

   -------------------
   -- Output_Matrix --
   -------------------
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

	procedure Constant_Matrix_Multiply
      (Const  : Integer;				     
       Right : in out Matrix;
       Start_Index: Integer;
       End_Index: Integer) is
   	begin
    	for I in Start_Index..End_Index loop
    		for J in Index loop
    			Right(I)(J) := Right(I)(J) * Const;
    		end loop;
      	end loop;
   	end Constant_Matrix_Multiply;

	procedure Matrix_Matrix_Multiply
      (Left  : Matrix;
      Right  : Matrix;
      Start_Index: Integer;
      End_Index: Integer;
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

   	procedure Matrix_Matrix_Add
      (Left: Matrix;
      Right:  Matrix;
      Start_Index: Integer;
      End_Index: Integer;
      Result_Matrix: out Matrix) is
    begin
        for I in Start_Index .. End_Index loop
            for J in Index loop
               Result_Matrix(I)(J) := Left(I)(J) + Right(I)(J);
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
   ------------------
   -- Input_Matrix --
   ------------------
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


   	procedure compareWithMinZ(const:Integer) is
   	begin
   		Put_Line("Task is ready for calc minZ");
   		New_line;
   		if ProtectedModule.readMinZ >= const then
   			Put_Line("Task is changing minZ");
   			New_line;
   			ProtectedModule.setMinZ(const);
   		end if;
   	end compareWithMinZ;
	procedure calcMatrixEquation(a,z,startIndex,endIndex : Integer; MB: Matrix) is
		Buf1: Matrix;
	begin
		Matrix_Matrix_Add(MC,MO,startIndex,endIndex,Buf1); --Buf1_h = MOh+MCh
		Matrix_Matrix_Multiply(Buf1, MB, startIndex, endIndex, MA); --MA_h = Buf1_h*MB
		Constant_Matrix_Multiply(a,MA,startIndex,endIndex); -- MA_h = MA_h*a
		Constant_Matrix_Multiply(z,MK,startIndex,endIndex);
		Matrix_Matrix_Add(MA,MK,startIndex,endIndex,MA);
	end calcMatrixEquation;

	task body ThreadTask is
		i: Integer := TaskNumber;
		ai, zi, startIndex, endIndex: Integer;
		MBi : Matrix;
	begin
		Put_Line("Task " & Integer'Image(i) & " started");
		New_line;
		startIndex := h*(i - 1) + 1;--тут ошибка мб
		endIndex := h*i;
		if i = 1 then
			Put_Line("Task "& Integer'Image(i) & " is initing data");
			New_line;
			Put_Line("Task "& Integer'Image(i) & " inited MB");
			New_line;
			ProtectedModule.initMB(Input_Matrix);
			Put_Line("Task "& Integer'Image(i) & " inited MO");
			New_line;
			MO := Input_Matrix;
			Put_Line("Task "& Integer'Image(i) & " inited A");
			New_line;
			ProtectedModule.initA(Input_Constant);
			--сигнал задачам о завершении ввода
			Put_Line("Task "& Integer'Image(i) & " finished input and send Signal to All");
			New_line;
			ProtectedModule.sendInputSignal;
		end if;
		if i = p then
			Put_Line("Task "& Integer'Image(i) & " is initing data");
			New_line;
			Put_Line("Task "& Integer'Image(i) & " inited MC");
			New_line;
			MC := Input_Matrix;
			Put_Line("Task "& Integer'Image(i) & " inited MK");
			New_line;
			MK := Input_Matrix;
			Put_Line("Task "& Integer'Image(i) & " inited Z");
			New_line;
			Z := Input_Vector;
			ProtectedModule.setMinZ(Z(1));
			--сигнал задачам о завершении ввода
			Put_Line("Task "& Integer'Image(i) & " finished input and send Signal to All");
			New_line;
			ProtectedModule.sendInputSignal;
		else
			--ожидание сигналов с T1, Tp
			Put_Line("Task "& Integer'Image(i) & " waits for inputting data in T1, Tp");
			New_line;
			ProtectedModule.Wait_Input;
		end if;
		zi := Min(Z,startIndex, endIndex); 
		if i = 1 then
			-- Т1.4
			Put_Line("Task "& Integer'Image(i) & " waits for calcs minZ in all taks");
			New_line;
			ProtectedModule.Wait_T1_All;
			-- T1.5
			compareWithMinZ(zi);
			-- T1.6
			Put_Line("Task "& Integer'Image(i) & " finished calcs minZ and send signal to all tasks");
			New_line;
			ProtectedModule.sendSignall_T1_All;
		else
			-- T2_p.5
			compareWithMinZ(zi);
			-- T2_p.6
			Put_Line("Task "& Integer'Image(i) & " finished calcs minZ and send signal to T1");
			New_line;
			ProtectedModule.sendSignall_All_T1;
			-- T2_p.7
			Put_Line("Task "& Integer'Image(i) & " is waiting for signal from T1(finishing calcs minZ)");
			New_line;
			ProtectedModule.Wait_All_T1;
		end if;
		Put_Line("Task "& Integer'Image(i) & " is copying shared resources");
		New_line;
		--копирование общих ресурсов
		ai := ProtectedModule.readAlpha;
		zi := ProtectedModule.readMinZ;
		MBi := ProtectedModule.readMB;
		Put_Line("Task "& Integer'Image(i) & " is calculating matrix equation");
		New_line;
		calcMatrixEquation(ai,zi,startIndex,endIndex,MBi);
		if i = 1 then
			--T1.9
			Put_Line("Task "& Integer'Image(i) & " is waiting for signal from all(finishing calc matrix equation)");
			New_line;
			ProtectedModule.Wait_Calcs_Finish;
			--T1.10
			if n <= 8 then
				Put_Line("Task "& Integer'Image(i) & " is outputting MA");
				New_line;
				Output_Matrix(MA);
			end if;
		else
			-- сигнал Т1
			Put_Line("Task "& Integer'Image(i) & " is sending signal to T1 (finishing calc matrix equation)");
			New_line;
			ProtectedModule.sendFinishCalcsSignal;
		end if;
		Put_Line("Task " & Integer'Image(i) & " finished");
		New_line;
	end ThreadTask;

	procedure Start is
		type ThreadTaskPointer is access ThreadTask;
		type TaskArray is array (1 .. p) of ThreadTaskPointer;
		tArray: TaskArray;
	begin	
		for I in 1 .. p loop
			tArray(I) := new ThreadTask(I);
		end loop;
	end Start;

begin
	Put("Program started");
	New_line;
	--Put("Input N");
	--Get(n);
	--Put("Input P");
	--Get(p);
	h := n/p;
	Start;
end Main;