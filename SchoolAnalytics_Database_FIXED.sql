-- ============================================================
--   SCHOOL VISUAL DATA ANALYTICS SYSTEM
--   SQL Server Database Script - FIXED VERSION
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SchoolAnalyticsDB')
BEGIN
    CREATE DATABASE SchoolAnalyticsDB;
END
GO

USE SchoolAnalyticsDB;
GO

-- Drop tables if exist
IF OBJECT_ID('Activities',  'U') IS NOT NULL DROP TABLE Activities;
IF OBJECT_ID('Attendance',  'U') IS NOT NULL DROP TABLE Attendance;
IF OBJECT_ID('Results',     'U') IS NOT NULL DROP TABLE Results;
IF OBJECT_ID('Students',    'U') IS NOT NULL DROP TABLE Students;
GO

-- TABLE 1: Students
CREATE TABLE Students (
    StudentID       INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(100) NOT NULL,
    Gender          NVARCHAR(10)  NOT NULL,
    Class           INT           NOT NULL,
    Section         NVARCHAR(5)   NOT NULL,
    Age             INT           NOT NULL,
    AdmissionYear   INT           NOT NULL
);
GO

-- TABLE 2: Results
CREATE TABLE Results (
    ResultID        INT PRIMARY KEY IDENTITY(1,1),
    StudentID       INT           NOT NULL REFERENCES Students(StudentID),
    Subject         NVARCHAR(50)  NOT NULL,
    Term            NVARCHAR(20)  NOT NULL,
    MarksObtained   INT           NOT NULL,
    TotalMarks      INT           NOT NULL DEFAULT 100,
    Grade AS (
        CASE
            WHEN (MarksObtained * 100.0 / TotalMarks) >= 90 THEN 'A+'
            WHEN (MarksObtained * 100.0 / TotalMarks) >= 80 THEN 'A'
            WHEN (MarksObtained * 100.0 / TotalMarks) >= 70 THEN 'B'
            WHEN (MarksObtained * 100.0 / TotalMarks) >= 60 THEN 'C'
            WHEN (MarksObtained * 100.0 / TotalMarks) >= 50 THEN 'D'
            ELSE 'F'
        END
    ) PERSISTED
);
GO

-- TABLE 3: Attendance
CREATE TABLE Attendance (
    AttendanceID         INT PRIMARY KEY IDENTITY(1,1),
    StudentID            INT          NOT NULL REFERENCES Students(StudentID),
    Month                NVARCHAR(20) NOT NULL,
    PresentDays          INT          NOT NULL,
    AbsentDays           INT          NOT NULL,
    AttendancePercentage AS (CAST(PresentDays * 100.0 / (PresentDays + AbsentDays) AS DECIMAL(5,2))) PERSISTED
);
GO

-- TABLE 4: Activities
CREATE TABLE Activities (
    ActivityID      INT PRIMARY KEY IDENTITY(1,1),
    StudentID       INT           NOT NULL REFERENCES Students(StudentID),
    ActivityName    NVARCHAR(100) NOT NULL,
    Participation   NVARCHAR(20)  NOT NULL,
    Position        NVARCHAR(50)  NULL
);
GO

-- ============================================================
-- INSERT STUDENTS
-- ============================================================

