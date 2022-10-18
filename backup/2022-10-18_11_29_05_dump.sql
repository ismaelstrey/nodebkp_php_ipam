/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: api
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `api` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` varchar(32) NOT NULL DEFAULT '',
  `app_code` varchar(32) DEFAULT '',
  `app_permissions` int(1) DEFAULT '1',
  `app_comment` text,
  `app_security` set('ssl_code', 'ssl_token', 'crypt', 'user', 'none') NOT NULL DEFAULT 'ssl_token',
  `app_lock` int(1) NOT NULL DEFAULT '0',
  `app_lock_wait` int(4) NOT NULL DEFAULT '30',
  `app_nest_custom_fields` tinyint(1) DEFAULT '0',
  `app_show_links` tinyint(1) DEFAULT '0',
  `app_last_access` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: changelog
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `changelog` (
  `cid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype` set('ip_addr', 'subnet', 'section') NOT NULL DEFAULT '',
  `coid` int(11) unsigned NOT NULL,
  `cuser` int(11) unsigned NOT NULL,
  `caction` enum(
    'add',
    'edit',
    'delete',
    'truncate',
    'resize',
    'perm_change'
  ) NOT NULL DEFAULT 'edit',
  `cresult` enum('error', 'success') NOT NULL DEFAULT 'success',
  `cdate` datetime NOT NULL,
  `cdiff` text,
  PRIMARY KEY (`cid`),
  KEY `coid` (`coid`),
  KEY `ctype` (`ctype`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: circuitProviders
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `circuitProviders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `description` text,
  `contact` varchar(128) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: circuitTypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `circuitTypes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctname` varchar(64) NOT NULL,
  `ctcolor` varchar(7) DEFAULT '#000000',
  `ctpattern` enum('Solid', 'Dotted') DEFAULT 'Solid',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: circuits
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `circuits` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(128) DEFAULT NULL,
  `provider` int(11) unsigned NOT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `capacity` varchar(128) DEFAULT NULL,
  `status` enum('Active', 'Inactive', 'Reserved') NOT NULL DEFAULT 'Active',
  `device1` int(11) unsigned DEFAULT NULL,
  `location1` int(11) unsigned DEFAULT NULL,
  `device2` int(11) unsigned DEFAULT NULL,
  `location2` int(11) unsigned DEFAULT NULL,
  `comment` text,
  `parent` int(10) unsigned NOT NULL DEFAULT '0',
  `customer_id` int(11) unsigned DEFAULT NULL,
  `differentiator` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `circuits_diff_UN` (`cid`, `differentiator`),
  KEY `location1` (`location1`),
  KEY `location2` (`location2`),
  KEY `customer_circuits` (`customer_id`),
  CONSTRAINT `customer_circuits` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: circuitsLogical
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `circuitsLogical` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logical_cid` varchar(128) NOT NULL,
  `purpose` varchar(64) DEFAULT NULL,
  `comments` text,
  `member_count` int(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `circuitsLogical_UN` (`logical_cid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: circuitsLogicalMapping
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `circuitsLogicalMapping` (
  `logicalCircuit_id` int(11) unsigned NOT NULL,
  `circuit_id` int(11) unsigned NOT NULL,
  `order` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`logicalCircuit_id`, `circuit_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: customers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL DEFAULT '',
  `address` varchar(255) DEFAULT NULL,
  `postcode` varchar(32) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `lat` varchar(31) DEFAULT NULL,
  `long` varchar(31) DEFAULT NULL,
  `contact_person` text,
  `contact_phone` varchar(32) DEFAULT NULL,
  `contact_mail` varchar(254) DEFAULT NULL,
  `note` text,
  `status` set('Active', 'Reserved', 'Inactive') DEFAULT 'Active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: deviceTypes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `deviceTypes` (
  `tid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tname` varchar(128) DEFAULT NULL,
  `tdescription` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE = InnoDB AUTO_INCREMENT = 10 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: devices
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) DEFAULT NULL,
  `ip_addr` varchar(100) DEFAULT NULL,
  `type` int(2) DEFAULT '0',
  `description` varchar(256) DEFAULT NULL,
  `sections` varchar(1024) DEFAULT NULL,
  `snmp_community` varchar(100) DEFAULT NULL,
  `snmp_version` set('0', '1', '2', '3') DEFAULT '0',
  `snmp_port` mediumint(5) unsigned DEFAULT '161',
  `snmp_timeout` mediumint(5) unsigned DEFAULT '1000',
  `snmp_queries` varchar(128) DEFAULT NULL,
  `snmp_v3_sec_level` set('none', 'noAuthNoPriv', 'authNoPriv', 'authPriv') DEFAULT 'none',
  `snmp_v3_auth_protocol` set('none', 'MD5', 'SHA') DEFAULT 'none',
  `snmp_v3_auth_pass` varchar(64) DEFAULT NULL,
  `snmp_v3_priv_protocol` set('none', 'DES', 'AES') DEFAULT 'none',
  `snmp_v3_priv_pass` varchar(64) DEFAULT NULL,
  `snmp_v3_ctx_name` varchar(64) DEFAULT NULL,
  `snmp_v3_ctx_engine_id` varchar(64) DEFAULT NULL,
  `rack` int(11) unsigned DEFAULT NULL,
  `rack_start` int(11) unsigned DEFAULT NULL,
  `rack_size` int(11) unsigned DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `hostname` (`hostname`),
  KEY `location` (`location`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: firewallZoneMapping
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `firewallZoneMapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zoneId` int(11) unsigned NOT NULL,
  `alias` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deviceId` int(11) unsigned DEFAULT NULL,
  `interface` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `devId_idx` (`deviceId`),
  CONSTRAINT `devId` FOREIGN KEY (`deviceId`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: firewallZoneSubnet
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `firewallZoneSubnet` (
  `zoneId` int(11) NOT NULL,
  `subnetId` int(11) NOT NULL,
  PRIMARY KEY (`zoneId`, `subnetId`),
  KEY `fk_zoneId_idx` (`zoneId`),
  KEY `fk_subnetId_idx` (`subnetId`),
  CONSTRAINT `fk_subnetId` FOREIGN KEY (`subnetId`) REFERENCES `subnets` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_zoneId` FOREIGN KEY (`zoneId`) REFERENCES `firewallZones` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: firewallZones
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `firewallZones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `generator` tinyint(1) NOT NULL,
  `length` int(2) DEFAULT NULL,
  `padding` tinyint(1) DEFAULT NULL,
  `zone` varchar(31) COLLATE utf8_unicode_ci NOT NULL,
  `indicator` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `permissions` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: instructions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `instructions` (
  `id` int(11) NOT NULL,
  `instructions` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: ipTags
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ipTags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `showtag` tinyint(4) DEFAULT '1',
  `bgcolor` varchar(7) DEFAULT '#000',
  `fgcolor` varchar(7) DEFAULT '#fff',
  `compress` set('No', 'Yes') NOT NULL DEFAULT 'No',
  `locked` set('No', 'Yes') NOT NULL DEFAULT 'No',
  `updateTag` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: ipaddresses
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ipaddresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subnetId` int(11) unsigned DEFAULT NULL,
  `ip_addr` varchar(100) NOT NULL,
  `is_gateway` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(64) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `owner` varchar(128) DEFAULT NULL,
  `state` int(3) DEFAULT '2',
  `switch` int(11) unsigned DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `port` varchar(32) DEFAULT NULL,
  `note` text,
  `lastSeen` datetime DEFAULT '1970-01-01 00:00:01',
  `excludePing` tinyint(1) NOT NULL DEFAULT '0',
  `PTRignore` tinyint(1) NOT NULL DEFAULT '0',
  `PTR` int(11) unsigned DEFAULT '0',
  `firewallAddressObject` varchar(100) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sid_ip_unique` (`ip_addr`, `subnetId`),
  KEY `subnetid` (`subnetId`),
  KEY `location` (`location`),
  KEY `customer_ip` (`customer_id`),
  CONSTRAINT `customer_ip` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 11 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: lang
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `lang` (
  `l_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `l_code` varchar(12) NOT NULL DEFAULT '',
  `l_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`l_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: locations
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `description` text,
  `address` varchar(128) DEFAULT NULL,
  `lat` varchar(31) DEFAULT NULL,
  `long` varchar(31) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: loginAttempts
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `loginAttempts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(128) NOT NULL DEFAULT '',
  `count` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: logs
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `severity` int(11) DEFAULT NULL,
  `date` varchar(32) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `ipaddr` varchar(64) DEFAULT NULL,
  `command` text,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: nameservers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `nameservers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `namesrv1` varchar(255) DEFAULT NULL,
  `description` text,
  `permissions` varchar(128) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: nat
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `nat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `type` set('source', 'static', 'destination') DEFAULT 'source',
  `src` text,
  `dst` text,
  `src_port` int(5) DEFAULT NULL,
  `dst_port` int(5) DEFAULT NULL,
  `device` int(11) unsigned DEFAULT NULL,
  `description` text,
  `policy` set('Yes', 'No') NOT NULL DEFAULT 'No',
  `policy_dst` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: nominatim
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `nominatim` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: nominatim_cache
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `nominatim_cache` (
  `sha256` binary(32) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `query` text NOT NULL,
  `lat_lng` text NOT NULL,
  PRIMARY KEY (`sha256`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: php_sessions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `php_sessions` (
  `id` varchar(128) NOT NULL DEFAULT '',
  `access` int(10) unsigned DEFAULT NULL,
  `data` text NOT NULL,
  `remote_ip` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: pstnNumbers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pstnNumbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` int(11) unsigned DEFAULT NULL,
  `number` varchar(32) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `owner` varchar(128) DEFAULT NULL,
  `state` int(11) unsigned DEFAULT NULL,
  `deviceId` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: pstnPrefixes
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pstnPrefixes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `prefix` varchar(32) DEFAULT NULL,
  `start` varchar(32) DEFAULT NULL,
  `stop` varchar(32) DEFAULT NULL,
  `master` int(11) DEFAULT '0',
  `deviceId` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: rackContents
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `rackContents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `rack` int(11) unsigned DEFAULT NULL,
  `rack_start` int(11) unsigned DEFAULT NULL,
  `rack_size` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rack` (`rack`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: racks
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `racks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `size` int(2) DEFAULT NULL,
  `location` int(11) unsigned DEFAULT NULL,
  `row` int(11) NOT NULL DEFAULT '1',
  `hasBack` tinyint(1) NOT NULL DEFAULT '0',
  `topDown` tinyint(1) NOT NULL DEFAULT '0',
  `description` text,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `location` (`location`),
  KEY `customer_racks` (`customer_id`),
  CONSTRAINT `customer_racks` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: requests
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `requests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subnetId` int(11) unsigned DEFAULT NULL,
  `ip_addr` varchar(100) DEFAULT NULL,
  `description` varchar(64) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `state` int(11) DEFAULT '2',
  `owner` varchar(128) DEFAULT NULL,
  `requester` varchar(128) DEFAULT NULL,
  `comment` text,
  `processed` binary(1) DEFAULT NULL,
  `accepted` binary(1) DEFAULT NULL,
  `adminComment` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routing_bgp
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routing_bgp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `local_as` int(12) unsigned NOT NULL,
  `local_address` varchar(100) NOT NULL DEFAULT '',
  `peer_name` varchar(255) NOT NULL DEFAULT '',
  `peer_as` int(12) unsigned NOT NULL,
  `peer_address` varchar(100) NOT NULL DEFAULT '',
  `bgp_type` enum('internal', 'external') NOT NULL DEFAULT 'external',
  `vrf_id` int(11) unsigned DEFAULT NULL,
  `circuit_id` int(11) unsigned DEFAULT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `vrf_id` (`vrf_id`),
  KEY `circuit_id` (`circuit_id`),
  KEY `cust_id` (`customer_id`),
  CONSTRAINT `circuit_id` FOREIGN KEY (`circuit_id`) REFERENCES `circuits` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `cust_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE,
  CONSTRAINT `vrf_id` FOREIGN KEY (`vrf_id`) REFERENCES `vrf` (`vrfId`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: routing_subnets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `routing_subnets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('bgp', 'ospf') NOT NULL DEFAULT 'bgp',
  `direction` enum('advertised', 'received') NOT NULL DEFAULT 'advertised',
  `object_id` int(11) unsigned NOT NULL,
  `subnet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`, `object_id`, `subnet_id`),
  KEY `bgp_id` (`object_id`),
  KEY `subnet_id` (`subnet_id`),
  CONSTRAINT `bgp_id` FOREIGN KEY (`object_id`) REFERENCES `routing_bgp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subnet_id` FOREIGN KEY (`subnet_id`) REFERENCES `subnets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: scanAgents
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `scanAgents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `description` text,
  `type` set('direct', 'api', 'mysql') NOT NULL DEFAULT '',
  `code` varchar(32) DEFAULT NULL,
  `last_access` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: sections
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `description` text,
  `masterSection` int(11) DEFAULT '0',
  `permissions` varchar(1024) DEFAULT NULL,
  `strictMode` binary(1) NOT NULL DEFAULT '1',
  `subnetOrdering` varchar(16) DEFAULT NULL,
  `order` int(3) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `showSubnet` tinyint(1) NOT NULL DEFAULT '1',
  `showVLAN` tinyint(1) NOT NULL DEFAULT '0',
  `showVRF` tinyint(1) NOT NULL DEFAULT '0',
  `showSupernetOnly` tinyint(1) NOT NULL DEFAULT '0',
  `DNS` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `id_2` (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: settings
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `siteTitle` varchar(64) DEFAULT NULL,
  `siteAdminName` varchar(64) DEFAULT NULL,
  `siteAdminMail` varchar(254) DEFAULT NULL,
  `siteDomain` varchar(32) DEFAULT NULL,
  `siteURL` varchar(64) DEFAULT NULL,
  `siteLoginText` varchar(128) DEFAULT NULL,
  `domainAuth` tinyint(1) DEFAULT NULL,
  `enableIPrequests` tinyint(1) DEFAULT NULL,
  `enableVRF` tinyint(1) DEFAULT '1',
  `enableDNSresolving` tinyint(1) DEFAULT NULL,
  `enableFirewallZones` tinyint(1) NOT NULL DEFAULT '0',
  `firewallZoneSettings` varchar(1024) NOT NULL DEFAULT '{"zoneLength":3,"ipType":{"0":"v4","1":"v6"},"separator":"_","indicator":{"0":"own","1":"customer"},"zoneGenerator":"2","zoneGeneratorType":{"0":"decimal","1":"hex","2":"text"},"deviceType":"3","padding":"on","strictMode":"on","pattern":{"0":"patternFQDN"}}',
  `enablePowerDNS` tinyint(1) DEFAULT '0',
  `powerDNS` text,
  `enableDHCP` tinyint(1) DEFAULT '0',
  `DHCP` varchar(256) DEFAULT '{"type":"kea","settings":{"file":"/etc/kea/kea.conf"}}',
  `enableMulticast` tinyint(1) DEFAULT '0',
  `enableNAT` tinyint(1) DEFAULT '1',
  `enableSNMP` tinyint(1) DEFAULT '0',
  `enableThreshold` tinyint(1) DEFAULT '1',
  `enableRACK` tinyint(1) DEFAULT '1',
  `enableLocations` tinyint(1) DEFAULT '1',
  `enablePSTN` tinyint(1) DEFAULT '0',
  `enableChangelog` tinyint(1) NOT NULL DEFAULT '1',
  `enableCustomers` tinyint(1) NOT NULL DEFAULT '1',
  `enableVaults` tinyint(1) NOT NULL DEFAULT '1',
  `link_field` varchar(32) DEFAULT '0',
  `version` varchar(5) DEFAULT NULL,
  `dbversion` int(8) NOT NULL DEFAULT '0',
  `dbverified` binary(1) NOT NULL DEFAULT '0',
  `donate` tinyint(1) DEFAULT '0',
  `IPfilter` varchar(128) DEFAULT NULL,
  `IPrequired` varchar(128) DEFAULT NULL,
  `vlanDuplicate` int(1) DEFAULT '0',
  `vlanMax` int(8) DEFAULT '4096',
  `subnetOrdering` varchar(16) DEFAULT 'subnet,asc',
  `visualLimit` int(2) NOT NULL DEFAULT '0',
  `theme` varchar(32) NOT NULL DEFAULT 'dark',
  `autoSuggestNetwork` tinyint(1) NOT NULL DEFAULT '0',
  `pingStatus` varchar(32) NOT NULL DEFAULT '1800;3600',
  `defaultLang` int(3) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `vcheckDate` datetime DEFAULT NULL,
  `api` binary(1) NOT NULL DEFAULT '0',
  `scanPingPath` varchar(64) DEFAULT '/bin/ping',
  `scanFPingPath` varchar(64) DEFAULT '/bin/fping',
  `scanPingType` enum('none', 'ping', 'pear', 'fping') NOT NULL DEFAULT 'ping',
  `scanMaxThreads` int(4) DEFAULT '128',
  `prettyLinks` enum('Yes', 'No') NOT NULL DEFAULT 'No',
  `hiddenCustomFields` text,
  `inactivityTimeout` int(5) NOT NULL DEFAULT '3600',
  `updateTags` tinyint(1) DEFAULT '0',
  `enforceUnique` tinyint(1) DEFAULT '1',
  `authmigrated` tinyint(4) NOT NULL DEFAULT '0',
  `maintaneanceMode` tinyint(1) DEFAULT '0',
  `decodeMAC` tinyint(1) DEFAULT '1',
  `tempShare` tinyint(1) DEFAULT '0',
  `tempAccess` text,
  `log` enum('Database', 'syslog', 'both') NOT NULL DEFAULT 'Database',
  `subnetView` tinyint(4) NOT NULL DEFAULT '0',
  `enableCircuits` tinyint(1) DEFAULT '1',
  `enableRouting` tinyint(1) DEFAULT '0',
  `permissionPropagate` tinyint(1) DEFAULT '1',
  `passwordPolicy` varchar(1024) DEFAULT '{"minLength":8,"maxLength":0,"minNumbers":0,"minLetters":0,"minLowerCase":0,"minUpperCase":0,"minSymbols":0,"maxSymbols":0,"allowedSymbols":"#,_,-,!,[,],=,~"}',
  `2fa_provider` enum('none', 'Google_Authenticator') DEFAULT 'none',
  `2fa_name` varchar(32) DEFAULT 'phpipam',
  `2fa_length` int(2) DEFAULT '16',
  `2fa_userchange` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: settingsMail
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `settingsMail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mtype` enum('localhost', 'smtp') NOT NULL DEFAULT 'localhost',
  `msecure` enum('none', 'ssl', 'tls') NOT NULL DEFAULT 'none',
  `mauth` enum('yes', 'no') NOT NULL DEFAULT 'no',
  `mserver` varchar(128) DEFAULT NULL,
  `mport` int(5) DEFAULT '25',
  `muser` varchar(254) DEFAULT NULL,
  `mpass` varchar(128) DEFAULT NULL,
  `mAdminName` varchar(128) DEFAULT NULL,
  `mAdminMail` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: subnets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `subnets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subnet` varchar(255) DEFAULT NULL,
  `mask` varchar(3) DEFAULT NULL,
  `sectionId` int(11) unsigned DEFAULT NULL,
  `description` text,
  `linked_subnet` int(11) unsigned DEFAULT NULL,
  `firewallAddressObject` varchar(100) DEFAULT NULL,
  `vrfId` int(11) unsigned DEFAULT NULL,
  `masterSubnetId` int(11) unsigned NOT NULL DEFAULT '0',
  `allowRequests` tinyint(1) NOT NULL DEFAULT '0',
  `vlanId` int(11) unsigned DEFAULT NULL,
  `showName` tinyint(1) NOT NULL DEFAULT '0',
  `device` int(10) unsigned DEFAULT '0',
  `permissions` varchar(1024) DEFAULT NULL,
  `pingSubnet` tinyint(1) NOT NULL DEFAULT '0',
  `discoverSubnet` tinyint(1) NOT NULL DEFAULT '0',
  `resolveDNS` tinyint(1) NOT NULL DEFAULT '0',
  `DNSrecursive` tinyint(1) NOT NULL DEFAULT '0',
  `DNSrecords` tinyint(1) NOT NULL DEFAULT '0',
  `nameserverId` int(11) DEFAULT '0',
  `scanAgent` int(11) DEFAULT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `isFolder` tinyint(1) NOT NULL DEFAULT '0',
  `isFull` tinyint(1) NOT NULL DEFAULT '0',
  `isPool` tinyint(1) NOT NULL DEFAULT '0',
  `state` int(3) DEFAULT '2',
  `threshold` int(3) DEFAULT '0',
  `location` int(11) unsigned DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `lastScan` timestamp NULL DEFAULT NULL,
  `lastDiscovery` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `masterSubnetId` (`masterSubnetId`),
  KEY `location` (`location`),
  KEY `sectionId` (`sectionId`),
  KEY `vrfId` (`vrfId`),
  KEY `customer_subnets` (`customer_id`),
  CONSTRAINT `customer_subnets` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 7 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: userGroups
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `userGroups` (
  `g_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `g_name` varchar(32) DEFAULT NULL,
  `g_desc` varchar(1024) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`g_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: users
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `authMethod` int(2) DEFAULT '1',
  `password` char(128) COLLATE utf8_bin DEFAULT NULL,
  `groups` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `role` text CHARACTER SET utf8,
  `real_name` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(254) CHARACTER SET utf8 DEFAULT NULL,
  `domainUser` binary(1) DEFAULT '0',
  `widgets` varchar(1024) COLLATE utf8_bin DEFAULT 'statistics;favourite_subnets;changelog;top10_hosts_v4',
  `lang` int(11) unsigned DEFAULT '9',
  `favourite_subnets` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `disabled` enum('Yes', 'No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `mailNotify` enum('Yes', 'No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `mailChangelog` enum('Yes', 'No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `passChange` enum('Yes', 'No') COLLATE utf8_bin NOT NULL DEFAULT 'No',
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `lastLogin` timestamp NULL DEFAULT NULL,
  `lastActivity` timestamp NULL DEFAULT NULL,
  `compressOverride` enum('default', 'Uncompress') COLLATE utf8_bin NOT NULL DEFAULT 'default',
  `hideFreeRange` tinyint(1) DEFAULT '0',
  `menuType` enum('Static', 'Dynamic') COLLATE utf8_bin NOT NULL DEFAULT 'Dynamic',
  `menuCompact` tinyint(4) DEFAULT '1',
  `2fa` tinyint(1) NOT NULL DEFAULT '0',
  `2fa_secret` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `theme` varchar(32) COLLATE utf8_bin DEFAULT '',
  `token` varchar(24) COLLATE utf8_bin DEFAULT NULL,
  `token_valid_until` datetime DEFAULT NULL,
  `module_permissions` varchar(255) COLLATE utf8_bin DEFAULT '{"vlan":"1","l2dom":"1","vrf":"1","pdns":"1","circuits":"1","racks":"1","nat":"1","pstn":"1","customers":"1","locations":"1","devices":"1","routing":"1","vaults":"1"}',
  `compress_actions` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`username`),
  UNIQUE KEY `id_2` (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8 COLLATE = utf8_bin;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: usersAuthMethod
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `usersAuthMethod` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum(
  'local',
  'http',
  'AD',
  'LDAP',
  'NetIQ',
  'Radius',
  'SAML2'
  ) NOT NULL DEFAULT 'local',
  `params` text,
  `protected` enum('Yes', 'No') NOT NULL DEFAULT 'Yes',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vaultItems
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vaultItems` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `vaultId` int(11) unsigned NOT NULL,
  `type` enum('password', 'certificate') NOT NULL DEFAULT 'password',
  `type_certificate` enum('public', 'pkcs12', 'certificate', 'website') NOT NULL DEFAULT 'public',
  `values` text,
  PRIMARY KEY (`id`),
  KEY `vaultId` (`vaultId`),
  CONSTRAINT `vaultItems_ibfk_1` FOREIGN KEY (`vaultId`) REFERENCES `vaults` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vaults
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vaults` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `type` enum('passwords', 'certificates') NOT NULL DEFAULT 'passwords',
  `description` text,
  `test` char(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vlanDomains
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vlanDomains` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `description` text,
  `permissions` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vlans
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vlans` (
  `vlanId` int(11) NOT NULL AUTO_INCREMENT,
  `domainId` int(11) NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `number` int(4) DEFAULT NULL,
  `description` text,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`vlanId`),
  KEY `customer_vlans` (`customer_id`),
  CONSTRAINT `customer_vlans` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: vrf
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vrf` (
  `vrfId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `rd` varchar(32) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `sections` varchar(128) DEFAULT NULL,
  `editDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`vrfId`),
  KEY `customer_vrf` (`customer_id`),
  CONSTRAINT `customer_vrf` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: widgets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `widgets` (
  `wid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `wtitle` varchar(64) NOT NULL DEFAULT '',
  `wdescription` varchar(1024) DEFAULT NULL,
  `wfile` varchar(64) NOT NULL DEFAULT '',
  `wparams` varchar(1024) DEFAULT NULL,
  `whref` enum('yes', 'no') NOT NULL DEFAULT 'no',
  `wsize` enum('4', '6', '8', '12') NOT NULL DEFAULT '6',
  `wadminonly` enum('yes', 'no') NOT NULL DEFAULT 'no',
  `wactive` enum('yes', 'no') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`wid`)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARSET = utf8;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: api
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: changelog
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: circuitProviders
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: circuitTypes
# ------------------------------------------------------------

INSERT INTO
  `circuitTypes` (`id`, `ctname`, `ctcolor`, `ctpattern`)
VALUES
  (1, 'Default', '#000000', 'Solid');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: circuits
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: circuitsLogical
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: circuitsLogicalMapping
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: customers
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: deviceTypes
# ------------------------------------------------------------

INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (1, 'Switch', 'Switch');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (2, 'Router', 'Router');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (3, 'Firewall', 'Firewall');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (4, 'Hub', 'Hub');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (5, 'Wireless', 'Wireless');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (6, 'Database', 'Database');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (7, 'Workstation', 'Workstation');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (8, 'Laptop', 'Laptop');
INSERT INTO
  `deviceTypes` (`tid`, `tname`, `tdescription`)
VALUES
  (9, 'Other', 'Other');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: devices
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: firewallZoneMapping
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: firewallZoneSubnet
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: firewallZones
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: instructions
# ------------------------------------------------------------

INSERT INTO
  `instructions` (`id`, `instructions`)
VALUES
  (1, 'You can write instructions under admin menu!');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: ipTags
# ------------------------------------------------------------

INSERT INTO
  `ipTags` (
    `id`,
    `type`,
    `showtag`,
    `bgcolor`,
    `fgcolor`,
    `compress`,
    `locked`,
    `updateTag`
  )
VALUES
  (1, 'Offline', 1, '#f59c99', '#ffffff', 'No', 'Yes', 1);
INSERT INTO
  `ipTags` (
    `id`,
    `type`,
    `showtag`,
    `bgcolor`,
    `fgcolor`,
    `compress`,
    `locked`,
    `updateTag`
  )
VALUES
  (2, 'Used', 0, '#a9c9a4', '#ffffff', 'No', 'Yes', 1);
INSERT INTO
  `ipTags` (
    `id`,
    `type`,
    `showtag`,
    `bgcolor`,
    `fgcolor`,
    `compress`,
    `locked`,
    `updateTag`
  )
VALUES
  (3, 'Reserved', 1, '#9ac0cd', '#ffffff', 'No', 'Yes', 1);
INSERT INTO
  `ipTags` (
    `id`,
    `type`,
    `showtag`,
    `bgcolor`,
    `fgcolor`,
    `compress`,
    `locked`,
    `updateTag`
  )
VALUES
  (4, 'DHCP', 1, '#c9c9c9', '#ffffff', 'Yes', 'Yes', 1);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: ipaddresses
# ------------------------------------------------------------

INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    1,
    3,
    '168427779',
    0,
    'Server1',
    'server1.cust1.local',
    NULL,
    NULL,
    2,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    2,
    3,
    '168427780',
    0,
    'Server2',
    'server2.cust1.local',
    NULL,
    NULL,
    2,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    3,
    3,
    '168427781',
    0,
    'Server3',
    'server3.cust1.local',
    NULL,
    NULL,
    3,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    4,
    3,
    '168427782',
    0,
    'Server4',
    'server4.cust1.local',
    NULL,
    NULL,
    3,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    5,
    3,
    '168428021',
    0,
    'Gateway',
    NULL,
    NULL,
    NULL,
    2,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    6,
    4,
    '168428286',
    0,
    'Gateway',
    NULL,
    NULL,
    NULL,
    2,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    7,
    4,
    '168428042',
    0,
    'Server1',
    'ser1.client2.local',
    NULL,
    NULL,
    2,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    8,
    6,
    '172037636',
    0,
    'DHCP range',
    NULL,
    NULL,
    NULL,
    4,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    9,
    6,
    '172037637',
    0,
    'DHCP range',
    NULL,
    NULL,
    NULL,
    4,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `ipaddresses` (
    `id`,
    `subnetId`,
    `ip_addr`,
    `is_gateway`,
    `description`,
    `hostname`,
    `mac`,
    `owner`,
    `state`,
    `switch`,
    `location`,
    `port`,
    `note`,
    `lastSeen`,
    `excludePing`,
    `PTRignore`,
    `PTR`,
    `firewallAddressObject`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    10,
    6,
    '172037638',
    0,
    'DHCP range',
    NULL,
    NULL,
    NULL,
    4,
    NULL,
    NULL,
    NULL,
    NULL,
    '1970-01-01 00:00:01',
    0,
    0,
    0,
    NULL,
    NULL,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: lang
# ------------------------------------------------------------

INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (1, 'en_GB.UTF-8', 'English');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (2, 'sl_SI.UTF-8', 'Slovenščina');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (3, 'fr_FR.UTF-8', 'Français');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (4, 'nl_NL.UTF-8', 'Nederlands');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (5, 'de_DE.UTF-8', 'Deutsch');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (6, 'pt_BR.UTF-8', 'Brazil');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (7, 'es_ES.UTF-8', 'Español');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (8, 'cs_CZ.UTF-8', 'Czech');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (9, 'en_US.UTF-8', 'English (US)');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (10, 'ru_RU.UTF-8', 'Russian');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (11, 'zh_CN.UTF-8', 'Chinese');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (12, 'ja_JP.UTF-8', 'Japanese');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (13, 'zh_TW.UTF-8', 'Chinese traditional (繁體中文)');
INSERT INTO
  `lang` (`l_id`, `l_code`, `l_name`)
VALUES
  (14, 'it_IT.UTF-8', 'Italian');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: locations
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: loginAttempts
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: logs
# ------------------------------------------------------------

INSERT INTO
  `logs` (
    `id`,
    `severity`,
    `date`,
    `username`,
    `ipaddr`,
    `command`,
    `details`
  )
VALUES
  (
    1,
    1,
    '2022-10-18 11:05:23',
    NULL,
    '172.25.0.1',
    'Database installation',
    'Database installed successfully. Version 1.5.016 installed'
  );
INSERT INTO
  `logs` (
    `id`,
    `severity`,
    `date`,
    `username`,
    `ipaddr`,
    `command`,
    `details`
  )
VALUES
  (
    2,
    2,
    '2022-10-18 11:06:07',
    'root',
    '172.25.0.1',
    'User login',
    'Invalid username'
  );
INSERT INTO
  `logs` (
    `id`,
    `severity`,
    `date`,
    `username`,
    `ipaddr`,
    `command`,
    `details`
  )
VALUES
  (
    3,
    0,
    '2022-10-18 11:06:10',
    'admin',
    '172.25.0.1',
    'User login',
    'User phpIPAM Admin logged in'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: nameservers
# ------------------------------------------------------------

INSERT INTO
  `nameservers` (
    `id`,
    `name`,
    `namesrv1`,
    `description`,
    `permissions`,
    `editDate`
  )
VALUES
  (
    1,
    'Google NS',
    '8.8.8.8;8.8.4.4',
    'Google public nameservers',
    '1;2',
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: nat
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: nominatim
# ------------------------------------------------------------

INSERT INTO
  `nominatim` (`id`, `url`)
VALUES
  (1, 'https://nominatim.openstreetmap.org/search');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: nominatim_cache
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: php_sessions
# ------------------------------------------------------------

INSERT INTO
  `php_sessions` (`id`, `access`, `data`, `remote_ip`)
VALUES
  (
    '99755ca17be1504818a47765840fb7a3',
    1666091172,
    'ipamusername|s:5:\"Admin\";ipamlanguage|s:11:\"en_US.UTF-8\";lastactive|i:1666091172;csrf_cookie_user-menu|s:32:\"m0tVIFLSYUC3QTdFCpm330Hw4D5GrFot\";',
    '172.25.0.1'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: pstnNumbers
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: pstnPrefixes
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: rackContents
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: racks
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: requests
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routing_bgp
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: routing_subnets
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: scanAgents
# ------------------------------------------------------------

INSERT INTO
  `scanAgents` (
    `id`,
    `name`,
    `description`,
    `type`,
    `code`,
    `last_access`
  )
VALUES
  (
    1,
    'localhost',
    'Scanning from local machine',
    'direct',
    NULL,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: sections
# ------------------------------------------------------------

INSERT INTO
  `sections` (
    `id`,
    `name`,
    `description`,
    `masterSection`,
    `permissions`,
    `strictMode`,
    `subnetOrdering`,
    `order`,
    `editDate`,
    `showSubnet`,
    `showVLAN`,
    `showVRF`,
    `showSupernetOnly`,
    `DNS`
  )
VALUES
  (
    1,
    'Customers',
    'Section for customers',
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    X'31',
    NULL,
    NULL,
    NULL,
    1,
    0,
    0,
    0,
    NULL
  );
INSERT INTO
  `sections` (
    `id`,
    `name`,
    `description`,
    `masterSection`,
    `permissions`,
    `strictMode`,
    `subnetOrdering`,
    `order`,
    `editDate`,
    `showSubnet`,
    `showVLAN`,
    `showVRF`,
    `showSupernetOnly`,
    `DNS`
  )
VALUES
  (
    2,
    'IPv6',
    'Section for IPv6 addresses',
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    X'31',
    NULL,
    NULL,
    NULL,
    1,
    0,
    0,
    0,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: settings
# ------------------------------------------------------------

INSERT INTO
  `settings` (
    `id`,
    `siteTitle`,
    `siteAdminName`,
    `siteAdminMail`,
    `siteDomain`,
    `siteURL`,
    `siteLoginText`,
    `domainAuth`,
    `enableIPrequests`,
    `enableVRF`,
    `enableDNSresolving`,
    `enableFirewallZones`,
    `firewallZoneSettings`,
    `enablePowerDNS`,
    `powerDNS`,
    `enableDHCP`,
    `DHCP`,
    `enableMulticast`,
    `enableNAT`,
    `enableSNMP`,
    `enableThreshold`,
    `enableRACK`,
    `enableLocations`,
    `enablePSTN`,
    `enableChangelog`,
    `enableCustomers`,
    `enableVaults`,
    `link_field`,
    `version`,
    `dbversion`,
    `dbverified`,
    `donate`,
    `IPfilter`,
    `IPrequired`,
    `vlanDuplicate`,
    `vlanMax`,
    `subnetOrdering`,
    `visualLimit`,
    `theme`,
    `autoSuggestNetwork`,
    `pingStatus`,
    `defaultLang`,
    `editDate`,
    `vcheckDate`,
    `api`,
    `scanPingPath`,
    `scanFPingPath`,
    `scanPingType`,
    `scanMaxThreads`,
    `prettyLinks`,
    `hiddenCustomFields`,
    `inactivityTimeout`,
    `updateTags`,
    `enforceUnique`,
    `authmigrated`,
    `maintaneanceMode`,
    `decodeMAC`,
    `tempShare`,
    `tempAccess`,
    `log`,
    `subnetView`,
    `enableCircuits`,
    `enableRouting`,
    `permissionPropagate`,
    `passwordPolicy`,
    `2fa_provider`,
    `2fa_name`,
    `2fa_length`,
    `2fa_userchange`
  )
VALUES
  (
    1,
    'phpipam',
    'Sysadmin',
    'admin@domain.local',
    'domain.local',
    '',
    NULL,
    0,
    0,
    0,
    0,
    0,
    '{\"zoneLength\":3,\"ipType\":{\"0\":\"v4\",\"1\":\"v6\"},\"separator\":\"_\",\"indicator\":{\"0\":\"own\",\"1\":\"customer\"},\"zoneGenerator\":\"2\",\"zoneGeneratorType\":{\"0\":\"decimal\",\"1\":\"hex\",\"2\":\"text\"},\"deviceType\":\"3\",\"padding\":\"on\",\"strictMode\":\"on\",\"pattern\":{\"0\":\"patternFQDN\"}}',
    0,
    NULL,
    0,
    '{\"type\":\"kea\",\"settings\":{\"file\":\"/etc/kea/kea.conf\"}}',
    0,
    1,
    0,
    1,
    1,
    1,
    0,
    1,
    1,
    1,
    '0',
    '1.5',
    39,
    X'31',
    0,
    'mac;owner;state;switch;note;firewallAddressObject',
    NULL,
    1,
    4096,
    'subnet,asc',
    24,
    'dark',
    0,
    '1800;3600',
    NULL,
    '2022-10-18 11:06:12',
    '2022-10-18 11:06:12',
    X'30',
    '/bin/ping',
    '/bin/fping',
    'ping',
    128,
    'No',
    NULL,
    3600,
    0,
    1,
    0,
    0,
    1,
    0,
    NULL,
    'Database',
    0,
    1,
    0,
    1,
    '{\"minLength\":8,\"maxLength\":0,\"minNumbers\":0,\"minLetters\":0,\"minLowerCase\":0,\"minUpperCase\":0,\"minSymbols\":0,\"maxSymbols\":0,\"allowedSymbols\":\"#,_,-,!,[,],=,~\"}',
    'none',
    'phpipam',
    16,
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: settingsMail
# ------------------------------------------------------------

INSERT INTO
  `settingsMail` (
    `id`,
    `mtype`,
    `msecure`,
    `mauth`,
    `mserver`,
    `mport`,
    `muser`,
    `mpass`,
    `mAdminName`,
    `mAdminMail`
  )
VALUES
  (
    1,
    'localhost',
    'none',
    'no',
    NULL,
    25,
    NULL,
    NULL,
    NULL,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: subnets
# ------------------------------------------------------------

INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    1,
    '336395549904799703390415618052362076160',
    '64',
    2,
    'Private subnet 1',
    NULL,
    NULL,
    0,
    0,
    1,
    1,
    1,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    0,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    2,
    '168427520',
    '16',
    1,
    'Business customers',
    NULL,
    NULL,
    0,
    0,
    1,
    0,
    1,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    0,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    3,
    '168427776',
    '24',
    1,
    'Customer 1',
    NULL,
    NULL,
    0,
    2,
    1,
    0,
    1,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    0,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    4,
    '168428032',
    '24',
    1,
    'Customer 2',
    NULL,
    NULL,
    0,
    2,
    1,
    0,
    1,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    0,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    5,
    '0',
    '',
    1,
    'My folder',
    NULL,
    NULL,
    0,
    0,
    0,
    0,
    0,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    1,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT INTO
  `subnets` (
    `id`,
    `subnet`,
    `mask`,
    `sectionId`,
    `description`,
    `linked_subnet`,
    `firewallAddressObject`,
    `vrfId`,
    `masterSubnetId`,
    `allowRequests`,
    `vlanId`,
    `showName`,
    `device`,
    `permissions`,
    `pingSubnet`,
    `discoverSubnet`,
    `resolveDNS`,
    `DNSrecursive`,
    `DNSrecords`,
    `nameserverId`,
    `scanAgent`,
    `customer_id`,
    `isFolder`,
    `isFull`,
    `isPool`,
    `state`,
    `threshold`,
    `location`,
    `editDate`,
    `lastScan`,
    `lastDiscovery`
  )
VALUES
  (
    6,
    '172037632',
    '24',
    1,
    'DHCP range',
    NULL,
    NULL,
    0,
    5,
    0,
    0,
    1,
    0,
    '{\"3\":\"1\",\"2\":\"2\"}',
    0,
    0,
    0,
    0,
    0,
    0,
    NULL,
    NULL,
    0,
    0,
    0,
    2,
    0,
    NULL,
    NULL,
    NULL,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: userGroups
# ------------------------------------------------------------

INSERT INTO
  `userGroups` (`g_id`, `g_name`, `g_desc`, `editDate`)
VALUES
  (2, 'Operators', 'default Operator group', NULL);
INSERT INTO
  `userGroups` (`g_id`, `g_name`, `g_desc`, `editDate`)
VALUES
  (3, 'Guests', 'default Guest group (viewers)', NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: users
# ------------------------------------------------------------

INSERT INTO
  `users` (
    `id`,
    `username`,
    `authMethod`,
    `password`,
    `groups`,
    `role`,
    `real_name`,
    `email`,
    `domainUser`,
    `widgets`,
    `lang`,
    `favourite_subnets`,
    `disabled`,
    `mailNotify`,
    `mailChangelog`,
    `passChange`,
    `editDate`,
    `lastLogin`,
    `lastActivity`,
    `compressOverride`,
    `hideFreeRange`,
    `menuType`,
    `menuCompact`,
    `2fa`,
    `2fa_secret`,
    `theme`,
    `token`,
    `token_valid_until`,
    `module_permissions`,
    `compress_actions`
  )
VALUES
  (
    1,
    'Admin',
    1,
    '$6$rounds=3000$AJiwl3D9mfkrA1lh$payq.eE7xePJtS7vool2A4yWetR88q8nAUeMOH7tHWmPMMwJILqvXsB0ecYKmtvnn97mfQtgXDEsH00zQCPEJ/',
    '',
    'Administrator',
    'phpIPAM Admin',
    'admin@domain.local',
    X'30',
    'statistics;favourite_subnets;changelog;access_logs;error_logs;top10_hosts_v4',
    9,
    NULL,
    'No',
    'No',
    'No',
    'No',
    '2022-10-18 11:06:12',
    '2022-10-18 11:06:10',
    '2022-10-18 11:06:12',
    'default',
    0,
    'Dynamic',
    1,
    0,
    NULL,
    '',
    NULL,
    NULL,
    '{\"vlan\":\"1\",\"l2dom\":\"1\",\"vrf\":\"1\",\"pdns\":\"1\",\"circuits\":\"1\",\"racks\":\"1\",\"nat\":\"1\",\"pstn\":\"1\",\"customers\":\"1\",\"locations\":\"1\",\"devices\":\"1\",\"routing\":\"1\",\"vaults\":\"1\"}',
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: usersAuthMethod
# ------------------------------------------------------------

INSERT INTO
  `usersAuthMethod` (`id`, `type`, `params`, `protected`, `description`)
VALUES
  (1, 'local', NULL, 'Yes', 'Local database');
INSERT INTO
  `usersAuthMethod` (`id`, `type`, `params`, `protected`, `description`)
VALUES
  (2, 'http', NULL, 'Yes', 'Apache authentication');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vaultItems
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vaults
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vlanDomains
# ------------------------------------------------------------

INSERT INTO
  `vlanDomains` (`id`, `name`, `description`, `permissions`)
VALUES
  (1, 'default', 'default L2 domain', NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vlans
# ------------------------------------------------------------

INSERT INTO
  `vlans` (
    `vlanId`,
    `domainId`,
    `name`,
    `number`,
    `description`,
    `editDate`,
    `customer_id`
  )
VALUES
  (
    1,
    1,
    'IPv6 private 1',
    2001,
    'IPv6 private 1 subnets',
    NULL,
    NULL
  );
INSERT INTO
  `vlans` (
    `vlanId`,
    `domainId`,
    `name`,
    `number`,
    `description`,
    `editDate`,
    `customer_id`
  )
VALUES
  (2, 1, 'Servers DMZ', 4001, 'DMZ public', NULL, NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: vrf
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: widgets
# ------------------------------------------------------------

INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    1,
    'Statistics',
    'Shows some statistics on number of hosts, subnets',
    'statistics',
    NULL,
    'no',
    '4',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    2,
    'Favourite subnets',
    'Shows 5 favourite subnets',
    'favourite_subnets',
    NULL,
    'yes',
    '8',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    3,
    'Top 10 IPv4 subnets by number of hosts',
    'Shows graph of top 10 IPv4 subnets by number of hosts',
    'top10_hosts_v4',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    4,
    'Top 10 IPv6 subnets by number of hosts',
    'Shows graph of top 10 IPv6 subnets by number of hosts',
    'top10_hosts_v6',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    5,
    'Top 10 IPv4 subnets by usage percentage',
    'Shows graph of top 10 IPv4 subnets by usage percentage',
    'top10_percentage',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    6,
    'Last 5 change log entries',
    'Shows last 5 change log entries',
    'changelog',
    NULL,
    'yes',
    '12',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    7,
    'Active IP addresses requests',
    'Shows list of active IP address request',
    'requests',
    NULL,
    'yes',
    '6',
    'yes',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    8,
    'Last 5 informational logs',
    'Shows list of last 5 informational logs',
    'access_logs',
    NULL,
    'yes',
    '6',
    'yes',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    9,
    'Last 5 warning / error logs',
    'Shows list of last 5 warning and error logs',
    'error_logs',
    NULL,
    'yes',
    '6',
    'yes',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    10,
    'Tools menu',
    'Shows quick access to tools menu',
    'tools',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    11,
    'IP Calculator',
    'Shows IP calculator as widget',
    'ipcalc',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    12,
    'IP Request',
    'IP Request widget',
    'iprequest',
    NULL,
    'no',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    13,
    'Threshold',
    'Shows threshold usage for top 5 subnets',
    'threshold',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    14,
    'Inactive hosts',
    'Shows list of inactive hosts for defined period',
    'inactive-hosts',
    '86400',
    'yes',
    '6',
    'yes',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    15,
    'Locations',
    'Shows map of locations',
    'locations',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    16,
    'Bandwidth calculator',
    'Calculate bandwidth',
    'bw_calculator',
    NULL,
    'no',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    17,
    'Customers',
    'Shows customer list',
    'customers',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    18,
    'User Instructions',
    'Shows user instructions',
    'instructions',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );
INSERT INTO
  `widgets` (
    `wid`,
    `wtitle`,
    `wdescription`,
    `wfile`,
    `wparams`,
    `whref`,
    `wsize`,
    `wadminonly`,
    `wactive`
  )
VALUES
  (
    19,
    'MAC lookup',
    'Shows MAC address vendor',
    'mac-lookup',
    NULL,
    'yes',
    '6',
    'no',
    'yes'
  );

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
