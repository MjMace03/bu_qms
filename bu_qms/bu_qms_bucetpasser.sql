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
-- Table structure for table `bucetpasser`
--

DROP TABLE IF EXISTS `bucetpasser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bucetpasser` (
  `nfc_tag` varchar(25) NOT NULL,
  `BUpass_surname` varchar(30) NOT NULL,
  `BUpass_firstname` varchar(30) NOT NULL,
  `BUpass_middlename` varchar(30) DEFAULT NULL,
  `intended_program` varchar(50) NOT NULL,
  PRIMARY KEY (`nfc_tag`),
  UNIQUE KEY `nfc_tag` (`nfc_tag`),
  CONSTRAINT `bucetpasser_ibfk_1` FOREIGN KEY (`nfc_tag`) REFERENCES `users` (`nfc_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bucetpasser`
--

LOCK TABLES `bucetpasser` WRITE;
/*!40000 ALTER TABLE `bucetpasser` DISABLE KEYS */;
INSERT INTO `bucetpasser` VALUES ('30001','Rosales','Jericho',NULL,'BS Chemistry'),('30002','Geronimo','Sarah',NULL,'BS Chemistry'),('30003','Rizal','Jose','Protacio','BS Biology'),('30004','Alcasid','Regine','Velasquez','BS Biology'),('30005','Amorsolo','Fernando',NULL,'BS Meteorology'),('30006','Luna','Juan',NULL,'BS Meteorology'),('30007','Bonifacio','Andres',NULL,'BS Meteorology'),('30008','Atienza','Kim',NULL,'BS Information Technology');
/*!40000 ALTER TABLE `bucetpasser` ENABLE KEYS */;
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
