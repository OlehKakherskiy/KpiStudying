with Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control, MatrixOperations;
use Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control;

procedure lab7 is

	n: Integer; 			--розмірність матриць та векторів
	p: Integer := 9; 		--кількість задач
	h: Integer;

	procedure Start is		

		package MatrixOperationsN is new MatrixOperations(N);
		use MatrixOperationsN;

		task type ThreadTask(TaskNumber, StartIndex, EndIndex, ResultStartIndex, ResultEndIndex: Integer) is
			entry ShareDataFrom1Thread(d: in Integer; MO: in DynamicMatrix);
			entry ShareDataFrom7Thread(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicMatrix);
			entry ShareFullData(Bh,C: DynamicVector; MKh,MO: DynamicMatrix; d: Integer);
			entry CollectResult(Ah: in DynamicVector);
		end ThreadTask;

		type ThreadTaskPointer is access ThreadTask;
		type TaskArray is array (1 .. p) of ThreadTaskPointer;
		tArray: TaskArray;

		procedure calcMatrixEquation(d: Integer; Bh:DynamicVector; C:DynamicVector; Res: out DynamicVector; MO:DynamicMatrix; MKh:DynamicMatrix) is
			MatrixBuffer : DynamicMatrix(MKh'Range);
			VectorBuffer : DynamicVector(Bh'Range);
		begin
			Matrix_Matrix_Multiply(MKh,MO,MatrixBuffer);
			Vector_Matrix_Multiply(C,MatrixBuffer,VectorBuffer);
			addVectors(Bh,VectorBuffer,Res,d);
		end calcMatrixEquation;

		procedure copyDataFromT1(d: in Integer; di: out Integer; MO: in DynamicMatrix; MOi: out DynamicMatrix; sendTid, receiveTid:Integer) is
		begin
			Put_Line("Task " & Integer'Image(receiveTid) & " parse data of T1 from T"&Integer'Image(sendTid));
			New_line;
			di := d;
			MOi := MO;
		end copyDataFromT1;

		procedure sendDataFromT1(d: Integer; MO: DynamicMatrix; sendTid, receiveTid: Integer) is
		begin
			Put_Line("Task "&Integer'Image(sendTid)&" send data to T"&Integer'Image(receiveTid)&" of T1");
			New_line;
			tArray(receiveTid).ShareDataFrom1Thread(d,MO);
		end sendDataFromT1;

		procedure sendDataFromT7(Bh, C : DynamicVector; MKh: DynamicMatrix; StartIndex, EndIndex, sendTid, receiveTid: Integer) is
			--отослать 2 данные, принятые с 4 таска
		begin
			Put_Line("Task " & Integer'Image(sendTid) & " send data to T"&Integer'Image(receiveTid)&" of T7");
			New_line;
			tArray(receiveTid).ShareDataFrom7Thread(Bh(StartIndex..EndIndex),C,MKh(StartIndex..EndIndex));
		end sendDataFromT7;

		procedure copyDataFromT7(Bh,C: in DynamicVector; MKh: in DynamicMatrix; Bi_h,Ci: out DynamicVector; MKi_h: out DynamicMatrix;
		 receiveTid, sendTid, StartIndex, EndIndex: Integer) is
		begin
			Put_Line("Task " & Integer'Image(receiveTid) & " parse data of T7 from T"& Integer'Image(sendTid));
			New_line;
			Bi_h(StartIndex..EndIndex) := Bh(StartIndex..EndIndex);
			Ci := C;
			MKi_h := MKh(StartIndex..EndIndex);
		end copyAndSendDataFromT7;

		procedure receiveFullData(
			Bh,C: in DynamicVector; Bi_h,Ci:out DynamicVector; 
			MO, MKh : in DynamicMatrix; Moi, MKi_h: out DynamicMatrix;
			d, StartIndex, EndIndex, receiveTid, sendTid: Integer; di: out Integer) is
		begin
			Put_Line("Task " & Integer'Image(receiveTid) & " received full data T"& Integer'Image(sendTid));
			Bi_h(StartIndex..EndIndex) := Bh(StartIndex..EndIndex);
			Ci := C;
			di := d;
			MOi := MO;
			MKi_h(StartIndex..EndIndex) := MKh(StartIndex..EndIndex);
		end receiveAndSendFullData;

		procedure sendFullData(Bh,C:DynamicVector; MO, MKh: DynamicMatrix; d, StartIndex, EndIndex, receiveTid,sendTid : Integer) is
			Put_Line("Task " & Integer'Image(sendTid) & " send full data to T"& Integer'Image(receiveTid));
			if sendTid rem 3 > 0 then
				tArray[receiveTid].ShareFullData(Bh(StartIndex .. EndIndex), C, MKh(StartIndex..EndIndex),MO,d);
			end if;
		end sendFullData;
		task body ThreadTask is
			tid: Integer := TaskNumber;
			Bi_h: DynamicVector(StartIndex .. EndIndex);
			Ai_h: DynamicVector(ResultStartIndex .. ResultEndIndex);
			Ci: DynamicVector(1..N);
			MOi: DynamicMatrix(1..N);
			MKi_h: DynamicMatrix(StartIndex..EndIndex);
			di: Integer;
		begin
			Put_Line("Task " & Integer'Image(tid) & " started");
			New_line;

			if tid = 1 then
				--ввод
				MOi := Input_Matrix;
				di := Input_Constant;

				--отослать 4 введенные данные
				sendDataFromT1(di,MOi,1,4);

				--принять с 4 таска отправленные данные 7 таска
				accept ShareDataFrom7Thread(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicMatrix) do
					copyDataFromT7(Bh,C,MKh,Bi_h,Ci,MKi_h,1,4,StartIndex,EndIndex);
				end ShareDataFrom7Thread;


			elsif tid = 7 then
				Bi_h := Input_Vector;
				Ci := Input_Vector;
				MKi_h := Input_Matrix;

				--отослать свои данные 8-9 таскам
				sendDataFromT7(Bi_h,Ci,MKi_h,EndIndex+1,N,7,8);

				--принять данные с 4 таска с данными первого таска (для 7-9 тасков)
				accept ShareDataFrom1Thread(d: in Integer; MO: in DynamicMatrix) do
					copyDataFromT1(d,di,MO,MOi,tid,4);
				end ShareDataFrom1Thread;

				--отослать свои данные 4 таску (данные для 1-6 тасков)
				sendDataFromT7(Bi_h,Ci,MKi_h,1,StartIndex-1,7,4);
				--отослать данные первого таска таскам 8-9
				sendDataFromT1(di,MOi,7,8);

			elsif tid = 4 then
				accept ShareDataFrom1Thread(d: in Integer; MO: in DynamicMatrix) do
					copyDataFromT1(d,di,MO,MOi,tid,1);
				end ShareDataFrom1Thread;

				sendDataFromT1(di,MOi,4,5);
				sendDataFromT1(di,MOi,4,7);

				accept ShareDataFrom7Thread(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicMatrix) do
					copyAndSendDataFromT7(Bh,C,MKh,Bi_h,Ci,MKi_h,4,7,5,StartIndex,EndIndex);
					sendDataFromT7(Bh,C,MKh,1,StartIndex-1,4,1);
				end ShareDataFrom7Thread;

			else --task 2,3,5,6,8,9
				accept ShareDataFrom1Thread(d: Integer; MO: in DynamicMatrix) do
					copyDataFromT1(d,di,MO,Moi,tid-1,tid);
				end ShareDataFrom1Thread;
			
			if tid rem 3 > 0 then --текущий номер 3,6,9 - не передаем дальше
				sendDataFromT1(di,MOi,tid,tid+1);
			end if;

			accept ShareDataFrom7Thread(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicMatrix) do
				copyAndSendDataFromT7(Bh,C,MKh,Bi_h,Ci,MKi_h,tid,tid-1,tid+1,StartIndex,EndIndex);
			end ShareDataFrom7Thread;

			end if;
			Put_Line("Task" & Integer'Image(tid) & " is starting calculation");
			--данные есть во всех задачах.
			calcMatrixEquation(di,Bi_h,Ci,Ai_h,MOi,MKi_h);
			Put_Line("Task" & Integer'Image(tid) & " finished calculation");

			--пересылка и склеивание результата
			if tid = 1 then
				for i in 1..2 loop
					accept CollectResult(Ah: in DynamicVector) do
						Ai_h(Ah'Range) := Ah(Ah'Range);
					end CollectResult;
				end loop;
				Output_Vector(Ai_h);
			elsif tid = 7 then--4 и 7 таск не правильно
				accept CollectResult(Ah: in DynamicVector) do
					Ai_h(Ah'Range) := Ah(Ah'Range);
					tArray(4).CollectResult(Ai_h);
				end CollectResult;
			elsif tid = 4 then
				for i in 1..2 loop
					accept CollectResult(Ah: in DynamicVector) do
						Ai_h(Ah'Range) := Ah(Ah'Range);
					end CollectResult;
				end loop;
				tArray(1).CollectResult(Ai_h);
			elsif tid rem 3 = 0 then --task 3,6,9
				tArray(tid-1).CollectResult(Ai_h);
			else 
				accept CollectResult(Ah: in DynamicVector) do
					Ai_h(Ah'Range) := Ah(Ah'Range);
				end CollectResult;
				tArray(tid-1).CollectResult(Ai_h);
			end if;
			Put_Line("Task " & Integer'Image(tid) & " finished");
		end ThreadTask;

	begin	
		for I in 1 .. p loop
			if i = p OR i = p-1 then
				tArray(I) := new ThreadTask(I,(i-1)*H+1,N,(i-1)*H+1,N);
			elsif i = 2 OR i = 5 then 
				tArray(I) := new ThreadTask(I,(i-1)*H+1,(i+1)*H,(i-1)*H+1,(i+1)*H);
			elseif i = 3 OR i = 6 then
				tArray(I) := new ThreadTask(I,(i-1)*H+1,N,(i-1)*H+1,N);
				tArray(i) := new ThreadTask(i, (i-1)*H+1, i*H, (i-1)*H+1, N);
			end if; 
		end loop;
		tArray[1] := new ThreadTask(1,1,)

	end Start;
begin
	Put("Program started");
	New_line;
	Put("Input N");
	New_line;
	Get(n);
	h:= n/p;
	Start;
end lab7;