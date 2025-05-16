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
-- Dumping routines for database 'bu_qms'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_to_queue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_to_queue`(
				IN p_nfc_tag VARCHAR(25), 
                IN p_user_type ENUM ('Student', 'Visitor', 'BUCET Passer')
)
BEGIN
	DECLARE v_queue_seq INT;
    DECLARE v_user_name VARCHAR(100);
    DECLARE v_program VARCHAR(100);
    DECLARE v_active_session INT;
    DECLARE v_user_prefix CHAR(1);
    DECLARE v_queue_number VARCHAR(25);

	SET v_user_prefix = 
		CASE 
            WHEN p_user_type = 'Student' THEN 'S'
            WHEN p_user_type = 'Visitor' THEN 'V'
            WHEN p_user_type = 'BUCET Passer' THEN 'B'
		END;
    
    SELECT IFNULL(MAX(queue_seq), 0) + 1 INTO v_queue_seq
    FROM queue
    WHERE user_prefix = v_user_prefix AND queue_date = CURRENT_DATE;
    
    SET v_queue_number = CONCAT(v_user_prefix, LPAD(v_queue_seq, 3, '0'));
	
    SELECT sessionID INTO v_active_session 
    FROM service_session 
    WHERE serve_status = 'Active' 
    LIMIT 1;

	CASE p_user_type
			WHEN 'Student' THEN
				SELECT CONCAT_WS(' ', student_firstname, student_middlename, student_surname, student_suffix)
				INTO v_user_name
				FROM student
				WHERE nfc_tag = p_nfc_tag;

			WHEN 'BUCET Passer' THEN
				SELECT CONCAT_WS(' ', BUpass_firstname, BUpass_middlename, BUpass_surname)
				INTO v_user_name
				FROM bucetpasser
				WHERE nfc_tag = p_nfc_tag;

			WHEN 'Visitor' THEN
				SET v_user_name = 'Visitor'; 
	END CASE;

    INSERT INTO queue (
        queueNumber, 
        user_prefix, 
        queue_seq, 
        user_name, 
        program, 
        user_type, 
        nfc_tag, 
        queue_status, 
        queue_date, 
        registrationTime, 
        sessionID
    ) 
    VALUES (
        v_queue_number,
        v_user_prefix,
        v_queue_seq,
        v_user_name,
        p_program,
        p_user_type,
        p_nfc_tag,
        'Waiting',
        CURRENT_DATE(),
        NOW(),
        v_active_session
    );
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_from_queue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_from_queue`(IN p_queue_number VARCHAR(25))
BEGIN

    UPDATE queue SET 
		queue_status = 'Removed',
		serviceEndTime = NOW()
		WHERE queueNumber = p_queue_number;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_session`(IN p_sessionID INT)
BEGIN
    -- Check if the session exists and is either Active or Paused
    IF NOT EXISTS (SELECT 1 FROM service_session WHERE sessionID = p_sessionID AND serve_status IN ('Active', 'Paused')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No active or paused session found with this ID';
    ELSE
        -- Update session status to Ended and set end time
        UPDATE service_session 
        SET serve_status = 'Ended',
            endTime = NOW(),
            -- Clear current serving if any
            currServing = NULL
        WHERE sessionID = p_sessionID;
        
        -- Calculate session duration and return summary
        SELECT 
            sessionID, 
            staffID, 
            'Ended' AS Status, 
            DATE_FORMAT(startTime, '%Y-%m-%d %h:%i %p') AS SessionStart,
            DATE_FORMAT(endTime, '%Y-%m-%d %h:%i %p') AS SessionEnd,
            TIMESTAMPDIFF(MINUTE, startTime, endTime) AS SessionDurationMinutes,
            totalServed,
            totalSkipped,
            totalNoShows,
            averageServiceTime
        FROM service_session 
        WHERE sessionID = p_sessionID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_as_complete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_as_complete`(IN p_queue_number VARCHAR(25))
