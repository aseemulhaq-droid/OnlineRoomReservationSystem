// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
   private static final String DB_URL = "jdbc:mysql://localhost:3306/ocean_view_resort";
   private static final String DB_USER = "root";
   private static final String DB_PASSWORD = "";
   private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
   private static Connection connection = null;

   private DBConnection() {
   }

   public static Connection getConnection() throws SQLException, ClassNotFoundException {
      if (connection == null || connection.isClosed()) {
         try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_resort", "root", "");
            System.out.println("Database connection established successfully.");
         } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw e;
         } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
         }
      }

      return connection;
   }

   public static void closeConnection() {
      if (connection != null) {
         try {
            connection.close();
            System.out.println("Database connection closed successfully.");
         } catch (SQLException e) {
            System.err.println("Error closing database connection: " + e.getMessage());
         }
      }

   }

   public static boolean testConnection() {
      try {
         Connection conn = getConnection();
         return conn != null && !conn.isClosed();
      } catch (Exception e) {
         System.err.println("Connection test failed: " + e.getMessage());
         return false;
      }
   }
}
