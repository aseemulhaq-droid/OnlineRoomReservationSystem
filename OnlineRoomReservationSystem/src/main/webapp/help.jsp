<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>OceanView | Help Center</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        :root {
            --bg: #020617;
            --card: #0f172a;
            --teal: #2dd4bf;
            --text: #f1f5f9;
            --dim: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 50px 10%;
            scroll-behavior: smooth;
            overflow-x: hidden; /* Prevents side scroll during animations */
        }

        .help-header { text-align: center; margin-bottom: 60px; }
        .help-header h1 { font-size: 2.5rem; font-weight: 800; letter-spacing: -1px; }
        .help-header p { color: var(--teal); font-weight: 600; text-transform: uppercase; letter-spacing: 2px; }

        /* --- Help Section --- */
        .help-section {
            background: var(--card);
            border-radius: 30px;
            padding: 40px;
            border: 1px solid var(--border);
            margin-bottom: 60px; /* Increased margin for better spacing */
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
            transition: 0.3s;
            position: relative;
        }

        /* Subtle Glow on Hover */
        .help-section:hover {
            border-color: var(--teal);
            box-shadow: 0 0 30px rgba(45, 212, 191, 0.05);
        }

        .help-content h2 { font-size: 1.8rem; margin-bottom: 20px; color: var(--teal); }
        .help-content p { color: var(--dim); margin-bottom: 15px; line-height: 1.6; }
        .help-content ul { list-style: none; padding: 0; }
        .help-content li { margin-bottom: 12px; display: flex; align-items: flex-start; gap: 10px; font-weight: 500; }
        .help-content li i { color: var(--teal); font-size: 0.9rem; margin-top: 4px; }

        /* --- Screenshot Placeholder --- */
        .screenshot-box {
            background: #1e293b;
            border-radius: 20px;
            overflow: hidden;
            border: 4px solid var(--border);
            box-shadow: 0 20px 40px rgba(0,0,0,0.5);
            transition: 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .screenshot-box:hover { 
            transform: scale(1.05) rotate(1deg); 
            border-color: var(--teal); 
        }

        .screenshot-box img {
            width: 100%;
            height: auto;
            display: block;
            opacity: 0.9;
            filter: grayscale(10%);
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--dim);
            text-decoration: none;
            font-weight: 700;
            transition: 0.3s;
        }
        .back-link:hover { color: var(--teal); transform: translateX(-5px); }

        @media (max-width: 900px) {
            .help-section { grid-template-columns: 1fr; }
            body { padding: 30px 5%; }
        }
    </style>
</head>
<body>

    <div class="help-header" data-aos="fade-down" data-aos-duration="1000">
        <p>User Guide & Support</p>
        <h1> OceanView Elite</h1>
        <a href="dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i>  Back </a>
    </div>

    <div class="help-section" data-aos="fade-right">
        <div class="help-content">
            <h2>1. Secure Access</h2>
            <p>Your journey begins at the secure login gateway.</p>
            <ul>
                <li><i class="fas fa-shield-alt"></i> <b>Credentials:</b> Enter your assigned Username and Password.</li>
                <li><i class="fas fa-user-tag"></i> <b>Roles:</b> Access levels are restricted (Only Admin ).</li>
                <li><i class="fas fa-key"></i> <b>Session Safety:</b> For security, sessions expire after inactivity.</li>
            </ul>
        </div>
        <div class="screenshot-box" data-aos="zoom-in" data-aos-delay="200">
            <img src="assets/img/help/login_ss.png" alt="Login Page Screenshot">
        </div>
    </div>

    <div class="help-section" style="direction: rtl; text-align: left;" data-aos="fade-left">
        <div class="help-content" style="direction: ltr;">
            <h2>2. The Dashboard</h2>
            <p>Your central command center for all hotel operations.</p>
            <ul>
                <li><i class="fas fa-chart-line"></i> <b>Live Stats:</b> Monitor revenue and bookings instantly.</li>
                <li><i class="fas fa-bed"></i> <b>Inventory:</b> Check room status via the visual capacity bars.</li>
                <li><i class="fas fa-history"></i> <b>Quick Actions:</b> Navigate with the sidebar menu.</li>
            </ul>
        </div>
        <div class="screenshot-box" data-aos="zoom-in" data-aos-delay="200">
            <img src="assets/img/help/dashboard_ss.png" alt="Dashboard Screenshot">
        </div>
    </div>

    <div class="help-section" data-aos="fade-right">
        <div class="help-content">
            <h2>3. Creating a Booking</h2>
            <p>Efficiently register new guests with automated pricing.</p>
            <ul>
                <li><i class="fas fa-user-plus"></i> Fill in the guest identity and contact details.</li>
                <li><i class="fas fa-calendar-check"></i> Choose stay dates and room categories.</li>
                <li><i class="fas fa-calculator"></i> Price is computed based on nights and room type.</li>
            </ul>
        </div>
        <div class="screenshot-box" data-aos="zoom-in" data-aos-delay="200">
            <img src="assets/img/help/add_res_ss.png" alt="Add Reservation Screenshot">
        </div>
    </div>

    <div class="help-section" style="direction: rtl; text-align: left;" data-aos="fade-left">
        <div class="help-content" style="direction: ltr;">
            <h2>4. Payments & Invoices</h2>
            <p>Handle checkouts and payments with total accuracy.</p>
            <ul>
                <li><i class="fas fa-file-invoice-dollar"></i> Generate bills directly from the Reservations table.</li>
                <li><i class="fas fa-credit-card"></i> Process payments via <b>Cash, Credit, or Debit Card</b>.</li>
                <li><i class="fas fa-print"></i> Provide guests with professional receipts.</li>
            </ul>
        </div>
        <div class="screenshot-box" data-aos="zoom-in" data-aos-delay="200">
            <img src="assets/img/help/billing_ss.png" alt="Billing Screenshot">
        </div>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize animations with specific settings
        AOS.init({
            duration: 800, // Animation speed
            once: true,    // Animation only happens once (when scrolling down)
            offset: 100    // Distance from the viewport to trigger animation
        });
    </script>
</body>
</html>