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
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `nfc_tag` varchar(25) NOT NULL,
  `studentID` varchar(25) NOT NULL,
  `student_surname` varchar(30) NOT NULL,
  `student_firstname` varchar(30) NOT NULL,
  `student_middlename` varchar(10) DEFAULT NULL,
  `student_suffix` char(5) DEFAULT NULL,
  `student_program` varchar(100) NOT NULL,
  `student_email` varchar(100) NOT NULL,
  `student_phonenumber` varchar(50) NOT NULL,
  PRIMARY KEY (`nfc_tag`),
  UNIQUE KEY `nfc_tag` (`nfc_tag`),
  UNIQUE KEY `studentID` (`studentID`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`nfc_tag`) REFERENCES `users` (`nfc_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES ('10001','2022-1234-5678','Maceda','Meja','Mendez',NULL,'BS Computer Science','mejamaceda@gmail.com','09202519978'),('10002','2022-5678-9010','Madriñan','Yunise','Minahal',NULL,'BS Computer Science','yunisemadriñan@gmail.com','09202519878'),('10003','2022-9101-3456','Severo','Maxine','Omamin',NULL,'BS Computer Science','maxisevero@gmail.com','09298719978'),('10004','2022-1288-5348','Magayon','Dara','Gang',NULL,'BS Information Technology','daragangmagayon@gmail.com','09202516438'),('10005','2022-1867-7654','Bay','Legazpi','Al',NULL,'BS Information Technology','legazpialbay@gmail.com','09202510987'),('10006','2022-2345-7684','Cruz','Juan','Dela',NULL,'BS Information Technology','juandelacruz@gmail.com','09202518765'),('10007','2022-9433-5744','Piattos','Mary','Garcia',NULL,'BS Information Technology','marygrace@gmail.com','09871519978'),('10008','2022-8433-9782','Nova','Crimson','Mendez',NULL,'BS Chemistry','crimsonnova@gmail.com','09202514478'),('10009','2022-9553-6544','Poe','Fernando',NULL,'Jr','BS Chemistry','fernandopoe@gmail.com','09202554678'),('10010','2022-7833-0956','Mercedes','Maria',NULL,'II','BS Chemistry','mamercedes@gmail.com','09202933378');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
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
