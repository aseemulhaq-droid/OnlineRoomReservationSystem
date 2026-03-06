package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import dao.ReservationDAO;
import dao.RoomDAO;
import model.Reservation;
import java.util.Date;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ReservationDAOTest {

    private static ReservationDAO reservationDAO;
    private static int testReservationId;

    @BeforeAll
    static void setUp() {
        reservationDAO = new ReservationDAO();
        System.out.println("=== ReservationDAO Tests Started ===");
    }

    @Test @Order(1) @DisplayName("TC09 - Create reservation returns valid ID")
    void testCreateReservation() {
        Reservation res = new Reservation();
        res.setUserId(1);
        res.setRoomId(1);
        res.setGuestName("Test Guest");
        res.setGuestAddress("123 Test Street");
        res.setGuestPhone("0771234567");
        res.setGuestEmail("test@test.com");
        res.setNumberOfGuests(2);
        res.setReservationStatus("Pending");
        res.setTotalAmount(150.00);

        int id = reservationDAO.createReservation(res);
        assertTrue(id > 0);
        testReservationId = id;
        System.out.println("TC09 PASSED - Reservation created ID: " + id);
    }

    @Test @Order(2) @DisplayName("TC10 - Get all reservations returns list")
    void testGetAllReservations() {
        List<Reservation> list = reservationDAO.getAllReservations();
        assertNotNull(list);
        assertTrue(list.size() > 0);
        System.out.println("TC10 PASSED - Total reservations: " + list.size());
    }

    @Test @Order(3) @DisplayName("TC11 - Get reservation by valid ID")
    void testGetReservationById() {
        if (testReservationId > 0) {
            Reservation res = reservationDAO.getReservationById(testReservationId);
            assertNotNull(res);
            assertEquals("Test Guest", res.getGuestName());
            System.out.println("TC11 PASSED - Reservation found: " + res.getGuestName());
        } else {
            System.out.println("TC11 SKIPPED - No test reservation created");
        }
    }

    @Test @Order(4) @DisplayName("TC12 - Update reservation status")
    void testUpdateStatus() {
        if (testReservationId > 0) {
            boolean result = reservationDAO.updateReservationStatus(testReservationId, "Confirmed");
            assertTrue(result);
            System.out.println("TC12 PASSED - Status updated to Confirmed");
        } else {
            System.out.println("TC12 SKIPPED - No test reservation created");
        }
    }

    @Test @Order(5) @DisplayName("TC13 - Delete test reservation")
    void testDeleteReservation() {
        if (testReservationId > 0) {
            boolean result = reservationDAO.deleteReservation(testReservationId);
            assertTrue(result);
            System.out.println("TC13 PASSED - Test reservation deleted");
        } else {
            System.out.println("TC13 SKIPPED - No test reservation to delete");
        }
    }
}