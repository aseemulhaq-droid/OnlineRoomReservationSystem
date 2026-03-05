// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package service;

import dao.ReservationDAO;
import dao.RoomDAO;
import java.sql.Date;
import model.Reservation;
import model.Room;
import util.DateValidator;

public class ReservationService {
   private ReservationDAO reservationDAO = new ReservationDAO();
   private RoomDAO roomDAO = new RoomDAO();

   public ReservationService() {
   }

   public int createReservation(Reservation reservation) {
      try {
         if (!DateValidator.isValidDateRange(reservation.getCheckInDate(), reservation.getCheckOutDate())) {
            System.err.println("Invalid date range: Check-out must be after check-in");
            return -2;
         } else if (!DateValidator.isCheckInDateValid(reservation.getCheckInDate())) {
            System.err.println("Check-in date cannot be in the past");
            return -3;
         } else {
            Room room = this.roomDAO.getRoomById(reservation.getRoomId());
            if (room == null) {
               System.err.println("Room not found: " + reservation.getRoomId());
               return -5;
            } else if (reservation.getNumberOfGuests() > room.getCapacity()) {
               System.err.println("Number of guests exceeds room capacity");
               return -6;
            } else if (!this.roomDAO.isRoomAvailable(reservation.getRoomId(), reservation.getCheckInDate(), reservation.getCheckOutDate())) {
               System.err.println("Room not available for selected dates");
               return -4;
            } else {
               long nights = DateValidator.calculateNights(reservation.getCheckInDate(), reservation.getCheckOutDate());
               double totalAmount = (double)nights * room.getRatePerNight();
               reservation.setTotalAmount(totalAmount);
               reservation.setReservationStatus("Pending");
               int reservationId = this.reservationDAO.createReservation(reservation);
               if (reservationId > 0) {
                  System.out.println("Reservation created successfully. ID: " + reservationId);
                  return reservationId;
               } else {
                  System.err.println("Failed to create reservation in database");
                  return -1;
               }
            }
         }
      } catch (Exception e) {
         System.err.println("Error creating reservation: " + e.getMessage());
         e.printStackTrace();
         return -1;
      }
   }

   public String validateDates(Date checkIn, Date checkOut) {
      if (!DateValidator.isValidDateRange(checkIn, checkOut)) {
         return "Check-out date must be after check-in date";
      } else {
         return !DateValidator.isCheckInDateValid(checkIn) ? "Check-in date cannot be in the past" : "";
      }
   }

   public boolean checkAvailability(int roomId, Date checkIn, Date checkOut) {
      return this.roomDAO.isRoomAvailable(roomId, checkIn, checkOut);
   }

   public boolean confirmReservation(int reservationId) {
      return this.reservationDAO.updateReservationStatus(reservationId, "Confirmed");
   }

   public boolean cancelReservation(int reservationId) {
      return this.reservationDAO.updateReservationStatus(reservationId, "Cancelled");
   }

   public boolean completeReservation(int reservationId) {
      return this.reservationDAO.updateReservationStatus(reservationId, "Completed");
   }
}
