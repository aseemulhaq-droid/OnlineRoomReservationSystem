package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Room;
import util.DBConnection;

public class RoomDAO {

    public RoomDAO() {
    }

    public List<Room> getAllAvailableRooms() {
        List<Room> rooms = new ArrayList();
        String query = "SELECT * FROM rooms WHERE is_available = TRUE ORDER BY room_type, rate_per_night";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rooms.add(extractRoomFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving available rooms: " + e.getMessage());
            e.printStackTrace();
        }
        return rooms;
    }

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList();
        String query = "SELECT * FROM rooms ORDER BY room_number";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rooms.add(extractRoomFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving all rooms: " + e.getMessage());
            e.printStackTrace();
        }
        return rooms;
    }

    public Room getRoomById(int roomId) {
        Room room = null;
        String query = "SELECT * FROM rooms WHERE room_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                room = extractRoomFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving room: " + e.getMessage());
            e.printStackTrace();
        }
        return room;
    }

    public List<Room> getRoomsByType(String roomType) {
        List<Room> rooms = new ArrayList();
        String query = "SELECT * FROM rooms WHERE room_type = ? AND is_available = TRUE";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, roomType);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                rooms.add(extractRoomFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving rooms by type: " + e.getMessage());
            e.printStackTrace();
        }
        return rooms;
    }

    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        String query = "SELECT COUNT(*) FROM reservations WHERE room_id = ? AND reservation_status NOT IN ('Cancelled') AND ((check_in_date <= ? AND check_out_date > ?) OR (check_in_date < ? AND check_out_date >= ?) OR (check_in_date >= ? AND check_out_date <= ?))";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, roomId);
            pstmt.setDate(2, checkIn);
            pstmt.setDate(3, checkIn);
            pstmt.setDate(4, checkOut);
            pstmt.setDate(5, checkOut);
            pstmt.setDate(6, checkIn);
            pstmt.setDate(7, checkOut);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                boolean available = rs.getInt(1) == 0;
                rs.close();
                pstmt.close();
                conn.close();
                return available;
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error checking room availability: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoomAvailability(int roomId, boolean isAvailable) {
        String query = "UPDATE rooms SET is_available = ? WHERE room_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setBoolean(1, isAvailable);
            pstmt.setInt(2, roomId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error updating room availability: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Room extractRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRatePerNight(rs.getDouble("rate_per_night"));
        room.setCapacity(rs.getInt("capacity"));
        room.setDescription(rs.getString("description"));
        room.setAmenities(rs.getString("amenities"));
        room.setAvailable(rs.getBoolean("is_available"));
        room.setCreatedAt(rs.getTimestamp("created_at"));
        return room;
    }
}