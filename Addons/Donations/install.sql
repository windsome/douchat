CREATE TABLE IF NOT EXISTS `wp_donations_list` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`content`  text NULL  COMMENT '捐赠者留言',
`money`  float(10) NULL  COMMENT '捐赠金额',
`email`  varchar(255) NULL  COMMENT '捐赠者邮箱',
`nickname`  varchar(255) NULL  COMMENT '捐赠者昵称',
`ctime`  int(10) NULL  COMMENT '捐赠时间',
`openid`  varchar(255) NULL  COMMENT '捐赠者openid',
`token`  varchar(255) NULL  COMMENT '公众号token',
`is_anonymous`  int(10) NULL  DEFAULT 0 COMMENT '是否匿名',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `dc_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`,`addon`) VALUES ('donations_list','捐赠列表','0','','1','["nickname","email","money","content"]','1:基础','','','','','nickname:捐赠者姓名\r\nmoney:捐赠金额\r\nemail:捐赠者邮箱\r\ncontent:捐赠者留言\r\nctime|time_format:捐赠时间\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除','10','nickname','','1446094856','1446095155','1','MyISAM','');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('content','捐赠者留言','text NULL','textarea','','','1','','0','0','1','1446095026','1446095026','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('money','捐赠金额','float(10) NULL','num','','','1','','0','0','1','1446094995','1446094995','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('email','捐赠者邮箱','varchar(255) NULL','string','','','1','','0','0','1','1446094966','1446094966','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('nickname','捐赠者昵称','varchar(255) NULL','string','','','1','','0','0','1','1446094946','1446094946','','3','','regex','','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('ctime','捐赠时间','int(10) NULL','datetime','','','0','','0','0','1','1446094933','1446094933','','3','','regex','time','1','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('openid','捐赠者openid','varchar(255) NULL','string','','','0','','0','0','1','1446094904','1446094904','','3','','regex','get_openid','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','公众号token','varchar(255) NULL','string','','','0','','0','0','1','1446094880','1446094880','','3','','regex','get_token','3','function');
INSERT INTO `dc_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('is_anonymous','是否匿名','int(10) NULL','select','0','','1','0:否\r\n1:是','0','0','1','1452044843','1452044832','','3','','regex','','3','function');
UPDATE `dc_attribute` SET model_id= (SELECT MAX(id) FROM `dc_model`) WHERE model_id=0;

CREATE TABLE IF NOT EXISTS `wp_donations_money` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`desc`  text NULL  COMMENT '描述',
`money`  int(10) NULL  COMMENT '金额',
`token`  varchar(255) NULL  COMMENT '公众号token',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `wp_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`) VALUES ('donations_money','捐赠说明','0','','1','["money","desc"]','1:基础','','','','','money:金额\r\ndesc:回报\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除','10','money','','1446094664','1446094831','1','MyISAM');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('desc','描述','text NULL','textarea','','','1','','0','0','1','1446094736','1446094736','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('money','金额','int(10) NULL','num','','','1','','0','0','1','1446094722','1446094722','','3','','regex','','3','function');
INSERT INTO `wp_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','公众号token','varchar(255) NULL','string','','','0','','0','0','1','1446094688','1446094688','','3','','regex','get_token','3','function');
UPDATE `wp_attribute` SET model_id= (SELECT MAX(id) FROM `wp_model`) WHERE model_id=0;