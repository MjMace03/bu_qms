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
-- Table structure for table `nfc_card`
--

DROP TABLE IF EXISTS `nfc_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nfc_card` (
  `cardID` int NOT NULL AUTO_INCREMENT,
  `cardType` enum('PermStudent','TempVisitor','TempPasser') NOT NULL,
  `nfc_tag` varchar(25) NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `issueDate` date NOT NULL DEFAULT (curdate()),
  `visit_date` date DEFAULT (curdate()),
  `is_returned` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`cardID`),
  KEY `nfc_tag` (`nfc_tag`),
  CONSTRAINT `nfc_card_ibfk_1` FOREIGN KEY (`nfc_tag`) REFERENCES `users` (`nfc_tag`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nfc_card`
--

LOCK TABLES `nfc_card` WRITE;
/*!40000 ALTER TABLE `nfc_card` DISABLE KEYS */;
INSERT INTO `nfc_card` VALUES (1,'PermStudent','10001',1,'2025-04-10','2025-05-16',NULL),(2,'PermStudent','10002',1,'2025-04-10','2025-05-16',NULL),(3,'PermStudent','10003',1,'2025-04-10','2025-05-16',NULL),(4,'PermStudent','10004',1,'2025-04-10','2025-05-16',NULL),(5,'PermStudent','10005',1,'2025-04-10','2025-05-16',NULL),(6,'PermStudent','10006',1,'2025-04-11','2025-05-16',NULL),(7,'PermStudent','10007',1,'2025-04-11','2025-05-16',NULL),(8,'PermStudent','10008',1,'2025-04-11','2025-05-16',NULL),(9,'PermStudent','10009',1,'2025-04-11','2025-05-16',NULL),(10,'PermStudent','10010',1,'2025-04-11','2025-05-16',NULL),(11,'TempVisitor','20001',1,'2025-05-16','2025-05-16',0),(12,'TempVisitor','20002',1,'2025-05-16','2025-05-16',0),(13,'TempVisitor','20003',1,'2025-05-16','2025-05-16',0),(14,'TempVisitor','20004',1,'2025-05-16','2025-05-16',0),(15,'TempVisitor','20005',1,'2025-05-16','2025-05-16',0),(16,'TempVisitor','20006',1,'2025-05-16','2025-05-16',0),(17,'TempVisitor','20007',1,'2025-05-16','2025-05-16',0),(18,'TempVisitor','20008',1,'2025-05-16','2025-05-16',0),(19,'TempVisitor','20009',1,'2025-05-16','2025-05-16',0),(20,'TempVisitor','20010',1,'2025-05-16','2025-05-16',0),(21,'TempPasser','30001',1,'2025-05-16','2025-05-16',0),(22,'TempPasser','30002',1,'2025-05-16','2025-05-16',0),(23,'TempPasser','30003',1,'2025-05-16','2025-05-16',0),(24,'TempPasser','30004',1,'2025-05-16','2025-05-16',0),(25,'TempPasser','30005',1,'2025-05-16','2025-05-16',0),(26,'TempPasser','30006',1,'2025-05-16','2025-05-16',0),(27,'TempPasser','30007',1,'2025-05-16','2025-05-16',0),(28,'TempPasser','30008',1,'2025-05-16','2025-05-16',0);
/*!40000 ALTER TABLE `nfc_card` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-16 16:51:53
