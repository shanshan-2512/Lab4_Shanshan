-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.22-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for restaurant
DROP DATABASE IF EXISTS `restaurant`;
CREATE DATABASE IF NOT EXISTS `restaurant` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `restaurant`;

-- Dumping structure for table restaurant.menu
DROP TABLE IF EXISTS `menu`;
CREATE TABLE IF NOT EXISTS `menu` (
  `menuId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `menuName` varchar(50) NOT NULL,
  `order` float NOT NULL,
  `label` varchar(64) NOT NULL,
  `type` enum('internal','external') NOT NULL DEFAULT 'internal',
  `pageKey` varchar(32) DEFAULT NULL,
  `externalURL` varchar(256) DEFAULT NULL,
  `dateCreated` datetime DEFAULT curdate(),
  PRIMARY KEY (`menuId`),
  KEY `FK_menu_page` (`pageKey`),
  CONSTRAINT `FK_menu_page` FOREIGN KEY (`pageKey`) REFERENCES `page` (`pageKey`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table restaurant.menu: ~3 rows (approximately)
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` (`menuId`, `menuName`, `order`, `label`, `type`, `pageKey`, `externalURL`, `dateCreated`) VALUES
	(1, 'main', 0, 'Welcome', 'internal', 'home', '0', '2022-03-14 00:00:00'),
	(2, 'main', 2, 'Our Food', 'internal', 'food', '0', '2022-03-14 00:00:00'),
	(3, 'main', 1, 'Get Food Delivered', 'internal', 'order', '0', '2022-03-14 00:00:00');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;

-- Dumping structure for table restaurant.page
DROP TABLE IF EXISTS `page`;
CREATE TABLE IF NOT EXISTS `page` (
  `pageId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pageKey` varchar(32) NOT NULL,
  `title` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `dateCreated` datetime NOT NULL DEFAULT curdate(),
  `dateModified` datetime DEFAULT curdate(),
  `lastEditUser` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`pageId`),
  UNIQUE KEY `pageKey` (`pageKey`),
  KEY `FK_page_user` (`lastEditUser`),
  CONSTRAINT `FK_page_user` FOREIGN KEY (`lastEditUser`) REFERENCES `user` (`userId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table restaurant.page: ~4 rows (approximately)
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` (`pageId`, `pageKey`, `title`, `content`, `dateCreated`, `dateModified`, `lastEditUser`) VALUES
	(1, 'home', 'Welcome to Our Restaurant', '<h1>Hola</h1>', '2022-03-14 00:00:00', '2022-03-14 00:00:00', 1),
	(2, 'food', 'Our Menu', 'more lorem', '2022-03-14 00:00:00', '2022-03-14 00:00:00', 2),
	(3, 'order', 'Order Food', 'even more lorem', '2022-03-14 00:00:00', '2022-03-14 00:00:00', 1),
	(4, 'staff', 'About Us', 'Learn about our <em>staff</em>', '2022-03-14 00:00:00', '2022-03-14 00:00:00', 2);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;

-- Dumping structure for table restaurant.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `first` varchar(50) NOT NULL,
  `passHash` varchar(256) DEFAULT NULL,
  `cookieHash` varchar(256) DEFAULT NULL,
  `email` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`userId`) USING BTREE,
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table restaurant.user: ~2 rows (approximately)
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`userId`, `username`, `first`, `passHash`, `cookieHash`, `email`) VALUES
	(1, 'joe', 'joes', 'db9fbddbd7caeff7a326645c1bb47116eb3fd4ae3834bf5039fc5d47386786f5', 'db9fbddbd7caeff7a326645c1bb47116eb3fd4ae3834bf5039fc5d47386786f5', 'joe@joe.com'),
	(2, 'lucky', 'luke', 'db9fbddbd7caeff7a326645c1bb47116eb3fd4ae3834bf5039fc5d47386786f5', 'db9fbddbd7caeff7a326645c1bb47116eb3fd4ae3834bf5039fc5d47386786f5', 'lucky@luke.com');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
