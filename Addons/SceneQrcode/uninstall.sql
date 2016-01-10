DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='scene_qrcode' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='scene_qrcode' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_scene_qrcode`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='scene_qrcode_statistics' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='scene_qrcode_statistics' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_scene_qrcode_statistics`;