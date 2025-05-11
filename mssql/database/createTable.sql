-- Создание базы данных

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'EducationPlans')
BEGIN
    CREATE DATABASE EducationPlans;
END
GO

USE EducationPlans;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Groups')
BEGIN
    CREATE TABLE Groups (
        id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
        title NVARCHAR(255) NOT NULL
    );
END

CREATE TABLE Student (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name NVARCHAR(255) NOT NULL,
    login NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,  
    groupID INT NOT NULL,           
    FOREIGN KEY (groupID) REFERENCES Groups(id)
);

CREATE TABLE Teacher (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name NVARCHAR(255) NOT NULL,
    login NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,  
    specialization NVARCHAR(255) NOT NULL
);

CREATE TABLE Class (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    title NVARCHAR(255) NOT NULL, 
    type NVARCHAR(255) NOT NULL
);

CREATE TABLE [Subject] (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    title NVARCHAR(255) NOT NULL, 
    hourAll INT NOT NULL,
    ending NVARCHAR(255) NOT NULL
);

CREATE TABLE SpecializationSubject (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    subjectID INT NOT NULL,   
    teacherID INT NOT NULL,  
    FOREIGN KEY (subjectID) REFERENCES [Subject](id),       
    FOREIGN KEY (teacherID) REFERENCES Teacher(id)
);

CREATE TABLE Schedule (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,    
    timeStart DATETIME NOT NULL,
    timeEnd DATETIME NOT NULL,
    classID INT NOT NULL,  
    groupID INT NOT NULL,
    specializationSubjectID INT NOT NULL, 
    FOREIGN KEY (classID) REFERENCES Class(id),
    FOREIGN KEY (groupID) REFERENCES Groups(id),
    FOREIGN KEY (specializationSubjectID) REFERENCES SpecializationSubject(id)
);

CREATE TABLE Journal (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    subjectID INT NOT NULL,   
    teacherID INT NOT NULL,  
    scheduleID INT NOT NULL, 
    studentID INT NOT NULL,
    value NVARCHAR(255) NOT NULL,
    FOREIGN KEY (subjectID) REFERENCES [Subject](id),       
    FOREIGN KEY (teacherID) REFERENCES Teacher(id),
    FOREIGN KEY (scheduleID) REFERENCES Schedule(id),
    FOREIGN KEY (studentID) REFERENCES Student(id)
);

CREATE TABLE JournalHomework (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    title NVARCHAR(255) NOT NULL, 
    description NVARCHAR(255) NOT NULL, 
    deadline DATETIME,
    subjectID INT NOT NULL,    
    scheduleID INT NOT NULL, 
    FOREIGN KEY (subjectID) REFERENCES [Subject](id),       
    FOREIGN KEY (scheduleID) REFERENCES Schedule(id)
);


-- Вставка данных

-- Удаление данных в правильном порядке из-за внешних ключей
DELETE FROM JournalHomework;
DELETE FROM Journal;
DELETE FROM Schedule;
DELETE FROM SpecializationSubject;
DELETE FROM [Subject];
DELETE FROM Class;
DELETE FROM Teacher;
DELETE FROM Student;
DELETE FROM Groups;

INSERT INTO Groups (title) VALUES
(N'Группа А'), (N'Группа Б'), (N'Группа В'), (N'Группа Г'), (N'Группа Д');


INSERT INTO Student (name, login, password, groupID) VALUES
(N'Алиса Иванова', 'alisa.i', 'pass123', (SELECT id FROM Groups WHERE title = N'Группа А')),
(N'Борис Смирнов', 'boris.s', 'pass123', (SELECT id FROM Groups WHERE title = N'Группа Б')),
(N'Виктория Ким', 'vika.k', 'pass123', (SELECT id FROM Groups WHERE title = N'Группа В')),
(N'Дмитрий Орлов', 'dmitry.o', 'pass123', (SELECT id FROM Groups WHERE title = N'Группа Г')),
(N'Екатерина Лисина', 'katya.l', 'pass123', (SELECT id FROM Groups WHERE title = N'Группа Д'));


INSERT INTO Teacher (name, login, password, specialization) VALUES
(N'Преп. Андреев', 'andreev.t', 'pass123', N'Математика'),
(N'Преп. Белова', 'belova.t', 'pass123', N'Физика'),
(N'Преп. Чернов', 'chernov.t', 'pass123', N'Химия'),
(N'Преп. Демина', 'demina.t', 'pass123', N'Биология'),
(N'Преп. Егоров', 'egorov.t', 'pass123', N'Информатика');


INSERT INTO Class (title, type) VALUES
(N'Лекция 1', N'Лекция'),
(N'Лабораторная 1', N'Лабораторная'),
(N'Семинар 1', N'Семинар'),
(N'Лекция 2', N'Лекция'),
(N'Лабораторная 2', N'Лабораторная');


INSERT INTO [Subject] (title, hourAll, ending) VALUES
(N'Алгебра', 60, N'Экзамен'),
(N'Механика', 45, N'Тест'),
(N'Органическая химия', 50, N'Экзамен'),
(N'Ботаника', 40, N'Зачёт'),
(N'Основы программирования', 70, N'Экзамен');


