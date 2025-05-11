namespace SchedulePlanner.Database
{
    public class Journal
    {
        public int Id { get; set; }
        public int SubjectID { get; set; }
        public int TeacherID { get; set; }
        public int ScheduleID { get; set; }
        public int StudentID { get; set; }
        public string Value { get; set; }
    }
}
