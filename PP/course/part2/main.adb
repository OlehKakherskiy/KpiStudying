with Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time, MatrixOperations;
use Ada.Text_IO, Ada.Integer_Text_IO,Ada.Float_Text_IO, Ada.Synchronous_Task_Control, Ada.Real_Time;


------------------------------------------------------------------
--                                                              --
--          Програмування паралельних компьютерних систем       --
--           Курсова робота. ПРГ1. Ада. Захищені модулі         --
--                                                              --
--  Файл: parallelCalcs.ada                                     --
--  Завдання:                                                   --
--        MA = MB*(MC+MO)*a + min(Z)*MK		                   	--
--                               								--
--        								                    	--
--                                                              --
--  Автор: Кахерський Олег, група IП-31                         --
--  Дата: 12.03.2016                                            --
--                                                              --
------------------------------------------------------------------

procedure Main is
	n: Integer; 			--розмірність матриць та векторів
	p: Integer; 			--кількість задач
	h: Integer; 			--кількість рядків матриць та векторів на одну задачу
	StartTime: Time;		--початок обчислень
	DiffTime : Time_Span; 	--різниця між поточним часом(завершення обчислень) та початковим часом
	procedure Start is
		package MatrixOperationsN is new MatrixOperations(N);
		use MatrixOperationsN;
	    MA,MO,MC,MK: Matrix;
		Z: Vector;
		Task type ThreadTask(TaskNumber: Integer);
		protected ProtectedModule is
			entry waitInput; 					--бар'єр для синхронізації вводу даних
			entry waitMinZCalcFinish; 			--бар'єр для синхронізації обчислень min(Z)
			entry readyForOuptut; 				--очікування сигналу від T2-Tp задачею Т1
			function readAlpha return Integer; 	--захищене зчитування alpha
			function readMinZ return Integer; 	--захищене зчитування min(Z)
			function readMB return Matrix; 		--захищене зчитування readMB
			procedure inputFinishSignal;		--надсилання сигналу про завершення вводу даних
			procedure finishCalcsSignal;		--надсилання сигналу про завершення обчислень
			procedure finishMinZCalcSignal;		--надсилання сигналу про завершення обчислень min(z,zi)
			procedure setMinZ(b: Integer);		--встановлення значення minZ
			procedure initMB(Buff: Matrix);		--ініціалізація MB
			procedure initAlpha(const: Integer);--ініціалізація alpha
		private
			inputFlag: integer := 0;			--флаг для синхронізації вводу
			minZCalcFlag : integer := 0;		--флаг для синхронізації завершення обчислень min(Z)
			finCalcFlag : integer := 0;			--флаг для синхронізації завершення обчислень мат. виразу
			--спільні ресурси
			a, minZ: Integer;					
			MB : Matrix;
		end ProtectedModule;

		protected body ProtectedModule is

			--розблокування задач при inputFlag = 2 (завершення вводу даних в T1, Tp)
			entry waitInput when inputFlag = 2 is
			begin
				null;
			end waitInput;

			--розблокування задач при minZCalcFlag = p (завершення обчислення min(Z))
			entry waitMinZCalcFinish when minZCalcFlag = p is
			begin
				null;
			end waitMinZCalcFinish;

			--розблокування Т1 при завершенні обчислень в задачах T2..Tp
			entry readyForOuptut when finCalcFlag = p-1 is
			begin
				null;
			end readyForOuptut;

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

			procedure inputFinishSignal is
			begin
				inputFlag := inputFlag + 1;
			end inputFinishSignal;

			procedure finishCalcsSignal is
			begin
				finCalcFlag := finCalcFlag + 1;
			end finishCalcsSignal;

			procedure finishMinZCalcSignal is
			begin
				minZCalcFlag := minZCalcFlag + 1;
			end finishMinZCalcSignal;
			
			procedure setMinZ(b: in Integer) is
			begin
				minZ := b;
			end setMinZ;

			procedure initAlpha(const: Integer) is
			begin
				a := const;
			end initAlpha;

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
	   	
		procedure calcMatrixEquation(a,zi,startIndex,endIndex : Integer; MB: Matrix) is
			Buf1: Matrix;
		begin
			Matrix_Matrix_Add(MC,MO,startIndex,endIndex,1,Buf1); 			--Buf1_h = MOh+MCh
			Matrix_Matrix_Multiply(Buf1, MB, startIndex, endIndex, a, MA); 	--MA_h = Buf1_h*MB
			Matrix_Matrix_Add(MA,MK,startIndex,endIndex,zi,MA);
		end calcMatrixEquation;

		task body ThreadTask is
			tid: Integer := TaskNumber;
			ai, zi, startIndex, endIndex: Integer;
			MBi : Matrix;
		begin
			Put_Line("Task " & Integer'Image(tid) & " started");
			New_line;
			startIndex := h*(tid - 1) + 1;
			endIndex := h*tid;
			if tid = 1 then
				Put_Line("Task "& Integer'Image(tid) & " is initing data");
				New_line;
				Put_Line("Task "& Integer'Image(tid) & " inited MB");
				New_line;
				ProtectedModule.initMB(Input_Matrix);
				Put_Line("Task "& Integer'Image(tid) & " inited MO");
				New_line;
				MO := Input_Matrix;
				Put_Line("Task "& Integer'Image(tid) & " inited A");
				New_line;
				ProtectedModule.initAlpha(Input_Constant);
				--сигнал задачам о завершении ввода
				Put_Line("Task "& Integer'Image(tid) & " finished input and send Signal to All");
				New_line;
				ProtectedModule.inputFinishSignal;
			end if;
			if tid = p then
				endIndex := n; --TODO:!!!!
				Put_Line("Task "& Integer'Image(tid) & " is initing data");
				New_line;
				Put_Line("Task "& Integer'Image(tid) & " inited MC");
				New_line;
				MC := Input_Matrix;
				Put_Line("Task "& Integer'Image(tid) & " inited MK");
				New_line;
				MK := Input_Matrix;
				Put_Line("Task "& Integer'Image(tid) & " inited Z");
				New_line;
				Z := Input_Vector;
				ProtectedModule.setMinZ(100000000);
				Put_Line("Task "& Integer'Image(tid) & " finished input and send Signal to All");
				New_line;
				ProtectedModule.inputFinishSignal;
			else
				Put_Line("Task "& Integer'Image(tid) & " waits for inputting data in T1, Tp");
				New_line;
			end if;
			ProtectedModule.waitInput;
			zi := Min(Z,startIndex, endIndex); 
			Put_Line("Task "& Integer'Image(tid) & " finished calcs minZ and sent signal of finishing");
			compareWithMinZ(zi);
			Put_Line("Task "& Integer'Image(tid) & " is copying shared resources");
			New_line;
			--копіювання СР
			ai := ProtectedModule.readAlpha;
			zi := ProtectedModule.readMinZ;
			MBi := ProtectedModule.readMB;
			Put_Line("Task "& Integer'Image(tid) & " is calculating matrix equation");
			New_line;
			calcMatrixEquation(ai,zi,startIndex,endIndex,MBi);
			if tid = 1 then
				Put_Line("Task "& Integer'Image(tid) & " is waiting for signal from all(finishing calc matrix equation)");
				New_line;
				ProtectedModule.readyForOuptut;
				DiffTime := Clock - StartTime;
				Put_Line("Calculating time = ");
				Put(Float(To_Duration(DiffTime)));
				New_line;
				if n <= 8 then
					Put_Line("Result:");
					New_line;
					Output_Matrix(MA);
				end if;
				Get(H);
			else
				Put_Line("Task "& Integer'Image(tid) & " is sending signal to T1 (finishing calc matrix equation)");
				New_line;
				ProtectedModule.finishCalcsSignal;
			end if;
			Put_Line("Task " & Integer'Image(tid) & " finished");
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