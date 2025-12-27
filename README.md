🏫 Online Coaching Class Management System

    A full-featured web-based application built using JSP, Servlets, and MySQL that helps manage coaching classes efficiently.
    It provides separate dashboards for Admin, Teachers, and Students, allowing complete digital management of courses, tests, enrollments, and results.

🚀 Features
👩‍💼 Admin Panel

    Dashboard overview (Total Teachers, Students, Courses, Tests)
    Manage Teachers (Add, View, Delete)
    Manage Students (Add, View, Delete)
    Manage Courses (Assign teachers, set fees & schedule)
    Manage Tests (View all tests)
    Change Password

👨‍🏫 Teacher Panel

    Dashboard showing assigned courses, enrolled students, and tests
    Add, edit, and manage test questions
    Schedule tests for courses
    View students’ test performances
    Update personal details and password

👨‍🎓 Student Panel

    Dashboard with quick access to:
    View all courses
    My enrollments
    Pending fees
    Timetable
    Attempt online tests (time-restricted)
    View test results and progress
    Update profile and change password

🧩 Tech Stack

    Category	Technology Used
    Frontend	HTML, CSS, Bootstrap, JSP
    Backend	Java Servlets (JDBC)
    Database	MySQL
    Server	Apache Tomcat
    IDE	Eclipse / IntelliJ IDEA

💾 Database Tables

    admin – stores admin credentials
    student – student info (sid, sname, suser, spass, etc.)
    teacher – teacher info (tid, tname, tuser, tpass, etc.)
    course – course details with assigned teacher
    enroll_courses – student-course enrollments
    test – test scheduling by teachers
    test_questions – questions & options for each test
    student_attempts – stores individual answers
    student_test_results – stores total marks obtained

🧠 Key Functionalities

    Secure login for all roles (Admin, Teacher, Student)
    CRUD operations for teachers, students, and courses
    Dynamic test scheduling & online exam system
    Auto-evaluation of test answers
    Responsive design (works on mobile & desktop)
    Session-based authentication

🏁 Conclusion

    This system efficiently bridges communication between teachers, students, and administrators, making coaching management seamless, organized, and paperless.    
