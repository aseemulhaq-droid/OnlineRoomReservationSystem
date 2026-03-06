package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import dao.RoomDAO;
import model.Room;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class RoomDAOTest {

    private static RoomDAO roomDAO;

    @BeforeAll
    static void setUp() {
        roomDAO = new RoomDAO();
        System.out.println("=== RoomDAO Tests Started ===");
    }

    @Test @Order(1) @DisplayName("TC05 - Get all rooms returns list")
    void testGetAllRooms() {
        List<Room> rooms = roomDAO.getAllRooms();
        assertNotNull(rooms);
        assertTrue(rooms.size() > 0);
        System.out.println("TC05 PASSED - Rooms list returned: " + rooms.size());
    }

    @Test @Order(2) @DisplayName("TC06 - Get available rooms returns list")
    void testGetAvailableRooms() {
        List<Room> rooms = roomDAO.getAllAvailableRooms();
        assertNotNull(rooms);
        System.out.println("TC06 PASSED - Available rooms: " + rooms.size());
    }

    @Test @Order(3) @DisplayName("TC07 - Get room by valid ID returns room")
    void testGetRoomById() {
        Room room = roomDAO.getRoomById(1);
        assertNotNull(room);
        System.out.println("TC07 PASSED - Room found: " + room.getRoomNumber());
    }

    @Test @Order(4) @DisplayName("TC08 - Get room by invalid ID returns null")
    void testGetRoomByInvalidId() {
        Room room = roomDAO.getRoomById(9999);
        assertNull(room);
        System.out.println("TC08 PASSED - Invalid room ID returns null");
    }
}