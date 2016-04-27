with Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control, DynamicMatrixOperations;
use Ada.Text_IO, Ada.Integer_text_IO, Ada.Synchronous_Task_Control;

procedure lab7 is

	n: Integer; 			--розмірність матриць та векторів
	p: Integer := 9; 		--кількість задач
	h: Integer; 			--кількість рядків матриць та векторів на одну задачу

	procedure Start is

		package DynamicMatrixOperationsN is new DynamicMatrixOperations(N);
		use DynamicMatrixOperationsN;

		Task T1 is
			entry DataFrom7(B3h: in DynamicVector; C: in DynamicVector; MK3h: in DynamicVector);
			entry ResultData(Ah: in DynamicVector);
		end T1;

		Task T2 is 
			entry DataFrom1(d: in Integer; MO: in DynamicMatrix);
			entry DataFrom7(B2h: in DynamicVector; C: in DynamicVector; MK2h: in DynamicVector)
			entry ResultDataFrom5(Ah: in DynamicVector);
		end T2;

		Task T3 is
			entry DataFrom1(d: in Integer; MO: in DynamicMatrix);
			entry DataFrom7(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicVector);
		end T3;

		Task T6 is
			entry DataFrom1(d: in Integer; MO: in DynamicMatrix);
			entry DataFrom7(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicVector);
		end T6;

		Task T9 is
			entry DataFrom1(d: in Integer; MO: in DynamicMatrix);
			entry DataFrom7(Bh: in DynamicVector; C: in DynamicVector; MKh: in DynamicVector);
		end T9;

		Task T4 is
			entry DataFrom1(d: in Integer; MO: in DynamicMatrix);
			entry DataFrom7(B6h: in DynamicVector; C: in DynamicVector; MK6h: in DynamicVector);
			entry ResultData(Ah: in DynamicVector);
		end T4;

		

		
	end Start;
begin
	Put("Program started");
	New_line;
	Put("Input N");
	New_line;
	Get(n);
	h := n/p;
	Start;
end lab7;