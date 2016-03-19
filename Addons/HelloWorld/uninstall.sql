DELETE FROM `dc_attribute` WHERE model_id = (SELECT id FROM dc_model WHERE `name`='wxdevice_devices' ORDER BY id DESC LIMIT 1);
DELETE FROM `dc_model` WHERE `name`='wxdevice_devices' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `dc_wxdevice_devices`;DELETE FROM `dc_attribute` WHERE model_id = (SELECT id FROM dc_model WHERE `name`='wxdevice_products' ORDER BY id DESC LIMIT 1);
DELETE FROM `dc_model` WHERE `name`='wxdevice_products' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `dc_wxdevice_products`;