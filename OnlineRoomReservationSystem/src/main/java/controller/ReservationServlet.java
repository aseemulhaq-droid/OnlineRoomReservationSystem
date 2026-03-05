// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package controller;

import dao.ReservationDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.util.List;
import model.Reservation;
import service.ReservationService;
import util.DateValidator;

@WebServlet({"/ReservationServlet"})
public class ReservationServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private ReservationService reservationService;
   private ReservationDAO reservationDAO;
   private RoomDAO roomDAO;

   public ReservationServlet() {
   }

   public void init() {
      this.reservationService = new ReservationService();
      this.reservationDAO = new ReservationDAO();
      this.roomDAO = new RoomDAO();
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession(false);
      if (session != null && session.getAttribute("user") != null) {
         String action = request.getParameter("action");
         if ("view".equals(action)) {
            this.viewReservations(request, response);
         } else if ("cancel".equals(action)) {
            this.cancelReservation(request, response);
         } else if ("confirm".equals(action)) {
            this.confirmReservation(request, response);
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
         if ("create".equals(action)) {
            this.createReservation(request, response);
         } else if ("checkAvailability".equals(action)) {
            this.checkAvailability(request, response);
         } else {
            response.sendRedirect("addReservation.jsp");
         }

      } else {
         response.sendRedirect("login.jsp?error=session");
      }
   }

   private void createReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession();
      int userId = (Integer)session.getAttribute("userId");

      try {
         int roomId = Integer.parseInt(request.getParameter("roomId"));
         String guestName = request.getParameter("guestName");
         String guestAddress = request.getParameter("guestAddress");
         String guestEmail = request.getParameter("guestEmail");
         String guestPhone = request.getParameter("guestPhone");
         String checkInStr = request.getParameter("checkInDate");
         String checkOutStr = request.getParameter("checkOutDate");
         int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
         String specialRequests = request.getParameter("specialRequests");
         if (guestName == null || guestName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Guest name is required");
            request.setAttribute("rooms", this.roomDAO.getAllAvailableRooms());
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);
            return;
         }

         Date checkInDate = DateValidator.stringToSqlDate(checkInStr);
         Date checkOutDate = DateValidator.stringToSqlDate(checkOutStr);
         Reservation reservation = new Reservation();
         reservation.setUserId(userId);
         reservation.setRoomId(roomId);
         reservation.setGuestName(guestName.trim());
         reservation.setGuestAddress(guestAddress.trim());
         reservation.setGuestEmail(guestEmail.trim());
         reservation.setGuestPhone(guestPhone.trim());
         reservation.setCheckInDate(checkInDate);
         reservation.setCheckOutDate(checkOutDate);
         reservation.setNumberOfGuests(numberOfGuests);
         reservation.setSpecialRequests(specialRequests);
         int reservationId = this.reservationService.createReservation(reservation);
         if (reservationId > 0) {
            response.sendRedirect("viewReservation.jsp?success=created");
         } else {
            String errorMessage = this.getErrorMessage(reservationId);
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("rooms", this.roomDAO.getAllAvailableRooms());
            request.getRequestDispatcher("addReservation.jsp").forward(request, response);
         }
      } catch (ParseException var19) {
         request.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");
         request.setAttribute("rooms", this.roomDAO.getAllAvailableRooms());
         request.getRequestDispatcher("addReservation.jsp").forward(request, response);
      } catch (NumberFormatException var20) {
         request.setAttribute("errorMessage", "Invalid input format");
         request.setAttribute("rooms", this.roomDAO.getAllAvailableRooms());
         request.getRequestDispatcher("addReservation.jsp").forward(request, response);
      } catch (Exception e) {
         request.setAttribute("errorMessage", "Error creating reservation: " + e.getMessage());
         request.setAttribute("rooms", this.roomDAO.getAllAvailableRooms());
         request.getRequestDispatcher("addReservation.jsp").forward(request, response);
      }

   }

   private void viewReservations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession();
      int userId = (Integer)session.getAttribute("userId");
      String role = (String)session.getAttribute("role");
      List<Reservation> reservations;
      if ("admin".equals(role)) {
         reservations = this.reservationDAO.getAllReservations();
      } else {
         reservations = this.reservationDAO.getReservationsByUserId(userId);
      }

      request.setAttribute("reservations", reservations);
      request.getRequestDispatcher("viewReservation.jsp").forward(request, response);
   }

   private void cancelReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         int reservationId = Integer.parseInt(request.getParameter("id"));
         boolean success = this.reservationService.cancelReservation(reservationId);
         if (success) {
            response.sendRedirect("viewReservation.jsp?success=cancelled");
         } else {
            response.sendRedirect("viewReservation.jsp?error=cancel_failed");
         }
      } catch (NumberFormatException var5) {
         response.sendRedirect("viewReservation.jsp?error=invalid_id");
      }

   }

   private void confirmReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession();
      String role = (String)session.getAttribute("role");
      if (!"admin".equals(role)) {
         response.sendRedirect("viewReservation.jsp?error=unauthorized");
      } else {
         try {
            int reservationId = Integer.parseInt(request.getParameter("id"));
            boolean success = this.reservationService.confirmReservation(reservationId);
            if (success) {
               response.sendRedirect("viewReservation.jsp?success=confirmed");
            } else {
               response.sendRedirect("viewReservation.jsp?error=confirm_failed");
            }
         } catch (NumberFormatException var7) {
            response.sendRedirect("viewReservation.jsp?error=invalid_id");
         }

      }
   }

   private void checkAvailability(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      try {
         int roomId = Integer.parseInt(request.getParameter("roomId"));
         String checkInStr = request.getParameter("checkInDate");
         String checkOutStr = request.getParameter("checkOutDate");
         Date checkInDate = DateValidator.stringToSqlDate(checkInStr);
         Date checkOutDate = DateValidator.stringToSqlDate(checkOutStr);
         boolean available = this.reservationService.checkAvailability(roomId, checkInDate, checkOutDate);
         response.setContentType("application/json");
         response.getWriter().write("{\"available\": " + available + "}");
      } catch (Exception e) {
         response.setContentType("application/json");
         response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
      }

   }

   private String getErrorMessage(int errorCode) {
      switch (errorCode) {
         case -6 -> {
            return "Number of guests exceeds room capacity";
         }
         case -5 -> {
            return "Selected room does not exist";
         }
         case -4 -> {
            return "Room is not available for the selected dates";
         }
         case -3 -> {
            return "Check-in date cannot be in the past";
         }
         case -2 -> {
            return "Invalid date range: Check-out date must be after check-in date";
         }
         default -> {
            return "Error creating reservation. Please try again";
         }
      }
   }
}
