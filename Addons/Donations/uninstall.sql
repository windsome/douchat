DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='donations_list' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='donations_list' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_donations_list`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='donations_money' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='donations_money' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_donations_money`;