package test;

import org.junit.platform.suite.api.SelectClasses;
import org.junit.platform.suite.api.Suite;

@Suite
@SelectClasses({
    UserDAOTest.class,
    RoomDAOTest.class,
    ReservationDAOTest.class,
    BillDAOTest.class,
    ReceiptDAOTest.class
})
public class AllTestsSuite {
    // Run all tests together
}