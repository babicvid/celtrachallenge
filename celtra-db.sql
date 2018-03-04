-- --------------------------------------------------------
-- Strežnik:                     127.0.0.1
-- Verzija strežnika:            10.2.13-MariaDB - mariadb.org binary distribution
-- Operacijski sistem strežnika: Win64
-- HeidiSQL Različica:           9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for database1
DROP DATABASE IF EXISTS `database1`;
CREATE DATABASE IF NOT EXISTS `database1` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `database1`;

-- Dumping structure for tabela database1.ad
DROP TABLE IF EXISTS `ad`;
CREATE TABLE IF NOT EXISTS `ad` (
  `CampaignID` smallint(6) NOT NULL,
  `AdID` smallint(6) NOT NULL,
  `AdName` varchar(100) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Active` int(11) NOT NULL,
  PRIMARY KEY (`CampaignID`,`AdID`),
  CONSTRAINT `CampaignID` FOREIGN KEY (`CampaignID`) REFERENCES `campaign` (`CampaignID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table database1.ad: ~6 rows (približno)
/*!40000 ALTER TABLE `ad` DISABLE KEYS */;
INSERT INTO `ad` (`CampaignID`, `AdID`, `AdName`, `StartDate`, `EndDate`, `Active`) VALUES
	(11, 1101, 'Ad1Fall', '2017-09-01 14:35:42', '2017-10-03 14:35:54', 0),
	(11, 1102, 'Ad2Fall', '2017-10-03 14:36:28', '2017-11-03 14:36:33', 0),
	(11, 1103, 'Ad3Fall', '2017-11-03 14:37:16', '2017-12-03 14:37:24', 0),
	(11, 1104, 'Ad4Fall', '2017-12-03 14:37:57', '2018-01-03 14:38:11', 0),
	(12, 1201, 'Ad1Win', '2018-01-03 14:19:46', NULL, 1),
	(12, 1202, 'Ad2Win', '2018-02-03 14:20:08', NULL, 1),
	(12, 1203, 'Ad3Win', '2018-03-03 14:20:36', NULL, 1);
/*!40000 ALTER TABLE `ad` ENABLE KEYS */;

-- Dumping structure for tabela database1.campaign
DROP TABLE IF EXISTS `campaign`;
CREATE TABLE IF NOT EXISTS `campaign` (
  `CampaignID` smallint(6) NOT NULL,
  `CampaignDescription` varchar(255) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Active` int(11) DEFAULT NULL,
  `CustomerID` int(11) NOT NULL,
  PRIMARY KEY (`CampaignID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table database1.campaign: ~2 rows (približno)
/*!40000 ALTER TABLE `campaign` DISABLE KEYS */;
INSERT INTO `campaign` (`CampaignID`, `CampaignDescription`, `StartDate`, `EndDate`, `Active`, `CustomerID`) VALUES
	(11, 'Fall2017', '2017-09-01 14:34:21', '2018-01-03 14:34:37', 0, 1),
	(12, 'Winter2018', '2018-01-03 14:17:54', '2018-03-30 14:18:05', 1, 1);
/*!40000 ALTER TABLE `campaign` ENABLE KEYS */;

-- Dumping structure for tabela database1.customer
DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(60) DEFAULT NULL,
  `CustomerAddress` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table database1.customer: ~0 rows (približno)
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` (`CustomerID`, `CustomerName`, `CustomerAddress`) VALUES
	(1, 'Spar', 'Jamova 105');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;

-- Dumping structure for tabela database1.impression
DROP TABLE IF EXISTS `impression`;
CREATE TABLE IF NOT EXISTS `impression` (
  `ImpressionID` int(11) NOT NULL,
  `User` int(11) DEFAULT NULL,
  `ImpressionTimestamp` datetime DEFAULT NULL,
  `CampaignID` smallint(6) NOT NULL,
  `AdID` smallint(6) NOT NULL,
  `SwipeNo` int(11) DEFAULT NULL,
  `PinchNo` int(11) DEFAULT NULL,
  `TouchNo` int(11) DEFAULT NULL,
  `ClickNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`ImpressionID`),
  KEY `FK_impression_ad` (`CampaignID`,`AdID`),
  CONSTRAINT `FK_impression_ad` FOREIGN KEY (`CampaignID`, `AdID`) REFERENCES `ad` (`CampaignID`, `AdID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table database1.impression: ~25 rows (približno)
/*!40000 ALTER TABLE `impression` DISABLE KEYS */;
INSERT INTO `impression` (`ImpressionID`, `User`, `ImpressionTimestamp`, `CampaignID`, `AdID`, `SwipeNo`, `PinchNo`, `TouchNo`, `ClickNo`) VALUES
	(110, 56847, '2018-03-03 18:41:35', 11, 1104, 0, 0, 0, 0),
	(112, 44321, '2018-02-27 19:26:29', 12, 1201, 3, 0, 0, 0),
	(118, 99854, '2018-02-13 18:15:06', 11, 1102, 1, 0, 0, 0),
	(204, 12533, '2018-02-28 16:25:44', 12, 1202, 0, 0, 0, 2),
	(334, 38851, '2018-02-28 10:35:04', 11, 1103, 0, 0, 0, 0),
	(338, 84165, '2018-02-28 14:18:02', 11, 1104, 0, 1, 2, 1),
	(344, 37451, '2018-02-17 14:35:07', 11, 1103, 0, 0, 0, 0),
	(417, 54713, '2018-03-01 14:34:19', 11, 1102, 0, 0, 0, 1),
	(431, 53113, '2018-02-04 14:32:35', 11, 1101, 4, 0, 0, 1),
	(451, 58421, '2018-01-06 14:54:26', 12, 1202, 0, 0, 0, 0),
	(458, 45812, '2018-02-13 14:39:39', 12, 1202, 0, 1, 0, 4),
	(462, 11241, '2018-02-28 19:26:57', 12, 1202, 0, 0, 0, 0),
	(485, 20015, '2018-01-09 14:55:13', 12, 1202, 0, 0, 0, 1),
	(487, 53113, '2018-02-05 18:32:35', 11, 1101, 1, 0, 0, 0),
	(523, 12533, '2018-03-02 19:25:44', 12, 1202, 0, 2, 0, 1),
	(565, 12068, '2018-01-05 14:32:33', 12, 1201, 4, 1, 0, 8),
	(572, 52242, '2018-01-03 14:17:59', 11, 1103, 1, 0, 0, 0),
	(667, 52242, '2018-01-05 16:17:59', 11, 1101, 0, 0, 0, 0),
	(748, 20015, '2018-01-14 16:53:13', 12, 1202, 0, 1, 0, 0),
	(769, 25165, '2018-03-01 20:14:05', 11, 1104, 0, 0, 0, 1),
	(784, 45812, '2018-03-01 19:25:12', 12, 1203, 1, 2, 5, 0),
	(824, 47965, '2017-12-04 14:34:41', 11, 1103, 1, 0, 0, 0),
	(843, 31532, '2018-03-02 16:27:38', 12, 1201, 3, 0, 2, 0),
	(967, 52234, '2018-03-03 14:17:59', 11, 1104, 0, 1, 2, 1),
	(980, 17951, '2018-02-28 19:25:44', 12, 1202, 1, 0, 0, 1);
/*!40000 ALTER TABLE `impression` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
