using System;
using System.Threading;
using System.Threading.Tasks;

namespace lab3{
    class Program{

        private static int[][] MO, MK, MT;
        private static int[] A, B, Z, R;
        private static int a, N, H, P;

        private static object bCritSec = new object();
        private static Semaphore resourceSemaphore;
        private static Mutex RMutex;
        private static WaitHandle[] inputSynch;
        private static WaitHandle[] outputSynch;
        private static Barrier maxCalcBarrier;

        private static volatile int maxB;

        static void Main(string[] args){
            Console.WriteLine("lab3 started");
            Console.WriteLine("input N");
            N = Int32.Parse(Console.ReadLine());
            Console.WriteLine("Input P");
            P = Int32.Parse(Console.ReadLine());
            H = N / P;
            A = new int[N];
            resourceSemaphore = new Semaphore(1, 1);
            RMutex = new Mutex();
            maxCalcBarrier = new Barrier(P);

            inputSynch = new WaitHandle[3];
            inputSynch[0] = new ManualResetEvent(false);
            inputSynch[1] = new Semaphore(0, P - 1);
            inputSynch[2] = new ManualResetEvent(false);

            outputSynch = new WaitHandle[P]; //[3] = null;
            outputSynch[0] = new Semaphore(0, 1);
            outputSynch[1] = new AutoResetEvent(false);
            outputSynch[2] = new Semaphore(0, 1);
            outputSynch[3] = new AutoResetEvent(true);
            for (int i = 4; i < P; i++)
                outputSynch[i] = new AutoResetEvent(false);
            Thread[] t = new Thread[P];
            for (int i = 0; i < P-1; i++) {
                t[i] = new Thread(new ThreadWorker(H * i, H * (i + 1), i).run);
            }
            t[P - 1] = new Thread(new ThreadWorker(H * (P - 1), N, (P - 1)).run);
            for (int i = 0; i < P; i++)
            {
                t[i].Start();
            }
            t[3].Join();
            Console.WriteLine("lab3 finished");

            Console.ReadLine();
        }

        public static void taskIFunction(int startIndex, int endIndex, int tID){
            int ai = 0, bi;
            int[] Zi = null, Ri = null;
            int[][] MKi = null;

            Console.WriteLine("task "+ tID+" started");

            //Ввод данных
            switch (tID){
                case 0: //задача 1

                    //Ввод данных
                    MO = MatrixOperations.inputMatrix(N);
                    MK = MatrixOperations.inputMatrix(N);
                    R = MatrixOperations.inputVector(N);
                    Console.WriteLine("task " + tID + " finishedInput and waiting");

                    //Сигнал остальным потокам о завершении ввода
                    ((ManualResetEvent)inputSynch[0]).Set();

                    //Ожидание ввода в 3 задаче
                    inputSynch[1].WaitOne();

                    //Ожидание ввода в 4 задаче
                    inputSynch[2].WaitOne();
                    break;
                case 2: //задача 3

                    //Ввод данных
                    a = MatrixOperations.inputConstant();
                    MT = MatrixOperations.inputMatrix(N);
                    Console.WriteLine("task " + tID + " finishedInput and waiting");

                    //Сигнал остальным потокам о завершении ввода
                    ((Semaphore)inputSynch[1]).Release(P-1);

                    //Ожидание ввода в 1 задаче
                    inputSynch[0].WaitOne();
                    //Ожидание ввода в 4 задаче
                    inputSynch[2].WaitOne();
                    break;

                case 3: //задача 4

                    //Ввод данных
                    B = MatrixOperations.inputVector(N);
                    maxB = B[0];
                    Z = MatrixOperations.inputVector(N);
                    Console.WriteLine("task " + tID + " finishedInput and waiting");

                    //Сигнал остальным потокам о завершении ввода
                    ((ManualResetEvent)inputSynch[2]).Set();

                    //Ожидание ввода в 1 задаче
                    inputSynch[0].WaitOne();
                    //Ожидание ввода в 3 задаче
                    inputSynch[1].WaitOne();
                    break;
                default:
                    //Ожидание ввода в 1,3,4 задачах
                    WaitHandle.WaitAll(inputSynch);
                    break;
            }

            //Копирование общих ресурсов
            Console.WriteLine("task " + tID + " is copying shared resources");
            copySharedResources(ref ai, ref Zi, ref Ri, ref MKi);
            
            //Вычисление max(B) в диапазоне
            bi = MatrixOperations.max(B, startIndex, endIndex);
            Console.WriteLine("task " + tID + " is comparing with maxB");

            //Сравнивание с общим maxB
            compareWithMax(bi);

            //Ожидание вычислений maxB во всех других потоках (барьер)
            Console.WriteLine("task " + tID + " is in barrier");
            maxCalcBarrier.SignalAndWait();

            //Копирование maxB
            Console.WriteLine("task " + tID + " is copying maxB");
            bi = copyMaxB();
            Console.WriteLine("task " + tID + " is calculating equation");

            //Вычисление выражения
            calculateMatrixEquation(ai, bi, Zi, Ri, MKi, startIndex, endIndex);
            switch (tID){
                case 0: //задача 1
                case 2: //задача 2
                    ((Semaphore)outputSynch[tID]).Release(); //сигнал о завершении вычисления
                    break;
                case 3: //задача 4
                    //ожидание вычисления выражения во всех потоках
                    WaitHandle.WaitAll(outputSynch);
                    if (N <= 8)
                        Console.WriteLine(MatrixOperations.ToString(A));
                    break;
                default:
                    ((AutoResetEvent)outputSynch[tID]).Set(); //сигнал о завершении вычисления
                    break;
            }
            Console.WriteLine("task " + tID + " finished");
        }

        private static void calculateMatrixEquation(int copy_a, int copy_b, int[] copyZ, int[] copyR, int[][] copyMK, int startIndex, int endIndex)
        {
            int[][] Buf1 = MatrixOperations.multiplyMatrixMatrix(MT, copyMK, startIndex, endIndex);
            int[] vect1 = MatrixOperations.multiplyVectorMatrix(copyR, MO, copy_b, startIndex, endIndex);
            int[] vect2 = MatrixOperations.multiplyVectorMatrix(copyZ, Buf1, copy_a, startIndex, endIndex);
            MatrixOperations.addVectors(vect1, vect2, A, startIndex, endIndex);
        }

        private static void copySharedResources(ref int copy_a, ref int[] copyZ, ref int[] copyR, ref int[][] copyMK) //TODO: тут мб ошибка
        {
            
            resourceSemaphore.WaitOne();
            copy_a = a;
            copyZ = MatrixOperations.copyVector(Z);
            resourceSemaphore.Release();
            
            Monitor.Enter(MK);
            copyMK = MatrixOperations.copyMatrix(MK);
            Monitor.Exit(MK);
            
            RMutex.WaitOne();
            copyR = MatrixOperations.copyVector(R);
            RMutex.ReleaseMutex();
        }

        private static void compareWithMax(int c){
            lock(bCritSec){
                if (maxB < c)
                    maxB = c;
            }
        }

        private static int copyMaxB(){
            lock (bCritSec)
                return maxB;
        }
    }
}
