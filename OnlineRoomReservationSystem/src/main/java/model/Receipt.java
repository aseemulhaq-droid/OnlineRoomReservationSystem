// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Receipt implements Serializable {
   private static final long serialVersionUID = 1L;
   private int receiptId;
   private int billId;
   private int reservationId;
   private String paymentMethod;
   private String transactionId;
   private double amountPaid;
   private Timestamp paymentDate;
   private String paymentStatus;
   private String remarks;
   private String guestName;
   private String roomNumber;
   private double totalBillAmount;

   public Receipt() {
   }

   public Receipt(int receiptId, int billId, int reservationId, String paymentMethod, String transactionId, double amountPaid, String paymentStatus, String remarks) {
      this.receiptId = receiptId;
      this.billId = billId;
      this.reservationId = reservationId;
      this.paymentMethod = paymentMethod;
      this.transactionId = transactionId;
      this.amountPaid = amountPaid;
      this.paymentStatus = paymentStatus;
      this.remarks = remarks;
   }

   public int getReceiptId() {
      return this.receiptId;
   }

   public void setReceiptId(int receiptId) {
      this.receiptId = receiptId;
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

   public String getPaymentMethod() {
      return this.paymentMethod;
   }

   public void setPaymentMethod(String paymentMethod) {
      this.paymentMethod = paymentMethod;
   }

   public String getTransactionId() {
      return this.transactionId;
   }

   public void setTransactionId(String transactionId) {
      this.transactionId = transactionId;
   }

   public double getAmountPaid() {
      return this.amountPaid;
   }

   public void setAmountPaid(double amountPaid) {
      this.amountPaid = amountPaid;
   }

   public Timestamp getPaymentDate() {
      return this.paymentDate;
   }

   public void setPaymentDate(Timestamp paymentDate) {
      this.paymentDate = paymentDate;
   }

   public String getPaymentStatus() {
      return this.paymentStatus;
   }

   public void setPaymentStatus(String paymentStatus) {
      this.paymentStatus = paymentStatus;
   }

   public String getRemarks() {
      return this.remarks;
   }

   public void setRemarks(String remarks) {
      this.remarks = remarks;
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

   public double getTotalBillAmount() {
      return this.totalBillAmount;
   }

   public void setTotalBillAmount(double totalBillAmount) {
      this.totalBillAmount = totalBillAmount;
   }

   public String toString() {
      return "Receipt{receiptId=" + this.receiptId + ", billId=" + this.billId + ", paymentMethod='" + this.paymentMethod + "', transactionId='" + this.transactionId + "', amountPaid=" + this.amountPaid + ", paymentStatus='" + this.paymentStatus + "'}";
   }
}
