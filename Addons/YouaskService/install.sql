CREATE TABLE IF NOT EXISTS `wp_youaskservice_group` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`token`  varchar(255) NULL  COMMENT 'token',
`groupname`  varchar(255) NULL  COMMENT '分组名称',
`groupdata`  text NULL  COMMENT '分组数据源',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `wp_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('youaskservice_group','你问我答-客服分组','0','','1','["groupname"]','1:基础','','','','','id:编号\r\ngroupname:分组名称\r\ntoken:操作:[EDIT]|编辑,[DELETE]|删除','20','groupname','','1404475456','1404491410','1','MyISAM','YouaskService');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','token','varchar(255) NULL','string','','','0','','0','0','1','1404485505','1404475530','','3','','regex','get_token','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('groupname','分组名称','varchar(255) NULL','string','','','1','','0','0','1','1404475556','1404475556','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('groupdata','分组数据源','text NULL','textarea','','','0','','0','0','1','1404476127','1404476127','','3','','regex','','3','function');
UPDATE `wp_attribute` SET model_id= (SELECT MAX(id) FROM `wp_model`) WHERE model_id=0;


CREATE TABLE IF NOT EXISTS `wp_youaskservice_keyword` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`msgkeyword`  varchar(555) NULL  COMMENT '消息关键字',
`msgkeyword_type`  char(50) NULL  DEFAULT 3 COMMENT '关键字类型',
`msgkfaccount`  varchar(255) NULL  COMMENT '接待的客服人员',
`cTime`  int(10) NULL  COMMENT '创建时间',
`token`  varchar(255) NULL  COMMENT 'token',
`msgstate`  tinyint(2) NULL  DEFAULT 1 COMMENT '关键字状态',
`zjnum`  int(10) NULL  COMMENT '转接次数',
`zdtype`  char(10) NULL  DEFAULT 0 COMMENT '指定类型',
`kfgroupid`  int(10) NULL  DEFAULT 0 COMMENT '客服分组id',
`kf_explain`  varchar(255) NULL  COMMENT '客服说明',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `wp_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('youaskservice_keyword','你问我答-关键词指配','0','','1','["msgkeyword","msgkeyword_type","zdtype","msgstate"]','1:基础','','','','','id:编号\r\nmsgkeyword:关键字\r\nkf_explain:客服说明\r\nmsgkeyword_type|get_name_by_status:匹配类型\r\nmsgkfaccount:指定的接待客服或分组\r\nmsgstate|get_name_by_status:状态\r\nzdtype:操作:[EDIT]|编辑,[DELETE]|删除','20','msgkeyword','','1404399143','1450018481','1','MyISAM','YouaskService');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('msgkeyword','消息关键字','varchar(555) NULL','string','','当用户发送的消息中含有关键字时,将自动转到分配的客服人员','1','','0','0','1','1404399336','1404399336','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('msgkeyword_type','关键字类型','char(50) NULL','select','3','选择关键字匹配的类型','1','0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配\r\n4:正则匹配\r\n5:随机匹配','0','0','1','1404399466','1404399466','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('msgkfaccount','接待的客服人员','varchar(255) NULL','string','','','0','','0','0','1','1404403340','1404399587','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('cTime','创建时间','int(10) NULL','date','','','0','','0','0','1','1404399629','1404399629','','3','','regex','time','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','token','varchar(255) NULL','string','','','0','','0','0','1','1404399656','1404399656','','3','','regex','get_token','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('msgstate','关键字状态','tinyint(2) NULL','bool','1','停用后用户将不会触发此关键词','1','0:停用\r\n1:启用','0','0','1','1404399749','1404399749','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('zjnum','转接次数','int(10) NULL','num','','','0','','0','0','1','1404399784','1404399784','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('zdtype','指定类型','char(10) NULL','radio','0','选择关键字匹配时是按指定人员或者指定客服组','1','0:指定客服人员\r\n1:指定客服组','0','0','1','1404474672','1404474672','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('kfgroupid','客服分组id','int(10) NULL','num','0','','0','','0','0','1','1404474777','1404474777','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('kf_explain','客服说明','varchar(255) NULL','string','','客服说明','1','','0','0','1','1450018523','1450018523','','3','','regex','','3','function');
UPDATE `wp_attribute` SET model_id= (SELECT MAX(id) FROM `wp_model`) WHERE model_id=0;


CREATE TABLE IF NOT EXISTS `wp_youaskservice_user` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`name`  varchar(60) NULL   COMMENT '客服昵称',
`token`  varchar(60) NULL   COMMENT 'token',
`userName`  varchar(60) NULL   COMMENT '客服帐号',
`userPwd`  varchar(32) NULL   COMMENT '客服密码',
`endJoinDate`  int(11) NULL   COMMENT '客服加入时间',
`status`  tinyint(1) NULL   DEFAULT 0 COMMENT '客服在线状态',
`state`  tinyint(2) NULL  DEFAULT 0 COMMENT '客服状态',
`isdelete`  tinyint(2) NULL  DEFAULT 0 COMMENT '是否删除',
`kfid`  varchar(255) NULL  COMMENT '客服编号',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `wp_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('youaskservice_user','你问我答-客服工号','0','','1','["name","userName","userPwd","state","kfid"]','1:基础','','','','','kfid:客服编号\r\nname:客服昵称\r\nuserName:客服帐号\r\ntoken:操作:[EDIT]|编辑,[DELETE]|删除','20','name','userName','1403947253','1450018368','1','MyISAM','YouaskService');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('name','客服昵称','varchar(60) NULL ','string','','','1','','0','0','1','1403959775','1403947255','','0','','regex','','0','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','token','varchar(60) NULL ','string','','','0','','0','0','1','1403959638','1403947256','','3','','regex','get_token','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('userName','客服帐号','varchar(60) NULL ','string','','','1','','0','0','1','1403959752','1403947256','','3','','regex','','0','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('userPwd','客服密码','varchar(32) NULL ','string','','','1','','0','0','1','1403959722','1403947257','','0','','regex','','0','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('endJoinDate','客服加入时间','int(11) NULL ','string','','','0','','0','0','1','1403959825','1403947257','','3','','regex','time','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('status','客服在线状态','tinyint(1) NULL ','bool','0','','0','0:离线\r\n1:在线','0','0','1','1404016782','1403947258','','0','','regex','','0','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('state','客服状态','tinyint(2) NULL','bool','0','','1','0:停用\r\n1:启用','0','0','1','1404016877','1404016877','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('isdelete','是否删除','tinyint(2) NULL','bool','0','','0','0:正常\r\n1:已被删除','0','0','1','1404016931','1404016931','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('kfid','客服编号','varchar(255) NULL','string','','','1','','0','0','1','1404398387','1404398387','','3','','regex','','3','function');
UPDATE `wp_attribute` SET model_id= (SELECT MAX(id) FROM `wp_model`) WHERE model_id=0;