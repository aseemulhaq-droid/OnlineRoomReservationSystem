// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
   private static final long serialVersionUID = 1L;
   private int userId;
   private String username;
   private String password;
   private String fullName;
   private String email;
   private String phone;
   private String role;
   private Timestamp createdAt;
   private boolean isActive;

   public User() {
   }

   public User(int userId, String username, String fullName, String email, String phone, String role) {
      this.userId = userId;
      this.username = username;
      this.fullName = fullName;
      this.email = email;
      this.phone = phone;
      this.role = role;
   }

   public int getUserId() {
      return this.userId;
   }

   public void setUserId(int userId) {
      this.userId = userId;
   }

   public String getUsername() {
      return this.username;
   }

   public void setUsername(String username) {
      this.username = username;
   }

   public String getPassword() {
      return this.password;
   }

   public void setPassword(String password) {
      this.password = password;
   }

   public String getFullName() {
      return this.fullName;
   }

   public void setFullName(String fullName) {
      this.fullName = fullName;
   }

   public String getEmail() {
      return this.email;
   }

   public void setEmail(String email) {
      this.email = email;
   }

   public String getPhone() {
      return this.phone;
   }

   public void setPhone(String phone) {
      this.phone = phone;
   }

   public String getRole() {
      return this.role;
   }

   public void setRole(String role) {
      this.role = role;
   }

   public Timestamp getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(Timestamp createdAt) {
      this.createdAt = createdAt;
   }

   public boolean isActive() {
      return this.isActive;
   }

   public void setActive(boolean active) {
      this.isActive = active;
   }

   public String toString() {
      return "User{userId=" + this.userId + ", username='" + this.username + "', fullName='" + this.fullName + "', email='" + this.email + "', role='" + this.role + "'}";
   }
}
