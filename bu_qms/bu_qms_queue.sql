-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: bu_qms
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `queue`
--

DROP TABLE IF EXISTS `queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queue` (
  `queueNumber` varchar(25) NOT NULL,
  `user_prefix` char(1) DEFAULT NULL,
  `queue_seq` int NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `program` varchar(100) DEFAULT NULL,
  `user_type` enum('Student','Visitor','BUCET Passer') NOT NULL,
  `nfc_tag` varchar(25) NOT NULL,
  `queue_status` enum('Waiting','Serving','Completed','Skipped','No-show','Removed') DEFAULT NULL,
  `queue_date` date DEFAULT (curdate()),
  `registrationTime` timestamp NULL DEFAULT (now()),
  `serviceStartTime` timestamp NULL DEFAULT NULL,
  `serviceEndTime` timestamp NULL DEFAULT NULL,
  `skipTime` timestamp NULL DEFAULT NULL,
  `sessionID` int NOT NULL,
  `staffID` varchar(25) DEFAULT NULL,
  `waitTime` time GENERATED ALWAYS AS (timediff(`serviceStartTime`,`registrationTime`)) STORED,
  `serviceTime` time GENERATED ALWAYS AS (timediff(`serviceEndTime`,`serviceStartTime`)) STORED,
  PRIMARY KEY (`queueNumber`),
  KEY `nfc_tag` (`nfc_tag`),
  KEY `sessionID` (`sessionID`),
  KEY `staffID` (`staffID`),
  CONSTRAINT `queue_ibfk_1` FOREIGN KEY (`nfc_tag`) REFERENCES `users` (`nfc_tag`),
  CONSTRAINT `queue_ibfk_3` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queue`
--

LOCK TABLES `queue` WRITE;
/*!40000 ALTER TABLE `queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `queue` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-16 16:51:54
