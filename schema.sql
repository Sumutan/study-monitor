-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: study_monitor
-- ------------------------------------------------------
-- Server version	8.0.46

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

--
-- Table structure for table `announcement_reads`
--

DROP TABLE IF EXISTS `announcement_reads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement_reads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `announcement_id` bigint NOT NULL COMMENT '公告ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `read_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '已读时间',
  PRIMARY KEY (`id`),
  KEY `ix_announcement_reads_announcement_id` (`announcement_id`),
  KEY `ix_announcement_reads_user_id` (`user_id`),
  CONSTRAINT `announcement_reads_ibfk_1` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`),
  CONSTRAINT `announcement_reads_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint DEFAULT NULL COMMENT 'å…³è”è¯¾ç¨‹ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'å…¬å‘Šæ ‡é¢˜',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'å…¬å‘Šæ­£æ–‡',
  `priority` enum('normal','important','urgent') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT 'ä¼˜å…ˆçº§',
  `created_by` bigint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_announcements_course_id` (`course_id`),
  KEY `fk_announcements_creator` (`created_by`),
  CONSTRAINT `fk_announcements_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_announcements_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='å…¬å‘Šè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint DEFAULT NULL COMMENT '所属课程ID(冗余)',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `question_files` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'é¢˜ç›®æ–‡ä»¶URLæ•°ç»„(JSON)',
  `answer_files` text COLLATE utf8mb4_unicode_ci COMMENT '答案附件URL数组(JSON)',
  `grading_prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '评分标准/批改提示词',
  `reference_answer` text COLLATE utf8mb4_unicode_ci COMMENT 'å‚è€ƒç­”æ¡ˆ',
  `grading_mode` enum('auto','manual','hybrid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'auto' COMMENT 'æ‰¹æ”¹æ¨¡å¼',
  `grading_status` enum('pending','graded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'æ‰¹æ”¹çŠ¶æ€',
  `grading_triggered` tinyint(1) DEFAULT '0' COMMENT 'æ˜¯å¦å·²è§¦å‘æ™ºèƒ½ä½“æ‰¹æ”¹',
  `deadline` datetime DEFAULT NULL,
  `auto_grade_at` datetime DEFAULT NULL COMMENT 'æ™ºèƒ½ä½“è‡ªåŠ¨æ‰¹æ”¹æ—¶é—´',
  `status` enum('draft','published','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `section_id` bigint NOT NULL COMMENT '所属小节ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assignments_section_id` (`section_id`),
  KEY `ix_assignments_course_id` (`course_id`),
  CONSTRAINT `fk_assignments_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `fk_assignments_section_id` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_type` enum('url','local') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'url',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `wukong_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '悟空播放器URL',
  `duration_seconds` int DEFAULT NULL COMMENT '课程总时长(秒)',
  `teacher_id` bigint NOT NULL,
  `require_minutes` int DEFAULT '60' COMMENT '要求学习时长(分钟)，null=不设要求',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('active','ended','draft') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `courses_ibfk_1` (`teacher_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grading_reports`
--

DROP TABLE IF EXISTS `grading_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grading_reports` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `submission_id` bigint NOT NULL,
  `score` int DEFAULT NULL COMMENT '分数0-100',
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '各题详细批改(JSON)',
  `generated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '智能体标识',
  `review_status` enum('pending_review','confirmed','modified') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'confirmed' COMMENT 'å¤æ ¸çŠ¶æ€',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `full_score` int DEFAULT '0' COMMENT '满分',
  `accuracy` float DEFAULT '0' COMMENT '正确率',
  `correct_count` int DEFAULT '0' COMMENT '正确题数',
  `wrong_count` int DEFAULT '0' COMMENT '错误题数',
  `status` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT 'success' COMMENT '智能体状态',
  `review_questions` text COLLATE utf8mb4_unicode_ci COMMENT '需复核题号JSON',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_grading_reports_submission_id` (`submission_id`),
  CONSTRAINT `grading_reports_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grading_tasks`
--

DROP TABLE IF EXISTS `grading_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grading_tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `submission_id` bigint NOT NULL,
  `stitched_image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拼接后的长图URL',
  `agent_task_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '智能体任务ID',
  `status` enum('pending','sent','graded','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务状态',
  `retry_count` int DEFAULT NULL COMMENT '已重试次数',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `sent_at` datetime DEFAULT NULL COMMENT '发送时间',
  `graded_at` datetime DEFAULT NULL COMMENT '批改完成时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_grading_tasks_submission_id` (`submission_id`),
  CONSTRAINT `grading_tasks_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `heartbeat_logs`
--

DROP TABLE IF EXISTS `heartbeat_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heartbeat_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `timestamp` datetime NOT NULL,
  `is_playing` tinyint(1) DEFAULT NULL,
  `is_page_visible` tinyint(1) DEFAULT NULL,
  `video_current_time` decimal(12,2) DEFAULT NULL COMMENT '当前播放秒数',
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'heartbeat/play/pause/seek/verify/end',
  PRIMARY KEY (`id`),
  KEY `ix_heartbeat_logs_user_id` (`user_id`),
  KEY `ix_heartbeat_logs_session_id` (`session_id`),
  KEY `idx_heartbeat_logs_timestamp` (`timestamp`),
  CONSTRAINT `heartbeat_logs_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `study_sessions` (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1801 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `section_feedbacks`
--

DROP TABLE IF EXISTS `section_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section_feedbacks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `section_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` int DEFAULT '5' COMMENT 'è¯„åˆ†1-5æ˜Ÿ',
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'æ–‡å­—è¯„ä»·',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_feedback_section_user` (`section_id`,`user_id`),
  KEY `ix_feedback_section_id` (`section_id`),
  KEY `ix_feedback_user_id` (`user_id`),
  CONSTRAINT `fk_feedback_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='å°èŠ‚è¯„ä»·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `title` varchar(200) NOT NULL COMMENT 'å°èŠ‚æ ‡é¢˜',
  `sort_order` int DEFAULT '0' COMMENT 'æŽ’åºåºå·',
  `video_type` enum('url','local') NOT NULL DEFAULT 'url',
  `video_url` varchar(500) DEFAULT '' COMMENT 'è§†é¢‘åœ°å€',
  `duration_seconds` int DEFAULT '0' COMMENT 'å°èŠ‚è§†é¢‘æ—¶é•¿(ç§’)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `open_time` datetime DEFAULT NULL COMMENT 'å¼€æ’­æ—¶é—´ï¼ˆæœªåˆ°ä¸å¯è¿›å…¥å­¦ä¹ ï¼Œnull=ä¸é™åˆ¶ï¼‰',
  PRIMARY KEY (`id`),
  KEY `ix_sections_course_id` (`course_id`),
  CONSTRAINT `fk_sections_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `study_sessions`
--

DROP TABLE IF EXISTS `study_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `course_id` bigint NOT NULL,
  `section_id` bigint DEFAULT NULL COMMENT 'å­¦ä¹ çš„å°èŠ‚ID',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` datetime NOT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  `effective_seconds` int DEFAULT NULL COMMENT '有效学习秒数',
  `video_progress` decimal(10,2) DEFAULT NULL COMMENT '视频播放进度0-100%',
  `is_active` tinyint(1) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_study_sessions_session_id` (`session_id`),
  KEY `ix_study_sessions_course_id` (`course_id`),
  KEY `ix_study_sessions_is_active` (`is_active`),
  KEY `ix_study_sessions_user_id` (`user_id`),
  KEY `ix_study_sessions_section_id` (`section_id`),
  KEY `idx_study_sessions_start_time` (`start_time`),
  KEY `idx_study_sessions_last_heartbeat` (`last_heartbeat`),
  KEY `idx_study_sessions_course_user` (`course_id`,`user_id`),
  CONSTRAINT `fk_study_sessions_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`),
  CONSTRAINT `study_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `study_sessions_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1069 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assignment_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '图片URL数组(JSON)',
  `status` enum('pending','graded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_late` tinyint(1) DEFAULT '0' COMMENT 'æ˜¯å¦è¿Ÿäº¤ï¼ˆæˆªæ­¢æ—¶é—´åŽæäº¤ï¼‰',
  `version` int DEFAULT '1' COMMENT 'æäº¤ç‰ˆæœ¬å·',
  `is_latest` tinyint(1) DEFAULT '1' COMMENT 'æ˜¯å¦æœ€æ–°ç‰ˆæœ¬',
  PRIMARY KEY (`id`),
  KEY `ix_submissions_user_id` (`user_id`),
  KEY `ix_submissions_assignment_id` (`assignment_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`),
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dingtalk_user_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '钉钉用户ID(null=未绑定)',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('student','teacher','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '班级名称',
  `class_id` bigint DEFAULT NULL COMMENT '班级ID',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `password_hash` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '浏览器登录密码哈希(空=仅钉钉登录)',
  `api_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'çœŸå®žå§“åï¼ˆé’‰é’‰é€šè®¯å½•èŽ·å–ï¼‰',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'æ‰‹æœºå·ï¼ˆé’‰é’‰é€šè®¯å½•èŽ·å–ï¼‰',
  `account` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '登录账号（唯一标识）',
  `contact_phones` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '家长联系电话(逗号分隔,用于免登自动绑定)',
  `must_change_password` tinyint(1) NOT NULL DEFAULT '0' COMMENT '强制改密标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_account` (`account`),
  UNIQUE KEY `api_key` (`api_key`),
  UNIQUE KEY `ix_users_dingtalk_user_id` (`dingtalk_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1618 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-10  2:50:32