-- CLASS 1-A (35 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Ahmed Ali','Male',1,'A',6,2024),('Sara Khan','Female',1,'A',6,2024),
('Bilal Hussain','Male',1,'A',7,2024),('Fatima Noor','Female',1,'A',6,2024),
('Usman Tariq','Male',1,'A',7,2024),('Ayesha Malik','Female',1,'A',6,2024),
('Hamza Sheikh','Male',1,'A',7,2024),('Zainab Raza','Female',1,'A',6,2024),
('Omar Farooq','Male',1,'A',7,2024),('Hina Baig','Female',1,'A',6,2024),
('Talha Qureshi','Male',1,'A',7,2024),('Maham Iqbal','Female',1,'A',6,2024),
('Faisal Chaudhry','Male',1,'A',7,2024),('Sana Pervez','Female',1,'A',6,2024),
('Anas Javed','Male',1,'A',7,2024),('Nida Rehman','Female',1,'A',6,2024),
('Zaid Anwar','Male',1,'A',7,2024),('Rabia Sultana','Female',1,'A',6,2024),
('Saad Mehmood','Male',1,'A',7,2024),('Iqra Farhan','Female',1,'A',6,2024),
('Asad Butt','Male',1,'A',7,2024),('Laiba Waqar','Female',1,'A',6,2024),
('Khurram Aziz','Male',1,'A',7,2024),('Maryam Saleem','Female',1,'A',6,2024),
('Shoaib Nawaz','Male',1,'A',7,2024),('Amna Zahid','Female',1,'A',6,2024),
('Rayan Hashmi','Male',1,'A',7,2024),('Sumbal Aslam','Female',1,'A',6,2024),
('Kamran Gillani','Male',1,'A',7,2024),('Aliya Babar','Female',1,'A',6,2024),
('Danyal Siddiqui','Male',1,'A',7,2024),('Tahreem Nasir','Female',1,'A',6,2024),
('Jawad Riaz','Male',1,'A',7,2024),('Hira Shabbir','Female',1,'A',6,2024),
('Muzammil Akram','Male',1,'A',7,2024);

-- CLASS 2-A (30 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Ali Raza','Male',2,'A',8,2023),('Bushra Naz','Female',2,'A',7,2023),
('Noman Iqbal','Male',2,'A',8,2023),('Anam Waheed','Female',2,'A',7,2023),
('Daniyal Yousuf','Male',2,'A',8,2023),('Tooba Arshad','Female',2,'A',7,2023),
('Hasan Zaheer','Male',2,'A',8,2023),('Eman Khalil','Female',2,'A',7,2023),
('Usama Latif','Male',2,'A',8,2023),('Mehwish Tariq','Female',2,'A',7,2023),
('Shahzeb Mirza','Male',2,'A',8,2023),('Nimra Cheema','Female',2,'A',7,2023),
('Waleed Chaudhry','Male',2,'A',8,2023),('Sidra Malik','Female',2,'A',7,2023),
('Ahsan Gul','Male',2,'A',8,2023),('Komal Nisar','Female',2,'A',7,2023),
('Farrukh Sajid','Male',2,'A',8,2023),('Madiha Rafiq','Female',2,'A',7,2023),
('Rehan Zubair','Male',2,'A',8,2023),('Shiza Imran','Female',2,'A',7,2023),
('Mohsin Hayat','Male',2,'A',8,2023),('Lubna Shakeel','Female',2,'A',7,2023),
('Rizwan Akhtar','Male',2,'A',8,2023),('Saira Farooq','Female',2,'A',7,2023),
('Junaid Asghar','Male',2,'A',8,2023),('Nadia Karim','Female',2,'A',7,2023),
('Burhan Afzal','Male',2,'A',8,2023),('Uzma Bashir','Female',2,'A',7,2023),
('Hamid Sultan','Male',2,'A',8,2023),('Aroha Mansoor','Female',2,'A',7,2023);

-- CLASS 3-A (20 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Zubair Ahmed','Male',3,'A',9,2022),('Huda Tauseef','Female',3,'A',8,2022),
('Kashif Rehman','Male',3,'A',9,2022),('Rida Ghani','Female',3,'A',8,2022),
('Saqlain Rao','Male',3,'A',9,2022),('Ushna Pervaiz','Female',3,'A',8,2022),
('Imran Basharat','Male',3,'A',9,2022),('Kiran Shaukat','Female',3,'A',8,2022),
('Nasir Yaqoob','Male',3,'A',9,2022),('Sobia Rauf','Female',3,'A',8,2022),
('Fawad Hamid','Male',3,'A',9,2022),('Mehak Zahid','Female',3,'A',8,2022),
('Salman Ghaffar','Male',3,'A',9,2022),('Ambreen Shahid','Female',3,'A',8,2022),
('Asim Nawab','Male',3,'A',9,2022),('Gulnaz Perveen','Female',3,'A',8,2022),
('Naeem Ullah','Male',3,'A',9,2022),('Samina Anwar','Female',3,'A',8,2022),
('Qasim Dar','Male',3,'A',9,2022),('Haleema Sadia','Female',3,'A',8,2022);

-- CLASS 3-B (15 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Taha Sohail','Male',3,'B',9,2022),('Misbah Ul Haq','Female',3,'B',8,2022),
('Waqas Rafique','Male',3,'B',9,2022),('Noor Fatima','Female',3,'B',8,2022),
('Jawwad Saeed','Male',3,'B',9,2022),('Alisha Noman','Female',3,'B',8,2022),
('Bilal Wahid','Male',3,'B',9,2022),('Madiha Umer','Female',3,'B',8,2022),
('Farhan Durrani','Male',3,'B',9,2022),('Samra Gul','Female',3,'B',8,2022),
('Adnan Moin','Male',3,'B',9,2022),('Zara Siddiq','Female',3,'B',8,2022),
('Saif Ullah','Male',3,'B',9,2022),('Bisma Irfan','Female',3,'B',8,2022),
('Umar Baig','Male',3,'B',9,2022);

-- CLASS 3-C (15 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Zeeshan Khawaja','Male',3,'C',9,2022),('Faria Imtiaz','Female',3,'C',8,2022),
('Luqman Haider','Male',3,'C',9,2022),('Tasmia Riaz','Female',3,'C',8,2022),
('Owais Javed','Male',3,'C',9,2022),('Rubab Shah','Female',3,'C',8,2022),
('Sohaib Aslam','Male',3,'C',9,2022),('Namra Farhan','Female',3,'C',8,2022),
('Kamran Butt','Male',3,'C',9,2022),('Arooj Fatima','Female',3,'C',8,2022),
('Haroon Rashid','Male',3,'C',9,2022),('Shanza Mehmood','Female',3,'C',8,2022),
('Ehtesham Ali','Male',3,'C',9,2022),('Ayesha Zulfiqar','Female',3,'C',8,2022),
('Waqar Nabi','Male',3,'C',9,2022);

-- CLASS 4-A (18 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Shahzad Iqbal','Male',4,'A',10,2021),('Mahnoor Aziz','Female',4,'A',9,2021),
('Zohaib Yousaf','Male',4,'A',10,2021),('Hifza Rehman','Female',4,'A',9,2021),
('Muneeb Ullah','Male',4,'A',10,2021),('Fiza Tariq','Female',4,'A',9,2021),
('Jibran Khan','Male',4,'A',10,2021),('Sundas Malik','Female',4,'A',9,2021),
('Arsalan Shafi','Male',4,'A',10,2021),('Rimsha Noor','Female',4,'A',9,2021),
('Danish Siddiqui','Male',4,'A',10,2021),('Aqsa Zahoor','Female',4,'A',9,2021),
('Shaheer Ansar','Male',4,'A',10,2021),('Fareeha Asif','Female',4,'A',9,2021),
('Abdur Rehman','Male',4,'A',10,2021),('Iram Nawaz','Female',4,'A',9,2021),
('Hasnat Khalid','Male',4,'A',10,2021),('Zobia Waqas','Female',4,'A',9,2021);

-- CLASS 5-A (20 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Adeel Akram','Male',5,'A',11,2020),('Raheela Farooq','Female',5,'A',10,2020),
('Sajid Mehmood','Male',5,'A',11,2020),('Nisha Bajwa','Female',5,'A',10,2020),
('Mujtaba Raza','Male',5,'A',11,2020),('Shama Riaz','Female',5,'A',10,2020),
('Muzahir Shah','Male',5,'A',11,2020),('Sahar Iftikhar','Female',5,'A',10,2020),
('Huzaifa Anwar','Male',5,'A',11,2020),('Zunaira Bashir','Female',5,'A',10,2020),
('Rohail Chaudhry','Male',5,'A',11,2020),('Pakeeza Sultana','Female',5,'A',10,2020),
('Nabeel Akhtar','Male',5,'A',11,2020),('Amber Saleem','Female',5,'A',10,2020),
('Umair Gillani','Male',5,'A',11,2020),('Mariam Asim','Female',5,'A',10,2020),
('Asrar Hussain','Male',5,'A',11,2020),('Qurat Ul Ain','Female',5,'A',10,2020),
('Moeez Elahi','Male',5,'A',11,2020),('Tehseen Bibi','Female',5,'A',10,2020);

-- CLASS 6-A (17 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Fahad Munir','Male',6,'A',12,2019),('Hafsa Nawaz','Female',6,'A',11,2019),
('Shehryar Qazi','Male',6,'A',12,2019),('Anum Rafiq','Female',6,'A',11,2019),
('Saifur Rehman','Male',6,'A',12,2019),('Rukhsar Ilyas','Female',6,'A',11,2019),
('Tabish Mirza','Male',6,'A',12,2019),('Huma Tauseef','Female',6,'A',11,2019),
('Saqib Lodhi','Male',6,'A',12,2019),('Shaista Kiran','Female',6,'A',11,2019),
('Murad Ali','Male',6,'A',12,2019),('Faiza Jabeen','Female',6,'A',11,2019),
('Sheraz Baig','Male',6,'A',12,2019),('Naz Parveen','Female',6,'A',11,2019),
('Majid Nawaz','Male',6,'A',12,2019),('Urwa Tufail','Female',6,'A',11,2019),
('Babar Zaman','Male',6,'A',12,2019);

-- CLASS 7-A (15 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Amir Hamza','Male',7,'A',13,2018),('Kainat Yousuf','Female',7,'A',12,2018),
('Tariq Mahmood','Male',7,'A',13,2018),('Shifa Akhtar','Female',7,'A',12,2018),
('Zulfiqar Ali','Male',7,'A',13,2018),('Tahira Sajid','Female',7,'A',12,2018),
('Asif Nadeem','Male',7,'A',13,2018),('Lubaba Irfan','Female',7,'A',12,2018),
('Ghulam Murtaza','Male',7,'A',13,2018),('Nosheen Qaiser','Female',7,'A',12,2018),
('Attique Rehman','Male',7,'A',13,2018),('Ibtisam Zahid','Female',7,'A',12,2018),
('Khizer Hayat','Male',7,'A',13,2018),('Anila Mukhtar','Female',7,'A',12,2018),
('Faizan Rauf','Male',7,'A',13,2018);

-- CLASS 8-A (16 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Mohsin Raza','Male',8,'A',14,2017),('Saman Arif','Female',8,'A',13,2017),
('Kashan Farooq','Male',8,'A',14,2017),('Sumaira Aziz','Female',8,'A',13,2017),
('Yasir Nawaz','Male',8,'A',14,2017),('Tayyaba Malik','Female',8,'A',13,2017),
('Naveed Ullah','Male',8,'A',14,2017),('Shabana Parveen','Female',8,'A',13,2017),
('Taimoor Shah','Male',8,'A',14,2017),('Raheela Naz','Female',8,'A',13,2017),
('Waseem Akram','Male',8,'A',14,2017),('Farhana Bibi','Female',8,'A',13,2017),
('Asjad Munir','Male',8,'A',14,2017),('Zulaikha Rauf','Female',8,'A',13,2017),
('Shahbaz Gill','Male',8,'A',14,2017),('Asma Hayat','Female',8,'A',13,2017);

-- CLASS 9-A (20 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Syed Hussain','Male',9,'A',15,2016),('Zara Fatima','Female',9,'A',14,2016),
('Abdullah Tariq','Male',9,'A',15,2016),('Rameeza Afzal','Female',9,'A',14,2016),
('Hamid Bashir','Male',9,'A',15,2016),('Shirin Gul','Female',9,'A',14,2016),
('Shahid Latif','Male',9,'A',15,2016),('Nabeela Sadiq','Female',9,'A',14,2016),
('Imtiaz Cheema','Male',9,'A',15,2016),('Shumaila Nawaz','Female',9,'A',14,2016),
('Pervaiz Akhtar','Male',9,'A',15,2016),('Ghazala Sultana','Female',9,'A',14,2016),
('Sikander Ali','Male',9,'A',15,2016),('Mehwish Ilyas','Female',9,'A',14,2016),
('Fawad Baig','Male',9,'A',15,2016),('Shagufta Rani','Female',9,'A',14,2016),
('Sohail Rashid','Male',9,'A',15,2016),('Rukhsana Riaz','Female',9,'A',14,2016),
('Waqar Elahi','Male',9,'A',15,2016),('Samreen Anwar','Female',9,'A',14,2016);

-- CLASS 10-A (14 students)
INSERT INTO Students (Name, Gender, Class, Section, Age, AdmissionYear) VALUES
('Zaid Hamid','Male',10,'A',16,2015),('Amna Shaukat','Female',10,'A',15,2015),
('Sajjad Ul Haq','Male',10,'A',16,2015),('Farah Naz','Female',10,'A',15,2015),
('Asim Iqbal','Male',10,'A',16,2015),('Nazia Parveen','Female',10,'A',15,2015),
('Irfan Haider','Male',10,'A',16,2015),('Tabassum Kiran','Female',10,'A',15,2015),
('Naseem Akhtar','Male',10,'A',16,2015),('Alvina Shah','Female',10,'A',15,2015),
('Rao Shoaib','Male',10,'A',16,2015),('Sehrish Karim','Female',10,'A',15,2015),
('Gulfam Hussain','Male',10,'A',16,2015),('Nazish Rauf','Female',10,'A',15,2015);
GO

-- ============================================================
-- INSERT RESULTS using a single clean loop (no nested cursors)
-- ============================================================
DECLARE @sid INT, @marks INT, @sub NVARCHAR(50), @term NVARCHAR(20), @cls INT;

-- Junior classes (1-3): 5 subjects x 3 terms
DECLARE @juniorSubjects NVARCHAR(MAX) = 'English|Mathematics|Urdu|General Knowledge|Drawing';
DECLARE @terms NVARCHAR(MAX) = '1st Term|Mid Term|Final Term';

DECLARE res_cur CURSOR FOR SELECT StudentID, Class FROM Students;
OPEN res_cur;
FETCH NEXT FROM res_cur INTO @sid, @cls;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @cls BETWEEN 1 AND 3
    BEGIN
        -- English
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','1st Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','Mid Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','Final Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        -- Mathematics
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','1st Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','Mid Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','Final Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        -- Urdu
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','1st Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','Mid Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','Final Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        -- General Knowledge
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'General Knowledge','1st Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'General Knowledge','Mid Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'General Knowledge','Final Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        -- Drawing
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Drawing','1st Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Drawing','Mid Term',45+ABS(CHECKSUM(NEWID()))%56,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Drawing','Final Term',45+ABS(CHECKSUM(NEWID()))%56,100);
    END
    ELSE
    BEGIN
        -- English
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'English','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Mathematics
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Mathematics','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Urdu
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Urdu','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Science
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Science','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Science','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Science','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Social Studies
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Social Studies','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Social Studies','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Social Studies','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Islamiyat
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Islamiyat','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Islamiyat','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Islamiyat','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        -- Computer
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Computer','1st Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Computer','Mid Term',40+ABS(CHECKSUM(NEWID()))%61,100);
        INSERT INTO Results(StudentID,Subject,Term,MarksObtained,TotalMarks) VALUES(@sid,'Computer','Final Term',40+ABS(CHECKSUM(NEWID()))%61,100);
    END
    FETCH NEXT FROM res_cur INTO @sid, @cls;
END
CLOSE res_cur;
DEALLOCATE res_cur;
GO

-- ============================================================
-- INSERT ATTENDANCE (5 months per student)
-- ============================================================
DECLARE @asid INT;
DECLARE att_cur CURSOR FOR SELECT StudentID FROM Students;
OPEN att_cur;
FETCH NEXT FROM att_cur INTO @asid;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @ab INT;
    SET @ab = ABS(CHECKSUM(NEWID())) % 5; INSERT INTO Attendance(StudentID,Month,PresentDays,AbsentDays) VALUES(@asid,'January',  22-@ab,@ab);
    SET @ab = ABS(CHECKSUM(NEWID())) % 5; INSERT INTO Attendance(StudentID,Month,PresentDays,AbsentDays) VALUES(@asid,'February', 20-@ab,@ab);
    SET @ab = ABS(CHECKSUM(NEWID())) % 5; INSERT INTO Attendance(StudentID,Month,PresentDays,AbsentDays) VALUES(@asid,'March',    21-@ab,@ab);
    SET @ab = ABS(CHECKSUM(NEWID())) % 5; INSERT INTO Attendance(StudentID,Month,PresentDays,AbsentDays) VALUES(@asid,'April',    22-@ab,@ab);
    SET @ab = ABS(CHECKSUM(NEWID())) % 5; INSERT INTO Attendance(StudentID,Month,PresentDays,AbsentDays) VALUES(@asid,'May',      20-@ab,@ab);
    FETCH NEXT FROM att_cur INTO @asid;
END
CLOSE att_cur;
DEALLOCATE att_cur;
GO

-- ============================================================
-- INSERT ACTIVITIES
-- ============================================================
DECLARE @act_sid INT, @act_cls INT, @part NVARCHAR(20), @pos NVARCHAR(50);
DECLARE act_cur CURSOR FOR SELECT StudentID, Class FROM Students;
OPEN act_cur;
FETCH NEXT FROM act_cur INTO @act_sid, @act_cls;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF @act_cls BETWEEN 1 AND 3
    BEGIN
        -- Color Day
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Color Day',@part,@pos);
        -- Fruit Day
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Fruit Day',@part,@pos);
        -- Sports Day
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Sports Day',@part,@pos);
        -- Field Trip
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Field Trip',@part,@pos);
    END
    ELSE
    BEGIN
        -- Sports Day
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Sports Day',@part,@pos);
        -- Picnic
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 8 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Picnic',@part,@pos);
        -- Debate Competition
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 7 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Debate Competition',@part,@pos);
        -- Science Exhibition
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 7 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Science Exhibition',@part,@pos);
        -- Art Competition
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 7 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Art Competition',@part,@pos);
        -- Quiz Competition
        SET @part = CASE WHEN ABS(CHECKSUM(NEWID()))%10 < 7 THEN 'Yes' ELSE 'No' END;
        SET @pos  = CASE WHEN @part='No' THEN NULL WHEN ABS(CHECKSUM(NEWID()))%10=0 THEN '1st Place' WHEN ABS(CHECKSUM(NEWID()))%10=1 THEN '2nd Place' WHEN ABS(CHECKSUM(NEWID()))%10=2 THEN '3rd Place' ELSE 'Participant' END;
        INSERT INTO Activities(StudentID,ActivityName,Participation,Position) VALUES(@act_sid,'Quiz Competition',@part,@pos);
    END
    FETCH NEXT FROM act_cur INTO @act_sid, @act_cls;
END
CLOSE act_cur;
DEALLOCATE act_cur;
GO

-- ============================================================
-- VIEWS
-- ============================================================
CREATE OR ALTER VIEW vw_StudentSummary AS
SELECT
    s.StudentID, s.Name, s.Gender, s.Class, s.Section, s.Age, s.AdmissionYear,
    CAST(AVG(CAST(r.MarksObtained AS FLOAT)) AS DECIMAL(5,2)) AS AvgMarks,
    CAST(AVG(CAST(a.AttendancePercentage AS FLOAT)) AS DECIMAL(5,2)) AS AvgAttendance,
    CASE
        WHEN AVG(CAST(r.MarksObtained AS FLOAT)) >= 90 THEN 'A+'
        WHEN AVG(CAST(r.MarksObtained AS FLOAT)) >= 80 THEN 'A'
        WHEN AVG(CAST(r.MarksObtained AS FLOAT)) >= 70 THEN 'B'
        WHEN AVG(CAST(r.MarksObtained AS FLOAT)) >= 60 THEN 'C'
        WHEN AVG(CAST(r.MarksObtained AS FLOAT)) >= 50 THEN 'D'
        ELSE 'F'
    END AS OverallGrade
FROM Students s
LEFT JOIN Results r ON s.StudentID = r.StudentID
LEFT JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.StudentID, s.Name, s.Gender, s.Class, s.Section, s.Age, s.AdmissionYear;
GO

CREATE OR ALTER VIEW vw_ClassSummary AS
SELECT
    s.Class, s.Section,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    CAST(AVG(CAST(r.MarksObtained AS FLOAT)) AS DECIMAL(5,2)) AS ClassAvgMarks,
    CAST(AVG(CAST(a.AttendancePercentage AS FLOAT)) AS DECIMAL(5,2)) AS ClassAvgAttendance,
    SUM(CASE WHEN r.MarksObtained >= 50 THEN 1 ELSE 0 END) * 100 / COUNT(r.ResultID) AS PassPercentage
FROM Students s
LEFT JOIN Results r ON s.StudentID = r.StudentID
LEFT JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.Class, s.Section;
GO

CREATE OR ALTER VIEW vw_SubjectPerformance AS
SELECT
    s.Class, s.Section, r.Subject, r.Term,
    CAST(AVG(CAST(r.MarksObtained AS FLOAT)) AS DECIMAL(5,2)) AS AvgMarks,
    MAX(r.MarksObtained) AS HighestMarks,
    MIN(r.MarksObtained) AS LowestMarks
FROM Students s
JOIN Results r ON s.StudentID = r.StudentID
GROUP BY s.Class, s.Section, r.Subject, r.Term;
GO

CREATE OR ALTER VIEW vw_ActivitySummary AS
SELECT
    s.Class, s.Section, a.ActivityName,
    COUNT(CASE WHEN a.Participation = 'Yes' THEN 1 END) AS Participants,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    COUNT(CASE WHEN a.Position = '1st Place' THEN 1 END) AS FirstPlace,
    COUNT(CASE WHEN a.Position = '2nd Place' THEN 1 END) AS SecondPlace,
    COUNT(CASE WHEN a.Position = '3rd Place' THEN 1 END) AS ThirdPlace
FROM Students s
JOIN Activities a ON s.StudentID = a.StudentID
GROUP BY s.Class, s.Section, a.ActivityName;
GO

PRINT 'SchoolAnalyticsDB created successfully with 255 students, results, attendance, and activities!';
GO
