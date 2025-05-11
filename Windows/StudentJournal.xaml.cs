using Microsoft.EntityFrameworkCore;
using SchedulePlanner.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace SchedulePlanner.Windows
{
    /// <summary>
    /// Логика взаимодействия для StudentJournal.xaml
    /// </summary>
    public partial class StudentJournal : Window
    {
        public StudentJournal()
        {
            InitializeComponent();
            loadStudentsMarks();

        }

        public void loadStudentsMarks()
        {
            using (var db = new ApplicationContext())
            {
                if (Session.IsTeacher())
                    return;

                var studentId = db.Student
                    .Where(s => s.Login == Session.CurrentUserLogin)
                    .Select(s => s.Id)
                    .FirstOrDefault();

                var studentMarks = db.Journal
                    .Where(j => j.StudentID == studentId)
                    .Select(j => new MarkRow
                    {
                        Subject = db.Subject
                            .Where(s => s.Id == j.SubjectID)
                            .Select(s => s.Title)
                            .FirstOrDefault(),

                        Teacher = db.Teacher
                            .Where(t => t.Id == j.TeacherID)
                            .Select(t => t.Name)
                            .FirstOrDefault(),

                        Mark = j.Value
                    })
                    .ToList();

                Schedule_DataGrid.ItemsSource = studentMarks;
            }
        }

        private void addLessonButton_Click(object sender, RoutedEventArgs e)
        {
            ScheduleWindow scheduleWindow = new ScheduleWindow(); 
            scheduleWindow.Show();
            this.Close();
        }
    }
}
