using System;
using System.Threading;
namespace lab4
{
	class Lab4
	{
		public static void Main (string[] args)
		{
			//создаем объекты потоков, передаем в качестве параметров ссылки на функции
			Thread t1 = new Thread (F1);
			Thread t2 = new Thread (F2);
			Thread t3 = new Thread (F3);

			//задаем приоритеты потокам
			t1.Priority = ThreadPriority.Highest;
			t2.Priority = ThreadPriority.BelowNormal;
			t3.Priority = ThreadPriority.Lowest;

			//запускаем потоки на выполнение
			t1.Start ();
			t2.Start ();
			t3.Start ();

			//блокируем главный поток до завершения выполнения потоков
			t1.Join ();
			t2.Join ();
			t3.Join ();
		}

		//F1: A = SORT(B) * (MB * MC)
		static void F1(){
			int n = 1000;
			Thread.Sleep (3000);
			System.Console.WriteLine("Завдання 1 старт");
			System.Console.WriteLine("Завдання 1 результат:\n"+Data.ToString(Data.multiplyVectorMatrix(Data.sort(Data.generateVector(n)),
			                                                             Data.multiplyMatrixMatrix(Data.generateMatrix(n), Data.generateMatrix(n)))));
			System.Console.WriteLine("Завдання 1 завершило виконання");
		}

		//F2: MF = MK + ML * (MN * MM)
		static void F2(){
			int n = 1000;
			System.Console.WriteLine("Завдання 2 старт");
			System.Console.WriteLine("Завдання 2 результат:\n"+Data.ToString(Data.add(Data.generateMatrix(n),
			                                                Data.multiplyMatrixMatrix(Data.generateMatrix(n),
			                          Data.multiplyMatrixMatrix(Data.generateMatrix(n), Data.generateMatrix(n))))));
			System.Console.WriteLine("Завдання 2 завершило виконання");
		}

		//F3: Q = SORT(X + Z) * (MT * MS)
		static void F3(){
			int n = 1000;
			System.Console.WriteLine("Завдання 3 старт");
			System.Console.WriteLine("Завдання 3 результат:\n"+
				Data.ToString(Data.multiplyVectorMatrix(
				Data.sort(Data.addVectors(Data.generateVector(n),Data.generateVector(n))),
				Data.multiplyMatrixMatrix(Data.generateMatrix(n),Data.generateMatrix(n)))));
			System.Console.WriteLine("Завдання 3 завершило виконання");
		}
	}
}
