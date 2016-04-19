with Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time, MatrixOperations;
use Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time;


------------------------------------------------------------------
--                                                              --
--          Програмування паралельних компьютерних систем       --
--          Лаб 5. Ада. Захищені модулі					        --
--                                                              --
--  Файл: main.abd			                                    --
--  Завдання:                                                   --
--                               								--
--        								                    	--
--                                                              --
--  Автор: Кахерський Олег, група IП-31                         --
--  Дата: 07.04.2016                                            --
--                                                              --
------------------------------------------------------------------

procedure Main is
	n: Integer; 			--розмірність матриць та векторів
	p: Integer; 			--кількість задач
	h: Integer; 			--кількість рядків матриць та векторів на одну задачу
	procedure Start is
		package MatrixOperationsN is new MatrixOperations(N);
		use MatrixOperationsN;
	   	MO : Matrix;
	   	A, B, C, Z : Vector;

		task type ThreadTask(tID: Integer);
		protected ProtectedModule is
			entry waitInput; 					--бар'єр для синхронізації вводу даних
			entry waitScalarMultFin;			--очікування підсумовування скалярних добутків підвекторів
			entry readyForOuptut; 				--очікування сигналу від T2-Tp задачею Т1

			function readE return Integer;
			function readD return Integer;
			function read_a return Integer;
			function readR return Vector;
			function readMK return Matrix;

			procedure inputFinishSignal;		--надсилання сигналу про завершення вводу даних
			procedure finishCalcsSignal;		--надсилання сигналу про завершення обчислень
			procedure finishScalarMultCalcs;    --надсилання сигналу про завершення обчислення скалярного добутку векторів
			procedure addToScalarMultResult(b: Integer);
			procedure init_e(b: Integer);
			procedure init_d(b: Integer);
			procedure initR(Buff: Vector);
			procedure initMK(Buff: Matrix);
			procedure outputLine(message: String);
		private
			inputFlag : Integer := 0;
			finishFlag : Integer := 0;
			scalarResultFlag : Integer := 0;

			e, x, d : Integer;
			R : Vector;
			MK : Matrix;
		end ProtectedModule;

		protected body ProtectedModule is

			--розблокування задач при inputFlag = 4 (завершення вводу даних в T1..4)
			entry waitInput when inputFlag = 4 is
			begin
				null;
			end waitInput;

			entry waitScalarMultFin when scalarResultFlag = p is
			begin
				null;
			end waitScalarMultFin;

			--розблокування Т2 при завершенні обчислень в задачах T1..Tp
			entry readyForOuptut when finishFlag = p-1 is
			begin
				null;
			end readyForOuptut;

			function readE return Integer is
			begin
				return e;
			end readE;

			function readD return Integer is
			begin
				return d;
			end readD;

			function read_A return Integer is
			begin
				return x;
			end read_A;

			function readR return Vector is
			begin
				return R;
			end readR;

			function readMK return Matrix is
			begin
				return MK;
			end readMK;

			procedure inputFinishSignal is   	--надсилання сигналу про завершення вводу даних
			begin
				inputFlag := inputFlag + 1;
			end inputFinishSignal;

			procedure finishCalcsSignal is		--надсилання сигналу про завершення обчислень
			begin
				finishFlag := finishFlag + 1;
			end finishCalcsSignal;

			procedure finishScalarMultCalcs is
			begin
				scalarResultFlag := scalarResultFlag + 1;
			end finishScalarMultCalcs;

			procedure addToScalarMultResult(b: Integer) is
			begin
				x := x + b;
			end addToScalarMultResult;

			procedure init_e(b: Integer) is
			begin
				e := b;
			end init_e;

			procedure init_d(b: Integer) is
			begin
				d := b;
			end init_d;

			procedure initR(Buff: Vector) is
			begin
				R := Buff;
			end initR;

			procedure initMK(Buff: Matrix) is
			begin
				MK := Buff;
			end initMK;

			procedure outputLine(message: String) is
			begin
				Put_Line(message);
				New_line;
			end outputLine;
		end ProtectedModule;

		procedure calcMatrixEquation(ai,ei,di,startIndex,endIndex : Integer; Ri:Vector; MKi: Matrix) is
			Buf1: Matrix;
			Vect_Buf: Vector;
		begin
			Matrix_Matrix_Multiply(MO,MKi,startIndex,endIndex,Buf1); 			--Buf1_h = MOh+MK
			Vector_Matrix_Multiply(Ri,Buf1,Vect_Buf,startIndex,endIndex);
			Vector_Vector_Add(Z,Vect_Buf,A,ei,ai*di,startIndex,endIndex);
		end calcMatrixEquation;

		task body ThreadTask is
			i: Integer := tID;
			xi, ei, di, startIndex, endIndex: Integer;
			MKi : Matrix;
			Ri: Vector;
		begin
			ProtectedModule.outputLine("Task " & Integer'Image(i) & " started");
			startIndex := h*(i - 1) + 1;
			if i = p then
				endIndex := N;
			else 
				endIndex := h*i;
			end if;

			if i = 1 then
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " is inputting data");
				
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inputted MK");
				ProtectedModule.initMK(Input_Matrix);

				--сигнал задачам о завершении ввода
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " finished input and send Signal to All");
				ProtectedModule.inputFinishSignal;

			elsif i = 2 then
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " is initing data");
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited Z");
				Z := Input_Vector;

				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited e");
				ProtectedModule.init_e(Input_Constant);

				--сигнал задачам о завершении ввода
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " finished input and send Signal to All");
				ProtectedModule.inputFinishSignal;

			elsif i = 3 then
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited B");
				B := Input_Vector;
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited R");
				ProtectedModule.initR(Input_Vector);

				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited d");
				ProtectedModule.init_d(Input_Constant);

				--сигнал задачам о завершении ввода
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " finished input and send Signal to All");
				ProtectedModule.inputFinishSignal;

			elsif i = 4 then

				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited C");
				C := Input_Vector;

				ProtectedModule.outputLine("Task "& Integer'Image(i) & " inited MO");
				MO := Input_Matrix;

				--сигнал задачам о завершении ввода
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " finished input and send Signal to All");
				ProtectedModule.inputFinishSignal;

			else
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " waits for inputting data in T1, Tp");
			end if;

			--синхронізація по вводу
			ProtectedModule.waitInput; 

			--обчислення скалярного добутку
			ProtectedModule.addToScalarMultResult(Scalar_Multiply(B, C, startIndex, endIndex));

			--синхронізація по завершенню обчислення скалярного добутку
			ProtectedModule.finishScalarMultCalcs;
			ProtectedModule.waitScalarMultFin;

			--копіювання СР
			ProtectedModule.outputLine("Task "& Integer'Image(i) & " is copying shared resources");
			ei := ProtectedModule.readE;
			di := ProtectedModule.readD;
			Ri := ProtectedModule.readR;
			xi := ProtectedModule.read_a;
			MKi := ProtectedModule.readMK;

			ProtectedModule.outputLine("Task "& Integer'Image(i) & " is calculating matrix equation");
			
			calcMatrixEquation(xi, ei, di, startIndex, endIndex, Ri, MKi);

			if i = 2 then
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " is waiting for signal from all(finishing calc matrix equation)");
				ProtectedModule.readyForOuptut;
				if n <= 8 then
					Put_Line("Result:");
					New_line;
					Output_Vector(A);
				end if;
				Get(H);
			else
				ProtectedModule.outputLine("Task "& Integer'Image(i) & " is sending signal to T2 (finishing calc matrix equation)");
				ProtectedModule.finishCalcsSignal;
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
	h := n/p;
	Start;
end Main;