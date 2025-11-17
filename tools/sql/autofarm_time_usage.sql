/*
Navicat MySQL Data Transfer

Source Server         : WSL_Debian
Source Server Version : 50505
Source Host           : 172.19.197.174:3306
Source Database       : l2wow

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2025-09-14 21:19:35
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `autofarm_time_usage`
-- ----------------------------
DROP TABLE IF EXISTS `autofarm_time_usage`;
CREATE TABLE `autofarm_time_usage` (
  `player_id` int(11) NOT NULL,
  `time_used` bigint(20) DEFAULT 0,
  `last_reset` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of autofarm_time_usage
-- ----------------------------
INSERT INTO `autofarm_time_usage` VALUES ('268492127', '-650000', '2025-09-13 00:58:49');
