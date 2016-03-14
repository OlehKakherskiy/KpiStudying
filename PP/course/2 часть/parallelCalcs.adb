with Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time, MatrixOperations;
use Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time;

procedure Main is
	n: Integer;
	p: Integer;
	h: Integer;
	StartTime: Time;
	DiffTime : Time_Span;
	procedure Start is
		package MatrixOperationsN is new MatrixOperations(N);
		use MatrixOperationsN;
	    MA,MO,MC,MK: Matrix;
		Z: Vector;
		task type ThreadTask(TaskNumber: Integer);
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
				ProtectedModule.setMinZ(100000000);
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
				DiffTime := Clock - StartTime;
				Put_Line("Calculating time = ");
				Put(Float(To_Duration(DiffTime)));
				New_line;
				--T1.10
				if n <= 8 then
					Put_Line("Result:");
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
	Put("Input N");
	New_line;
	Get(n);
	Put("Input P");
	New_line;
	Get(p);
	StartTime := Clock;
	h := n/p;
	Start;
end Main;