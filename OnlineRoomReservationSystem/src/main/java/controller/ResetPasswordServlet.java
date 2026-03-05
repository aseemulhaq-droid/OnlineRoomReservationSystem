// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet({"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {
   public ResetPasswordServlet() {
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String user = request.getParameter("username");
      String answer = request.getParameter("answer");
      String newPass = request.getParameter("newPassword");

      try {
         Class.forName("com.mysql.cj.jdbc.Driver");
         Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocean_view_resort", "root", "");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND security_answer=?");
         ps.setString(1, user);
         ps.setString(2, answer);
         ResultSet rs = ps.executeQuery();
         if (rs.next()) {
            PreparedStatement updatePs = con.prepareStatement("UPDATE users SET password=? WHERE username=?");
            updatePs.setString(1, newPass);
            updatePs.setString(2, user);
            int rowEffected = updatePs.executeUpdate();
            if (rowEffected > 0) {
               response.sendRedirect("login.jsp?reset=success");
            }
         } else {
            response.sendRedirect("forgot_password.jsp?error=invalid");
         }

         con.close();
      } catch (Exception e) {
         e.printStackTrace();
         response.getWriter().println("Database Error: " + e.getMessage());
      }

   }
}
