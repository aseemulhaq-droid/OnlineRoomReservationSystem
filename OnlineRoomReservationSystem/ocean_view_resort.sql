-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 06, 2026 at 11:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ocean_view_resort`
--

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) DEFAULT 0.00,
  `service_charge` decimal(10,2) DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL,
  `bill_status` enum('Pending','Paid','Cancelled') DEFAULT 'Pending',
  `bill_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`bill_id`, `reservation_id`, `user_id`, `subtotal`, `tax_amount`, `service_charge`, `discount`, `total_amount`, `bill_status`, `bill_date`) VALUES
(1, 1, 1, 3000.00, 390.00, 150.00, 0.00, 3540.00, 'Paid', '2026-02-19 05:59:46'),
(2, 2, 1, 17500.00, 2275.00, 875.00, 0.00, 20650.00, 'Paid', '2026-02-27 14:33:49'),
(3, 3, 1, 13500.00, 1755.00, 675.00, 0.00, 15930.00, 'Pending', '2026-03-06 08:11:18');

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `receipt_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  `payment_method` enum('Cash','Credit Card','Debit Card','Online Banking','PayPal') NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `payment_status` enum('Success','Failed','Refunded') DEFAULT 'Success',
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `receipts`
--

INSERT INTO `receipts` (`receipt_id`, `bill_id`, `reservation_id`, `payment_method`, `transaction_id`, `amount_paid`, `payment_date`, `payment_status`, `remarks`) VALUES
(12, 1, 1, 'Cash', 'TXN177174923136661F7BE84', 3540.00, '2026-02-22 08:33:51', 'Success', ''),
(13, 2, 2, 'Cash', 'TXN177220285537548C7B344', 20650.00, '2026-02-27 14:34:15', 'Success', '');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `guest_name` varchar(100) NOT NULL,
  `guest_address` text DEFAULT NULL,
  `guest_email` varchar(100) NOT NULL,
  `guest_phone` varchar(15) NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `number_of_guests` int(11) NOT NULL,
  `special_requests` text DEFAULT NULL,
  `reservation_status` enum('Pending','Confirmed','Cancelled','Completed') DEFAULT 'Pending',
  `total_amount` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`reservation_id`, `user_id`, `room_id`, `guest_name`, `guest_address`, `guest_email`, `guest_phone`, `check_in_date`, `check_out_date`, `number_of_guests`, `special_requests`, `reservation_status`, `total_amount`, `created_at`) VALUES
(1, 1, 1, 'Mohamed Aseemulhaq', 'beach road , pottuvil', 'aseemaseemulhaq@gmail.com', '763689100', '2026-02-19', '2026-02-21', 1, NULL, 'Confirmed', 3000.00, '2026-02-19 05:59:34'),
(2, 1, 3, 'mi nifras', 'kodimaram spk pottuvil', 'nifras@gmail.com', '756897675', '2026-02-28', '2026-03-07', 2, NULL, 'Confirmed', 17500.00, '2026-02-27 14:33:38'),
(3, 1, 1, 'mohan', '241 beach road batticalo', 'mohan@gmail.com', '7756432190', '2026-03-05', '2026-03-14', 1, NULL, 'Pending', 13500.00, '2026-03-05 15:34:00');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_number` varchar(10) NOT NULL,
  `room_type` enum('Single','Double','Suite','Deluxe','Presidential') NOT NULL,
  `rate_per_night` decimal(10,2) NOT NULL,
  `capacity` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `amenities` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_number`, `room_type`, `rate_per_night`, `capacity`, `description`, `amenities`, `is_available`, `created_at`) VALUES
(1, '101', 'Single', 1500.00, 1, 'Cozy single room with ocean view', 'WiFi, TV, AC, Mini Bar', 1, '2026-02-12 07:46:33'),
(2, '102', 'Single', 1500.00, 1, 'Comfortable single room', 'WiFi, TV, AC', 1, '2026-02-12 07:46:33'),
(3, '201', 'Double', 2500.00, 2, 'Spacious double room with balcony', 'WiFi, TV, AC, Mini Bar, Balcony', 1, '2026-02-12 07:46:33'),
(4, '202', 'Double', 2500.00, 2, 'Elegant double room', 'WiFi, TV, AC, Mini Bar', 1, '2026-02-12 07:46:33'),
(5, '301', 'Suite', 5000.00, 4, 'Luxury suite with living area', 'WiFi, TV, AC, Mini Bar, Living Room, Kitchen', 1, '2026-02-12 07:46:33'),
(6, '302', 'Deluxe', 4000.00, 3, 'Deluxe room with premium amenities', 'WiFi, TV, AC, Mini Bar, Jacuzzi', 1, '2026-02-12 07:46:33'),
(7, '401', 'Presidential', 10000.00, 6, 'Presidential suite with ocean view', 'WiFi, TV, AC, Mini Bar, Living Room, Kitchen, Private Pool', 1, '2026-02-12 07:46:33');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `role` enum('admin','customer') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  `security_question` varchar(255) DEFAULT 'What is your favorite place ?',
  `security_answer` varchar(255) DEFAULT 'icbt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `email`, `phone`, `role`, `created_at`, `is_active`, `security_question`, `security_answer`) VALUES
(1, 'admin', 'admin123', 'Administrator', 'admin@oceanview.com', '1234567890', 'admin', '2026-02-12 07:46:33', 1, 'What is your favorite place ?', 'icbt');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD UNIQUE KEY `reservation_id` (`reservation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_bills_reservation` (`reservation_id`);

--
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`receipt_id`),
  ADD UNIQUE KEY `bill_id` (`bill_id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `reservation_id` (`reservation_id`),
  ADD KEY `idx_receipts_bill` (`bill_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `idx_reservations_user` (`user_id`),
  ADD KEY `idx_reservations_room` (`room_id`),
  ADD KEY `idx_reservations_dates` (`check_in_date`,`check_out_date`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD UNIQUE KEY `room_number` (`room_number`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `receipts`
--
ALTER TABLE `receipts`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `receipts_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `receipts_ibfk_2` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`) ON DELETE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
