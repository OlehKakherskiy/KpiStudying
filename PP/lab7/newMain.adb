with Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control, MatrixOperations;
use Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control;

procedure lab7 is

	n: Integer; 			--розмірність матриць та векторів
	p: Integer := 9; 		--кількість задач
	h: Integer;

	procedure Start is		

		package MatrixOperationsN is new MatrixOperations(N);
		use MatrixOperationsN;

		procedure calcMatrixEquation(d,startIndex,endIndex: Integer; 
			Bh:DynamicVector; C:DynamicVector; Res: out DynamicVector; MO:DynamicMatrix; MKh:DynamicMatrix) is
			MatrixBuffer : DynamicMatrix(MKh'Range);
			VectorBuffer : DynamicVector(Bh'Range);
		begin
			Matrix_Matrix_Multiply(MKh,MO,MatrixBuffer);
			Vector_Matrix_Multiply(C,MatrixBuffer,VectorBuffer);
			Vector_Vector_Add(Bh,VectorBuffer,Res,d,startIndex,endIndex);
		end calcMatrixEquation;
		Task T1 is
			entry receiveDataFrom4(Bh,C:DynamicVector; MKh : DynamicMatrix);
			entry receiveA(Ah:DynamicVector);
		end T1;

		Task T7 is
			entry receiveDataFrom4(d: Integer; MO : DynamicMatrix);
			entry receiveA(Ah:DynamicVector);
		end T7;

		Task T2 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
			entry receiveA(Ah:DynamicVector);
		end T2;

		Task T5 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
			entry receiveA(Ah:DynamicVector);
		end T5;

		Task T8 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
			entry receiveA(Ah:DynamicVector);
		end T8;

		Task T3 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
		end T3;

		Task T6 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
		end T6;

		Task T9 is
			entry receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer);
		end T9;

		Task T4 is
			entry receiveDataFrom7(Bh,C:DynamicVector; MKh : DynamicMatrix);
			entry receiveA(Ah:DynamicVector);
			entry receiveDataFrom1(d:Integer; MO:DynamicMatrix);
		end T4;

		Task body T1 is
			MO: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(1..3*H);
			d:Integer;
			Bhi:DynamicVector(1..3*H);
			Ci,Ahi:DynamicVector(1..N);
		begin
			Put_Line("Task 1 started");
			d  := Input_Constant;
			MO := Input_Matrix;

			Put_Line("T1 sended own data to T4");
			T4.receiveDataFrom1(d, MO);

			accept receiveDataFrom4(Bh,C:DynamicVector; MKh : DynamicMatrix) do
			Put_Line("T1 received data from T4");
				Ci := C;
				Bhi := Bh;
				MKhi := MKh;
			end receiveDataFrom4;

			Put_Line("T1 sended full data to T2");
			T2.receiveFullData(Bhi(H+1..3*H),Ci,MO,MKhi(H+1..3*H), d);

			Put_Line("T1 is calculating matrixEquation");
			calcMatrixEquation(d,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MO,MKhi);
			Put_Line("T1 is finished calculating matrixEquation");

			
			accept receiveA(Ah:DynamicVector) do
			Put_Line("T1 received one part of result");
				Ahi(Ah'Range) := Ah(Ah'Range);
			end receiveA;

			accept receiveA(Ah:DynamicVector) do
			Put_Line("T1 received one part of result");
				Ahi(Ah'Range) := Ah(Ah'Range);
			end receiveA;

			if N <= 18 then
				Output_Vector(Ahi);
			end if;
			Put_Line("Task 1 finished");
		end T1;

		Task body T7 is
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(1..N);
			di:Integer;
			Bhi,Ci:DynamicVector(1..N);
			Ahi:DynamicVector(6*H+1..N);
		begin
			Put_Line("T7 started");
			Bhi := Input_Vector;
			Ci := Input_Vector;
			MKhi := Input_Matrix;

			Put_Line("T7 sends own data to T4");
			T4.receiveDataFrom7(Bhi(1..6*H),Ci,MKhi(1..6*H));

			Put_Line("T7 is waiting data from T4");
			accept receiveDataFrom4(d: Integer; MO : DynamicMatrix) do
			Put_Line("T7 received data from T4");
				di := d;
				MOi := MO;
			end receiveDataFrom4;

			Put_Line("T7 sends full data to T8");
			T8.receiveFullData(Bhi(7*H+1..N),Ci,MOi,MKhi(7*H+1..N),di);

			Put_Line("T7 is calculating matrixEquation");
			calcMatrixEquation(di,Ahi'First,Ahi'Last,Bhi,Ci,Ahi,MOi,MKhi);
			Put_Line("T7 is finished calculating matrixEquation");

			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
				Put_Line("T7 received result data (1)");
			end receiveA;

			Put_Line("Task 7 sends result data to T4");
			T4.receiveA(Ahi);
			Put_Line("Task 7 finished");
		end T7;

		Task body T4 is
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(1..6*H);
			di:Integer;
			Bhi:DynamicVector(1..6*H);
			Ahi:DynamicVector(3*H+1..N);
			Ci:DynamicVector(1..N);
		begin
			Put_Line("Task 4 started");
			Put_Line("T4 is waiting data from T1");
			accept receiveDataFrom1(d:Integer; MO:DynamicMatrix) do
			Put_Line("T4 received data from T1");
				di := d;
				MOi := MO;
			end receiveDataFrom1;

			Put_Line("T4 is waiting data from T7");
			accept receiveDataFrom7(Bh,C:DynamicVector; MKh : DynamicMatrix) do
			Put_Line("T4 received data from T7");
				Bhi:=Bh;
				Ci:=C;
				MKhi:=MKh;
			Put_Line("T4 finished receiving data from T7");
			end receiveDataFrom7;

			Put_Line("T4 send data of T1 to T7");
			T7.receiveDataFrom4(di,MOi);

			Put_Line("T4 starts sending data of T7 to T1");
			T1.receiveDataFrom4(Bhi(1..3*H),Ci, MKhi(1..3*H));
			Put_Line("T4 finished sending data of T7 to T1");

			Put_Line("T4 send full data to T5");
			T5.receiveFullData(Bhi(4*H+1..6*H),Ci,MOi, MKhi(4*H+1..6*H),di);

			calcMatrixEquation(di,3*H+1,4*H,Bhi,Ci,Ahi,MOi,MKhi);

			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
				Put_Line("T4 received result data (1)");
			end receiveA;

			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
				Put_Line("T4 received result data (2)");
			end receiveA;

			Put_Line("T4 sends result data to T1");
			T1.receiveA(Ahi);
			Put_Line("Task 4 finished");
		end T4;

		task body T2 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(H+1..3*H);
			di:Integer;
			Bhi:DynamicVector(H+1..3*H);
			Ahi:DynamicVector(H+1..3*H);
			Ci:DynamicVector(1..N);
		begin
			Put_Line("Task 2 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
				Put_Line("Task 2 received full data from T1");
			end receiveFullData;

			Put_Line("Task 2 sends full data to T3");
			T3.receiveFullData(Bhi(2*H+1..3*H),Ci,MOi,MKhi(2*H+1..3*H),di);

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);
			
			Put_Line("Task 2 finished calculating matrixEquation");
			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
			end receiveA;

			Put_Line("T2 sends result data to T1");
			T1.receiveA(Ahi);
			Put_Line("Task 2 finished");
		end T2;

		task body T3 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(2*H+1..3*H);
			di:Integer;
			Bhi,Ahi:DynamicVector(2*H+1..3*H);
			Ci:DynamicVector(1..N);
		begin
			Put_Line("Task 3 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
			end receiveFullData;

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);

			Put_Line("T3 sends result data to T2");
			T2.receiveA(Ahi);
			Put_Line("Task 3 finished");
		end T3;

		task body T5 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(4*H+1..6*H);
			di:Integer;
			Bhi,Ahi:DynamicVector(4*H+1..6*H);
			Ci:DynamicVector(1..N);
		begin
			Put_Line("Task 5 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
			end receiveFullData;

			T6.receiveFullData(Bhi(5*H+1..6*H),Ci,MOi,MKhi(5*H+1..6*H),di);

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);

			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
			end receiveA;

			Put_Line("T5 sends result data to T4");
			T4.receiveA(Ahi);
			Put_Line("Task 5 finished");
		end T5;

		task body T6 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(5*H+1..6*H);
			di:Integer;
			Bhi:DynamicVector(5*H+1..6*H);
			Ci:DynamicVector(1..N);
			Ahi:DynamicVector(5*H+1..6*h);
		begin
			Put_Line("Task 6 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
			end receiveFullData;

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);

			Put_Line("T6 sends result data to T5");
			T5.receiveA(Ahi);
			Put_Line("Task 6 finished");
		end T6;

		task body T8 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(7*H+1..N);
			di:Integer;
			Bhi:DynamicVector(7*H+1..N);
			Ci:DynamicVector(1..N);
			Ahi:DynamicVector(7*H+1..N);
		begin
			Put_Line("Task 8 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
			end receiveFullData;

			T9.receiveFullData(Bhi(8*H+1..N),Ci,MOi,MKhi(8*H+1..N),di);

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);

			accept receiveA(Ah:DynamicVector) do
				Ahi(Ah'Range) := Ah(Ah'Range);
			end receiveA;
			Put_Line("T8 received result data from T9");

			Put_Line("T8 sends result data to T7");
			T7.receiveA(Ahi);
			Put_Line("Task 8 finished");
		end T8;

		task body T9 is 
			MOi: DynamicMatrix(1..N);
			MKhi: DynamicMatrix(8*H+1..N);
			di:Integer;
			Bhi:DynamicVector(8*H+1..N);
			Ci:DynamicVector(1..N);
			Ahi:DynamicVector(8*H+1..N);
		begin
			Put_Line("Task 9 started");
			accept receiveFullData(Bh,C:DynamicVector;MO,MKh:DynamicMatrix; d:Integer) do
				Bhi := Bh;
				Ci := C;
				MOi := MO;
				MKhi := Mkh;
				di := d;
			end receiveFullData;

			calcMatrixEquation(di,Bhi'First,Bhi'Last,Bhi,Ci,Ahi,MOi,MKhi);

			Put_Line("T9 sends result data to T8");
			T8.receiveA(Ahi);
			Put_Line("Task 9 finished");
		end T9;


	begin
		null;
	end Start;
begin
	Put("Program started");
	New_line;
	Put("Input N");
	New_line;
	Get(n);
	h:= n/p;
	Start;
end;