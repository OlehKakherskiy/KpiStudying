using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab3
{
    class ThreadWorker
    {
        private int startIndex;
        private int endIndex;
        private int tID;
        public ThreadWorker(int start, int end, int tID)
        {
            this.startIndex = start;
            this.endIndex = end;
            this.tID = tID;
        }

        public void run()
        {
            Program.taskIFunction(startIndex, endIndex, tID);
        }
    }
}
