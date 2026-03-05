// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Bill implements Serializable {
   private static final long serialVersionUID = 1L;
   private int billId;
   private int reservationId;
   private int userId;
   private double subtotal;
   private double taxAmount;
   private double serviceCharge;
   private double discount;
   private double totalAmount;
   private String billStatus;
   private Timestamp billDate;
   private String guestName;
   private String roomNumber;
   private String roomType;

   public Bill() {
   }

   public Bill(int billId, int reservationId, int userId, double subtotal, double taxAmount, double serviceCharge, double discount, double totalAmount, String billStatus) {
      this.billId = billId;
      this.reservationId = reservationId;
      this.userId = userId;
      this.subtotal = subtotal;
      this.taxAmount = taxAmount;
      this.serviceCharge = serviceCharge;
      this.discount = discount;
      this.totalAmount = totalAmount;
      this.billStatus = billStatus;
   }

   public int getBillId() {
      return this.billId;
   }

   public void setBillId(int billId) {
      this.billId = billId;
   }

   public int getReservationId() {
      return this.reservationId;
   }

   public void setReservationId(int reservationId) {
      this.reservationId = reservationId;
   }

   public int getUserId() {
      return this.userId;
   }

   public void setUserId(int userId) {
      this.userId = userId;
   }

   public double getSubtotal() {
      return this.subtotal;
   }

   public void setSubtotal(double subtotal) {
      this.subtotal = subtotal;
   }

   public double getTaxAmount() {
      return this.taxAmount;
   }

   public void setTaxAmount(double taxAmount) {
      this.taxAmount = taxAmount;
   }

   public double getServiceCharge() {
      return this.serviceCharge;
   }

   public void setServiceCharge(double serviceCharge) {
      this.serviceCharge = serviceCharge;
   }

   public double getDiscount() {
      return this.discount;
   }

   public void setDiscount(double discount) {
      this.discount = discount;
   }

   public double getTotalAmount() {
      return this.totalAmount;
   }

   public void setTotalAmount(double totalAmount) {
      this.totalAmount = totalAmount;
   }

   public String getBillStatus() {
      return this.billStatus;
   }

   public void setBillStatus(String billStatus) {
      this.billStatus = billStatus;
   }

   public Timestamp getBillDate() {
      return this.billDate;
   }

   public void setBillDate(Timestamp billDate) {
      this.billDate = billDate;
   }

   public String getGuestName() {
      return this.guestName;
   }

   public void setGuestName(String guestName) {
      this.guestName = guestName;
   }

   public String getRoomNumber() {
      return this.roomNumber;
   }

   public void setRoomNumber(String roomNumber) {
      this.roomNumber = roomNumber;
   }

   public String getRoomType() {
      return this.roomType;
   }

   public void setRoomType(String roomType) {
      this.roomType = roomType;
   }

   public String toString() {
      return "Bill{billId=" + this.billId + ", reservationId=" + this.reservationId + ", subtotal=" + this.subtotal + ", taxAmount=" + this.taxAmount + ", serviceCharge=" + this.serviceCharge + ", totalAmount=" + this.totalAmount + ", billStatus='" + this.billStatus + "'}";
   }
}
