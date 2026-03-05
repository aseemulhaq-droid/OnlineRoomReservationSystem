<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, dao.*" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }

    String receiptIdStr = request.getParameter("receiptId");
    ReceiptDAO receiptDAO = new ReceiptDAO();
    BillDAO billDAO = new BillDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    
    Receipt receipt = null;
    Bill bill = null;
    Reservation reservation = null;

    if (receiptIdStr != null) {
        int receiptId = Integer.parseInt(receiptIdStr);
        receipt = receiptDAO.getReceiptById(receiptId);
        if (receipt != null) {
            bill = billDAO.getBillById(receipt.getBillId());
            reservation = reservationDAO.getReservationById(receipt.getReservationId());
        }
    }

    if (receipt == null || bill == null || reservation == null) {
        response.sendRedirect("viewReservation.jsp?error=receipt_not_found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Receipt | OceanView</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --primary: #0f172a;
            --teal: #2dd4bf;
            --success: #10b981;
            --dim: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #020617;
            background-image: 
                radial-gradient(at 0% 0%, rgba(45, 212, 191, 0.15) 0, transparent 50%),
                radial-gradient(at 100% 100%, rgba(96, 165, 250, 0.15) 0, transparent 50%);
            min-height: 100vh;
            color: var(--primary);
        }

        /* --- NAVIGATION BAR --- */
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
        .nav-links a:hover { color: var(--teal); }
        .nav-links i { margin-right: 8px; }

        /* --- FLOATING BACK BUTTON --- */
        .back-nav {
            position: fixed; top: 100px; left: 30px; z-index: 100;
            animation: fadeInLeft 0.8s ease;
        }
        .btn-back {
            background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2); color: #fff;
            padding: 12px 24px; border-radius: 15px; text-decoration: none;
            font-weight: 700; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;
            transition: 0.3s;
        }
        .btn-back:hover { background: var(--teal); border-color: var(--teal); transform: translateX(-5px); }

        .container { padding: 40px 20px; display: flex; justify-content: center; }

        /* --- RECEIPT CARD --- */
        .receipt-card {
            background: #fff;
            width: 100%;
            max-width: 600px;
            border-radius: 35px;
            padding: 50px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            position: relative;
            overflow: hidden;
            animation: zoomIn 0.6s ease-out;
        }

        .paid-stamp {
            position: absolute; top: 40px; right: 40px;
            border: 5px solid var(--success); color: var(--success);
            padding: 10px 25px; font-size: 1.8rem; font-weight: 900;
            text-transform: uppercase; border-radius: 15px;
            transform: rotate(-15deg); opacity: 0.2; user-select: none;
        }

        .header { text-align: center; margin-bottom: 40px; border-bottom: 2px dashed #e2e8f0; padding-bottom: 30px; }
        .header h2 { font-size: 1.8rem; font-weight: 800; color: var(--primary); letter-spacing: -1px; }

        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 18px; font-size: 1rem; }
        .label { color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
        .value { color: var(--primary); font-weight: 700; text-align: right; }

        .amount-box {
            background: #f0fdf4; border-radius: 20px; padding: 25px;
            text-align: center; margin: 35px 0; border: 1px solid #dcfce7;
        }
        .amount-box .total { font-size: 2.2rem; font-weight: 900; color: var(--success); }

        .btn-group { display: flex; gap: 12px; justify-content: center; margin-top: 40px; }
        .btn {
            flex: 1; padding: 15px 25px; border-radius: 15px; font-weight: 700; 
            text-decoration: none; transition: 0.3s; cursor: pointer; border: none; 
            font-size: 0.95rem; display: flex; align-items: center; justify-content: center; gap: 10px;
        }
        .btn-print { background: var(--primary); color: white; }
        .btn-print:hover { transform: translateY(-3px); box-shadow: 0 10px 15px rgba(15, 23, 42, 0.2); }
        .btn-secondary { background: #f1f5f9; color: #475569; }
        .btn-secondary:hover { background: #e2e8f0; }

        .footer-note { text-align: center; color: #94a3b8; font-size: 0.85rem; margin-top: 40px; line-height: 1.6; }

        @media print { 
            .no-print, .navbar, .back-nav { display: none; } 
            body { background: white; } 
            .receipt-card { box-shadow: none; margin: 0; max-width: 100%; border: 1px solid #eee; } 
        }
    </style>
</head>
<body>

<nav class="navbar no-print">
    <a href="dashboard.jsp" class="nav-brand">🏖️ Ocean<span>View</span></a>
    <div class="nav-links">
        <a href="dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="addReservation.jsp"><i class="fas fa-plus-circle"></i> New</a>
        <a href="viewReservation.jsp"><i class="fas fa-calendar-alt"></i> Archive</a>
        <a href="help.jsp"><i class="fas fa-question-circle"></i> Help</a>
    </div>
</nav>

<div class="back-nav no-print">
    <a href="viewReservation.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Archive
    </a>
</div>

<div class="container">
    <div class="receipt-card animate__animated animate__zoomIn">
        <div class="paid-stamp">PAID</div>
        
        <div class="header">
            <h2>OceanView Resort</h2>
            <p style="color: #64748b; margin-top: 5px; font-weight: 500;">Official Transaction Receipt</p>
        </div>

        <div class="receipt-row">
            <span class="label">Receipt Number</span>
            <span class="value">#REC-<%= receipt.getReceiptId() %></span>
        </div>
        <div class="receipt-row">
            <span class="label">Transaction Ref</span>
            <span class="value" style="font-family: monospace;"><%= receipt.getTransactionId() %></span>
        </div>
        <div class="receipt-row">
            <span class="label">Date of Payment</span>
            <span class="value"><%= receipt.getPaymentDate() %></span>
        </div>
        
        <div style="border-top: 1px solid #f1f5f9; margin: 25px 0;"></div>

        <div class="receipt-row">
            <span class="label">Guest Name</span>
            <span class="value"><%= reservation.getGuestName() %></span>
        </div>
        <div class="receipt-row">
            <span class="label">Accommodation</span>
            <span class="value">Room <%= reservation.getRoomNumber() %> (<%= reservation.getRoomType() %>)</span>
        </div>
        <div class="receipt-row">
            <span class="label">Method</span>
            <span class="value"><%= receipt.getPaymentMethod() %></span>
        </div>

        <div class="amount-box">
            <div class="label" style="margin-bottom: 8px;">Total Amount Received</div>
            <div class="total">LKR <%= String.format("%.2f", receipt.getAmountPaid()) %></div>
        </div>

        <% if(receipt.getRemarks() != null && !receipt.getRemarks().isEmpty()) { %>
        <div class="receipt-row">
            <span class="label">Notes</span>
            <span class="value" style="font-style: italic; font-weight: 500;"><%= receipt.getRemarks() %></span>
        </div>
        <% } %>

        <div class="btn-group no-print">
            <button onclick="window.print()" class="btn btn-print"><i class="fas fa-print"></i> Print</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Dashboard</a>
        </div>

        <div class="footer-note">
            Thank you for choosing OceanView Resort.<br>
            This is a computer-generated receipt. No signature required.
        </div>
    </div>
</div>

</body>
</html>