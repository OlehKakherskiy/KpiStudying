with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control,Data;
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
procedure Lab1 is
	package DataN is new Data(3000);
	use DataN;
	MO,MZ: Matrix;
	B,C,a:Vector;
	alpha: Integer;
	h,n:integer;
	Skd1,S1,S2 : Suspension_Object;

	procedure Start is
		task T1;
		task T2;

		task body T1 is
			MO1, Buff: Matrix;
			B1, cHBuff: Vector;
			a1: integer;
		begin
			Put_Line("T1 started\n");

			--init data
			Input_Matrix(MO);
			Input_Matrix(MZ);
			Input_Vector(B);
			Input_Vector(C); 
			Input_Constant(alpha);
			Put_Line("T1 sent signal S1\n");
			Set_True(S1);

			Put_Line("T1 waits for Skd1\n");
			Suspend_Until_True(Skd1);
			Put_Line("T1 in crit section Skd1\n");
			B1  := B;
			a1  := alpha;
			MO1 := MO;
			Set_True(Skd1);
			Put_Line("T1 cancelled Skd1 section\n");

			Matrix_Matrix_Multiply(MO1,MZ,1,h,Buff); --Buff = MOh*MZ.
			--Output_Matrix(Buff);
		Vector_Matrix_Multiply(B1,Buff,1,h,A); -- A = Bh*Buff_h
		--Output_Vector(A);
			Constant_Vector_Multiply(a1,C,1,h,cHBuff); --a*Ch
			--Output_Vector(CHBuff);
			Vector_Vector_Add(CHBuff,A,1,h,A);

			Put_Line("T1 waiting for signal S2 from T2\n");
			Suspend_Until_True(S2);
			if h*2 <= 8 then
				Output_Vector(A);
			end if;
			Put_Line("T1 finished\n");			
		end T1;

		task body T2 is
			MO2, Buff: Matrix;
			B2,cHBuff : Vector;
			a2 : Integer;
		begin
			--Put_Line("T2 started\n");
			--Put_Line("T2 waiting for signal S1 from T1");
			Suspend_Until_True(S1);
			--Put_Line("T2 waits for Skd1\n");
			Suspend_Until_True(Skd1);
			--Put_Line("T2 in crit section Skd1\n");
			B2 := B;
			a2 := alpha;
			MO2:= MO;
			Set_True(Skd1);
			Put_Line("T2 cancelled Skd1 section\n");

			Matrix_Matrix_Multiply(MO2,MZ,H+1,n,Buff); --Buff = MOh*MZ.
			--Output_Matrix(Buff);
			Vector_Matrix_Multiply(B2,Buff,H+1,n,A); -- A = Bh*Buff_h
			--Output_Vector(A);
			Constant_Vector_Multiply(a2,C,H+1,n,cHBuff); --a*Ch
			--Output_Vector(CHBuff);
			Vector_Vector_Add(cHBuff,A,H+1,n,A);
			--Output_Vector(A);

			--Put_Line("T2 sent signal S2\n");
			Set_True(S2);
			--Put_Line("T2 finished\n");
		end T2;
	begin	
		null;
	end Start;
begin
	n:=3000;
	h := n/2;
	Set_True(Skd1);
	Start;
end Lab1;