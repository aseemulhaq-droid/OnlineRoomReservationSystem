<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Restore Access | OceanView</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #2dd4bf; 
            --bg: #020617; 
            --error: #ef4444;
            --success: #10b981;
        }

        /* Smooth Entrance Animation */
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(30px); filter: blur(10px); }
            to { opacity: 1; transform: translateY(0); filter: blur(0); }
        }

        body { 
            background: var(--bg); 
            background-image: radial-gradient(circle at 50% -20%, #1e293b, #020617);
            color: white; 
            font-family: 'Plus Jakarta Sans', sans-serif;
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0;
        }

        .card {
            background: rgba(15, 23, 42, 0.6); 
            backdrop-filter: blur(20px);
            padding: 3rem; 
            border-radius: 2.5rem; 
            border: 1px solid rgba(255, 255, 255, 0.1);
            width: 90%; 
            max-width: 420px; 
            text-align: center;
            animation: slideIn 0.8s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        h2 { font-weight: 800; letter-spacing: -1px; margin-bottom: 0.5rem; }

        /* The Question Box */
        .question-box {
            background: rgba(45, 212, 191, 0.1);
            border: 1px dashed var(--primary);
            padding: 1rem;
            border-radius: 1rem;
            margin: 1.5rem 0;
            color: var(--primary);
            font-size: 0.95rem;
            font-weight: 600;
        }

        .input-group { text-align: left; margin-bottom: 15px; }
        label { font-size: 0.7rem; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; font-weight: 800; margin-left: 5px; }
        
        input {
            width: 100%; padding: 14px; margin: 8px 0; border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1); 
            background: rgba(255, 255, 255, 0.03); 
            color: white;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1);
        }

        .btn {
            width: 100%; padding: 16px; background: var(--primary); color: var(--bg);
            border: none; border-radius: 12px; font-weight: 800; cursor: pointer; 
            transition: all 0.4s ease; margin-top: 10px;
            font-size: 1rem;
        }

        .btn:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 10px 20px -5px rgba(45, 212, 191, 0.4);
            opacity: 0.9;
        }

        /* Toast Popup Styles */
        #toast {
            position: fixed; top: 20px; right: 20px;
            padding: 15px 25px; border-radius: 10px;
            font-weight: 600; z-index: 1000;
            display: none; animation: slideIn 0.5s ease;
        }
    </style>
</head>
<body>

    <div id="toast"></div>

    <div class="card">
        <h2>Account Recovery</h2>
        <p style="color: #94a3b8; font-size: 0.9rem;">Security Verification</p>
        
        <div class="question-box">
            <span style="font-size: 0.7rem; opacity: 0.7; display: block; margin-bottom: 5px;">SECURITY QUESTION:</span>
            "What is your favorite place ?"
        </div>

        <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="POST">
            <div class="input-group">
                <label>Confirm Username</label>
                <input type="text" name="username" placeholder="admin" required>
            </div>

            <div class="input-group">
                <label>Your Answer</label>
                <input type="text" name="answer" placeholder="Enter secret answer" required>
            </div>

            <div class="input-group">
                <label>New Password</label>
                <input type="password" name="newPassword" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn">Update Password</button>
        </form>
        
        <a href="login.jsp" style="display:block; margin-top:25px; color:#64748b; text-decoration:none; font-size:0.85rem; font-weight:600;">← Back to Login</a>
    </div>

    <script>
        // Automatic Popup Script
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const toast = document.getElementById('toast');

            if (urlParams.has('error')) {
                toast.style.display = 'block';
                toast.style.background = '#ef4444'; // Error Red
                toast.innerText = '❌ Invalid Username or Answer!';
                setTimeout(() => toast.style.display = 'none', 4000);
            }
        }
    </script>
</body>
</html>