BEGIN
	DECLARE v_session_id INT;
    DECLARE v_service_start TIMESTAMP;
    DECLARE v_service_time TIME;
        
    SELECT sessionID INTO v_session_id
    FROM service_session
    WHERE serve_status = 'Active'
    LIMIT 1;
    
    SELECT serviceStartTime INTO v_service_start
    FROM queue
    WHERE queueNumber = p_queue_number;
    
    UPDATE queue SET
        queue_status = 'Completed',
        serviceEndTime = NOW(),
        serviceTime = TIMEDIFF(NOW(), v_service_start)
    WHERE queueNumber = p_queue_number;
    
    
    SELECT serviceTime INTO v_service_time
    FROM queue
    WHERE queueNumber = p_queue_number;
    
    UPDATE service_session SET
        totalServed = totalServed + 1,
        currServing = NULL,
        averageServiceTime = (
            SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(serviceTime)))
            FROM queue
            WHERE sessionID = v_session_id AND queue_status = 'Completed'
        )
    WHERE sessionID = v_session_id;
    
    SELECT q.queueNumber, q.user_name, q.serviceTime, 
           (SELECT totalServed FROM service_session WHERE sessionID = v_session_id) AS 'Total Served'
    FROM queue q
    WHERE q.queueNumber = p_queue_number;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_as_noshow` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_as_noshow`(IN p_queue_number VARCHAR (25))
BEGIN
	DECLARE v_session_id INT;

    SELECT sessionID INTO v_session_id
    FROM service_session
    WHERE serve_status = 'Active'
    LIMIT 1;
    
    UPDATE queue SET
        queue_status = 'No-show',
        skipTime = NOW()
    WHERE queueNumber = p_queue_number;
    
    UPDATE service_session SET
        totalNoShows = totalNoShows + 1,
        currServing = NULL
    WHERE sessionID = v_session_id;
    
    
    SELECT q.queueNumber, q.user_name, 'No-show' AS Status, 
           (SELECT totalNoShows FROM service_session WHERE sessionID = v_session_id) AS 'Total No-shows'
    FROM queue q
    WHERE q.queueNumber = p_queue_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_as_serving` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_as_serving`(IN p_queue_number VARCHAR(25))
BEGIN
	DECLARE v_session_id INT;
    DECLARE v_staff_id VARCHAR(25);
    DECLARE v_registration_time TIMESTAMP;

    SELECT sessionID, staffID INTO v_session_id, v_staff_id
    FROM service_session
    WHERE serve_status = 'Active'
    LIMIT 1;
    
	SELECT registrationTime INTO v_registration_time
    FROM queue
    WHERE queueNumber = p_queue_number;
        SELECT registrationTime INTO v_registration_time
    FROM queue
    WHERE queueNumber = p_queue_number;

    UPDATE queue SET
        queue_status = 'Serving',
        staffID = v_staff_id,
        serviceStartTime = NOW(),
        waitTime = TIMEDIFF(NOW(), v_registration_time)
    WHERE queueNumber = p_queue_number;
    

    UPDATE service_session SET
        currServing = p_queue_number
    WHERE sessionID = v_session_id;
    
    
    SELECT q.queueNumber, q.user_name, q.user_type, q.waitTime
    FROM queue q
    WHERE q.queueNumber = p_queue_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mark_as_skip` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_as_skip`(IN p_queue_number VARCHAR(25))
BEGIN
    DECLARE v_session_id INT;
    
    SELECT sessionID INTO v_session_id
    FROM service_session
    WHERE serve_status = 'Active'
    LIMIT 1;
    
    UPDATE queue SET
        queue_status = 'Skipped',
        skipTime = NOW()
    WHERE queueNumber = p_queue_number;
    
    UPDATE service_session SET
        totalSkipped = totalSkipped + 1,
        currServing = NULL
    WHERE sessionID = v_session_id;

    SELECT q.queueNumber, q.user_name, 'Skipped' AS Status, 
           (SELECT totalSkipped FROM service_session WHERE sessionID = v_session_id) AS 'Total Skipped'
    FROM queue q
    WHERE q.queueNumber = p_queue_number;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pause_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pause_session`(IN p_sessionID INT)
BEGIN
    -- Check if the session exists and is active
    IF NOT EXISTS (SELECT 1 FROM service_session WHERE sessionID = p_sessionID AND serve_status = 'Active') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No active session found with this ID';
    ELSE
        -- Update session status to Paused
        UPDATE service_session 
        SET serve_status = 'Paused',
            pauseTime = NOW()
        WHERE sessionID = p_sessionID;
        
        -- Return updated session info
        SELECT 
            sessionID, 
            staffID, 
            'Paused' AS Status, 
            DATE_FORMAT(pauseTime, '%Y-%m-%d %h:%i %p') AS PausedTime 
        FROM service_session 
        WHERE sessionID = p_sessionID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `resume_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `resume_session`(IN p_sessionID INT)
