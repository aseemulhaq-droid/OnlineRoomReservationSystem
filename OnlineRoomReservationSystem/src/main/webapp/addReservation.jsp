<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Room, dao.RoomDAO, java.util.List" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    RoomDAO roomDAO = new RoomDAO();
    List<Room> rooms = roomDAO.getAllAvailableRooms();
    String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Booking | OceanView</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --bg: #020617;
            --card: rgba(15, 23, 42, 0.85);
            --teal: #2dd4bf;
            --view-color: #60a5fa;
            --text: #f8fafc;
            --dim: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
            --danger: #f87171;
            --success: #10b981;
            --accent-gradient: linear-gradient(135deg, #2dd4bf 0%, #60a5fa 100%);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #020617;
            background-image: 
                radial-gradient(at 0% 0%, rgba(45, 212, 191, 0.2) 0, transparent 50%),
                radial-gradient(at 100% 100%, rgba(96, 165, 250, 0.2) 0, transparent 50%);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* --- RESTORED ORIGINAL NAVBAR STYLE --- */
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

        .nav-brand { font-size: 1.5rem; font-weight: 800; color: #fff; text-decoration: none; }
        .nav-brand span { color: var(--teal); }
        .nav-links { display: flex; align-items: center; gap: 25px; }
        .nav-links a { text-decoration: none; color: var(--dim); font-weight: 500; font-size: 0.95rem; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: var(--teal); }

        .btn-logout {
            background: rgba(248, 113, 113, 0.1); border: 1px solid rgba(248, 113, 113, 0.3);
            color: #f87171; padding: 8px 22px; border-radius: 30px; font-weight: 700; cursor: pointer;
        }

        /* --- ADVANCED FORM UI --- */
        .wrapper { display: flex; align-items: center; justify-content: center; padding: 40px 20px; }
        .glass-card {
            background: var(--card); width: 100%; max-width: 950px;
            padding: 45px; border-radius: 35px; border: 1px solid var(--border);
            backdrop-filter: blur(30px); box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
        }

        .header-box { margin-bottom: 35px; border-left: 5px solid var(--teal); padding-left: 20px; }
        .header-box h2 { font-size: 2.2rem; font-weight: 800; letter-spacing: -1px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 25px; }
        label { font-size: 0.7rem; font-weight: 800; color: var(--teal); text-transform: uppercase; margin-bottom: 8px; display: flex; align-items: center; gap: 8px; }

        .form-control {
            width: 100%; background: rgba(15, 23, 42, 0.6); border: 2px solid var(--border);
            border-radius: 15px; padding: 14px 18px; color: #fff; font-size: 0.95rem; outline: none; transition: 0.4s;
        }
        .form-control:focus { border-color: var(--teal); background: rgba(15, 23, 42, 0.9); box-shadow: 0 0 15px rgba(45, 212, 191, 0.2); }
        
        select.form-control option { background: #0f172a; color: white; padding: 10px; }

        .phone-group { display: flex; gap: 10px; }
        .country-select { width: 115px; cursor: pointer; }

        #roomDetails, #calculation { margin-top: 25px; padding: 25px; border-radius: 20px; display: none; border: 1px solid var(--border); animation: fadeInUp 0.5s ease; }
        #roomDetails { background: linear-gradient(to right, rgba(45, 212, 191, 0.1), transparent); border-left: 4px solid var(--teal); }
        #calculation { background: linear-gradient(to right, rgba(96, 165, 250, 0.1), transparent); border-left: 4px solid var(--view-color); }

        .btn-group { display: flex; gap: 15px; margin-top: 35px; }
        .btn { flex: 1; padding: 18px; border-radius: 18px; font-weight: 800; cursor: pointer; border: none; font-size: 0.95rem; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-submit { background: var(--accent-gradient); color: #fff; }
        .btn-submit:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(96, 165, 250, 0.4); }
        
        .alert-box { padding: 15px 25px; border-radius: 15px; margin-bottom: 25px; display: flex; align-items: center; gap: 15px; border: 1px solid transparent; }
        .alert-error { background: rgba(248, 113, 113, 0.1); border-color: var(--danger); color: #fff; }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="nav-brand">🏖️ Ocean<span>View</span></a>
        <div class="nav-links">
            <a href="dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
            <a href="addReservation.jsp" class="active"><i class="fas fa-plus-circle"></i> New Booking</a>
            <a href="viewReservation.jsp"><i class="fas fa-calendar-alt"></i> Reservations</a>
            <a href="help.jsp"><i class="fas fa-question-circle"></i> Help</a>
        </div>
        <form action="LoginServlet" method="post" style="margin: 0;">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="btn-logout"><i class="fas fa-power-off"></i> Logout</button>
        </form>
    </nav>

    <div class="wrapper">
        <div class="glass-card animate__animated animate__fadeInUp">
            <div class="header-box">
                <h2>Elite Reservation</h2>
                <p>Registering guests for a premium OceanView experience.</p>
            </div>

            <% String error = (String) request.getAttribute("errorMessage");
               if (error != null) { %>
                <div class="alert-box alert-error animate__animated animate__headShake">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>

            <form action="ReservationServlet" method="post" id="resForm">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="totalAmount" id="hiddenTotalAmount">

                <div class="form-grid">
                    <div>
                        <label><i class="fas fa-bed"></i> Suite Collection</label>
                        <select id="roomId" name="roomId" class="form-control" required onchange="updateRoomDetails()">
                            <option value="" disabled selected>Select Available Room</option>
                            <% for (Room room : rooms) { %>
                                <option value="<%= room.getRoomId() %>" data-rate="<%= room.getRatePerNight() %>" data-capacity="<%= room.getCapacity() %>" data-type="<%= room.getRoomType() %>">
                                    Room <%= room.getRoomNumber() %> — <%= room.getRoomType() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label><i class="fas fa-user"></i> Guest Full Name</label>
                        <input type="text" name="guestName" class="form-control" placeholder="John Doe" required 
                               pattern="[A-Za-z\s]+" title="Only letters are allowed">
                    </div>
                </div>

                <div style="margin-bottom: 25px;">
                    <label><i class="fas fa-map-marker-alt"></i> Guest Home Address</label>
                    <input type="text" name="guestAddress" class="form-control" placeholder="123 Ocean Drive, Colombo" required>
                </div>

                <div class="form-grid">
                    <div>
                        <label><i class="fas fa-envelope"></i> Email Address</label>
                        <input type="email" name="guestEmail" class="form-control" placeholder="guest@example.com" required>
                    </div>
                    <div>
                        <label><i class="fas fa-phone"></i> Phone Number</label>
                        <div class="phone-group">
                            <select class="form-control country-select">
                                <option value="+94">🇱🇰 +94</option>
                                <option value="+91">🇮🇳 +91</option>
                                <option value="+44">🇬🇧 +44</option>
                                <option value="+1">🇺🇸 +1</option>
                                <option value="+61">🇦🇺 +61</option>
                                <option value="+971">🇦🇪 +971</option>
                            </select>
                            <input type="text" name="guestPhone" class="form-control" placeholder="771234567" required 
                                   pattern="\d{7,12}" title="Please enter a valid phone number">
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
                    <div><label>Check-In</label><input type="date" id="checkInDate" name="checkInDate" class="form-control" min="<%= today %>" required onchange="calculateTotal()"></div>
                    <div><label>Check-Out</label><input type="date" id="checkOutDate" name="checkOutDate" class="form-control" required onchange="calculateTotal()"></div>
                    <div><label>Occupants</label><input type="number" name="numberOfGuests" class="form-control" min="1" max="10" value="1" required></div>
                </div>

                <div id="roomDetails">
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); text-align: center;">
                        <div><small style="color: var(--dim);">TYPE</small><div id="displayRoomType" style="font-weight: 800;">-</div></div>
                        <div><small style="color: var(--dim);">CAPACITY</small><div id="displayCapacity" style="font-weight: 800;">-</div></div>
                        <div><small style="color: var(--dim);">NIGHTLY RATE</small><div style="font-weight: 800; color: var(--teal);">LKR <span id="displayRate">0</span></div></div>
                    </div>
                </div>

                <div id="calculation">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <small style="color: var(--dim);">STAY TOTAL (<span id="displayNights">0</span> NIGHTS)</small>
                            <div id="displayTotal" style="font-size: 1.8rem; font-weight: 900; color: var(--view-color);">LKR 0.00</div>
                        </div>
                        <i class="fas fa-receipt fa-3x" style="opacity: 0.1;"></i>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-submit"><i class="fas fa-concierge-bell"></i> Book Luxury Stay</button>
                    <button type="reset" class="btn" style="background: rgba(255,255,255,0.05); color: var(--dim);">Clear</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementsByName('guestName')[0].addEventListener('input', function(e) {
            this.value = this.value.replace(/[^A-Za-z\s]/g, '');
        });

        document.getElementsByName('guestPhone')[0].addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        function updateRoomDetails() {
            const select = document.getElementById('roomId');
            const opt = select.options[select.selectedIndex];
            document.getElementById('displayRoomType').innerText = opt.dataset.type;
            document.getElementById('displayCapacity').innerText = opt.dataset.capacity + " Pax";
            document.getElementById('displayRate').innerText = parseFloat(opt.dataset.rate).toLocaleString();
            document.getElementById('roomDetails').style.display = 'block';
            calculateTotal();
        }

        function calculateTotal() {
            const select = document.getElementById('roomId');
            const opt = select.options[select.selectedIndex];
            const inDate = document.getElementById('checkInDate').value;
            const outDate = document.getElementById('checkOutDate').value;

            if (opt.value && inDate && outDate) {
                const diff = new Date(outDate) - new Date(inDate);
                const nights = Math.ceil(diff / (1000 * 60 * 60 * 24));
                if (nights > 0) {
                    const total = nights * parseFloat(opt.dataset.rate);
                    document.getElementById('displayNights').innerText = nights;
                    document.getElementById('displayTotal').innerText = "LKR " + total.toLocaleString(undefined, {minimumFractionDigits: 2});
                    document.getElementById('hiddenTotalAmount').value = total;
                    document.getElementById('calculation').style.display = 'block';
                } else {
                    document.getElementById('calculation').style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>