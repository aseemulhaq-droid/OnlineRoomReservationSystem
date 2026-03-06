package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer;

import dao.UserDAO;
import model.User;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserDAOTest {

    private static UserDAO userDAO;

    @BeforeAll
    static void setUp() {
        userDAO = new UserDAO();
        System.out.println("=== UserDAO Test Started ===");
    }

    @Test
    @Order(1)
    @DisplayName("TC01 - Valid login returns User")
    void testValidLogin() {
        User user = userDAO.authenticateUser("admin", "admin123");
        assertNotNull(user);
        System.out.println("TC01 PASSED - Valid login works");
    }

    @Test
    @Order(2)
    @DisplayName("TC02 - Wrong password returns null")
    void testInvalidLogin() {
        User user = userDAO.authenticateUser("admin", "wrongpass");
        assertNull(user);
        System.out.println("TC02 PASSED - Invalid login returns null");
    }

    @Test
    @Order(3)
    @DisplayName("TC03 - Wrong username returns null")
    void testWrongUsername() {
        User user = userDAO.authenticateUser("wronguser", "admin123");
        assertNull(user);
        System.out.println("TC03 PASSED - Wrong username returns null");
    }

    @Test
    @Order(4)
    @DisplayName("TC04 - Empty fields returns null")
    void testEmptyFields() {
        User user = userDAO.authenticateUser("", "");
        assertNull(user);
        System.out.println("TC04 PASSED - Empty fields returns null");
    }

}