// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Room implements Serializable {
   private static final long serialVersionUID = 1L;
   private int roomId;
   private String roomNumber;
   private String roomType;
   private double ratePerNight;
   private int capacity;
   private String description;
   private String amenities;
   private boolean isAvailable;
   private Timestamp createdAt;

   public Room() {
   }

   public Room(int roomId, String roomNumber, String roomType, double ratePerNight, int capacity, String description, String amenities, boolean isAvailable) {
      this.roomId = roomId;
      this.roomNumber = roomNumber;
      this.roomType = roomType;
      this.ratePerNight = ratePerNight;
      this.capacity = capacity;
      this.description = description;
      this.amenities = amenities;
      this.isAvailable = isAvailable;
   }

   public int getRoomId() {
      return this.roomId;
   }

   public void setRoomId(int roomId) {
      this.roomId = roomId;
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

   public int getCapacity() {
      return this.capacity;
   }

   public void setCapacity(int capacity) {
      this.capacity = capacity;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public String getAmenities() {
      return this.amenities;
   }

   public void setAmenities(String amenities) {
      this.amenities = amenities;
   }

   public boolean isAvailable() {
      return this.isAvailable;
   }

   public void setAvailable(boolean available) {
      this.isAvailable = available;
   }

   public Timestamp getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(Timestamp createdAt) {
      this.createdAt = createdAt;
   }

   public String toString() {
      return "Room{roomId=" + this.roomId + ", roomNumber='" + this.roomNumber + "', roomType='" + this.roomType + "', ratePerNight=" + this.ratePerNight + ", capacity=" + this.capacity + ", isAvailable=" + this.isAvailable + "}";
   }
}
