package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Receipt;
import util.DBConnection;

public class ReceiptDAO {

    public ReceiptDAO() {
    }

    public int createReceipt(Receipt receipt) {
        String query = "INSERT INTO receipts (bill_id, reservation_id, payment_method, transaction_id, amount_paid, payment_status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query, 1);
            pstmt.setInt(1, receipt.getBillId());
            pstmt.setInt(2, receipt.getReservationId());
            pstmt.setString(3, receipt.getPaymentMethod());
            pstmt.setString(4, receipt.getTransactionId());
            pstmt.setDouble(5, receipt.getAmountPaid());
            pstmt.setString(6, receipt.getPaymentStatus());
            pstmt.setString(7, receipt.getRemarks());
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
            System.err.println("Error creating receipt: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public Receipt getReceiptById(int receiptId) {
        Receipt receipt = null;
        String query = "SELECT rec.*, r.guest_name, ro.room_number, b.total_amount FROM receipts rec INNER JOIN bills b ON rec.bill_id = b.bill_id INNER JOIN reservations r ON rec.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE rec.receipt_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, receiptId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                receipt = extractReceiptFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving receipt: " + e.getMessage());
            e.printStackTrace();
        }
        return receipt;
    }

    public Receipt getReceiptByBillId(int billId) {
        Receipt receipt = null;
        String query = "SELECT rec.*, r.guest_name, ro.room_number, b.total_amount FROM receipts rec INNER JOIN bills b ON rec.bill_id = b.bill_id INNER JOIN reservations r ON rec.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE rec.bill_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                receipt = extractReceiptFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving receipt by bill: " + e.getMessage());
            e.printStackTrace();
        }
        return receipt;
    }

    public Receipt getReceiptByReservationId(int reservationId) {
        Receipt receipt = null;
        String query = "SELECT rec.*, r.guest_name, ro.room_number, b.total_amount FROM receipts rec INNER JOIN bills b ON rec.bill_id = b.bill_id INNER JOIN reservations r ON rec.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id WHERE rec.reservation_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                receipt = extractReceiptFromResultSet(rs);
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving receipt by reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return receipt;
    }

    public List<Receipt> getAllReceipts() {
        List<Receipt> receipts = new ArrayList();
        String query = "SELECT rec.*, r.guest_name, ro.room_number, b.total_amount FROM receipts rec INNER JOIN bills b ON rec.bill_id = b.bill_id INNER JOIN reservations r ON rec.reservation_id = r.reservation_id INNER JOIN rooms ro ON r.room_id = ro.room_id ORDER BY rec.payment_date DESC";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                receipts.add(extractReceiptFromResultSet(rs));
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error retrieving all receipts: " + e.getMessage());
            e.printStackTrace();
        }
        return receipts;
    }

    public boolean receiptExistsForBill(int billId) {
        String query = "SELECT COUNT(*) FROM receipts WHERE bill_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, billId);
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
            System.err.println("Error checking receipt existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePaymentStatus(int receiptId, String status) {
        String query = "UPDATE receipts SET payment_status = ? WHERE receipt_id = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, status);
            pstmt.setInt(2, receiptId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return rowsAffected > 0;
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Receipt extractReceiptFromResultSet(ResultSet rs) throws SQLException {
        Receipt receipt = new Receipt();
        receipt.setReceiptId(rs.getInt("receipt_id"));
        receipt.setBillId(rs.getInt("bill_id"));
        receipt.setReservationId(rs.getInt("reservation_id"));
        receipt.setPaymentMethod(rs.getString("payment_method"));
        receipt.setTransactionId(rs.getString("transaction_id"));
        receipt.setAmountPaid(rs.getDouble("amount_paid"));
        receipt.setPaymentDate(rs.getTimestamp("payment_date"));
        receipt.setPaymentStatus(rs.getString("payment_status"));
        receipt.setRemarks(rs.getString("remarks"));
        receipt.setGuestName(rs.getString("guest_name"));
        receipt.setRoomNumber(rs.getString("room_number"));
        receipt.setTotalBillAmount(rs.getDouble("total_amount"));
        return receipt;
    }
}