using SchedulePlanner.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System;
using System.Collections.Generic;
using System.Linq;
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
    /// Логика взаимодействия для ScheduleWindow.xaml
    /// </summary>
    public partial class ScheduleWindow : Window
    {
        public ScheduleWindow()
        {
            InitializeComponent();
            loadDataGrid();
            ProccessWindowForStudents();
        }

        public void UpdateSchedule()
        {
            loadDataGrid();
        }

        public void ProccessWindowForStudents()
        {
            if (Session.IsStudent())
            {
                addLessonButton.Visibility = Visibility.Hidden;
            }
        }

        private void loadDataGrid()
        {
            using (var db = new ApplicationContext())
            {
                var schedules = (from s in db.Schedule
                                 join c in db.Class on s.ClassID equals c.Id
                                 join g in db.Groups on s.GroupID equals g.Id
                                 join ss in db.SpecializationSubject on s.SpecializationSubjectID equals ss.Id
                                 join sub in db.Subject on ss.SubjectID equals sub.Id
                                 join t in db.Teacher on ss.TeacherID equals t.Id
                                 select new ScheduleRow
                                 {
                                     TimeStart = s.TimeStart,
                                     TimeEnd = s.TimeEnd,
                                     ClassTitle = c.Title,
                                     GroupTitle = g.Title,
                                     SubjectTitle = sub.Title,
                                     TeacherName = t.Name
                                 })
                                 .OrderBy(s => s.TimeStart)
                                 .ToList();

                if (Session.IsStudent())
                {
                    var studentGroup = db.Student
                        .Where(s => s.Login == Session.CurrentUserLogin)
                        .Select(s => s.GroupID)
                        .FirstOrDefault();

                    if (studentGroup != 0)
                    {
                        var groupTitle = db.Groups
                            .Where(g => g.Id == studentGroup)
                            .Select(g => g.Title)
                            .FirstOrDefault();

                        schedules = schedules.Where(s => s.GroupTitle == groupTitle).ToList();
                    }
                }

                ScheduleDataGrid.ItemsSource = schedules;
            }
        }

        private void addLessonButton_Click(object sender, RoutedEventArgs e)
        {
            if (Session.IsStudent())
            {
                MessageBox.Show("Недостаточно прав");
                return;
            }

            AddLessonWindow addLessonWindow = new AddLessonWindow(this);
            addLessonWindow.Show();
        }

        private void lookMarksButton_Click(object sender, RoutedEventArgs e)
        {
            StudentJournal journal = new StudentJournal(); 
            journal.Show();

            this.Close();
        }
    }
}