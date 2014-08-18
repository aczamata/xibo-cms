
ALTER TABLE  `module` ADD  `render_as` VARCHAR( 10 ) NULL;
ALTER TABLE  `module` ADD  `settings` TEXT NULL;

UPDATE `resolution` SET enabled = 0;

ALTER TABLE  `resolution` ADD  `version` TINYINT NOT NULL DEFAULT  '1';
ALTER TABLE  `resolution` ADD  `enabled` TINYINT NOT NULL DEFAULT  '1';
ALTER TABLE  `resolution` CHANGE  `resolution`  `resolution` VARCHAR( 254 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

INSERT INTO `resolution` (`resolutionID`, `resolution`, `width`, `height`, `intended_width`, `intended_height`, `version`, `enabled`) VALUES
(9, '1080p HD Landscape', 800, 450, 1920, 1080, 2, 1),
(10, '720p HD Landscape', 800, 450, 1280, 720, 2, 1),
(11, '1080p HD Portrait', 450, 800, 1080, 1920, 2, 1),
(12, '720p HD Portrait', 450, 800, 720, 1280, 2, 1),
(13, '4k', 800, 450, 4096, 2304, 2, 1),
(14, 'Common PC Monitor 4:3', 800, 600, 1024, 768, 2, 1);

DELETE FROM `lktemplategroup` WHERE TemplateID IN (SELECT TemplateID FROM `template` WHERE isSystem = 1);
DELETE FROM `template` WHERE isSystem = 1;

ALTER TABLE `template` DROP `isSystem`;

ALTER TABLE  `display` ADD  `displayprofileid` INT NULL;

INSERT INTO `pages` (`name`, `pagegroupID`)
SELECT 'displayprofile', pagegroupID FROM `pagegroup` WHERE pagegroup.pagegroup = 'Displays';

INSERT INTO `menuitem` (MenuID, PageID, Args, Text, Class, Img, Sequence, External)
SELECT 7, PageID, NULL, 'Display Settings', NULL, NULL, 4, 0
  FROM `pages`
 WHERE name = 'displayprofile';

CREATE TABLE IF NOT EXISTS `displayprofile` (
  `displayprofileid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` varchar(15) NOT NULL,
  `config` text NOT NULL,
  `isdefault` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`displayprofileid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

UPDATE layout SET background = SUBSTRING_INDEX(background, '.', 1) WHERE IFNULL(background, '') <> '';
ALTER TABLE  `layout` CHANGE  `background`  `backgroundImageId` INT( 11 ) NULL DEFAULT NULL;

INSERT INTO `lklayoutmedia` (mediaid, layoutid, regionid)
SELECT backgroundimageid, layoutid, 'background' FROM `layout` WHERE IFNULL(backgroundImageId, 0) <> 0;

ALTER TABLE  `setting` CHANGE  `type`  `fieldType` VARCHAR( 24 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

ALTER TABLE  `setting` ADD  `title` VARCHAR( 254 ) NOT NULL ,
ADD  `type` VARCHAR( 50 ) NOT NULL,
ADD  `validation` VARCHAR( 50 ) NOT NULL ,
ADD  `ordering` INT NOT NULL,
ADD  `default` VARCHAR( 1000 ) NOT NULL,
ADD  `userSee` TINYINT NOT NULL DEFAULT  '1';

UPDATE `setting` SET type = fieldType;

DELETE FROM `setting` WHERE setting IN ('BASE_URL', 'adminMessage', 'ppt_width', 'ppt_height');

UPDATE `setting` SET cat = 'configuration', ordering = 10, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'LIBRARY_LOCATION';
UPDATE `setting` SET cat = 'configuration', ordering = 20, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'SERVER_KEY';
UPDATE `setting` SET cat = 'configuration', ordering = 30, usersee = '1', userchange = '1', `default` = 'default' WHERE setting = 'GLOBAL_THEME_NAME';
UPDATE `setting` SET cat = 'content', ordering = 10, usersee = '1', userchange = '1', `default` = '10' WHERE setting = 'ppt_length';
UPDATE `setting` SET cat = 'content', ordering = 20, usersee = '1', userchange = '1', `default` = '10' WHERE setting = 'swf_length';
UPDATE `setting` SET cat = 'content', ordering = 30, usersee = '1', userchange = '1', `default` = '10' WHERE setting = 'jpg_length';
UPDATE `setting` SET cat = 'defaults', ordering = 10, usersee = '1', userchange = '1', `default` = 'Unchecked' WHERE setting = 'LIBRARY_MEDIA_UPDATEINALL_CHECKB';
UPDATE `setting` SET cat = 'defaults', ordering = 20, usersee = '1', userchange = '1', `default` = 'Unchecked' WHERE setting = 'LAYOUT_COPY_MEDIA_CHECKB';
UPDATE `setting` SET cat = 'defaults', ordering = 30, usersee = '0', userchange = '0', `default` = 'Unchecked' WHERE setting = 'MODULE_CONFIG_LOCKED_CHECKB';
UPDATE `setting` SET cat = 'defaults', ordering = 40, usersee = '1', userchange = '0', `default` = 'Unchecked' WHERE setting = 'TRANSITION_CONFIG_LOCKED_CHECKB';
UPDATE `setting` SET cat = 'displays', ordering = 10, usersee = '1', userchange = '1', `default` = '51.504' WHERE setting = 'DEFAULT_LAT';
UPDATE `setting` SET cat = 'displays', ordering = 20, usersee = '1', userchange = '1', `default` = '-0.104' WHERE setting = 'DEFAULT_LONG';
UPDATE `setting` SET cat = 'displays', ordering = 30, usersee = '1', userchange = '1', `default` = '0' WHERE setting = 'SHOW_DISPLAY_AS_VNCLINK';
UPDATE `setting` SET cat = 'displays', ordering = 40, usersee = '1', userchange = '1', `default` = '_top' WHERE setting = 'SHOW_DISPLAY_AS_VNC_TGT';
UPDATE `setting` SET cat = 'displays', ordering = 50, usersee = '0', userchange = '0', `default` = '0' WHERE setting = 'MAX_LICENSED_DISPLAYS';
UPDATE `setting` SET cat = 'general', ordering = 10, usersee = '1', userchange = '1', `default` = 'On' WHERE setting = 'PHONE_HOME';
UPDATE `setting` SET cat = 'general', ordering = 20, usersee = '0', userchange = '0', `default` = '' WHERE setting = 'PHONE_HOME_KEY';
UPDATE `setting` SET cat = 'general', ordering = 30, usersee = '0', userchange = '0', `default` = '0' WHERE setting = 'PHONE_HOME_DATE';
UPDATE `setting` SET cat = 'general', ordering = 40, usersee = '1', userchange = '0', `default` = 'On' WHERE setting = 'SCHEDULE_LOOKAHEAD';
UPDATE `setting` SET cat = 'general', ordering = 50, usersee = '1', userchange = '1', `default` = '172800' WHERE setting = 'REQUIRED_FILES_LOOKAHEAD';
UPDATE `setting` SET cat = 'general', ordering = 60, usersee = '1', userchange = '1', `default` = 'Off' WHERE setting = 'SENDFILE_MODE';
UPDATE `setting` SET cat = 'general', ordering = 70, usersee = '1', userchange = '0', `default` = '' WHERE setting = 'EMBEDDED_STATUS_WIDGET';
UPDATE `setting` SET cat = 'general', ordering = 80, usersee = '1', userchange = '1', `default` = '1' WHERE setting = 'SETTING_IMPORT_ENABLED';
UPDATE `setting` SET cat = 'general', ordering = 90, usersee = '1', userchange = '1', `default` = '1' WHERE setting = 'SETTING_LIBRARY_TIDY_ENABLED';
UPDATE `setting` SET cat = 'general', ordering = 10, usersee = '1', userchange = '1', `default` = 'http://www.xibo.org.uk/manual/' WHERE setting = 'HELP_BASE';
UPDATE `setting` SET cat = 'maintenance', ordering = 10, usersee = '1', userchange = '1', `default` = 'Off' WHERE setting = 'MAINTENANCE_ENABLED';
UPDATE `setting` SET cat = 'maintenance', ordering = 20, usersee = '1', userchange = '1', `default` = 'On' WHERE setting = 'MAINTENANCE_EMAIL_ALERTS';
UPDATE `setting` SET cat = 'maintenance', ordering = 30, usersee = '1', userchange = '1', `default` = 'mail@yoursite.com' WHERE setting = 'mail_to';
UPDATE `setting` SET cat = 'maintenance', ordering = 40, usersee = '1', userchange = '1', `default` = 'mail@yoursite.com' WHERE setting = 'mail_from';
UPDATE `setting` SET cat = 'maintenance', ordering = 50, usersee = '1', userchange = '1', `default` = 'changeme' WHERE setting = 'MAINTENANCE_KEY';
UPDATE `setting` SET cat = 'maintenance', ordering = 60, usersee = '1', userchange = '1', `default` = '30' WHERE setting = 'MAINTENANCE_LOG_MAXAGE';
UPDATE `setting` SET cat = 'maintenance', ordering = 70, usersee = '1', userchange = '1', `default` = '30' WHERE setting = 'MAINTENANCE_STAT_MAXAGE';
UPDATE `setting` SET cat = 'maintenance', ordering = 80, usersee = '1', userchange = '1', `default` = '12' WHERE setting = 'MAINTENANCE_ALERT_TOUT';
UPDATE `setting` SET cat = 'maintenance', ordering = 80, usersee = '1', userchange = '1', `default` = 'Off' WHERE setting = 'MAINTENANCE_ALWAYS_ALERT';
UPDATE `setting` SET cat = 'network', ordering = 10, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'PROXY_HOST';
UPDATE `setting` SET cat = 'network', ordering = 20, usersee = '1', userchange = '1', `default` = '0' WHERE setting = 'PROXY_PORT';
UPDATE `setting` SET cat = 'network', ordering = 30, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'PROXY_AUTH';
UPDATE `setting` SET cat = 'network', ordering = 40, usersee = '1', userchange = '0', `default` = '0' WHERE setting = 'MONTHLY_XMDS_TRANSFER_LIMIT_KB';
UPDATE `setting` SET cat = 'network', ordering = 50, usersee = '1', userchange = '0', `default` = '0' WHERE setting = 'LIBRARY_SIZE_LIMIT_KB';
UPDATE `setting` SET cat = 'network', ordering = 60, usersee = '0', userchange = '0', `default` = 'http://www.xibo.org.uk/stats/track.php' WHERE setting = 'PHONE_HOME_URL';
UPDATE `setting` SET cat = 'permissions', ordering = 10, usersee = '1', userchange = '1', `default` = 'private' WHERE setting = 'LAYOUT_DEFAULT';
UPDATE `setting` SET cat = 'permissions', ordering = 20, usersee = '1', userchange = '1', `default` = 'private' WHERE setting = 'MEDIA_DEFAULT';
UPDATE `setting` SET cat = 'permissions', ordering = 30, usersee = '1', userchange = '1', `default` = 'Media Colouring' WHERE setting = 'REGION_OPTIONS_COLOURING';
UPDATE `setting` SET cat = 'permissions', ordering = 40, usersee = '1', userchange = '1', `default` = 'No' WHERE setting = 'SCHEDULE_WITH_VIEW_PERMISSION';
UPDATE `setting` SET cat = 'regional', ordering = 10, usersee = '1', userchange = '1', `default` = 'en_GB' WHERE setting = 'DEFAULT_LANGUAGE';
UPDATE `setting` SET cat = 'regional', ordering = 20, usersee = '1', userchange = '1', `default` = 'Europe/London' WHERE setting = 'defaultTimezone';
UPDATE `setting` SET cat = 'troubleshooting', ordering = 10, usersee = '1', userchange = '1', `default` = 'Off' WHERE setting = 'debug';
UPDATE `setting` SET cat = 'troubleshooting', ordering = 20, usersee = '1', userchange = '1', `default` = 'Off' WHERE setting = 'audit';
UPDATE `setting` SET cat = 'troubleshooting', ordering = 30, usersee = '1', userchange = '1', `default` = 'Production' WHERE setting = 'SERVER_MODE';
UPDATE `setting` SET cat = 'users', ordering = 0, usersee = '0', userchange = '0', `default` = 'module_user_general.php' WHERE setting = 'userModule';
UPDATE `setting` SET cat = 'users', ordering = 10, usersee = '1', userchange = '1', `default` = 'User' WHERE setting = 'defaultUsertype';
UPDATE `setting` SET cat = 'users', ordering = 20, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'USER_PASSWORD_POLICY';
UPDATE `setting` SET cat = 'users', ordering = 30, usersee = '1', userchange = '1', `default` = '' WHERE setting = 'USER_PASSWORD_ERROR';

ALTER TABLE  `schedule` ADD  `DisplayOrder` INT NOT NULL DEFAULT  '0';

UPDATE `schedule` SET DisplayOrder = (SELECT MAX(DisplayOrder) FROM `schedule_detail` WHERE schedule_detail.eventid = schedule.eventid);

ALTER TABLE  `schedule_detail` DROP FOREIGN KEY  `schedule_detail_ibfk_9` ;
ALTER TABLE `schedule_detail` DROP `CampaignID`;
ALTER TABLE `schedule_detail` DROP `is_priority`;
ALTER TABLE `schedule_detail` DROP `DisplayOrder`;

ALTER TABLE  `user` ADD  `newUserWizard` TINYINT NOT NULL DEFAULT  '0';

UPDATE `version` SET `app_ver` = '1.7.0-alpha', `XmdsVersion` = 4;
UPDATE `setting` SET `value` = 0 WHERE `setting` = 'PHONE_HOME_DATE';
UPDATE `version` SET `DBVersion` = '80';
