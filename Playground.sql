-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                10.4.32-MariaDB - mariadb.org binary distribution
-- Server-OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumpar databasstruktur för qbcoreframework_6f803d
CREATE DATABASE IF NOT EXISTS `qbcoreframework_6f803d` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `qbcoreframework_6f803d`;

-- Dumpar struktur för tabell qbcoreframework_6f803d.apartments
CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.apartments: ~0 rows (ungefär)
INSERT IGNORE INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
	(1, 'apartment22640', 'apartment2', 'Morningwood Blvd 2640', 'YIA61095');

-- Dumpar struktur för tabell qbcoreframework_6f803d.bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `account_name` varchar(50) DEFAULT NULL,
  `account_balance` int(11) NOT NULL DEFAULT 0,
  `account_type` enum('shared','job','gang') NOT NULL,
  `users` longtext DEFAULT '[]',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `account_name` (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.bank_accounts: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.bank_statements
CREATE TABLE IF NOT EXISTS `bank_statements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `account_name` varchar(50) DEFAULT 'checking',
  `amount` int(11) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `statement_type` enum('deposit','withdraw') DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.bank_statements: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.bans: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.crypto
CREATE TABLE IF NOT EXISTS `crypto` (
  `crypto` varchar(50) NOT NULL DEFAULT 'qbit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`crypto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.crypto: ~0 rows (ungefär)
INSERT IGNORE INTO `crypto` (`crypto`, `worth`, `history`) VALUES
	('qbit', 1711, '[{"PreviousWorth":1709,"NewWorth":1709},{"PreviousWorth":1709,"NewWorth":1709},{"PreviousWorth":1709,"NewWorth":1709},{"PreviousWorth":1709,"NewWorth":1711}]');

-- Dumpar struktur för tabell qbcoreframework_6f803d.crypto_transactions
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.crypto_transactions: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext DEFAULT NULL,
  `time` longtext DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.dealers: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.fuel_stations
CREATE TABLE IF NOT EXISTS `fuel_stations` (
  `location` int(11) NOT NULL,
  `owned` int(11) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT NULL,
  `fuelprice` int(11) DEFAULT NULL,
  `balance` int(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.fuel_stations: ~27 rows (ungefär)
INSERT IGNORE INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES
	(1, 0, '0', 100000, 3, 0, 'Davis Avenue Ron'),
	(2, 0, '0', 100000, 3, 0, 'Grove Street LTD'),
	(3, 0, '0', 100000, 3, 0, 'Dutch London Xero'),
	(4, 0, '0', 100000, 3, 0, 'Little Seoul LTD'),
	(5, 0, '0', 100000, 3, 0, 'Strawberry Ave Xero'),
	(6, 0, '0', 100000, 3, 0, 'Popular Street Ron'),
	(7, 0, '0', 100000, 3, 0, 'Capital Blvd Ron'),
	(8, 0, '0', 100000, 3, 0, 'Mirror Park LTD'),
	(9, 0, '0', 100000, 3, 0, 'Clinton Ave Globe Oil'),
	(10, 0, '0', 100000, 3, 0, 'North Rockford Ron'),
	(11, 0, '0', 100000, 3, 0, 'Great Ocean Xero'),
	(12, 0, '0', 100000, 3, 0, 'Paleto Blvd Xero'),
	(13, 0, '0', 100000, 3, 0, 'Paleto Ron'),
	(14, 0, '0', 100000, 3, 0, 'Paleto Globe Oil'),
	(15, 0, '0', 100000, 3, 0, 'Grapeseed LTD'),
	(16, 0, '0', 100000, 3, 0, 'Sandy Shores Xero'),
	(17, 0, '0', 100000, 3, 0, 'Sandy Shores Globe Oil'),
	(18, 0, '0', 100000, 3, 0, 'Senora Freeway Xero'),
	(19, 0, '0', 100000, 3, 0, 'Harmony Globe Oil'),
	(20, 0, '0', 100000, 3, 0, 'Route 68 Globe Oil'),
	(21, 0, '0', 100000, 3, 0, 'Route 68 Workshop Globe O'),
	(22, 0, '0', 100000, 3, 0, 'Route 68 Xero'),
	(23, 0, '0', 100000, 3, 0, 'Route 68 Ron'),
	(24, 0, '0', 100000, 3, 0, 'Rex\'s Diner Globe Oil'),
	(25, 0, '0', 100000, 3, 0, 'Palmino Freeway Ron'),
	(26, 0, '0', 100000, 3, 0, 'North Rockford LTD'),
	(27, 0, '0', 100000, 3, 0, 'Alta Street Globe Oil');

-- Dumpar struktur för tabell qbcoreframework_6f803d.houselocations
CREATE TABLE IF NOT EXISTS `houselocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(1) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(4) DEFAULT NULL,
  `garage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.houselocations: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.house_plants
CREATE TABLE IF NOT EXISTS `house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(50) DEFAULT NULL,
  `stage` int(11) DEFAULT 1,
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building` (`building`),
  KEY `plantid` (`plantid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.house_plants: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.inventories
CREATE TABLE IF NOT EXISTS `inventories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `items` longtext DEFAULT '[]',
  PRIMARY KEY (`identifier`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.inventories: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.lapraces: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_bolos
CREATE TABLE IF NOT EXISTS `mdt_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `individual` varchar(50) DEFAULT NULL,
  `detail` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `officersinvolved` text DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) NOT NULL DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_bolos: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_bulletin
CREATE TABLE IF NOT EXISTS `mdt_bulletin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `desc` text NOT NULL,
  `author` varchar(50) NOT NULL,
  `time` varchar(20) NOT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_bulletin: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_clocking
CREATE TABLE IF NOT EXISTS `mdt_clocking` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `lastname` varchar(255) NOT NULL DEFAULT '',
  `clock_in_time` varchar(255) NOT NULL DEFAULT '',
  `clock_out_time` varchar(50) DEFAULT NULL,
  `total_time` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_clocking: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_convictions
CREATE TABLE IF NOT EXISTS `mdt_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(50) DEFAULT NULL,
  `linkedincident` int(11) NOT NULL DEFAULT 0,
  `warrant` varchar(50) DEFAULT NULL,
  `guilty` varchar(50) DEFAULT NULL,
  `processed` varchar(50) DEFAULT NULL,
  `associated` varchar(50) DEFAULT '0',
  `charges` text DEFAULT NULL,
  `fine` int(11) DEFAULT 0,
  `sentence` int(11) DEFAULT 0,
  `recfine` int(11) DEFAULT 0,
  `recsentence` int(11) DEFAULT 0,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_convictions: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_data
CREATE TABLE IF NOT EXISTS `mdt_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) NOT NULL,
  `information` mediumtext DEFAULT NULL,
  `tags` text NOT NULL,
  `gallery` text NOT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  `pfp` text DEFAULT NULL,
  `fingerprint` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_data: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_impound
CREATE TABLE IF NOT EXISTS `mdt_impound` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleid` int(11) NOT NULL,
  `linkedreport` int(11) NOT NULL,
  `fee` int(11) DEFAULT NULL,
  `time` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_impound: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_incidents
CREATE TABLE IF NOT EXISTS `mdt_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(50) NOT NULL DEFAULT '0',
  `details` text NOT NULL,
  `tags` text NOT NULL,
  `officersinvolved` text NOT NULL,
  `civsinvolved` text NOT NULL,
  `evidence` text NOT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) NOT NULL DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_incidents: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_logs
CREATE TABLE IF NOT EXISTS `mdt_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_logs: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `officersinvolved` text DEFAULT NULL,
  `civsinvolved` text DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_reports: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_vehicleinfo
CREATE TABLE IF NOT EXISTS `mdt_vehicleinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) DEFAULT NULL,
  `information` text NOT NULL DEFAULT '',
  `stolen` tinyint(1) NOT NULL DEFAULT 0,
  `code5` tinyint(1) NOT NULL DEFAULT 0,
  `image` text NOT NULL DEFAULT '',
  `points` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_vehicleinfo: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.mdt_weaponinfo
CREATE TABLE IF NOT EXISTS `mdt_weaponinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `information` text NOT NULL DEFAULT '',
  `weapClass` varchar(50) DEFAULT NULL,
  `weapModel` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.mdt_weaponinfo: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.multijobs
CREATE TABLE IF NOT EXISTS `multijobs` (
  `citizenid` varchar(100) NOT NULL,
  `jobdata` text DEFAULT NULL,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.multijobs: ~0 rows (ungefär)
INSERT IGNORE INTO `multijobs` (`citizenid`, `jobdata`) VALUES
	('YIA61095', '{"police":1}');

-- Dumpar struktur för tabell qbcoreframework_6f803d.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.occasion_vehicles: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.ox_doorlock
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.ox_doorlock: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.phone_gallery
CREATE TABLE IF NOT EXISTS `phone_gallery` (
  `citizenid` varchar(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.phone_gallery: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.phone_invoices
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `society` tinytext DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.phone_invoices: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.phone_messages: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `firstName` varchar(25) DEFAULT NULL,
  `lastName` varchar(25) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `url` text DEFAULT NULL,
  `picture` varchar(512) DEFAULT './img/default.png',
  `tweetId` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.phone_tweets: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.pickle_prisons
CREATE TABLE IF NOT EXISTS `pickle_prisons` (
  `identifier` varchar(46) NOT NULL,
  `prison` varchar(50) DEFAULT 'default',
  `time` int(11) NOT NULL DEFAULT 0,
  `inventory` longtext NOT NULL,
  `sentence_date` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.pickle_prisons: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=557 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.players: ~1 rows (ungefär)
INSERT IGNORE INTO `players` (`id`, `citizenid`, `cid`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `metadata`, `inventory`, `last_updated`) VALUES
	(1, 'YIA61095', 1, 'license:b17e3ffcaacfd0d0b3815da593f86e6ee481af71', 'simon', '{"crypto":0,"cash":494,"bank":23063}', '{"lastname":"Devv","phone":"5187171513","firstname":"Mike","nationality":"Sweden","cid":1,"birthdate":"2024-06-19","account":"US09QBCore4060336461","gender":0}', '{"onduty":true,"label":"Law Enforcement","isboss":false,"grade":{"name":"Officer","level":1,"isboss":false,"payment":75},"name":"police","type":"leo","payment":10}', '{"name":"none","grade":{"name":"none","level":0},"isboss":false,"label":"No Gang Affiliation"}', '{"x":-815.3274536132813,"y":-417.8637390136719,"z":97.959716796875}', '{"jailitems":[],"callsign":"NO CALLSIGN","rep":[],"bloodtype":"O-","heroin":0,"injail":0,"tracker":false,"inlaststand":false,"armor":0,"phone":[],"phonedata":{"SerialNumber":74329689,"InstalledApps":[]},"inside":{"apartment":[]},"isdead":false,"licences":{"driver":true,"business":false,"weapon":false},"fingerprint":"xD557F76gyJ3824","lsd":0,"ishandcuffed":false,"criminalrecord":{"hasRecord":false},"thirst":100,"hunger":100,"coke":0,"status":[],"walletid":"QB-95018714","stress":0}', '[{"name":"advancedlockpick","amount":1,"type":"item","info":[],"slot":1},{"name":"phone","amount":1,"type":"item","info":[],"slot":2}]', '2024-07-14 01:51:40');

-- Dumpar struktur för tabell qbcoreframework_6f803d.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.playerskins: ~2 rows (ungefär)
INSERT IGNORE INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
	(1, 'YIA61095', '1885233650', '{"accessory":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"jaw_bone_back_lenght":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"nose_1":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"bag":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"eyebrows":{"item":-1,"texture":1,"defaultItem":-1,"defaultTexture":1},"hair":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"eye_color":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"nose_4":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"vest":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"lips_thickness":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"face2":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"hat":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"lipstick":{"item":-1,"texture":1,"defaultItem":-1,"defaultTexture":1},"neck_thikness":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"bracelet":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"chimp_bone_width":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"chimp_bone_lenght":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"watch":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"eyebrown_high":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"mask":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"arms":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"eyebrown_forward":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"chimp_bone_lowering":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"jaw_bone_width":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"beard":{"item":-1,"texture":1,"defaultItem":-1,"defaultTexture":1},"chimp_hole":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"cheek_2":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"nose_5":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"face":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"cheek_3":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"pants":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"cheek_1":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"nose_3":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"ageing":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"t-shirt":{"item":1,"texture":0,"defaultItem":1,"defaultTexture":0},"shoes":{"item":1,"texture":0,"defaultItem":1,"defaultTexture":0},"nose_0":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"blush":{"item":-1,"texture":1,"defaultItem":-1,"defaultTexture":1},"moles":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"facemix":{"defaultSkinMix":0.0,"defaultShapeMix":0.0,"skinMix":0,"shapeMix":0},"eye_opening":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"ear":{"item":-1,"texture":0,"defaultItem":-1,"defaultTexture":0},"glass":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"torso2":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"nose_2":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0},"makeup":{"item":-1,"texture":1,"defaultItem":-1,"defaultTexture":1},"decals":{"item":0,"texture":0,"defaultItem":0,"defaultTexture":0}}', 0),
	(3, 'YIA61095', 'mp_m_freemode_01', '{"headBlend":{"skinFirst":4,"skinMix":0,"shapeMix":0,"skinThird":0,"shapeFirst":0,"skinSecond":0,"shapeThird":0,"shapeSecond":0,"thirdMix":0},"props":[{"prop_id":0,"drawable":-1,"texture":-1},{"prop_id":1,"drawable":5,"texture":5},{"prop_id":2,"drawable":2,"texture":0},{"prop_id":6,"drawable":-1,"texture":-1},{"prop_id":7,"drawable":-1,"texture":-1}],"components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":0,"texture":0},{"component_id":2,"drawable":21,"texture":0},{"component_id":4,"drawable":24,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":6,"drawable":21,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":23,"texture":1},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":498,"texture":0},{"component_id":3,"drawable":27,"texture":0}],"model":"mp_m_freemode_01","faceFeatures":{"eyesOpening":0,"eyeBrownForward":0,"cheeksBoneHigh":0,"jawBoneBackSize":0,"cheeksBoneWidth":0,"neckThickness":0,"nosePeakLowering":0,"nosePeakHigh":0,"noseBoneHigh":0,"cheeksWidth":0,"jawBoneWidth":0,"noseWidth":0,"chinBoneSize":0,"chinHole":0,"chinBoneLenght":0,"lipsThickness":0,"noseBoneTwist":0,"nosePeakSize":0,"eyeBrownHigh":0,"chinBoneLowering":0},"headOverlays":{"bodyBlemishes":{"opacity":0,"style":0,"color":0,"secondColor":0},"lipstick":{"opacity":0,"style":0,"color":0,"secondColor":0},"moleAndFreckles":{"opacity":0,"style":0,"color":0,"secondColor":0},"sunDamage":{"opacity":1,"style":0,"color":0,"secondColor":0},"makeUp":{"opacity":0,"style":0,"color":0,"secondColor":0},"blemishes":{"opacity":0,"style":0,"color":0,"secondColor":0},"ageing":{"opacity":1,"style":4,"color":0,"secondColor":0},"eyebrows":{"opacity":1,"style":30,"color":0,"secondColor":0},"chestHair":{"opacity":1,"style":0,"color":0,"secondColor":0},"blush":{"opacity":0,"style":0,"color":0,"secondColor":0},"beard":{"opacity":1,"style":11,"color":0,"secondColor":0},"complexion":{"opacity":0,"style":0,"color":0,"secondColor":0}},"tattoos":[],"eyeColor":2,"hair":{"highlight":14,"texture":0,"color":0,"style":21}}', 1);

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_contacts
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_contacts: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_houses
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(11) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `house` (`house`),
  KEY `citizenid` (`citizenid`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_houses: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_mails: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(11) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `outfitId` (`outfitId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_outfits: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(11) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(8) NOT NULL,
  `fakeplate` varchar(8) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `paymentamount` int(11) NOT NULL DEFAULT 0,
  `paymentsleft` int(11) NOT NULL DEFAULT 0,
  `financetime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_vehicles: ~0 rows (ungefär)
INSERT IGNORE INTO `player_vehicles` (`id`, `license`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `fakeplate`, `garage`, `fuel`, `engine`, `body`, `state`, `depotprice`, `drivingdistance`, `status`, `balance`, `paymentamount`, `paymentsleft`, `financetime`) VALUES
	(1, 'license:b17e3ffcaacfd0d0b3815da593f86e6ee481af71', 'YIA61095', 'panto', '-431692672', '{"modFrame":-1,"color1":3,"modTrimA":-1,"modRearBumper":-1,"modLightbar":-1,"modFender":-1,"dashboardColor":0,"modOrnaments":-1,"modRoof":-1,"modSmokeEnabled":false,"model":-431692672,"modSuspension":-1,"modTank":-1,"modEngineBlock":-1,"modFrontWheels":-1,"modSteeringWheel":-1,"modRightFender":-1,"wheelSize":0.0,"oilLevel":5,"modHood":-1,"paintType2":0,"modDoorR":-1,"wheels":5,"modSpoilers":-1,"modHydraulics":false,"tyreSmokeColor":[255,255,255],"modTransmission":-1,"modBrakes":-1,"modAPlate":-1,"windows":[4,5,6],"bulletProofTyres":true,"wheelWidth":0.0,"interiorColor":0,"neonEnabled":[false,false,false,false],"tankHealth":1000,"modTrimB":-1,"neonColor":[255,0,255],"modVanityPlate":-1,"extras":[0,0,0,0,0],"modBackWheels":-1,"modStruts":-1,"modTrunk":-1,"modNitrous":-1,"tyres":[],"plate":"63BPT565","modCustomTiresR":false,"modGrille":-1,"bodyHealth":1000,"modPlateHolder":-1,"modHorns":-1,"modShifterLeavers":-1,"modLivery":-1,"doors":[],"modRoofLivery":-1,"modCustomTiresF":false,"modTurbo":false,"driftTyres":false,"dirtLevel":0,"modSeats":-1,"modSubwoofer":-1,"modAerials":-1,"modExhaust":-1,"modWindows":-1,"modFrontBumper":-1,"modArmor":-1,"modSideSkirt":-1,"paintType1":0,"modDial":-1,"modXenon":false,"modHydrolic":-1,"xenonColor":255,"modDoorSpeaker":-1,"modEngine":-1,"modSpeakers":-1,"color2":3,"modAirFilter":-1,"windowTint":-1,"plateIndex":0,"engineHealth":1000,"pearlescentColor":0,"modDashboard":-1,"modArchCover":-1,"fuelLevel":22,"wheelColor":156}', '63BPT565', NULL, NULL, 100, 1000, 1000, 1, 0, NULL, NULL, 0, 0, 0, 0);

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_warns
CREATE TABLE IF NOT EXISTS `player_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.player_warns: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.player_xp
CREATE TABLE IF NOT EXISTS `player_xp` (
  `identifier` varchar(46) NOT NULL,
  `xp` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ROW_FORMAT=DYNAMIC;

-- Dumpar data för tabell qbcoreframework_6f803d.player_xp: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.ps_banking_accounts
CREATE TABLE IF NOT EXISTS `ps_banking_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `balance` bigint(20) NOT NULL,
  `holder` varchar(255) NOT NULL,
  `cardNumber` varchar(255) NOT NULL,
  `users` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`users`)),
  `owner` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`owner`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.ps_banking_accounts: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.ps_banking_bills
CREATE TABLE IF NOT EXISTS `ps_banking_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `isPaid` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.ps_banking_bills: ~0 rows (ungefär)

-- Dumpar struktur för tabell qbcoreframework_6f803d.ps_banking_transactions
CREATE TABLE IF NOT EXISTS `ps_banking_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `isIncome` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumpar data för tabell qbcoreframework_6f803d.ps_banking_transactions: ~0 rows (ungefär)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
