using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using SchedulePlanner.Database;
using System.Linq;
using SchedulePlanner.Windows;

namespace SchedulePlanner
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            EnterDevMode();
        }

        private void EnterDevMode()
        {
            Session.IsLoggedIn = true;
            Session.typeUser = "teacher";
            Session.CurrentUserLogin = "andreev.t";

            ScheduleWindow scheduleWindow = new ScheduleWindow();
            scheduleWindow.Show();
            this.Close(); 


        }

        private void loginButton_Click(object sender, RoutedEventArgs e)
        {
            if (loginTextbox.Text.Length == 0 || passwordTextbox.Text.Length == 0)
            {
                MessageBox.Show("Введите логин и пароль");
            }

            bool? isTeacher = radioIsTeacher.IsChecked;

            string login = loginTextbox.Text; 
            string password = passwordTextbox.Text;

            if (login.Length == 0 || password.Length == 0)
            {
                MessageBox.Show("Неверно указан логин или пароль");
                return;
            }

            using (var db = new ApplicationContext())
            {
                if (isTeacher.HasValue && isTeacher.Value)
                {
                    var teacher = db.Teacher.FirstOrDefault(p => p.Login == login && p.Password == password);
                    if (teacher == null)
                    {
                        MessageBox.Show("Введены неверные данные", "Ошибка входа");
                        return;
                    }

                    string typeUser = "teacher";

                    Session.IsLoggedIn = true;
                    Session.typeUser = typeUser;
                    Session.CurrentUserLogin = login; 

                    ScheduleWindow scheduleWindow = new ScheduleWindow(); 
                    scheduleWindow.Show();
                    this.Close();

                    return;
                }
            }
        }
    }
}