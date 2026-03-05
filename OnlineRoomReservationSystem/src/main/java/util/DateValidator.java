// Source code is decompiled from a .class file using FernFlower decompiler (from Intellij IDEA).
package util;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DateValidator {
   private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

   static {
      DATE_FORMAT.setLenient(false);
   }

   public DateValidator() {
   }

   public static boolean isValidDate(String dateStr) {
      if (dateStr != null && !dateStr.trim().isEmpty()) {
         try {
            DATE_FORMAT.parse(dateStr);
            return true;
         } catch (ParseException var2) {
            return false;
         }
      } else {
         return false;
      }
   }

   public static boolean isValidDateRange(Date checkIn, Date checkOut) {
      return checkIn != null && checkOut != null ? checkOut.after(checkIn) : false;
   }

   public static boolean isCheckInDateValid(Date checkIn) {
      if (checkIn == null) {
         return false;
      } else {
         LocalDate today = LocalDate.now();
         LocalDate checkInLocal = checkIn.toLocalDate();
         return !checkInLocal.isBefore(today);
      }
   }

   public static long calculateNights(Date checkIn, Date checkOut) {
      if (checkIn != null && checkOut != null) {
         LocalDate checkInLocal = checkIn.toLocalDate();
         LocalDate checkOutLocal = checkOut.toLocalDate();
         return ChronoUnit.DAYS.between(checkInLocal, checkOutLocal);
      } else {
         return 0L;
      }
   }

   public static Date stringToSqlDate(String dateStr) throws ParseException {
      if (!isValidDate(dateStr)) {
         throw new ParseException("Invalid date format: " + dateStr, 0);
      } else {
         java.util.Date utilDate = DATE_FORMAT.parse(dateStr);
         return new Date(utilDate.getTime());
      }
   }

   public static String sqlDateToString(Date date) {
      return date == null ? "" : DATE_FORMAT.format(date);
   }
}
