CREATE TABLE IF NOT EXISTS `cfx_refunds` (
  `discord` VARCHAR(255) NOT NULL,
  `item` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int(11) NOT NULL,
   PRIMARY KEY (`discord`)
)