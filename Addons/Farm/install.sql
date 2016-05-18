CREATE TABLE IF NOT EXISTS `dc_wxdevice_devices` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`productid`  int(10) NULL  COMMENT '设备编号',
`deviceid`  varchar(255) NULL  COMMENT '设备ID',
`uuid`  varchar(255) NOT NULL  COMMENT '设备UID',
`qrcode`  varchar(255) NULL  COMMENT '设备二维码',
`mac`  varchar(255) NULL  COMMENT '设备MAC地址',
`openid`  varchar(255) NULL  COMMENT '关联用户',
`info`  varchar(255) NULL  COMMENT '描述',
`swver`  varchar(255) NULL  COMMENT '软件版本',
`hwver`  varchar(255) NULL  COMMENT '硬件版本号',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('wxdevice_devices','微信设备','0','','1','["deviceid","uuid","qrcode","mac","openid","info","swver","hwver"]','1:基础','','','','','deviceid:设备ID\r\nqrcode|get_code_img:设备二维码\r\nuuid:设备UID\r\nmac:MAC地址\r\nswver:软件版本\r\nhwver:硬件版本','10','','','1458372178','1463570208','1','InnoDB','HelloWorld');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('productid','设备编号','int(10) NULL','num','','','0','','0','1','1','1458372237','1458372237','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('deviceid','设备ID','varchar(255) NULL','string','','','1','','0','1','1','1458372264','1458372264','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('uuid','设备UID','varchar(255) NOT NULL','string','','','1','','0','0','1','1458704713','1458372289','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('qrcode','设备二维码','varchar(255) NULL','string','','','1','','0','0','1','1458372324','1458372324','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('mac','设备MAC地址','varchar(255) NULL','string','','','1','','0','0','1','1458372341','1458372341','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('openid','关联用户','varchar(255) NULL','string','','所关联用户的openid','1','','0','0','1','1458804545','1458803904','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('info','描述','varchar(255) NULL','string','','','1','各种信息描述，是一个json结构，包含经度，纬度，坐标系名称，用户openid等等','0','0','1','1458805037','1458804452','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('swver','软件版本','varchar(255) NULL','string','','终端设备软件版本号，升级中用户判断是否升级成功','1','','0','0','1','1463568476','1463567758','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('hwver','硬件版本号','varchar(255) NULL','string','','了解硬件的版本','1','','0','0','1','1463568491','1463567848','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;
CREATE TABLE IF NOT EXISTS `dc_wxdevice_products` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`token`  varchar(255) NULL  COMMENT '公众号原始ID',
`productid`  int(10) NULL  COMMENT '产品编号',
`product_name`  varchar(255) NULL  COMMENT '设备名称',
`product_model`  varchar(255) NULL  COMMENT '设备型号',
`qrimage_id`  int(10) UNSIGNED NULL  COMMENT '型号二维码',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('wxdevice_products','微信硬件产品','0','','1','["product_name","product_model","qrimage_id","productid"]','1:基础','','','','','productid:设备编号\r\nproduct_name:设备名称\r\nproduct_model:设备型号\r\nqrimage_id:型号二维码\r\nproduct_number:设备数量\r\nproduct_bind:已绑定\r\nproduct_online:在线\r\nids:操作:add_device&pid=[productid]|授权,list_device&pid=[productid]|查看,[EDIT]&productid=[productid]|编辑,[DELETE]|删除','10','','','1458371649','1458372053','1','InnoDB','HelloWorld');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','公众号原始ID','varchar(255) NULL','string','','','0','','0','1','1','1458371780','1458371780','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('productid','产品编号','int(10) NULL','num','','','1','','0','1','1','1458371837','1458371837','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('product_name','设备名称','varchar(255) NULL','string','','','1','','0','0','1','1458371886','1458371886','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('product_model','设备型号','varchar(255) NULL','string','','','1','','0','0','1','1458371921','1458371921','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('qrimage_id','型号二维码','int(10) UNSIGNED NULL','picture','','','1','','0','0','1','1458371969','1458371969','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;
CREATE TABLE IF NOT EXISTS `dc_wxdevice_cmd` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`deviceid`  varchar(255) NULL  COMMENT '设备id',
`cmd`  varchar(255) NULL  COMMENT '设备命令',
`cTime`  int(10) NULL  COMMENT '创建时间',
`pTime`  int(10) NULL  COMMENT '处理时间',
`manager_id`  int(10) NULL  COMMENT '管理员',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('wxdevice_cmd','微信硬件命令表','0','','1','["deviceid","cmd","cTime","pTime","manager_id"]','1:基础','','','','','deviceid:设备id\r\ncmd:命令内容\r\ncTime:发送时间\r\npTime:处理时间\r\nmanager_id:管理员\r\n','10','','','1463300800','1463301326','1','InnoDB','HelloWorld');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('deviceid','设备id','varchar(255) NULL','string','','','1','','0','1','1','1463300845','1463300845','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('cmd','设备命令','varchar(255) NULL','string','','设备命令，json格式，支持同时多个命令，包括update, interval, url, uuid','1','','0','0','1','1463300957','1463300957','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('cTime','创建时间','int(10) NULL','datetime','','命令创建时间，多个命令以最后一个为准','1','','0','1','1','1463301022','1463301022','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('pTime','处理时间','int(10) NULL','datetime','','命令被终端取走的时间，默认为空，如果不为空说明已经被取走','1','','0','0','1','1463301136','1463301136','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('manager_id','管理员','int(10) NULL','num','','发命令的管理员id','1','','0','0','1','1463301235','1463301235','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;
CREATE TABLE IF NOT EXISTS `dc_wxdevice_firmware` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`filepath`  varchar(255) NULL  COMMENT '文件路径',
`manager_id`  int(10) NULL  COMMENT '上传用户',
`cTime`  int(10) NULL  COMMENT '上传时间',
`desc`  varchar(255) NULL  COMMENT '固件名称',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_wxdevice_firmware` (`id`,`filepath`,`manager_id`,`cTime`,`desc`) VALUES ('9','Firmware/2016-05-17/1463461755_200094557.bin','0','1463461754','armstrong.bin');
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('wxdevice_firmware','微信硬件固件','0','','1','["filepath","cTime","desc","manager_id"]','1:基础','','','','','desc:固件名称\r\nfilepath:文件路径\r\ncTime:上传时间\r\nmanager_id:上传用户\r\n','10','','','1463210237','1463210832','1','InnoDB','HelloWorld');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('filepath','文件路径','varchar(255) NULL','string','','文件服务器端路径','1','','0','1','1','1463210316','1463210316','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('manager_id','上传用户','int(10) NULL','num','','上传该固件的用户','1','','0','1','1','1463210413','1463210413','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('cTime','上传时间','int(10) NULL','datetime','','','1','','0','1','1','1463210482','1463210482','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('desc','固件名称','varchar(255) NULL','string','','包含版本号等信息的一个文件名称，默认使用上传的文件名','1','','0','1','1','1463210568','1463210568','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;
CREATE TABLE IF NOT EXISTS `dc_wxdevice_datax` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`deviceid`  varchar(255) NULL  COMMENT '设备UUID',
`subid`  varchar(255) NULL  COMMENT '内部传感器序号',
`type`  varchar(255) NULL  COMMENT '传感器类型',
`val`  DOUBLE PRECISION(10,4) NULL  DEFAULT 0 COMMENT '传感器值',
`time`  int(13) NULL  COMMENT '数据时间',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('wxdevice_datax','传感器数据','0','','1','["deviceid","subid","type","val","time"]','1:基础','','','','','deviceid:设备id\r\nsubid:传感器id\r\ntype:设备类型\r\nval:值\r\ntime:时间','10','deviceid','','1460618623','1460621800','1','InnoDB','HelloWorld');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('deviceid','设备UUID','varchar(255) NULL','string','','设备UUID','1','','0','1','1','1460618889','1460618889','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('subid','内部传感器序号','varchar(255) NULL','string','','内部或外接传感器序号，内部的在出产时即确定序号和类型，外部的由用户设置类型，并与某个设备关联','1','','0','1','1','1460620477','1460620477','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('type','传感器类型','varchar(255) NULL','string','','传感器类型，温度temp，湿度humi，光照lm，二氧化碳co2','1','','0','0','1','1460620555','1460620555','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('val','传感器值','DOUBLE PRECISION(10,4) NULL','num','0','传感器值，为double值','1','','0','1','1','1460621259','1460621259','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('time','数据时间','int(13) NULL','datetime','','上传数据的时间','1','','0','1','1','1460625353','1460621397','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;
