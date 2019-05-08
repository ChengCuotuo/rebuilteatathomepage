/*
Navicat MySQL Data Transfer

Source Server         : 服务器
Source Server Version : 50643
Source Host           : 39.108.141.193:3306
Source Database       : eatathome

Target Server Type    : MYSQL
Target Server Version : 50643
File Encoding         : 65001

Date: 2019-05-06 21:43:56
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `t_common`
-- ----------------------------
DROP TABLE IF EXISTS `t_common`;
CREATE TABLE `t_common` (
  `CId` int(11) NOT NULL AUTO_INCREMENT,
  `CDId` int(11) NOT NULL,
  `CUId` int(11) NOT NULL,
  `CComent` varchar(225) DEFAULT NULL,
  `CComDate` datetime DEFAULT NULL,
  PRIMARY KEY (`CId`),
  KEY `CDId` (`CDId`),
  KEY `CUId` (`CUId`),
  CONSTRAINT `t_common_ibfk_1` FOREIGN KEY (`CDId`) REFERENCES `t_dynamic` (`DId`),
  CONSTRAINT `t_common_ibfk_2` FOREIGN KEY (`CUId`) REFERENCES `t_user` (`UId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_common
-- ----------------------------
INSERT INTO `t_common` VALUES ('1', '1', '2', '换个头像', '2019-03-12 12:41:22');
INSERT INTO `t_common` VALUES ('2', '5', '2', 'hhh', '2019-03-18 15:31:08');
INSERT INTO `t_common` VALUES ('3', '5', '2', '今天', '2019-03-18 15:34:44');
INSERT INTO `t_common` VALUES ('4', '5', '2', '怎么回事都是乱码', '2019-03-18 15:36:02');

-- ----------------------------
-- Table structure for `t_delete`
-- ----------------------------
DROP TABLE IF EXISTS `t_delete`;
CREATE TABLE `t_delete` (
  `DelUId` int(11) NOT NULL,
  `DelDId` int(11) NOT NULL,
  PRIMARY KEY (`DelUId`,`DelDId`),
  KEY `DelDId` (`DelDId`),
  CONSTRAINT `t_delete_ibfk_1` FOREIGN KEY (`DelUId`) REFERENCES `t_user` (`UId`),
  CONSTRAINT `t_delete_ibfk_2` FOREIGN KEY (`DelDId`) REFERENCES `t_dynamic` (`DId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_delete
-- ----------------------------

-- ----------------------------
-- Table structure for `t_dynamic`
-- ----------------------------
DROP TABLE IF EXISTS `t_dynamic`;
CREATE TABLE `t_dynamic` (
  `DId` int(11) NOT NULL AUTO_INCREMENT,
  `DUId` int(11) DEFAULT NULL,
  `DDescribe` varchar(225) DEFAULT NULL,
  `DPhoto` varchar(200) DEFAULT NULL,
  `DDate` datetime DEFAULT NULL,
  `DUpCount` int(11) DEFAULT NULL,
  `DDownCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`DId`),
  KEY `UId` (`DUId`),
  CONSTRAINT `t_dynamic_ibfk_1` FOREIGN KEY (`DUId`) REFERENCES `t_user` (`UId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_dynamic
-- ----------------------------
INSERT INTO `t_dynamic` VALUES ('1', '1', '为了解决乱码问题，我已经快要烦死了', 'test1552352220736.jpg', '2019-03-12 08:57:30', '0', '0');
INSERT INTO `t_dynamic` VALUES ('2', '1', '上课调试程序，没有认真听课。看到黑板上的东西，有点后悔，还是应该好好上课。', 'test1552352311849.jpg', '2019-03-12 08:59:25', '0', '0');
INSERT INTO `t_dynamic` VALUES ('3', '2', '齐齐哈尔大学中区', 'chunlei1552365602036.jpg', '2019-03-12 12:40:14', '0', '0');
INSERT INTO `t_dynamic` VALUES ('4', '2', '蒋老师在上.net', 'chunlei1552374775559.jpg', '2019-03-12 15:13:09', '0', '0');
INSERT INTO `t_dynamic` VALUES ('5', '2', '请相信，这不是一节英语课。', 'chunlei1552438534405.jpg', '2019-03-13 08:56:07', '1', '0');

-- ----------------------------
-- Table structure for `t_user`
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `UId` int(11) NOT NULL AUTO_INCREMENT,
  `UName` varchar(20) DEFAULT NULL,
  `UAge` int(11) unsigned DEFAULT '0',
  `UHead` varchar(200) DEFAULT NULL,
  `UCreateDate` datetime DEFAULT NULL,
  `UDel` int(11) DEFAULT '0',
  `USignature` varchar(200) DEFAULT NULL,
  `UPassword` varchar(15) NOT NULL,
  `UGender` enum('man','woman') DEFAULT NULL,
  PRIMARY KEY (`UId`),
  UNIQUE KEY `UName` (`UName`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES ('1', 'test', '18', 'test.jpg', '2019-03-12 08:55:13', '0', '再忙也要记得抽空回家吃饭', '123', 'man');
INSERT INTO `t_user` VALUES ('2', 'chunlei', '18', 'chunlei.jpg', '2019-03-12 10:11:17', '0', '我家的狗还是很威武的', '123', 'man');
INSERT INTO `t_user` VALUES ('3', 'nyc', '18', 'nyc.jpg', '2019-03-12 15:14:41', '0', '再忙也要记得抽空回家吃饭', 'nycnyc', 'man');
DROP TRIGGER IF EXISTS `setCComDate_beforeInsert`;
DELIMITER ;;
CREATE TRIGGER `setCComDate_beforeInsert` BEFORE INSERT ON `t_common` FOR EACH ROW BEGIN
set new.CComDate=CURRENT_TIMESTAMP();
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `setDDate_beforeInsert`;
DELIMITER ;;
CREATE TRIGGER `setDDate_beforeInsert` BEFORE INSERT ON `t_dynamic` FOR EACH ROW BEGIN
set new.DDate=CURRENT_TIMESTAMP();
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `tri_dynamic_downcount`;
DELIMITER ;;
CREATE TRIGGER `tri_dynamic_downcount` BEFORE UPDATE ON `t_dynamic` FOR EACH ROW BEGIN
	declare upcount int;
	declare downcount int;
	set upcount = new.DUpCount;
	set downcount = new.DDownCount;

	if (downcount - upcount) = 5 then
			insert into t_delete(DelUId, DelDId) select DUId, DId from t_dynamic where 
DId = new.DId;
			update t_user set UDel=UDel+1 where new.DUId = UId;
	end if;
end
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `setCreateDate_beforeInsert`;
DELIMITER ;;
CREATE TRIGGER `setCreateDate_beforeInsert` BEFORE INSERT ON `t_user` FOR EACH ROW BEGIN
set new.UCreateDate=CURRENT_TIMESTAMP();
END
;;
DELIMITER ;
