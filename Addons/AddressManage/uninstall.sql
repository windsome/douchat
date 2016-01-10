DELETE FROM `dc_attribute` WHERE model_id = (SELECT id FROM dc_model WHERE `name`='address' ORDER BY id DESC LIMIT 1);
DELETE FROM `dc_model` WHERE `name`='address' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `dc_address`;