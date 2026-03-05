// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package controller;

import dao.BillDAO;
import dao.ReceiptDAO;
import dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;
import model.Bill;
import model.Receipt;
import model.Reservation;
import service.BillingService;

@WebServlet({"/BillingServlet"})
public class BillingServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private BillingService billingService;
   private BillDAO billDAO;
   private ReceiptDAO receiptDAO;
   private ReservationDAO reservationDAO;

   public BillingServlet() {
   }

   public void init() {
      this.billingService = new BillingService();
      this.billDAO = new BillDAO();
      this.receiptDAO = new ReceiptDAO();
      this.reservationDAO = new ReservationDAO();
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession(false);
      if (session != null && session.getAttribute("user") != null) {
         String action = request.getParameter("action");
         if ("generate".equals(action)) {
            this.generateBill(request, response);
         } else if ("view".equals(action)) {
            this.viewBill(request, response);
         } else if ("viewReceipt".equals(action)) {
            this.viewReceipt(request, response);
         } else {
            response.sendRedirect("viewReservation.jsp");
         }

      } else {
         response.sendRedirect("login.jsp?error=session");
      }
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession(false);
      if (session != null && session.getAttribute("user") != null) {
         String action = request.getParameter("action");
         if ("processPayment".equals(action)) {
            this.processPayment(request, response);
         } else {
            response.sendRedirect("viewReservation.jsp");
         }

      } else {
         response.sendRedirect("login.jsp?error=session");
      }
   }

   private void generateBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         int reservationId = Integer.parseInt(request.getParameter("reservationId"));
         Bill existingBill = this.billDAO.getBillByReservationId(reservationId);
         if (existingBill != null) {
            response.sendRedirect("bill.jsp?billId=" + existingBill.getBillId() + "&message=existing");
            return;
         }

         int billId = this.billingService.generateBill(reservationId);
         if (billId > 0) {
            response.sendRedirect("bill.jsp?billId=" + billId + "&success=generated");
         } else {
            response.sendRedirect("viewReservation.jsp?error=bill_generation_failed");
         }
      } catch (NumberFormatException var6) {
         response.sendRedirect("viewReservation.jsp?error=invalid_id");
      } catch (Exception e) {
         response.sendRedirect("viewReservation.jsp?error=" + e.getMessage());
      }

   }

   private void viewBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         int billId = Integer.parseInt(request.getParameter("billId"));
         Bill bill = this.billDAO.getBillById(billId);
         if (bill != null) {
            Reservation reservation = this.reservationDAO.getReservationById(bill.getReservationId());
            request.setAttribute("bill", bill);
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("bill.jsp").forward(request, response);
         } else {
            response.sendRedirect("viewReservation.jsp?error=bill_not_found");
         }
      } catch (NumberFormatException var6) {
         response.sendRedirect("viewReservation.jsp?error=invalid_id");
      }

   }

   private void processPayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession();
      int userId = (Integer)session.getAttribute("userId");

      try {
         int billId = Integer.parseInt(request.getParameter("billId"));
         int reservationId = Integer.parseInt(request.getParameter("reservationId"));
         String paymentMethod = request.getParameter("paymentMethod");
         String remarks = request.getParameter("remarks");
         Bill bill = this.billDAO.getBillById(billId);
         if (bill == null) {
            response.sendRedirect("viewReservation.jsp?error=bill_not_found");
            return;
         }

         Receipt existingReceipt = this.receiptDAO.getReceiptByBillId(billId);
         if (existingReceipt != null) {
            response.sendRedirect("receipt.jsp?receiptId=" + existingReceipt.getReceiptId() + "&message=existing");
            return;
         }

         long var10000 = System.currentTimeMillis();
         String transactionId = "TXN" + var10000 + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
         Receipt receipt = new Receipt();
         receipt.setBillId(billId);
         receipt.setReservationId(reservationId);
         receipt.setPaymentMethod(paymentMethod);
         receipt.setTransactionId(transactionId);
         receipt.setAmountPaid(bill.getTotalAmount());
         receipt.setPaymentStatus("Success");
         receipt.setRemarks(remarks != null ? remarks : "Payment processed successfully");
         int receiptId = this.receiptDAO.createReceipt(receipt);
         if (receiptId > 0) {
            this.billingService.markBillAsPaid(billId);
            this.reservationDAO.updateReservationStatus(reservationId, "Confirmed");
            response.sendRedirect("receipt.jsp?receiptId=" + receiptId + "&success=paid");
         } else {
            response.sendRedirect("bill.jsp?billId=" + billId + "&error=payment_failed");
         }
      } catch (NumberFormatException var14) {
         response.sendRedirect("viewReservation.jsp?error=invalid_id");
      } catch (Exception e) {
         response.sendRedirect("viewReservation.jsp?error=" + e.getMessage());
      }

   }

   private void viewReceipt(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         int receiptId = Integer.parseInt(request.getParameter("receiptId"));
         Receipt receipt = this.receiptDAO.getReceiptById(receiptId);
         if (receipt != null) {
            Bill bill = this.billDAO.getBillById(receipt.getBillId());
            Reservation reservation = this.reservationDAO.getReservationById(receipt.getReservationId());
            request.setAttribute("receipt", receipt);
            request.setAttribute("bill", bill);
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("receipt.jsp").forward(request, response);
         } else {
            response.sendRedirect("viewReservation.jsp?error=receipt_not_found");
         }
      } catch (NumberFormatException var7) {
         response.sendRedirect("viewReservation.jsp?error=invalid_id");
      }

   }
}
