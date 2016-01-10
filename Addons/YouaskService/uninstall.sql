DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_group' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_group' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_group`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_keyword' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_keyword' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_keyword`;



DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_user' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_user' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_user`;




