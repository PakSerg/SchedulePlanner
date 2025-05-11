using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchedulePlanner.Database
{
    public class ScheduleRow
    {
        public DateTime TimeStart { get; set; }
        public DateTime TimeEnd { get; set; }
        public string ClassTitle { get; set; }
        public string GroupTitle { get; set; }
        public string SubjectTitle { get; set; }
        public string TeacherName { get; set; }
    }
}
