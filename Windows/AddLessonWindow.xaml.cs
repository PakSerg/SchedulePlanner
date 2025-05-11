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
    /// Логика взаимодействия для AddLessonWindow.xaml
    /// </summary>
    public partial class AddLessonWindow : Window
    {
        private List<Subject> allSubjects;
        private List<Teacher> allTeachers;
        private ScheduleWindow parentWindow;

        public AddLessonWindow(ScheduleWindow parent)
        {
            InitializeComponent();
            parentWindow = parent;
            LoadComboboxesData();
            
            subjectCombobox.SelectionChanged += SubjectCombobox_SelectionChanged;
            teacherCombobox.SelectionChanged += TeacherCombobox_SelectionChanged;
        }

        private void LoadComboboxesData()
        {
            using (var db = new ApplicationContext())
            {
                allSubjects = db.Subject.ToList();
                allTeachers = db.Teacher.ToList();

                subjectCombobox.ItemsSource = allSubjects;
                subjectCombobox.DisplayMemberPath = "Title";

                classCombobox.ItemsSource = db.Class.ToList();
                classCombobox.DisplayMemberPath = "Title";

                groupCombobox.ItemsSource = db.Groups.ToList();
                groupCombobox.DisplayMemberPath = "Title"; 

                teacherCombobox.ItemsSource = allTeachers;
                teacherCombobox.DisplayMemberPath = "Name";
            }
        }

        private void SubjectCombobox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (teacherCombobox.SelectedItem == null)
            {
                using (var db = new ApplicationContext())
                {
                    var selectedSubject = subjectCombobox.SelectedItem as Subject;
                    if (selectedSubject != null)
                    {
                        var teacherIds = db.SpecializationSubject
                            .Where(ss => ss.SubjectID == selectedSubject.Id)
                            .Select(ss => ss.TeacherID)
                            .ToList();

                        var filteredTeachers = allTeachers
                            .Where(t => teacherIds.Contains(t.Id))
                            .ToList();

                        teacherCombobox.ItemsSource = filteredTeachers;
                    }
                }
            }
        }

        private void TeacherCombobox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (subjectCombobox.SelectedItem == null)
            {
                using (var db = new ApplicationContext())
                {
                    var selectedTeacher = teacherCombobox.SelectedItem as Teacher;
                    if (selectedTeacher != null)
                    {
                        var subjectIds = db.SpecializationSubject
                            .Where(ss => ss.TeacherID == selectedTeacher.Id)
                            .Select(ss => ss.SubjectID)
                            .ToList();

                        var filteredSubjects = allSubjects
                            .Where(s => subjectIds.Contains(s.Id))
                            .ToList();

                        subjectCombobox.ItemsSource = filteredSubjects;
                    }
                }
            }
        }

        private void addLessonButton_Click(object sender, RoutedEventArgs e)
        {
            string startDate = startDateTextBox.Text;
            string endDate = endDateTextBox.Text;
            string group = groupCombobox.Text;
            string classes = classCombobox.Text;
            string subject = subjectCombobox.Text;
            string teacherName = teacherCombobox.Text;

            if (string.IsNullOrWhiteSpace(startDate) || string.IsNullOrWhiteSpace(endDate) ||
                string.IsNullOrWhiteSpace(group) || string.IsNullOrWhiteSpace(classes) ||
                string.IsNullOrWhiteSpace(subject) || string.IsNullOrWhiteSpace(teacherName))
            {
                MessageBox.Show("Заполните все данные");
                return;
            }

            try
            {
                DateTime startDateTime;
                DateTime endDateTime;

                if (!DateTime.TryParse(startDate, out startDateTime))
                {
                    MessageBox.Show("Неверный формат даты и времени начала занятия (пример: 25.03.2024 14:30)");
                    return;
                }

                if (!DateTime.TryParse(endDate, out endDateTime))
                {
                    MessageBox.Show("Неверный формат даты и времени начала занятия (пример: 25.03.2024 14:30)");
                    return;
                }

                if (endDateTime <= startDateTime)
                {
                    MessageBox.Show("Время окончания занятия должно быть позже времени начала");
                    return;
                }

                using (var db = new ApplicationContext())
                {
                    var selectedSubject = db.Subject.FirstOrDefault(s => s.Title == subject);
                    var selectedTeacher = db.Teacher.FirstOrDefault(t => t.Name == teacherName);
                    var selectedClass = db.Class.FirstOrDefault(c => c.Title == classes);
                    var selectedGroup = db.Groups.FirstOrDefault(g => g.Title == group);

                    if (selectedSubject == null || selectedTeacher == null || 
                        selectedClass == null || selectedGroup == null)
                    {
                        MessageBox.Show("Ошибка при поиске выбранных данных");
                        return;
                    }

                    var specializationSubject = db.SpecializationSubject
                        .FirstOrDefault(ss => ss.SubjectID == selectedSubject.Id && 
                                           ss.TeacherID == selectedTeacher.Id);

                    if (specializationSubject == null)
                    {
                        MessageBox.Show("Выбранный преподаватель не может вести данный предмет");
                        return;
                    }

                    var schedule = new Schedule
                    {
                        TimeStart = startDateTime,
                        TimeEnd = endDateTime,
                        ClassID = selectedClass.Id,
                        GroupID = selectedGroup.Id,
                        SpecializationSubjectID = specializationSubject.Id
                    };

                    db.Schedule.Add(schedule);
                    db.SaveChanges();

                    MessageBox.Show("Занятие успешно добавлено");
                    dropAllFields_Click(sender, e);

                    parentWindow.UpdateSchedule();
                    this.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Ошибка при добавлении занятия: {ex.Message}");
            }
        }

        private void dropAllFields_Click(object sender, RoutedEventArgs e)
        {
            startDateTextBox.Text = string.Empty;
            endDateTextBox.Text = string.Empty;
            groupCombobox.SelectedItem = null;
            classCombobox.SelectedItem = null;
            subjectCombobox.SelectedItem = null;
            teacherCombobox.SelectedItem = null;

            subjectCombobox.ItemsSource = allSubjects;
            teacherCombobox.ItemsSource = allTeachers;
        }
    }
}
