package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Bill;
import util.DBConnection;

public class BillDAO {

    public BillDAO() {
    }

    public int createBill(Bill bill) {
        String query = "INSERT INTO bills (reservation_id, user_id, subtotal, tax_amount, service_charge, discount, total_amount, bill_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query, 1);
            pstmt.setInt(1, bill.getReservationId());
            pstmt.setInt(2, bill.getUserId());
            pstmt.setDouble(3, bill.getSubtotal());
            pstmt.setDouble(4, bill.getTaxAmount());
            pstmt.setDouble(5, bill.getServiceCharge());
            pstmt.setDouble(6, bill.getDiscount());
            pstmt.setDouble(7, bill.getTotalAmount());
            pstmt.setString(8, bill.getBillStatus());
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
            System.err.println("Error creating bill: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public Bill getBillByReservationId(int reservationId) {
        Bill bill = null;
        String query = "SELECT b.*, r.guest_name, ro.room_number, ro.room_type FROM bills b INNER JOIN reservations r ON b.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE b.reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                bill = extractBillFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving bill by reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return bill;
    }

    public Bill getBillById(int billId) {
        Bill bill = null;
        String query = "SELECT b.*, r.guest_name, ro.room_number, ro.room_type FROM bills b INNER JOIN reservations r ON b.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE b.bill_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                bill = extractBillFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving bill: " + e.getMessage());
            e.printStackTrace();
        }
        return bill;
    }

    public List<Bill> getBillsByUserId(int userId) {
        List<Bill> bills = new ArrayList();
        String query = "SELECT b.*, r.guest_name, ro.room_number, ro.room_type FROM bills b INNER JOIN reservations r ON b.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE b.user_id = ? ORDER BY b.bill_date DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                bills.add(extractBillFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving user bills: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList();
        String query = "SELECT b.*, r.guest_name, ro.room_number, ro.room_type FROM bills b INNER JOIN reservations r ON b.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id ORDER BY b.bill_date DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                bills.add(extractBillFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving all bills: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    public boolean updateBillStatus(int billId, String status) {
        String query = "UPDATE bills SET bill_status = ? WHERE bill_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, status);
            pstmt.setInt(2, billId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error updating bill status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean billExistsForReservation(int reservationId) {
        String query = "SELECT COUNT(*) FROM bills WHERE reservation_id = ?";
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
            System.err.println("Error checking bill existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBill(int billId) {
        String query = "DELETE FROM bills WHERE bill_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, billId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error deleting bill: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Bill extractBillFromResultSet(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setReservationId(rs.getInt("reservation_id"));
        bill.setUserId(rs.getInt("user_id"));
        bill.setSubtotal(rs.getDouble("subtotal"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setServiceCharge(rs.getDouble("service_charge"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setBillStatus(rs.getString("bill_status"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        bill.setGuestName(rs.getString("guest_name"));
        bill.setRoomNumber(rs.getString("room_number"));
        bill.setRoomType(rs.getString("room_type"));
        return bill;
    }
}