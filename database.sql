-- DB Schema for FiveM Framework
-- Import these tables if using MySQL

-- Characters Table
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `citizen_id` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT 'male',
  `level` int(11) DEFAULT 1,
  `experience` int(11) DEFAULT 0,
  `money` int(11) DEFAULT 5000,
  `bank_balance` int(11) DEFAULT 5000,
  `job` varchar(50) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Vehicles Table
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `vehicle_id` varchar(50) NOT NULL UNIQUE,
  `model` varchar(50) NOT NULL,
  `plate` varchar(20) UNIQUE,
  `fuel` int(11) DEFAULT 100,
  `engine_health` int(11) DEFAULT 1000,
  `body_health` int(11) DEFAULT 1000,
  `mods` longtext,
  `position_x` float DEFAULT 0,
  `position_y` float DEFAULT 0,
  `position_z` float DEFAULT 0,
  `heading` float DEFAULT 0,
  `registration_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Bank Accounts Table
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL UNIQUE,
  `balance` int(11) DEFAULT 5000,
  `pin` varchar(6) DEFAULT '0000',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Bank Transactions Table
CREATE TABLE IF NOT EXISTS `bank_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL,
  `balance_after` int(11) DEFAULT 0,
  `other_player` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `transaction_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `transaction_date` (`transaction_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Inventory Items Table
CREATE TABLE IF NOT EXISTS `inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `metadata` longtext,
  `slot` int(11) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  UNIQUE KEY `player_item_slot` (`player_id`, `item_name`, `slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Warrants Table
CREATE TABLE IF NOT EXISTS `warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `warrant_id` varchar(50) NOT NULL UNIQUE,
  `target_player` int(11) NOT NULL,
  `issued_by` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `level` int(11) DEFAULT 1,
  `active` tinyint(1) DEFAULT 1,
  `issued_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL,
  PRIMARY KEY (`id`),
  KEY `target_player` (`target_player`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Arrests Table
CREATE TABLE IF NOT EXISTS `arrests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `arrest_id` varchar(50) NOT NULL UNIQUE,
  `target_player` int(11) NOT NULL,
  `officer` int(11) NOT NULL,
  `charges` varchar(255) NOT NULL,
  `bail` int(11) DEFAULT 0,
  `bail_paid` tinyint(1) DEFAULT 0,
  `jail_time` int(11) DEFAULT 60,
  `arrest_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  `release_date` timestamp NULL,
  PRIMARY KEY (`id`),
  KEY `target_player` (`target_player`),
  KEY `officer` (`officer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- NPCs Table
CREATE TABLE IF NOT EXISTS `npcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `npc_id` varchar(50) NOT NULL UNIQUE,
  `model` varchar(50) NOT NULL,
  `position_x` float NOT NULL,
  `position_y` float NOT NULL,
  `position_z` float NOT NULL,
  `heading` float DEFAULT 0,
  `name` varchar(100) NOT NULL,
  `dialogues` longtext,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Job Data Table
CREATE TABLE IF NOT EXISTS `job_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL UNIQUE,
  `job_name` varchar(50) NOT NULL,
  `grade` int(11) DEFAULT 1,
  `day_earnings` int(11) DEFAULT 0,
  `clocked_in` tinyint(1) DEFAULT 0,
  `clock_in_time` timestamp NULL,
  `clock_out_time` timestamp NULL,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `job_name` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Wanted List Table
CREATE TABLE IF NOT EXISTS `wanted_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL UNIQUE,
  `wanted_level` int(11) DEFAULT 0,
  `reason` varchar(255),
  `reported_by` int(11),
  `report_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  `cleared_date` timestamp NULL,
  PRIMARY KEY (`id`),
  KEY `wanted_level` (`wanted_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Logs Table (for audit trail)
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11),
  `action` varchar(100) NOT NULL,
  `description` text,
  `data` longtext,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
