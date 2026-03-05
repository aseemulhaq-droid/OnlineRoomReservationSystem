<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Reservation, dao.ReservationDAO, dao.BillDAO, java.util.List" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");
    int userId = (int) session.getAttribute("userId");
    
    ReservationDAO reservationDAO = new ReservationDAO();
    BillDAO billDAO = new BillDAO();
    List<Reservation> reservations;
    
    if ("admin".equals(role)) {
        reservations = reservationDAO.getAllReservations();
    } else {
        reservations = reservationDAO.getReservationsByUserId(userId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations | OceanView</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --bg: #020617;
            --card: rgba(15, 23, 42, 0.7);
            --teal: #2dd4bf;
            --view-color: #60a5fa;
            --text: #f8fafc;
            --dim: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
            --danger: #f87171;
            --success: #10b981;
            --warning: #f59e0b;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #020617;
            background-image: 
                radial-gradient(at 0% 0%, rgba(45, 212, 191, 0.15) 0, transparent 50%),
                radial-gradient(at 100% 100%, rgba(96, 165, 250, 0.15) 0, transparent 50%);
            color: var(--text);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(15, 23, 42, 0.8);
            backdrop-filter: blur(15px);
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0; z-index: 1000;
            border-bottom: 1px solid var(--border);
        }
        .nav-brand { font-size: 1.5rem; font-weight: 800; color: #fff; text-decoration: none; letter-spacing: -1px; }
        .nav-brand span { color: var(--teal); }
        .nav-links { display: flex; align-items: center; gap: 25px; }
        .nav-links a { text-decoration: none; color: var(--dim); font-weight: 500; font-size: 0.95rem; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: var(--teal); }
        .nav-links i { margin-right: 8px; }

        .btn-logout {
            background: rgba(248, 113, 113, 0.1); border: 1px solid rgba(248, 113, 113, 0.3);
            color: #f87171; padding: 8px 22px; border-radius: 30px; font-weight: 700; cursor: pointer;
        }

        .container { padding: 50px 5%; max-width: 1400px; margin: 0 auto; }
        
        .page-header { margin-bottom: 40px; animation: fadeInDown 0.8s ease; }
        .page-header h2 { font-size: 2.5rem; font-weight: 800; }
        
        .toolbar {
            background: var(--card); padding: 25px; border-radius: 24px;
            border: 1px solid var(--border); margin-bottom: 30px;
            display: flex; flex-direction: column; gap: 20px;
            backdrop-filter: blur(20px);
            animation: fadeIn 1s ease;
        }

        .search-box { position: relative; }
        .search-box i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--teal); }
        .search-box input {
            width: 100%; background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border);
            padding: 15px 50px; border-radius: 15px; color: white; outline: none; transition: 0.3s;
        }
        .search-box input:focus { border-color: var(--teal); }

        .table-container {
            background: var(--card); border-radius: 30px; border: 1px solid var(--border);
            overflow: hidden; backdrop-filter: blur(20px);
            animation: fadeInUp 0.8s ease;
        }

        table { width: 100%; border-collapse: collapse; }
        th { padding: 20px 25px; text-align: left; font-size: 0.75rem; color: var(--dim); text-transform: uppercase; letter-spacing: 1px; }
        td { padding: 22px 25px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        tr:hover td { background: rgba(255, 255, 255, 0.02); }

        .guest-info { display: flex; align-items: center; gap: 15px; }
        .avatar-sq {
            width: 45px; height: 45px; border-radius: 12px; display: flex; 
            align-items: center; justify-content: center; font-weight: 800; color: white;
        }
        
        .status-badge {
            padding: 6px 14px; border-radius: 10px; font-size: 0.75rem; font-weight: 800;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .status-confirmed { background: rgba(16, 185, 129, 0.15); color: var(--success); }
        .status-pending { background: rgba(245, 158, 11, 0.15); color: var(--warning); }
        .status-cancelled { background: rgba(239, 68, 68, 0.15); color: var(--danger); }

        .btn-action {
            padding: 10px 18px; border-radius: 12px; font-size: 0.85rem; font-weight: 700;
            text-decoration: none; transition: 0.3s; display: flex; align-items: center; gap: 8px;
        }
        .btn-bill-view { background: white; color: var(--bg); }
        .btn-bill-view:hover { background: var(--teal); transform: scale(1.05); }

        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="nav-brand">🏖️ Ocean<span>View</span></a>
        <div class="nav-links">
            <a href="dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
            <a href="addReservation.jsp"><i class="fas fa-plus-circle"></i> New Reservation</a>
            <a href="viewReservation.jsp" class="active"><i class="fas fa-calendar-alt"></i> Reservations</a>
            <a href="help.jsp"><i class="fas fa-question-circle"></i> Help</a>
        </div>
        
        <form action="LoginServlet" method="post" style="margin: 0;">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="btn-logout"><i class="fas fa-power-off"></i> Logout</button>
        </form>
    </nav>

    <div class="container">
        <header class="page-header">
            <h2>Reservations Archive</h2>
            <p style="color: var(--dim);">Centralized command center for guest management.</p>
        </header>

        <div class="toolbar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="reservationSearch" onkeyup="filterTable()" placeholder="Search by name, address, room or status...">
            </div>
        </div>

        <div class="table-container">
            <table id="resTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Guest Details</th>
                        <th>Location/Address</th> <th>Stay Period</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Reservation r : reservations) { 
                        String statusType = "status-pending";
                        String icon = "fa-hourglass-start";
                        if("Confirmed".equals(r.getReservationStatus())) { statusType = "status-confirmed"; icon="fa-check-double"; }
                        if("Cancelled".equals(r.getReservationStatus())) { statusType = "status-cancelled"; icon="fa-ban"; }
                        
                        boolean hasBill = billDAO.billExistsForReservation(r.getReservationId());
                        String initial = (r.getGuestName() != null && !r.getGuestName().isEmpty()) ? r.getGuestName().substring(0,1).toUpperCase() : "?";
                    %>
                    <tr class="animate__animated animate__fadeInUp">
                        <td style="color: var(--dim); font-weight: 800;">#<%= r.getReservationId() %></td>
                        <td>
                            <div class="guest-info">
                                <div class="avatar-sq" style="background: <%= "Confirmed".equals(r.getReservationStatus()) ? "var(--teal)" : "var(--view-color)" %>">
                                    <%= initial %>
                                </div>
                                <div>
                                    <span style="font-weight: 700; display: block;"><%= r.getGuestName() %></span>
                                    <span style="font-size: 0.8rem; color: var(--teal);">Room <%= r.getRoomNumber() %> • <%= r.getRoomType() %></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div style="font-size: 0.9rem; max-width: 200px; color: var(--text);">
                                <i class="fas fa-map-marker-alt" style="color: var(--danger); margin-right: 5px;"></i>
                                <%= (r.getGuestAddress() != null) ? r.getGuestAddress() : "N/A" %>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 700;"><%= r.getCheckInDate() %></div>
                            <div style="font-size: 0.8rem; color: var(--dim);">to <%= r.getCheckOutDate() %></div>
                        </td>
                        <td><span style="font-weight: 800;">LKR <%= String.format("%.2f", r.getTotalAmount()) %></span></td>
                        <td>
                            <span class="status-badge <%= statusType %>">
                                <i class="fas <%= icon %>"></i> <%= r.getReservationStatus() %>
                            </span>
                        </td>
                        <td>
                            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                                <% if (hasBill) { %>
                                    <a href="bill.jsp?reservationId=<%= r.getReservationId() %>" class="btn-action btn-bill-view">
                                        <i class="fas fa-file-invoice-dollar"></i> Bill
                                    </a>
                                <% } else if (!"Cancelled".equals(r.getReservationStatus())) { %>
                                    <a href="BillingServlet?action=generate&reservationId=<%= r.getReservationId() %>" class="btn-action btn-bill-view">
                                        <i class="fas fa-plus-square"></i> Pay
                                    </a>
                                <% } %>

                                <% if (!"Cancelled".equals(r.getReservationStatus()) && !"Completed".equals(r.getReservationStatus())) { %>
                                    <a href="ReservationServlet?action=cancel&id=<%= r.getReservationId() %>" 
                                       style="color: var(--dim); border: 1px solid var(--border); padding: 10px; border-radius: 12px;"
                                       onclick="return confirm('Cancel reservation #<%= r.getReservationId() %>?')" title="Cancel">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function filterTable() {
            const input = document.getElementById("reservationSearch");
            const filter = input.value.toUpperCase();
            const table = document.getElementById("resTable");
            const tr = table.getElementsByTagName("tr");
            for (let i = 1; i < tr.length; i++) {
                let textContent = tr[i].textContent || tr[i].innerText;
                tr[i].style.display = textContent.toUpperCase().indexOf(filter) > -1 ? "" : "none";
            }
        }
    </script>
</body>
</html>