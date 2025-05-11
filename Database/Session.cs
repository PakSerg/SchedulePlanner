namespace SchedulePlanner.Database
{
    public static class Session
    {
        public static bool IsLoggedIn { get; set; }
        public static string CurrentUserLogin { get; set; }
        public static string typeUser { get; set; }

        public static bool IsTeacher()
        {
            if (typeUser == "teacher") return true;

            else if (typeUser == "student") return false;

            else throw new Exception($"Неизвестный тип пользователя: {typeUser}");
        }

        public static bool IsStudent()
        {
            return !IsTeacher();
        }
    }
}
