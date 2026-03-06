package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import dao.ReceiptDAO;
import model.Receipt;
import java.util.Date;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ReceiptDAOTest {

    private static ReceiptDAO receiptDAO;
    private static int testReceiptId;

    // ⚠️ Change to an existing bill ID in your database
    private static final int TEST_BILL_ID = 1;
    private static final int TEST_RESERVATION_ID = 1;

    @BeforeAll
    static void setUp() {
        receiptDAO = new ReceiptDAO();
        System.out.println("=== ReceiptDAO Tests Started ===");
    }

    @Test @Order(1) @DisplayName("TC18 - Create receipt returns valid ID")
    void testCreateReceipt() {
        if (!receiptDAO.receiptExistsForBill(TEST_BILL_ID)) {
            Receipt receipt = new Receipt();
            receipt.setBillId(TEST_BILL_ID);
            receipt.setReservationId(TEST_RESERVATION_ID);
            receipt.setPaymentMethod("Cash");
            receipt.setTransactionId("TXN-TEST-001");
            receipt.setAmountPaid(172.50);
            receipt.setPaymentStatus("Completed");
            receipt.setRemarks("Test payment");

            int id = receiptDAO.createReceipt(receipt);
            assertTrue(id > 0);
            testReceiptId = id;
            System.out.println("TC18 PASSED - Receipt created ID: " + id);
        } else {
            Receipt existing = receiptDAO.getReceiptByBillId(TEST_BILL_ID);
            testReceiptId = existing.getReceiptId();
            System.out.println("TC18 PASSED - Receipt already exists ID: " + testReceiptId);
        }
    }

    @Test @Order(2) @DisplayName("TC19 - Get receipt by bill ID")
    void testGetReceiptByBillId() {
        Receipt receipt = receiptDAO.getReceiptByBillId(TEST_BILL_ID);
        assertNotNull(receipt);
        System.out.println("TC19 PASSED - Receipt found: " + receipt.getPaymentMethod());
    }

    @Test @Order(3) @DisplayName("TC20 - Receipt exists for bill")
    void testReceiptExists() {
        boolean exists = receiptDAO.receiptExistsForBill(TEST_BILL_ID);
        assertTrue(exists);
        System.out.println("TC20 PASSED - Receipt exists confirmed");
    }
}