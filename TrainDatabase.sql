CREATE DATABASE IF NOT EXISTS `TrainDatabase` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `TrainDatabase`;

-- MySQL dump 10.13  Distrib 8.3.0, for macos14 (arm64)
-- Host: localhost    Database: TrainDatabase
-- ------------------------------------------------------
-- Server version 8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Create Customers Table
DROP TABLE IF EXISTS `Customers`;
CREATE TABLE `Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Username` VARCHAR(50) UNIQUE NOT NULL,
  `PasswordHash` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create Employees Table
DROP TABLE IF EXISTS `Employees`;
CREATE TABLE `Employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Username` VARCHAR(50) UNIQUE NOT NULL,
  `PasswordHash` VARCHAR(255) NOT NULL,
  `Role` ENUM('Admin', 'CustomerRep') NOT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create Stations Table
DROP TABLE IF EXISTS `Stations`;
CREATE TABLE `Stations` (
  `StationID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `City` VARCHAR(50) NOT NULL,
  `State` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`StationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create TrainSchedules Table
DROP TABLE IF EXISTS `TrainSchedules`;
CREATE TABLE `TrainSchedules` (
  `ScheduleID` INT NOT NULL AUTO_INCREMENT,
  `TrainID` INT NOT NULL,
  `OriginStationID` INT NOT NULL,
  `DestinationStationID` INT NOT NULL,
  `DepartureTime` DATETIME NOT NULL,
  `ArrivalTime` DATETIME NOT NULL,
  `Fare` DECIMAL(10, 2) NOT NULL,
  `TransitLine` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ScheduleID`),
  FOREIGN KEY (`OriginStationID`) REFERENCES `Stations` (`StationID`),
  FOREIGN KEY (`DestinationStationID`) REFERENCES `Stations` (`StationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create Reservations Table
DROP TABLE IF EXISTS `Reservations`;
CREATE TABLE `Reservations` (
    `ReservationID` INT NOT NULL AUTO_INCREMENT,
    `CustomerID` INT NOT NULL,                   
    `ScheduleID` INT NOT NULL,                    
    `SeatsReserved` INT NOT NULL DEFAULT 1,
    `ReservationStatus` ENUM('Confirmed', 'Cancelled') DEFAULT 'Confirmed',
    `Price` DECIMAL(10, 2) NOT NULL DEFAULT 0.00, 
    PRIMARY KEY (`ReservationID`),
    FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`) ON DELETE CASCADE,
    FOREIGN KEY (`ScheduleID`) REFERENCES `TrainSchedules` (`ScheduleID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create TrainStops Table
DROP TABLE IF EXISTS `TrainStops`;
CREATE TABLE `TrainStops` (
    `TrainStopID` INT NOT NULL AUTO_INCREMENT,
    `ScheduleID` INT NOT NULL,
    `StationID` INT NOT NULL,
    `StopOrder` INT NOT NULL,
    PRIMARY KEY (`TrainStopID`),
    FOREIGN KEY (`ScheduleID`) REFERENCES `TrainSchedules` (`ScheduleID`) ON DELETE CASCADE,
    FOREIGN KEY (`StationID`) REFERENCES `Stations` (`StationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create Questions Table
DROP TABLE IF EXISTS `Questions`;
CREATE TABLE `Questions` (
    `QuestionID` INT NOT NULL AUTO_INCREMENT,
    `CustomerID` INT NOT NULL,
    `EmployeeID` INT DEFAULT NULL,
    `QuestionText` TEXT NOT NULL,
    `ReplyText` TEXT DEFAULT NULL,
    `Status` ENUM('Resolved', 'Unresolved') DEFAULT 'Unresolved',
    PRIMARY KEY (`QuestionID`),
    FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`) ON DELETE CASCADE,
    FOREIGN KEY (`EmployeeID`) REFERENCES `Employees` (`EmployeeID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert test data for Customers
INSERT INTO `Customers` (`FirstName`, `LastName`, `Email`, `Username`, `PasswordHash`) VALUES
('John', 'Doe', 'john.doe@example.com', 'johndoe', SHA2('password123', 256)),
('Jane', 'Smith', 'jane.smith@example.com', 'janesmith', SHA2('password456', 256)),
('Eric', 'Lin', 'el894@rutgers.edu', 'ericline', SHA2('ckey', 256));

-- Insert test data for Employees
INSERT INTO `Employees` (`FirstName`, `LastName`, `Username`, `PasswordHash`, `Role`) VALUES
('Admin', 'User', 'adminuser', SHA2('adminpassword', 256), 'Admin'),
('Customer', 'Rep', 'custrep', SHA2('custreppassword', 256), 'CustomerRep'),
('Eric', 'Lin', 'ericline', SHA2('ekey', 256), 'Admin'),
('Eric', 'Lin', 'ericlin', SHA2('ekey', 256), 'CustomerRep');

-- Insert test data for Stations
INSERT INTO `Stations` (`Name`, `City`, `State`) VALUES
('New York Penn Station', 'New York', 'NY'),
('New Brunswick Station', 'New Brunswick', 'NJ'),
('Trenton Station', 'Trenton', 'NJ'),
('Princeton Junction', 'Princeton', 'NJ'),
('Philadelphia 30th Street Station', 'Philadelphia', 'PA'),
('Metropark Station', 'Iselin', 'NJ'),
('Rahway Station', 'Rahway', 'NJ'),
('Newark Penn Station', 'Newark', 'NJ');

-- Add Train Schedules
INSERT INTO `TrainSchedules` (`TrainID`, `OriginStationID`, `DestinationStationID`, `DepartureTime`, `ArrivalTime`, `Fare`, `TransitLine`) VALUES
(101, 1, 2, '2024-12-10 09:00:00', '2024-12-10 10:00:00', 25.00, 'Northeast Corridor Line'),
(102, 2, 3, '2024-12-10 11:00:00', '2024-12-10 12:00:00', 15.00, 'Northeast Corridor Line'),
(103, 1, 2, '2024-12-10 10:00:00', '2024-12-10 11:00:00', 25.00, 'North Jersey Coast Line'),
(104, 1, 2, '2024-12-10 12:00:00', '2024-12-10 13:00:00', 24.00, 'Northeast Corridor Line'),
(105, 2, 1, '2024-12-10 13:00:00', '2024-12-10 14:00:00', 22.00, 'Pascack Valley Line'),
(106, 2, 3, '2024-12-10 08:00:00', '2024-12-10 09:00:00', 11.00, 'Northeast Corridor Line'),
(107, 3, 2, '2024-12-10 13:30:00', '2024-12-10 14:30:00', 16.00, 'North Jersey Coast Line'),
(110, 3, 2, '2024-12-10 15:00:00', '2024-12-10 16:10:00', 20.00, 'Northeast Corridor Line'),
(113, 3, 2, '2024-12-10 12:00:00', '2024-12-10 13:00:00', 26.00, 'Northeast Corridor Line'),
(115, 1, 3, '2024-12-10 15:00:00', '2024-12-10 17:00:00', 32.00, 'North Jersey Coast Line'),
(116, 1, 3, '2024-12-10 07:00:00', '2024-12-10 09:00:00', 22.00, 'Pascack Valley Line'),
(120, 3, 1, '2024-12-10 19:00:00', '2024-12-10 21:00:00', 12.00, 'Northeast Corridor Line'),
(123, 5, 1, '2024-12-10 06:00:00', '2024-12-10 09:30:00', 45.00, 'Northeast Corridor Line'),
(125, 4, 5, '2024-12-10 14:00:00', '2024-12-10 15:30:00', 18.00, 'Pascack Valley Line');

-- Add stops for TrainSchedules
INSERT INTO TrainStops (ScheduleID, StationID, StopOrder) VALUES
(101, 6, 1), -- Metropark Station
(101, 7, 2), -- Rahway Station
(102, 4, 1), -- Princeton Junction
(103, 8, 1), -- Newark Penn Station
(103, 6, 2), -- Metropark Station
(103, 7, 3), -- Rahway Station
(104, 6, 1), -- Metropark Station
(105, 7, 1), -- Rahway Station
(105, 6, 2), -- Metropark Station
(106, 4, 1), -- Princeton Junction
(107, 6, 1), -- Metropark Station
(107, 7, 2), -- Rahway Station
(110, 7, 1), -- Rahway Station
(110, 6, 2), -- Metropark Station
(113, 7, 1), -- Rahway Station
(115, 8, 1), -- Newark Penn Station
(115, 7, 2), -- Rahway Station
(116, 6, 1), -- Metropark Station
(116, 7, 2), -- Rahway Station
(120, 7, 1), -- Rahway Station
(120, 6, 2), -- Metropark Station
(123, 4, 1), -- Princeton Junction
(123, 7, 2), -- Rahway Station
(123, 6, 3), -- Metropark Station
(125, 5, 1); -- Philadelphia 30th Street Station

INSERT INTO `Questions` (`CustomerID`, `QuestionText`)
VALUES
(1, 'How can I reset my password?'),
(2, 'Is there a way to update my billing address?'),
(3, 'What is the return policy for damaged items?');
INSERT INTO `Questions` (`CustomerID`, `EmployeeID`, `QuestionText`, `ReplyText`, `Status`)
VALUES
(1, NULL, 'How can I reset my password?', NULL, 'Unresolved'),
(2, 3, 'Is there a way to update my billing address?', 'Yes, you can update it in the account settings.', 'Resolved'),
(3, 5, 'What is the return policy for damaged items?', NULL, 'Unresolved'),
(2, NULL, 'Can I cancel my subscription anytime?', 'Yes, you can cancel it anytime without additional charges.', 'Resolved'),
(1, 2, 'When will my refund be processed?', NULL, 'Unresolved');

-- Final Cleanup
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
