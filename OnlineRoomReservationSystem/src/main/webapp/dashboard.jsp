<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, dao.*, java.util.*" %>
<%
    // LOGIC REMAINS STABLE
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    
    ReservationDAO reservationDAO = new ReservationDAO();
    RoomDAO roomDAO = new RoomDAO();
    String role = (String) session.getAttribute("role");
    
    List<Reservation> userReservations;
    if ("admin".equals(role)) {
        userReservations = reservationDAO.getAllReservations();
    } else {
        int userId = (int) session.getAttribute("userId");
        userReservations = reservationDAO.getReservationsByUserId(userId);
    }
    
    int confirmedCount = (int) userReservations.stream().filter(r -> "Confirmed".equals(r.getReservationStatus())).count();
    int pendingCount = (int) userReservations.stream().filter(r -> "Pending".equals(r.getReservationStatus())).count();
    int cancelledCount = (int) userReservations.stream().filter(r -> "Cancelled".equals(r.getReservationStatus())).count();
    double totalRevenue = userReservations.stream().filter(r -> "Confirmed".equals(r.getReservationStatus())).mapToDouble(Reservation::getTotalAmount).sum();

    int totalRooms = roomDAO.getAllRooms().size();
    int occupancyPercent = (totalRooms > 0) ? (confirmedCount * 100 / totalRooms) : 0;
    int pendingPercent = (totalRooms > 0) ? (pendingCount * 100 / totalRooms) : 0;
    List<Reservation> recentReservations = userReservations.size() > 5 ? userReservations.subList(0, 5) : userReservations;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView | Elite Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --bg: #020617; --card: #0f172a; --teal: #2dd4bf;
            --text: #f8fafc; --dim: #94a3b8; --border: rgba(255, 255, 255, 0.08);
            --danger: #f87171; --warning: #fbbf24; --glass: rgba(15, 23, 42, 0.7);
        }

        /* --- ADVANCED ANIMATIONS --- */
        @keyframes slideInSidebar { 0% { transform: translateX(-100%); } 100% { transform: translateX(0); } }
        @keyframes fadeInUp { 0% { transform: translateY(30px); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
        @keyframes progressFill { from { width: 0; } }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: var(--text); display: flex; overflow-x: hidden; }

        /* --- SIDEBAR: HELP LINK RESTORED --- */
        .sidebar {
            width: 280px; background: #000; height: 100vh; position: fixed; left: 0; top: 0;
            padding: 40px 24px; border-right: 1px solid var(--border);
            display: flex; flex-direction: column; animation: slideInSidebar 0.8s cubic-bezier(0.2, 1, 0.2, 1); z-index: 1000;
        }
        .logo { font-size: 1.6rem; font-weight: 800; color: var(--teal); margin-bottom: 50px; display: flex; align-items: center; gap: 12px; }
        .nav-links { flex-grow: 1; }
        .nav-item {
            text-decoration: none; color: var(--dim); padding: 16px; border-radius: 16px;
            display: flex; align-items: center; gap: 14px; margin-bottom: 8px; font-weight: 600; transition: 0.3s;
        }
        .nav-item:hover { background: rgba(255,255,255,0.05); color: #fff; transform: translateX(5px); }
        .nav-item.active { background: var(--teal); color: var(--bg); box-shadow: 0 10px 30px rgba(45, 212, 191, 0.2); }

        /* --- CONTENT WRAPPER --- */
        .main { margin-left: 280px; width: calc(100% - 280px); padding: 60px; }
        .header { margin-bottom: 50px; animation: fadeInUp 0.8s ease; }

        /* --- ELITE STAT CARDS --- */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 40px; }
        .stat-card {
            background: var(--card); padding: 30px; border-radius: 28px; border: 1px solid var(--border);
            animation: fadeInUp 0.8s ease both; transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .stat-card:hover { transform: translateY(-10px); border-color: var(--teal); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .stat-val { font-size: 2.2rem; font-weight: 800; display: block; margin-top: 8px; }
        .stat-label { color: var(--dim); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; }

        /* --- PANELS --- */
        .panel-grid { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 30px; animation: fadeInUp 1s ease both; }
        .panel { background: var(--glass); backdrop-filter: blur(20px); border-radius: 32px; padding: 40px; border: 1px solid var(--border); }
        
        /* --- PROGRESS --- */
        .bar-bg { width: 100%; height: 10px; background: rgba(0,0,0,0.3); border-radius: 10px; overflow: hidden; margin-top: 12px; }
        .bar-fill { height: 100%; border-radius: 10px; animation: progressFill 1.5s ease-out; }

        .guest-row { display: flex; align-items: center; justify-content: space-between; padding: 15px 0; border-bottom: 1px solid var(--border); }
        .avatar { width: 44px; height: 44px; background: #1e293b; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 800; color: var(--teal); }
        
        .btn-main {
            display: block; width: 100%; padding: 18px; background: #fff; color: #000;
            text-align: center; text-decoration: none; border-radius: 16px; font-weight: 800; transition: 0.3s;
        }
        .btn-main:hover { background: var(--teal); transform: scale(1.02); }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo"><i class="fa-solid fa-droplet"></i> OceanView</div>
        <nav class="nav-links">
            <a href="dashboard.jsp" class="nav-item active"><i class="fa-solid fa-grid-2"></i> Overview</a>
            <a href="addReservation.jsp" class="nav-item"><i class="fa-solid fa-plus-circle"></i> New Reserve</a>
            <a href="viewReservation.jsp" class="nav-item"><i class="fa-solid fa-shield-halved"></i> Reservations</a>
            <a href="help.jsp" class="nav-item"><i class="fa-solid fa-circle-question"></i> Help</a>
        </nav>
        <div style="margin-top: auto;">
            <form action="LoginServlet" method="post">
                <input type="hidden" name="action" value="logout">
                <button type="submit" style="background:none; border:1px solid var(--danger); color:var(--danger); width:100%; padding:14px; border-radius:14px; cursor:pointer; font-weight:700;">
                    <i class="fa-solid fa-power-off"></i> Logout
                </button>
            </form>
        </div>
    </aside>

    <main class="main">
        <header class="header">
            <p style="color: var(--teal); font-weight: 800; letter-spacing: 4px;">AH - 27 ♡</p>
            <h1 style="font-size: 2.8rem; letter-spacing: -1.5px;">System Intelligence</h1>
        </header>

        <div class="stats-grid">
            <div class="stat-card" style="animation-delay: 0.1s;">
                <span class="stat-label">Total Revenue</span>
                <span class="stat-val" style="color: var(--teal);">LKR <%= String.format("%.0f", totalRevenue) %></span>
            </div>
            <div class="stat-card" style="animation-delay: 0.2s;">
                <span class="stat-label">Pending Approval</span>
                <span class="stat-val" style="color: var(--warning);"><%= pendingCount %></span>
            </div>
            <div class="stat-card" style="animation-delay: 0.3s;">
                <span class="stat-label">Cancelled</span>
                <span class="stat-val" style="color: var(--danger);"><%= cancelledCount %></span>
            </div>
            <div class="stat-card" style="animation-delay: 0.4s;">
                <span class="stat-label">Confirmed Stays</span>
                <span class="stat-val"><%= confirmedCount %></span>
            </div>
        </div>

        <div class="panel-grid">
            <div style="display: flex; flex-direction: column; gap: 30px;">
                <div class="panel">
                    <h3 style="margin-bottom: 25px; font-weight: 800;">Booking Velocity</h3>
                    <canvas id="liveChart" style="max-height: 250px;"></canvas>
                </div>
                
                <div class="panel">
                    <h3 style="margin-bottom: 20px; font-weight: 800;">Recent Stream</h3>
                    <% for (Reservation res : recentReservations) { %>
                    <div class="guest-row">
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <div class="avatar"><%= res.getGuestName().substring(0,1) %></div>
                            <div>
                                <p style="font-weight: 700; font-size: 1.05rem;"><%= res.getGuestName() %></p>
                                <p style="color: var(--dim); font-size: 0.8rem;">Suite <%= res.getRoomNumber() %></p>
                            </div>
                        </div>
                        <span style="color: <%= "Confirmed".equals(res.getReservationStatus()) ? "var(--teal)" : "var(--warning)" %>; font-size: 0.7rem; font-weight: 800; letter-spacing: 1px;">
                            <%= res.getReservationStatus().toUpperCase() %>
                        </span>
                    </div>
                    <% } %>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: 30px;">
                <div class="panel">
                    <h3 style="margin-bottom: 30px; font-weight: 800;">Resource Load</h3>
                    <div class="inv-item" style="margin-bottom: 25px;">
                        <div style="display:flex; justify-content:space-between; font-weight:700;"><span>Confirmed Occupancy</span><span><%= occupancyPercent %>%</span></div>
                        <div class="bar-bg"><div class="bar-fill" style="width: <%= occupancyPercent %>%; background: var(--teal);"></div></div>
                    </div>
                    <div class="inv-item">
                        <div style="display:flex; justify-content:space-between; font-weight:700;"><span>Pending Request Flow</span><span><%= pendingPercent %>%</span></div>
                        <div class="bar-bg"><div class="bar-fill" style="width: <%= pendingPercent %>%; background: var(--warning);"></div></div>
                    </div>
                </div>

                <div class="panel" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);">
                    <h3 style="font-weight: 800; margin-bottom: 10px;">Quick Deployment</h3>
                    <p style="color: var(--dim); font-size: 0.85rem; margin-bottom: 25px;">Instantly add a new guest reservation to the system.</p>
                    <a href="addReservation.jsp" class="btn-main">Launch New Entry</a>
                </div>
            </div>
        </div>
    </main>

    <script>
        const ctx = document.getElementById('liveChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                datasets: [{
                    data: [3, 9, 6, <%= confirmedCount %>],
                    borderColor: '#2dd4bf',
                    backgroundColor: 'rgba(45, 212, 191, 0.05)',
                    fill: true, tension: 0.4, borderWidth: 3, pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { display: false },
                    x: { grid: { display: false }, ticks: { color: '#94a3b8' } }
                }
            }
        });
    </script>
</body>
</html>