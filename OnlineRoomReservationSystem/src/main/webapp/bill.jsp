<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*, dao.*, util.DateValidator" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }
    
    String reservationIdStr = request.getParameter("reservationId");
    String billIdStr = request.getParameter("billId");
    
    BillDAO billDAO = new BillDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    ReceiptDAO receiptDAO = new ReceiptDAO();
    
    Bill bill = null;
    Reservation reservation = null;
    Receipt receipt = null;
    
    if (reservationIdStr != null) {
        int reservationId = Integer.parseInt(reservationIdStr);
        bill = billDAO.getBillByReservationId(reservationId);
        reservation = reservationDAO.getReservationById(reservationId);
    } else if (billIdStr != null) {
        int billId = Integer.parseInt(billIdStr);
        bill = billDAO.getBillById(billId);
        if (bill != null) reservation = reservationDAO.getReservationById(bill.getReservationId());
    }
    
    if (bill == null || reservation == null) {
        response.sendRedirect("viewReservation.jsp?error=bill_not_found");
        return;
    }
    
    receipt = receiptDAO.getReceiptByBillId(bill.getBillId());
    boolean isPaid = "Paid".equals(bill.getBillStatus()) || receipt != null;
    long nights = DateValidator.calculateNights(reservation.getCheckInDate(), reservation.getCheckOutDate());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice | OceanView</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --bg: #020617;
            --card: #ffffff;
            --teal: #2dd4bf;
            --view-color: #60a5fa;
            --text-dark: #1e293b;
            --text-light: #64748b;
            --border: rgba(0, 0, 0, 0.05);
            --success: #10b981;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #020617;
            background-image: 
                radial-gradient(at 0% 0%, rgba(45, 212, 191, 0.15) 0, transparent 50%),
                radial-gradient(at 100% 100%, rgba(96, 165, 250, 0.15) 0, transparent 50%);
            min-height: 100vh;
            color: var(--text-dark);
            padding-bottom: 50px;
        }

        /* --- FLOATING BACK BUTTON --- */
        .back-nav {
            position: fixed; top: 30px; left: 30px; z-index: 100;
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

        .container { display: flex; justify-content: center; padding: 100px 20px 40px; }

        /* --- MODERN BILL SHEET --- */
        .bill-sheet {
            background: var(--card); width: 100%; max-width: 800px;
            border-radius: 35px; overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            animation: fadeInUp 0.8s ease-out;
        }

        .bill-header {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: white; padding: 50px; position: relative;
        }
        .bill-header h2 { font-size: 2rem; font-weight: 800; letter-spacing: -1px; }
        .bill-header p { opacity: 0.6; font-size: 0.9rem; margin-top: 5px; }
        .status-stamp {
            position: absolute; right: 50px; top: 50%; transform: translateY(-50%) rotate(-10deg);
            padding: 10px 25px; border: 4px solid; border-radius: 15px;
            font-weight: 900; font-size: 1.5rem; text-transform: uppercase;
        }
        .stamp-paid { border-color: var(--teal); color: var(--teal); }
        .stamp-pending { border-color: #f59e0b; color: #f59e0b; }

        .bill-body { padding: 50px; }

        .info-row { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; }
        .info-block label { font-size: 0.65rem; font-weight: 800; color: var(--text-light); text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 8px; }
        .info-block p { font-size: 1rem; font-weight: 600; line-height: 1.5; }

        /* --- TABLE STYLE --- */
        .bill-table { width: 100%; border-collapse: collapse; margin: 30px 0; }
        .bill-table th { text-align: left; padding: 15px; border-bottom: 2px solid #f1f5f9; color: var(--text-light); font-size: 0.75rem; text-transform: uppercase; }
        .bill-table td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; font-weight: 500; }

        .total-box { margin-left: auto; width: 300px; margin-top: 30px; }
        .total-item { display: flex; justify-content: space-between; padding: 10px 0; font-size: 0.9rem; color: var(--text-light); }
        .total-main { margin-top: 15px; padding-top: 15px; border-top: 2px solid #f1f5f9; color: var(--text-dark); }
        .total-main span:last-child { font-size: 1.8rem; font-weight: 800; color: var(--view-color); }

        /* --- PAYMENT SECTION --- */
        .payment-card {
            background: #f8fafc; border-radius: 25px; padding: 30px; margin-top: 40px;
            border: 1px solid #e2e8f0;
        }
        .form-control {
            width: 100%; padding: 14px; border: 2px solid #e2e8f0; border-radius: 12px;
            font-family: inherit; margin-top: 8px; transition: 0.3s;
        }
        .form-control:focus { border-color: var(--teal); outline: none; }

        .btn-group { display: flex; gap: 15px; margin-top: 25px; }
        .btn { 
            flex: 1; padding: 16px; border-radius: 15px; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 10px; border: none; transition: 0.3s;
        }
        .btn-pay { background: var(--teal); color: white; box-shadow: 0 10px 15px -3px rgba(45, 212, 191, 0.3); }
        .btn-pay:hover { transform: translateY(-3px); box-shadow: 0 20px 25px -5px rgba(45, 212, 191, 0.4); }
        .btn-print { background: #e2e8f0; color: #475569; }
        .btn-print:hover { background: #cbd5e1; }

        @media print { .no-print, .back-nav { display: none; } body { background: white; padding: 0; } .bill-sheet { box-shadow: none; max-width: 100%; } }
        
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <div class="back-nav">
        <a href="viewReservation.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Back to Archive
        </a>
    </div>

    <div class="container">
        <div class="bill-sheet">
            <div class="bill-header">
                <div>
                    <h2>Ocean<span>View</span> Resort</h2>
                    <p>Official Invoice | ID #<%= bill.getBillId() %></p>
                </div>
                <div class="status-stamp <%= isPaid ? "stamp-paid" : "stamp-pending" %>">
                    <%= isPaid ? "PAID" : "UNPAID" %>
                </div>
            </div>

            <div class="bill-body">
                <div class="info-row">
                    <div class="info-block">
                        <label>Guest Details</label>
                        <p><%= reservation.getGuestName() %></p>
                        <p style="color: var(--text-light); font-weight: 400;"><%= reservation.getGuestEmail() %></p>
                        <p style="color: var(--text-light); font-weight: 400;"><%= reservation.getGuestPhone() %></p>
                    </div>
                    <div class="info-block">
                        <label>Stay Info</label>
                        <p>Room <%= reservation.getRoomNumber() %> — <%= reservation.getRoomType() %></p>
                        <p style="color: var(--text-light); font-weight: 400;">
                            <%= reservation.getCheckInDate() %> to <%= reservation.getCheckOutDate() %>
                        </p>
                        <p style="color: var(--view-color); font-weight: 700;"><%= nights %> Nights Total</p>
                    </div>
                </div>

                <table class="bill-table">
                    <thead>
                        <tr>
                            <th>Service Description</th>
                            <th style="text-align: right;">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Accommodation Charge (<%= nights %> Nights)</td>
                            <td style="text-align: right;">LKR <%= String.format("%.2f", bill.getSubtotal()) %></td>
                        </tr>
                        <tr>
                            <td>Tourism Tax & Vat (13%)</td>
                            <td style="text-align: right;">LKR <%= String.format("%.2f", bill.getTaxAmount()) %></td>
                        </tr>
                        <tr>
                            <td>Service Charge (5%)</td>
                            <td style="text-align: right;">LKR <%= String.format("%.2f", bill.getServiceCharge()) %></td>
                        </tr>
                        <% if (bill.getDiscount() > 0) { %>
                        <tr style="color: var(--success);">
                            <td>Loyalty Discount Applied</td>
                            <td style="text-align: right;">- LKR <%= String.format("%.2f", bill.getDiscount()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="total-box">
                    <div class="total-item">
                        <span>Invoice Date</span>
                        <span><%= bill.getBillDate() %></span>
                    </div>
                    <div class="total-item total-main">
                        <span>Grand Total</span>
                        <span>LKR <%= String.format("%.2f", bill.getTotalAmount()) %></span>
                    </div>
                </div>

                <div class="payment-card no-print">
                    <% if (!isPaid) { %>
                        <h4 style="font-weight: 800; font-size: 0.9rem; margin-bottom: 20px;">
                            <i class="fas fa-credit-card" style="color: var(--teal); margin-right: 10px;"></i>
                            PAYMENT SETTLEMENT
                        </h4>
                        <form action="BillingServlet" method="post">
                            <input type="hidden" name="action" value="processPayment">
                            <input type="hidden" name="billId" value="<%= bill.getBillId() %>">
                            <input type="hidden" name="reservationId" value="<%= reservation.getReservationId() %>">
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div>
                                    <label style="font-size: 0.7rem; font-weight: 700;">PAYMENT METHOD</label>
                                    <select name="paymentMethod" class="form-control">
                                        <option value="Cash">Cash Settlement</option>
                                        <option value="Credit Card">Credit Card</option>
                                        <option value="Debit Card">Debit Card</option>
                                    </select>
                                </div>
                                <div>
                                    <label style="font-size: 0.7rem; font-weight: 700;">INTERNAL NOTES</label>
                                    <input type="text" name="remarks" class="form-control" placeholder="Optional notes...">
                                </div>
                            </div>
                            <div class="btn-group">
                                <button type="submit" class="btn btn-pay">Confirm & Settle Bill</button>
                                <button type="button" class="btn btn-print" onclick="window.print()"><i class="fas fa-print"></i></button>
                            </div>
                        </form>
                    <% } else { %>
                        <div style="text-align: center;">
                            <h3 style="color: var(--success); font-weight: 800; margin-bottom: 20px;">
                                <i class="fas fa-check-circle"></i> ACCOUNT SETTLED
                            </h3>
                            <div class="btn-group">
                                <a href="receipt.jsp?receiptId=<%= receipt.getReceiptId() %>" class="btn btn-pay">View Official Receipt</a>
                                <button type="button" class="btn btn-print" onclick="window.print()">Print Invoice</button>
                            </div>
                        </div>
                    <% } %>
                </div>

                <p style="text-align:center; font-size: 0.7rem; color: var(--text-light); margin-top: 40px; font-weight: 600; letter-spacing: 1px;">
                    THANK YOU FOR CHOOSING OCEANVIEW RESORT
                </p>
            </div>
        </div>
    </div>

</body>
</html>