BEGIN
    -- Check if the session exists and is paused
    IF NOT EXISTS (SELECT 1 FROM service_session WHERE sessionID = p_sessionID AND serve_status = 'Paused') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No paused session found with this ID';
    ELSE
        -- Update session status back to Active and clear pauseTime
        UPDATE service_session 
        SET serve_status = 'Active',
            pauseTime = NULL
        WHERE sessionID = p_sessionID;
        
        -- Return updated session info
        SELECT 
            sessionID, 
            staffID, 
            'Active' AS Status,
            DATE_FORMAT(NOW(), '%Y-%m-%d %h:%i %p') AS ResumedTime
        FROM service_session 
        WHERE sessionID = p_sessionID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_session`(IN p_staffID VARCHAR(25))
BEGIN
    -- Check if there's already an active session for this staff
    IF EXISTS (SELECT 1 FROM service_session WHERE staffID = p_staffID AND serve_status = 'Active') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Staff already has an active session';
    ELSE
        -- Create new session
        INSERT INTO service_session (
            staffID,
            startTime,
            serve_status,
            currServing,
            totalServed,
            totalSkipped,
            totalNoShows,
            averageServiceTime
        ) VALUES (
            p_staffID,
            NOW(),
            'Active',
            NULL,
            0,
            0,
            0,
            '00:00:00'
        );
        
        -- Return session info
        SELECT 
            sessionID, 
            staffID, 
            'Active' AS Status, 
            DATE_FORMAT(startTime, '%Y-%m-%d %h:%i %p') AS SessionStart 
        FROM service_session 
        WHERE staffID = p_staffID AND serve_status = 'Active';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `to_re_queue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `to_re_queue`(IN p_queue_number VARCHAR(25))
BEGIN
    DECLARE v_session_id INT;
    DECLARE v_user_prefix CHAR(1);
    DECLARE v_new_seq INT;
    DECLARE v_new_queue_number VARCHAR(25);

    -- Get the current active session
    SELECT sessionID INTO v_session_id
    FROM service_session
    WHERE serve_status = 'Active'
    LIMIT 1;

    -- Get user prefix from original queue number (first character)
    SELECT SUBSTRING(queueNumber, 1, 1)
    INTO v_user_prefix
    FROM queue
    WHERE queueNumber = p_queue_number;

    -- Get the next available queue sequence for that user prefix
    SELECT IFNULL(MAX(queue_seq), 0) + 1 INTO v_new_seq
    FROM queue
    WHERE user_prefix = v_user_prefix AND queue_date = CURRENT_DATE;

    -- Generate new queue number
    SET v_new_queue_number = CONCAT(v_user_prefix, LPAD(v_new_seq, 3, '0'));

    -- Update the user to re-queue them
    UPDATE queue SET
        queue_status = 'Waiting',
        queue_seq = v_new_seq,
        queueNumber = v_new_queue_number,
        registrationTime = NOW(),
        staffID = NULL,
        serviceStartTime = NULL,
        serviceEndTime = NULL,
        serviceTime = NULL,
        waitTime = NULL,
        skipTime = NULL
    WHERE queueNumber = p_queue_number;

    -- Return updated info
    SELECT v_new_queue_number AS queueNumber, user_name, 'Re-queued' AS Status
    FROM queue
    WHERE queueNumber = v_new_queue_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-16 16:51:54
