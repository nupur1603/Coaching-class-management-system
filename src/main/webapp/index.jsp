<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Coaching Classes | Excellence in Education</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background: #f4f4f4;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Header */
        .header {
            background: linear-gradient(90deg, #6a11cb, #2575fc); /* Gradient Effect */
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .logo img {
            width: 40px;
            margin-right: 10px;
        }

        .header-buttons a {
            background: white;
            color: #6a11cb;
            font-weight: bold;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            margin: 0 5px;
            display: inline-block;
            transition: all 0.3s ease-in-out;
        }

        .header-buttons a:hover {
            background: #2575fc;
            color: white;
            transform: scale(1.1);
        }

        /* Hero Section */
        .hero {
            background: url('images/bg_image.jpg') no-repeat center center/cover;
            color: white;
            text-align: center;
            padding: 150px 20px;
            flex-grow: 1;
            position: relative;
            animation: fadeIn 2s ease-in-out;
        }

        .hero h1 {
            font-size: 45px;
            font-weight: bold;
            animation: slideIn 1s ease-in-out;
        }

        .hero p {
            font-size: 20px;
            margin-top: 10px;
            opacity: 0;
            animation: fadeIn 1.5s ease-in-out forwards;
        }

        .hero .cta-buttons {
            margin-top: 20px;
        }

        .hero .btn {
            background: white;
            color: #6a11cb;
            font-weight: bold;
            padding: 12px 20px;
            border-radius: 30px;
            text-decoration: none;
            margin: 10px;
            display: inline-block;
            transition: 0.3s;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .hero .btn:hover {
            background: #2575fc;
            color: white;
            transform: scale(1.1);
        }

        /* Features Section */
        .features {
            background: white;
            padding: 60px 20px;
            text-align: center;
            animation: fadeInUp 1s ease-in-out;
        }

        .features h2 {
            color: #6a11cb;
            margin-bottom: 30px;
        }

        .feature-box {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
        }

        .feature {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            width: 300px;
            text-align: center;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease-in-out;
        }

        .feature:hover {
            transform: translateY(-10px);
        }

        .feature i {
            font-size: 45px;
            color: #6a11cb;
            margin-bottom: 10px;
        }

        /* Testimonials Section */
        .testimonials {
            background: #6a11cb;
            color: white;
            text-align: center;
            padding: 60px 20px;
            animation: fadeInUp 1.5s ease-in-out;
        }

        .testimonials h2 {
            margin-bottom: 30px;
        }

        .testimonial {
            width: 80%;
            margin: auto;
            background: white;
            color: #6a11cb;
            padding: 20px;
            border-radius: 10px;
            font-style: italic;
            box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.2);
        }

        /* Footer */
        .footer {
            background: #222;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }

        .footer a {
            color: #00bfff;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes fadeInUp {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>



    <!-- Header -->
    <div class="header">
        <div class="logo">
            <img src="https://cdn-icons-png.flaticon.com/512/1903/1903162.png" alt="Logo">
            ABC Coaching Classes
        </div>
        <div class="header-buttons">
            <a href="adminLogin.jsp">Admin Login</a>
            <a href="teacherLogin.jsp">Teacher Login</a>
            <a href="studentLogin.jsp">Student Login</a>
        </div>
    </div>

    <!-- Hero Section -->
    <div class="hero">
        <h1>Empowering Students for a Brighter Future</h1>
        <p>Join our coaching classes and achieve academic excellence with expert guidance.</p>
        <div class="cta-buttons">
            <a href="courses.jsp" class="btn">View Courses</a>
        </div>
    </div>

    <!-- Features Section -->
    <div class="features">
        <h2>Why Choose ABC Coaching Classes?</h2>
        <div class="feature-box">
            <div class="feature">
                <i class="fas fa-user-graduate"></i>
                <h4>Expert Faculty</h4>
                <p>Our instructors are highly experienced and dedicated to student success.</p>
            </div>
            <div class="feature">
                <i class="fas fa-book"></i>
                <h4>Comprehensive Courses</h4>
                <p>We offer a wide range of courses to help students excel academically.</p>
            </div>
            <div class="feature">
                <i class="fas fa-chalkboard-teacher"></i>
                <h4>Personalized Learning</h4>
                <p>Get individual attention with small class sizes and dedicated mentors.</p>
            </div>
        </div>
    </div>

    <!-- Testimonials Section -->
    <div class="testimonials">
        <h2>What Our Students Say</h2>
        <div class="testimonial">
            <p>"ABC Coaching has transformed my learning experience. The teachers are very supportive!"</p>
            <strong>- Unmesh Dudharkar </strong>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>📍 Address: 123, Main Street, City, Country</p>
        <p>📞 Phone: +123-456-7890 | ✉️ Email: <a href="mailto:info@coachingclass.com">info@coachingclass.com</a></p>
        <p>&copy; 2024 ABC Coaching Classes. All rights reserved.</p>
    </div>

    <!-- Bootstrap Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
