// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package service;

import dao.BillDAO;
import dao.ReservationDAO;
import dao.RoomDAO;
import model.Bill;
import model.Reservation;
import model.Room;
import util.DateValidator;

public class BillingService {
   private BillDAO billDAO = new BillDAO();
   private ReservationDAO reservationDAO = new ReservationDAO();
   private RoomDAO roomDAO = new RoomDAO();
   private static final double TAX_RATE = 0.13;
   private static final double SERVICE_CHARGE_RATE = 0.05;

   public BillingService() {
   }

   public int generateBill(int reservationId) {
      try {
         if (this.billDAO.billExistsForReservation(reservationId)) {
            System.err.println("Bill already exists for reservation ID: " + reservationId);
            return -1;
         } else {
            Reservation reservation = this.reservationDAO.getReservationById(reservationId);
            if (reservation == null) {
               System.err.println("Reservation not found: " + reservationId);
               return -1;
            } else {
               Room room = this.roomDAO.getRoomById(reservation.getRoomId());
               if (room == null) {
                  System.err.println("Room not found: " + reservation.getRoomId());
                  return -1;
               } else {
                  long nights = DateValidator.calculateNights(reservation.getCheckInDate(), reservation.getCheckOutDate());
                  if (nights <= 0L) {
                     System.err.println("Invalid date range for billing");
                     return -1;
                  } else {
                     double subtotal = (double)nights * room.getRatePerNight();
                     double taxAmount = subtotal * 0.13;
                     double serviceCharge = subtotal * 0.05;
                     double discount = (double)0.0F;
                     double totalAmount = subtotal + taxAmount + serviceCharge - discount;
                     Bill bill = new Bill();
                     bill.setReservationId(reservationId);
                     bill.setUserId(reservation.getUserId());
                     bill.setSubtotal(subtotal);
                     bill.setTaxAmount(taxAmount);
                     bill.setServiceCharge(serviceCharge);
                     bill.setDiscount(discount);
                     bill.setTotalAmount(totalAmount);
                     bill.setBillStatus("Pending");
                     int billId = this.billDAO.createBill(bill);
                     if (billId > 0) {
                        System.out.println("Bill generated successfully. Bill ID: " + billId);
                        return billId;
                     } else {
                        System.err.println("Failed to create bill in database");
                        return -1;
                     }
                  }
               }
            }
         }
      } catch (Exception e) {
         System.err.println("Error generating bill: " + e.getMessage());
         e.printStackTrace();
         return -1;
      }
   }

   public Bill calculateBillPreview(int roomId, long nights) {
      Bill bill = new Bill();

      try {
         Room room = this.roomDAO.getRoomById(roomId);
         if (room == null) {
            return null;
         } else {
            double subtotal = (double)nights * room.getRatePerNight();
            double taxAmount = subtotal * 0.13;
            double serviceCharge = subtotal * 0.05;
            double discount = (double)0.0F;
            double totalAmount = subtotal + taxAmount + serviceCharge - discount;
            bill.setSubtotal(subtotal);
            bill.setTaxAmount(taxAmount);
            bill.setServiceCharge(serviceCharge);
            bill.setDiscount(discount);
            bill.setTotalAmount(totalAmount);
            return bill;
         }
      } catch (Exception e) {
         System.err.println("Error calculating bill preview: " + e.getMessage());
         e.printStackTrace();
         return null;
      }
   }

   public boolean markBillAsPaid(int billId) {
      return this.billDAO.updateBillStatus(billId, "Paid");
   }

   public boolean cancelBill(int billId) {
      return this.billDAO.updateBillStatus(billId, "Cancelled");
   }
}
