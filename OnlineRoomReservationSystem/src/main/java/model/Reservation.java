// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Reservation implements Serializable {
   private static final long serialVersionUID = 1L;
   private int reservationId;
   private int userId;
   private int roomId;
   private String guestName;
   private String guestAddress;
   private String guestEmail;
   private String guestPhone;
   private Date checkInDate;
   private Date checkOutDate;
   private int numberOfGuests;
   private String specialRequests;
   private String reservationStatus;
   private double totalAmount;
   private Timestamp createdAt;
   private String roomNumber;
   private String roomType;
   private double ratePerNight;

   public Reservation() {
   }

   public Reservation(int reservationId, int userId, int roomId, String guestName, String guestAddress, String guestEmail, String guestPhone, Date checkInDate, Date checkOutDate, int numberOfGuests, String specialRequests, String reservationStatus, double totalAmount) {
      this.reservationId = reservationId;
      this.userId = userId;
      this.roomId = roomId;
      this.guestName = guestName;
      this.guestAddress = guestAddress;
      this.guestEmail = guestEmail;
      this.guestPhone = guestPhone;
      this.checkInDate = checkInDate;
      this.checkOutDate = checkOutDate;
      this.numberOfGuests = numberOfGuests;
      this.specialRequests = specialRequests;
      this.reservationStatus = reservationStatus;
      this.totalAmount = totalAmount;
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

   public int getRoomId() {
      return this.roomId;
   }

   public void setRoomId(int roomId) {
      this.roomId = roomId;
   }

   public String getGuestName() {
      return this.guestName;
   }

   public void setGuestName(String guestName) {
      this.guestName = guestName;
   }

   public String getGuestAddress() {
      return this.guestAddress;
   }

   public void setGuestAddress(String guestAddress) {
      this.guestAddress = guestAddress;
   }

   public String getGuestEmail() {
      return this.guestEmail;
   }

   public void setGuestEmail(String guestEmail) {
      this.guestEmail = guestEmail;
   }

   public String getGuestPhone() {
      return this.guestPhone;
   }

   public void setGuestPhone(String guestPhone) {
      this.guestPhone = guestPhone;
   }

   public Date getCheckInDate() {
      return this.checkInDate;
   }

   public void setCheckInDate(Date checkInDate) {
      this.checkInDate = checkInDate;
   }

   public Date getCheckOutDate() {
      return this.checkOutDate;
   }

   public void setCheckOutDate(Date checkOutDate) {
      this.checkOutDate = checkOutDate;
   }

   public int getNumberOfGuests() {
      return this.numberOfGuests;
   }

   public void setNumberOfGuests(int numberOfGuests) {
      this.numberOfGuests = numberOfGuests;
   }

   public String getSpecialRequests() {
      return this.specialRequests;
   }

   public void setSpecialRequests(String specialRequests) {
      this.specialRequests = specialRequests;
   }

   public String getReservationStatus() {
      return this.reservationStatus;
   }

   public void setReservationStatus(String reservationStatus) {
      this.reservationStatus = reservationStatus;
   }

   public double getTotalAmount() {
      return this.totalAmount;
   }

   public void setTotalAmount(double totalAmount) {
      this.totalAmount = totalAmount;
   }

   public Timestamp getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(Timestamp createdAt) {
      this.createdAt = createdAt;
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

   public double getRatePerNight() {
      return this.ratePerNight;
   }

   public void setRatePerNight(double ratePerNight) {
      this.ratePerNight = ratePerNight;
   }

   public String toString() {
      int var10000 = this.reservationId;
      return "Reservation{reservationId=" + var10000 + ", guestName='" + this.guestName + "', guestAddress ='" + this.guestAddress + "', roomId=" + this.roomId + ", checkInDate=" + String.valueOf(this.checkInDate) + ", checkOutDate=" + String.valueOf(this.checkOutDate) + ", reservationStatus='" + this.reservationStatus + "', totalAmount=" + this.totalAmount + "}";
   }
}
