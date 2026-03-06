package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import dao.BillDAO;
import model.Bill;
import java.util.Date;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BillDAOTest {

    private static BillDAO billDAO;
    private static int testBillId;

    // ⚠️ Change this to an existing reservation ID in your database
    private static final int TEST_RESERVATION_ID = 1;

    @BeforeAll
    static void setUp() {
        billDAO = new BillDAO();
        System.out.println("=== BillDAO Tests Started ===");
    }

    @Test @Order(1) @DisplayName("TC14 - Create bill returns valid ID")
    void testCreateBill() {
        // Only create if bill does not already exist
        if (!billDAO.billExistsForReservation(TEST_RESERVATION_ID)) {
            Bill bill = new Bill();
            bill.setReservationId(TEST_RESERVATION_ID);
            bill.setUserId(1);
            bill.setSubtotal(150.00);
            bill.setTaxAmount(15.00);
            bill.setServiceCharge(7.50);
            bill.setDiscount(0.00);
            bill.setTotalAmount(172.50);
            bill.setBillStatus("Pending");
         

            int id = billDAO.createBill(bill);
            assertTrue(id > 0);
            testBillId = id;
            System.out.println("TC14 PASSED - Bill created ID: " + id);
        } else {
            Bill existing = billDAO.getBillByReservationId(TEST_RESERVATION_ID);
            testBillId = existing.getBillId();
            System.out.println("TC14 PASSED - Bill already exists ID: " + testBillId);
        }
    }

    @Test @Order(2) @DisplayName("TC15 - Get bill by reservation ID")
    void testGetBillByReservationId() {
        Bill bill = billDAO.getBillByReservationId(TEST_RESERVATION_ID);
        assertNotNull(bill);
        System.out.println("TC15 PASSED - Bill total: " + bill.getTotalAmount());
    }

    @Test @Order(3) @DisplayName("TC16 - Bill exists for reservation")
    void testBillExists() {
        boolean exists = billDAO.billExistsForReservation(TEST_RESERVATION_ID);
        assertTrue(exists);
        System.out.println("TC16 PASSED - Bill exists confirmed");
    }

    @Test @Order(4) @DisplayName("TC17 - Update bill status to Paid")
    void testUpdateBillStatus() {
        if (testBillId > 0) {
            boolean result = billDAO.updateBillStatus(testBillId, "Paid");
            assertTrue(result);
            System.out.println("TC17 PASSED - Bill status updated to Paid");
        } else {
            System.out.println("TC17 SKIPPED - No test bill ID");
        }
    }
}