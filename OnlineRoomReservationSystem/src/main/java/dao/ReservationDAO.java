package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Reservation;
import util.DBConnection;

public class ReservationDAO {

    public ReservationDAO() {
    }

    public int createReservation(Reservation reservation) {
        String query = "INSERT INTO reservations (user_id, room_id, guest_name, guest_address , guest_email, guest_phone, check_in_date, check_out_date, number_of_guests, special_requests, reservation_status, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query, 1);
            pstmt.setInt(1, reservation.getUserId());
            pstmt.setInt(2, reservation.getRoomId());
            pstmt.setString(3, reservation.getGuestName());
            pstmt.setString(4, reservation.getGuestAddress());
            pstmt.setString(5, reservation.getGuestEmail());
            pstmt.setString(6, reservation.getGuestPhone());
            pstmt.setDate(7, reservation.getCheckInDate());
            pstmt.setDate(8, reservation.getCheckOutDate());
            pstmt.setInt(9, reservation.getNumberOfGuests());
            pstmt.setString(10, reservation.getSpecialRequests());
            pstmt.setString(11, reservation.getReservationStatus());
            pstmt.setDouble(12, reservation.getTotalAmount());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    rs.close();
                    pstmt.close();
                    conn.close();
                    return id;
                }
            }
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error creating reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public List<Reservation> getReservationsByUserId(int userId) {
        List<Reservation> reservations = new ArrayList();
        String query = "SELECT r.*, ro.room_number, ro.room_type, ro.rate_per_night FROM reservations r INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE r.user_id = ? ORDER BY r.created_at DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                reservations.add(extractReservationFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving user reservations: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList();
        String query = "SELECT r.*, ro.room_number, ro.room_type, ro.rate_per_night FROM reservations r INNER JOIN rooms ro ON r.room_id = ro.room_id ORDER BY r.created_at DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                reservations.add(extractReservationFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving all reservations: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }

    public Reservation getReservationById(int reservationId) {
        Reservation reservation = null;
        String query = "SELECT r.*, ro.room_number, ro.room_type, ro.rate_per_night FROM reservations r INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE r.reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                reservation = extractReservationFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return reservation;
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        String query = "UPDATE reservations SET reservation_status = ? WHERE reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, status);
            pstmt.setInt(2, reservationId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error updating reservation status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelReservation(int reservationId) {
        return this.updateReservationStatus(reservationId, "Cancelled");
    }

    public boolean deleteReservation(int reservationId) {
        String query = "DELETE FROM reservations WHERE reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error deleting reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean reservationExists(int reservationId) {
        String query = "SELECT COUNT(*) FROM reservations WHERE reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                rs.close();
                pstmt.close();
                conn.close();
                return exists;
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error checking reservation existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Reservation extractReservationFromResultSet(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setUserId(rs.getInt("user_id"));
        reservation.setRoomId(rs.getInt("room_id"));
        reservation.setGuestName(rs.getString("guest_name"));
        reservation.setGuestAddress(rs.getString("guest_address"));
        reservation.setGuestEmail(rs.getString("guest_email"));
        reservation.setGuestPhone(rs.getString("guest_phone"));
        reservation.setCheckInDate(rs.getDate("check_in_date"));
        reservation.setCheckOutDate(rs.getDate("check_out_date"));
        reservation.setNumberOfGuests(rs.getInt("number_of_guests"));
        reservation.setSpecialRequests(rs.getString("special_requests"));
        reservation.setReservationStatus(rs.getString("reservation_status"));
        reservation.setTotalAmount(rs.getDouble("total_amount"));
        reservation.setCreatedAt(rs.getTimestamp("created_at"));
        reservation.setRoomNumber(rs.getString("room_number"));
        reservation.setRoomType(rs.getString("room_type"));
        reservation.setRatePerNight(rs.getDouble("rate_per_night"));
        return reservation;
    }
}