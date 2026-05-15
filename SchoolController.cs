using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;

namespace SchoolAnalyticsAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SchoolController : ControllerBase
    {
        private readonly string _connStr;

        public SchoolController(IConfiguration config)
        {
            _connStr = config.GetConnectionString("DefaultConnection")!;
        }

        // ── helper ──────────────────────────────────────────────
        private List<Dictionary<string, object?>> Query(string sql, SqlParameter[]? prms = null)
        {
            var rows = new List<Dictionary<string, object?>>();
            using var con = new SqlConnection(_connStr);
            using var cmd = new SqlCommand(sql, con);
            if (prms != null) cmd.Parameters.AddRange(prms);
            con.Open();
            using var rd = cmd.ExecuteReader();
            while (rd.Read())
            {
                var row = new Dictionary<string, object?>();
                for (int i = 0; i < rd.FieldCount; i++)
                    row[rd.GetName(i)] = rd.IsDBNull(i) ? null : rd.GetValue(i);
                rows.Add(row);
            }
            return rows;
        }

        // ── 1. SEARCH STUDENT by name or ID ─────────────────────
        // GET /api/school/student?search=Ali
        // GET /api/school/student?search=5
        [HttpGet("student")]
        public IActionResult GetStudent([FromQuery] string search)
        {
            if (string.IsNullOrWhiteSpace(search))
                return BadRequest(new { message = "Please provide a name or student ID." });

            // Profile
            var profileSql = @"
                SELECT StudentID, Name, Gender, Class, Section, Age, AdmissionYear,
                       AvgMarks, AvgAttendance, OverallGrade
                FROM vw_StudentSummary
                WHERE CAST(StudentID AS NVARCHAR) = @s OR Name LIKE '%' + @s + '%'";

            var profiles = Query(profileSql, new[] { new SqlParameter("@s", search) });

            if (profiles.Count == 0)
                return NotFound(new { message = "No student found." });

            // If multiple matches return list so frontend can pick
            if (profiles.Count > 1)
                return Ok(new { multiple = true, students = profiles });

            var sid = profiles[0]["StudentID"];

            // Marks per subject per term
            var marksSql = @"
                SELECT Subject, Term, MarksObtained, TotalMarks, Grade
                FROM Results WHERE StudentID = @sid
                ORDER BY Subject, Term";
            var marks = Query(marksSql, new[] { new SqlParameter("@sid", sid) });

            // Attendance per month
            var attSql = @"
                SELECT Month, PresentDays, AbsentDays, AttendancePercentage
                FROM Attendance WHERE StudentID = @sid";
            var attendance = Query(attSql, new[] { new SqlParameter("@sid", sid) });

            // Activities
            var actSql = @"
                SELECT ActivityName, Participation, Position
                FROM Activities WHERE StudentID = @sid";
            var activities = Query(actSql, new[] { new SqlParameter("@sid", sid) });

            return Ok(new
            {
                profile    = profiles[0],
                marks      = marks,
                attendance = attendance,
                activities = activities
            });
        }

        // ── 2. CLASS ANALYTICS ───────────────────────────────────
        // GET /api/school/class/5/A
        [HttpGet("class/{classNum}/{section}")]
        public IActionResult GetClass(int classNum, string section)
        {
            // Summary
            var summarySql = @"
                SELECT * FROM vw_ClassSummary
                WHERE Class = @c AND Section = @s";
            var summary = Query(summarySql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            // Top 5 students
            var topSql = @"
                SELECT TOP 5 Name, AvgMarks, OverallGrade
                FROM vw_StudentSummary
                WHERE Class = @c AND Section = @s
                ORDER BY AvgMarks DESC";
            var topStudents = Query(topSql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            // Weak students (avg < 50)
            var weakSql = @"
                SELECT Name, AvgMarks, OverallGrade
                FROM vw_StudentSummary
                WHERE Class = @c AND Section = @s AND AvgMarks < 50
                ORDER BY AvgMarks ASC";
            var weakStudents = Query(weakSql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            // Subject performance (Final Term)
            var subjectSql = @"
                SELECT Subject, AvgMarks, HighestMarks, LowestMarks
                FROM vw_SubjectPerformance
                WHERE Class = @c AND Section = @s AND Term = 'Final Term'
                ORDER BY Subject";
            var subjects = Query(subjectSql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            // All students list
            var allSql = @"
                SELECT StudentID, Name, Gender, AvgMarks, AvgAttendance, OverallGrade
                FROM vw_StudentSummary
                WHERE Class = @c AND Section = @s
                ORDER BY Name";
            var allStudents = Query(allSql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            // Activity participation
            var actSql = @"
                SELECT ActivityName, Participants, TotalStudents, FirstPlace, SecondPlace, ThirdPlace
                FROM vw_ActivitySummary
                WHERE Class = @c AND Section = @s";
            var activities = Query(actSql, new[] {
                new SqlParameter("@c", classNum),
                new SqlParameter("@s", section)
            });

            if (summary.Count == 0)
                return NotFound(new { message = $"Class {classNum}-{section} not found." });

            return Ok(new
            {
                summary      = summary[0],
                topStudents  = topStudents,
                weakStudents = weakStudents,
                subjects     = subjects,
                allStudents  = allStudents,
                activities   = activities
            });
        }

        // ── 3. SCHOOL DASHBOARD ──────────────────────────────────
        // GET /api/school/dashboard
        [HttpGet("dashboard")]
        public IActionResult GetDashboard()
        {
            // KPI cards
            var kpiSql = @"
                SELECT
                    COUNT(DISTINCT StudentID)                        AS TotalStudents,
                    CAST(AVG(AvgMarks) AS DECIMAL(5,2))             AS SchoolAvgMarks,
                    CAST(AVG(AvgAttendance) AS DECIMAL(5,2))        AS SchoolAvgAttendance,
                    SUM(CASE WHEN OverallGrade != 'F' THEN 1 ELSE 0 END) * 100
                        / COUNT(StudentID)                          AS PassPercentage
                FROM vw_StudentSummary";
            var kpi = Query(kpiSql);

            // Best class
            var bestClassSql = @"
                SELECT TOP 1 Class, Section, ClassAvgMarks
                FROM vw_ClassSummary ORDER BY ClassAvgMarks DESC";
            var bestClass = Query(bestClassSql);

            // All classes summary
            var classesSql = @"
                SELECT Class, Section, TotalStudents, ClassAvgMarks,
                       ClassAvgAttendance, PassPercentage
                FROM vw_ClassSummary ORDER BY Class, Section";
            var classes = Query(classesSql);

            // Top 10 students school-wide
            var topSql = @"
                SELECT TOP 10 Name, Class, Section, AvgMarks, OverallGrade
                FROM vw_StudentSummary ORDER BY AvgMarks DESC";
            var topStudents = Query(topSql);

            // Activity participation rate school-wide
            var actSql = @"
                SELECT ActivityName,
                       SUM(Participants)   AS TotalParticipants,
                       SUM(TotalStudents)  AS TotalStudents
                FROM vw_ActivitySummary
                GROUP BY ActivityName";
            var activities = Query(actSql);

            return Ok(new
            {
                kpi         = kpi.Count > 0 ? kpi[0] : null,
                bestClass   = bestClass.Count > 0 ? bestClass[0] : null,
                classes     = classes,
                topStudents = topStudents,
                activities  = activities
            });
        }

        // ── 4. ACTIVITY SEARCH ───────────────────────────────────
        // GET /api/school/activity/Sports Day
        [HttpGet("activity/{activityName}")]
        public IActionResult GetActivity(string activityName)
        {
            var detailSql = @"
                SELECT s.Name, s.Class, s.Section, a.Participation, a.Position
                FROM Activities a
                JOIN Students s ON a.StudentID = s.StudentID
                WHERE a.ActivityName = @a
                ORDER BY a.Position, s.Class, s.Name";
            var details = Query(detailSql, new[] { new SqlParameter("@a", activityName) });

            var statsSql = @"
                SELECT ActivityName,
                       SUM(Participants)  AS TotalParticipants,
                       SUM(TotalStudents) AS TotalStudents,
                       SUM(FirstPlace)    AS FirstPlace,
                       SUM(SecondPlace)   AS SecondPlace,
                       SUM(ThirdPlace)    AS ThirdPlace
                FROM vw_ActivitySummary
                WHERE ActivityName = @a
                GROUP BY ActivityName";
            var stats = Query(statsSql, new[] { new SqlParameter("@a", activityName) });

            var classwiseSql = @"
                SELECT Class, Section, Participants, TotalStudents
                FROM vw_ActivitySummary
                WHERE ActivityName = @a
                ORDER BY Class, Section";
            var classwise = Query(classwiseSql, new[] { new SqlParameter("@a", activityName) });

            if (details.Count == 0)
                return NotFound(new { message = $"Activity '{activityName}' not found." });

            return Ok(new
            {
                stats     = stats.Count > 0 ? stats[0] : null,
                classwise = classwise,
                details   = details
            });
        }

        // ── 5. ALL ACTIVITIES LIST ───────────────────────────────
        // GET /api/school/activities
        [HttpGet("activities")]
        public IActionResult GetActivities()
        {
            var sql = "SELECT DISTINCT ActivityName FROM Activities ORDER BY ActivityName";
            return Ok(Query(sql));
        }

        // ── 6. ALL CLASSES LIST ──────────────────────────────────
        // GET /api/school/classes
        [HttpGet("classes")]
        public IActionResult GetClasses()
        {
            var sql = "SELECT DISTINCT Class, Section FROM Students ORDER BY Class, Section";
            return Ok(Query(sql));
        }
    }
}