// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet({"/LoginServlet"})
public class LoginServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private UserDAO userDAO;

   public LoginServlet() {
   }

   public void init() {
      this.userDAO = new UserDAO();
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      response.sendRedirect("login.jsp");
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getParameter("action");
      if ("login".equals(action)) {
         this.handleLogin(request, response);
      } else if ("logout".equals(action)) {
         this.handleLogout(request, response);
      } else {
         response.sendRedirect("login.jsp");
      }

   }

   private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String username = request.getParameter("username");
      String password = request.getParameter("password");
      if (username != null && !username.trim().isEmpty() && password != null && !password.trim().isEmpty()) {
         User user = this.userDAO.authenticateUser(username.trim(), password);
         if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(1800);
            response.sendRedirect("dashboard.jsp?welcome=true");
         } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
         }

      } else {
         request.setAttribute("errorMessage", "Username and password are required");
         request.getRequestDispatcher("login.jsp").forward(request, response);
      }
   }

   private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession(false);
      if (session != null) {
         session.invalidate();
      }

      response.sendRedirect("login.jsp?message=logout");
   }
}
