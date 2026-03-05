<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #0f172a;
            --teal-accent: #2dd4bf;
            --glass-bg: rgba(15, 23, 42, 0.75);
            --glass-border: rgba(255, 255, 255, 0.1);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(rgba(15, 23, 42, 0.6), rgba(15, 23, 42, 0.6)), 
                        url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .login-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 28px;
            padding: 50px 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            color: white;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-header { text-align: center; margin-bottom: 35px; }
        .login-header h1 { font-size: 2rem; font-weight: 800; letter-spacing: -1px; margin-bottom: 5px; }
        .login-header h1 span { color: var(--teal-accent); }
        .login-header p { font-weight: 400; font-size: 0.9rem; color: #94a3b8; }

        .form-group { margin-bottom: 22px; position: relative; }
        .form-group i { position: absolute; left: 18px; top: 43px; color: var(--teal-accent); font-size: 1rem; }

        label { display: block; margin-bottom: 8px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: #94a3b8; }

        .form-control {
            width: 100%;
            padding: 14px 15px 14px 50px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
            color: white;
            font-size: 0.95rem;
            outline: none;
            transition: 0.3s;
        }
        .form-control:focus { border-color: var(--teal-accent); background: rgba(255, 255, 255, 0.1); }

        .btn-login {
            width: 100%;
            padding: 15px;
            background: var(--teal-accent);
            border: none;
            border-radius: 14px;
            color: var(--primary);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(45, 212, 191, 0.3); }

        .alert { padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 0.85rem; text-align: center; }
        .alert-error { background: rgba(248, 113, 113, 0.15); border: 1px solid rgba(248, 113, 113, 0.3); color: #f87171; }
        .alert-success { background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.3); color: #34d399; }

        /* --- New Options Layout --- */
        .login-footer-links {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .footer-btn {
            text-decoration: none;
            color: #94a3b8;
            font-size: 0.8rem;
            font-weight: 600;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .footer-btn:hover { color: white; }
        .footer-btn i { color: var(--teal-accent); }
    </style>
</head>
<body>
      <% if ("success".equals(request.getParameter("reset"))) { %>
    <div id="successToast" style="position:fixed; top:20px; right:20px; background:#10b981; color:white; padding:15px 25px; border-radius:12px; font-weight:800; z-index:1000; box-shadow: 0 10px 15px rgba(0,0,0,0.3); animation: slideIn 0.5s ease;">
        ✅ Password Updated Successfully!
    </div>
    <script>
        setTimeout(() => { document.getElementById('successToast').style.display='none'; }, 4000);
    </script>
    <% } %>

    <div class="login-card">
        <div class="login-header">
            <h1>🏖️ Ocean<span>View</span></h1>
            <p>Staff & Administrator Portal</p>
        </div>
        
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String message = request.getParameter("message");
            
            if (errorMessage != null) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <%
            }
            if ("logout".equals(message)) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Logged out successfully.
            </div>
        <%
            }
        %>
        
        <form action="LoginServlet" method="post">
            <input type="hidden" name="action" value="login">
            
            <div class="form-group">
                <label for="username">User ID</label>
                <i class="fas fa-user-shield"></i>
                <input type="text" id="username" name="username" class="form-control" placeholder="Enter ID" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">Security Password</label>
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            
            
            <button type="submit" class="btn-login">
                Login to System <i class="fas fa-arrow-right"></i>
            </button>
        </form>
        
        
            <div style="margin-top: 20px; text-align: center;">
                 <a href="forgot_password.jsp" style="color: #94a3b8; text-decoration: none; font-size: 0.85rem;">
                  Forgot Password? <span style="color: #2dd4bf; font-weight: 600;">Reset here</span>
                 </a>
            </div>
        
        <div class="login-footer-links">
            <a href="index.jsp" class="footer-btn">
                <i class="fas fa-home"></i> Home Page
            </a>
            <a href="help.jsp" class="footer-btn">
                <i class="fas fa-question-circle"></i> Need Help?
            </a>
        </div>
    </div>

</body>
</html>