INSERT INTO SpecializationSubject (subjectID, teacherID) VALUES
((SELECT id FROM [Subject] WHERE title = N'Алгебра'), (SELECT id FROM Teacher WHERE name = N'Преп. Андреев')),
((SELECT id FROM [Subject] WHERE title = N'Механика'), (SELECT id FROM Teacher WHERE name = N'Преп. Белова')),
((SELECT id FROM [Subject] WHERE title = N'Органическая химия'), (SELECT id FROM Teacher WHERE name = N'Преп. Чернов')),
((SELECT id FROM [Subject] WHERE title = N'Ботаника'), (SELECT id FROM Teacher WHERE name = N'Преп. Демина')),
((SELECT id FROM [Subject] WHERE title = N'Основы программирования'), (SELECT id FROM Teacher WHERE name = N'Преп. Егоров'));


INSERT INTO SpecializationSubject (subjectID, teacherID) VALUES
((SELECT id FROM [Subject] WHERE title = N'Алгебра'), (SELECT id FROM Teacher WHERE name = N'Преп. Андреев')),
((SELECT id FROM [Subject] WHERE title = N'Механика'), (SELECT id FROM Teacher WHERE name = N'Преп. Белова')),
((SELECT id FROM [Subject] WHERE title = N'Органическая химия'), (SELECT id FROM Teacher WHERE name = N'Преп. Чернов')),
((SELECT id FROM [Subject] WHERE title = N'Ботаника'), (SELECT id FROM Teacher WHERE name = N'Преп. Демина')),
((SELECT id FROM [Subject] WHERE title = N'Основы программирования'), (SELECT id FROM Teacher WHERE name = N'Преп. Егоров'));


INSERT INTO Schedule (timeStart, timeEnd, classID, groupID, specializationSubjectID) VALUES
('2025-05-12 08:00', '2025-05-12 09:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лекция 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа А'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Алгебра'))),

('2025-05-13 10:00', '2025-05-13 11:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лабораторная 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Б'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Механика'))),

('2025-05-14 12:00', '2025-05-14 13:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Семинар 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа В'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Органическая химия'))),

('2025-05-15 14:00', '2025-05-15 15:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лекция 2'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Г'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Ботаника'))),

('2025-05-16 16:00', '2025-05-16 17:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лабораторная 2'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Д'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Основы программирования')));


INSERT INTO Schedule (timeStart, timeEnd, classID, groupID, specializationSubjectID) VALUES
('2025-05-12 08:00', '2025-05-12 09:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лекция 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа А'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Алгебра'))),

('2025-05-13 10:00', '2025-05-13 11:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лабораторная 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Б'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Механика'))),

('2025-05-14 12:00', '2025-05-14 13:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Семинар 1'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа В'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Органическая химия'))),

('2025-05-15 14:00', '2025-05-15 15:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лекция 2'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Г'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Ботаника'))),

('2025-05-16 16:00', '2025-05-16 17:30',
 (SELECT TOP 1 id FROM Class WHERE title = N'Лабораторная 2'),
 (SELECT TOP 1 id FROM Groups WHERE title = N'Группа Д'),
 (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = (SELECT TOP 1 id FROM [Subject] WHERE title = N'Основы программирования')));


INSERT INTO Journal (subjectID, teacherID, scheduleID, value, studentID) VALUES
(
 (SELECT TOP 1 id FROM [Subject] WHERE title = N'Алгебра'),
 (SELECT TOP 1 id FROM Teacher WHERE name = N'Преп. Андреев'),
 (SELECT TOP 1 id FROM Schedule WHERE specializationSubjectID = 
     (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = 
         (SELECT TOP 1 id FROM [Subject] WHERE title = N'Алгебра'))),
 '5', 
 (SELECT TOP 1 id FROM Student WHERE name = N'Алиса Иванова')
),
(
 (SELECT TOP 1 id FROM [Subject] WHERE title = N'Механика'),
 (SELECT TOP 1 id FROM Teacher WHERE name = N'Преп. Белова'),
 (SELECT TOP 1 id FROM Schedule WHERE specializationSubjectID = 
     (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = 
         (SELECT TOP 1 id FROM [Subject] WHERE title = N'Механика'))),
 '4', 
 (SELECT TOP 1 id FROM Student WHERE name = N'Борис Смирнов')
),
(
 (SELECT TOP 1 id FROM [Subject] WHERE title = N'Органическая химия'),
 (SELECT TOP 1 id FROM Teacher WHERE name = N'Преп. Чернов'),
 (SELECT TOP 1 id FROM Schedule WHERE specializationSubjectID = 
     (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = 
         (SELECT TOP 1 id FROM [Subject] WHERE title = N'Органическая химия'))),
 '3', 
 (SELECT TOP 1 id FROM Student WHERE name = N'Виктория Ким')
),
(
 (SELECT TOP 1 id FROM [Subject] WHERE title = N'Ботаника'),
 (SELECT TOP 1 id FROM Teacher WHERE name = N'Преп. Демина'),
 (SELECT TOP 1 id FROM Schedule WHERE specializationSubjectID = 
     (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = 
         (SELECT TOP 1 id FROM [Subject] WHERE title = N'Ботаника'))),
 '2', 
 (SELECT TOP 1 id FROM Student WHERE name = N'Дмитрий Орлов')
),
(
 (SELECT TOP 1 id FROM [Subject] WHERE title = N'Основы программирования'),
 (SELECT TOP 1 id FROM Teacher WHERE name = N'Преп. Егоров'),
 (SELECT TOP 1 id FROM Schedule WHERE specializationSubjectID = 
     (SELECT TOP 1 id FROM SpecializationSubject WHERE subjectID = 
         (SELECT TOP 1 id FROM [Subject] WHERE title = N'Основы программирования'))),
 N'Н/А',
 (SELECT TOP 1 id FROM Student WHERE name = N'Екатерина Лисина')
);
