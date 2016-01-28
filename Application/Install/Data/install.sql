-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2016 年 01 月 21 日 03:36
-- 服务器版本: 5.5.20
-- PHP 版本: 5.3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `douchat`
--

-- --------------------------------------------------------

--
-- 表的结构 `dc_action`
--

CREATE TABLE IF NOT EXISTS `dc_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '行为唯一标识',
  `title` char(80) NOT NULL DEFAULT '' COMMENT '行为说明',
  `remark` char(140) NOT NULL DEFAULT '' COMMENT '行为描述',
  `rule` text COMMENT '行为规则',
  `log` text COMMENT '日志规则',
  `type` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '类型',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='系统行为表' AUTO_INCREMENT=13 ;

--
-- 转存表中的数据 `dc_action`
--

INSERT INTO `dc_action` (`id`, `name`, `title`, `remark`, `rule`, `log`, `type`, `status`, `update_time`) VALUES
(1, 'user_login', '用户登录', '积分+10，每天一次', 'table:member|field:score|condition:uid={$self} AND status>-1|rule:score+10|cycle:24|max:1;', '[user|get_nickname]在[time|time_format]登录了管理中心', 1, 0, 1393685660),
(2, 'add_article', '发布文章', '积分+5，每天上限5次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:5', '', 2, 0, 1380173180),
(3, 'review', '评论', '评论积分+1，无限制', 'table:member|field:score|condition:uid={$self}|rule:score+1', '', 2, 0, 1383285646),
(4, 'add_document', '发表文档', '积分+10，每天上限5次', 'table:member|field:score|condition:uid={$self}|rule:score+10|cycle:24|max:5', '[user|get_nickname]在[time|time_format]发表了一篇文章。\r\n表[model]，记录编号[record]。', 2, 0, 1386139726),
(5, 'add_document_topic', '发表讨论', '积分+5，每天上限10次', 'table:member|field:score|condition:uid={$self}|rule:score+5|cycle:24|max:10', '', 2, 0, 1383285551),
(6, 'update_config', '更新配置', '新增或修改或删除配置', '', '', 1, 1, 1383294988),
(7, 'update_model', '更新模型', '新增或修改模型', '', '', 1, 1, 1383295057),
(8, 'update_attribute', '更新属性', '新增或更新或删除属性', '', '', 1, 1, 1383295963),
(9, 'update_channel', '更新导航', '新增或修改或删除导航', '', '', 1, 1, 1383296301),
(10, 'update_menu', '更新菜单', '新增或修改或删除菜单', '', '', 1, 1, 1383296392),
(11, 'update_category', '更新分类', '新增或修改或删除分类', '', '', 1, 1, 1383296765),
(12, 'admin_login', '登录后台', '管理员登录后台', '', '[user|get_nickname]在[time|time_format]登录了后台', 2, 1, 1393685618);

-- --------------------------------------------------------

--
-- 表的结构 `dc_action_log`
--

CREATE TABLE IF NOT EXISTS `dc_action_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行为id',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行用户id',
  `action_ip` bigint(20) NOT NULL COMMENT '执行行为者ip',
  `model` varchar(50) NOT NULL DEFAULT '' COMMENT '触发行为的表',
  `record_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '触发行为的数据id',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '日志备注',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '执行行为的时间',
  PRIMARY KEY (`id`),
  KEY `action_ip_ix` (`action_ip`),
  KEY `action_id_ix` (`action_id`),
  KEY `user_id_ix` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='行为日志表' AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `dc_action_log`
--

INSERT INTO `dc_action_log` (`id`, `action_id`, `user_id`, `action_ip`, `model`, `record_id`, `remark`, `status`, `create_time`) VALUES
(1, 12, 1, 0, 'user', 1, 'admin在2015-12-18 22:54登录了后台', 1, 1450450499),
(2, 12, 1, 0, 'user', 1, 'admin在2016-01-10 17:11登录了后台', 1, 1452417078),
(3, 8, 1, 0, 'attribute', 12362, '操作url：/douchat_beta/index.php?s=/Admin/Attribute/update.html', 1, 1452417198),
(4, 12, 1, 0, 'user', 1, 'Array在2016-01-11 09:53登录了后台', 1, 1452477231);

-- --------------------------------------------------------

--
-- 表的结构 `dc_addons`
--

CREATE TABLE IF NOT EXISTS `dc_addons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(40) NOT NULL COMMENT '插件名或标识',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '中文名',
  `description` text COMMENT '插件描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `config` text COMMENT '配置',
  `author` varchar(40) DEFAULT '' COMMENT '作者',
  `version` varchar(20) DEFAULT '' COMMENT '版本号',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '安装时间',
  `has_adminlist` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否有后台列表',
  `type` tinyint(1) DEFAULT '0' COMMENT '插件类型 0 普通插件 1 微信插件 2 易信插件',
  `cate_id` int(11) DEFAULT NULL,
  `is_show` tinyint(2) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `sti` (`status`,`is_show`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='微信插件表' AUTO_INCREMENT=219 ;

--
-- 转存表中的数据 `dc_addons`
--

INSERT INTO `dc_addons` (`id`, `name`, `title`, `description`, `status`, `config`, `author`, `version`, `create_time`, `has_adminlist`, `type`, `cate_id`, `is_show`) VALUES
(198, 'WeiSite', '微官网', '微3G网站、支持分类管理，文章管理、底部导航管理、微信引导信息配置，微网站统计代码部署。同时支持首页多模板切换、信息列表多模板切换、信息详情模板切换、底部导航多模板切换。并配置有详细的模板二次开发教程', 1, '{"title":"\\u70b9\\u51fb\\u8fdb\\u5165\\u9996\\u9875","cover":"","info":"","background":"","code":"","template_index":"ColorV1","template_footer":"V1","template_lists":"V1","template_detail":"V1"}', '艾逗笔', '1.0', 1450450573, 0, 0, 3, 1),
(199, 'AutoReply', '自动回复', '实现配置关键词，用户回复此关键词后自动回复对应的文件，图文，图片信息', 1, 'null', '艾逗笔', '1.0', 1450450576, 1, 0, 1, 1),
(218, 'CustomMenu', '自定义菜单', '自定义菜单能够帮助公众号丰富界面，让用户更好更快地理解公众号的功能', 1, 'null', '艾逗笔', '1.0', 1453347048, 1, 0, 1, 1),
(201, 'YouaskService', '多客服', '一个支持指定客服，未识别回复，智能聊天(图灵机器人)的微信客服系统', 1, '{"state":"0","zrg":"\\u4eba\\u5de5\\u5ba2\\u670d","kfbz":"\\u60a8\\u597d\\uff0c\\u5ba2\\u670d\\u5de5\\u4f5c\\u65f6\\u95f4\\uff1a\\u5468\\u4e00\\u81f3\\u5468\\u4e948:00-17:00","zdkfbz":"\\u60a8\\u597d\\uff0c\\u60a8\\u6307\\u5b9a\\u7684\\u5ba2\\u670d\\u6682\\u65f6\\u4e0d\\u5728\\u7ebf\\uff0c\\u8bf7\\u9009\\u62e9\\u5176\\u4ed6\\u5ba2\\u670d,\\u67e5\\u8be2\\u5728\\u7ebf\\u5ba2\\u670d\\u5217\\u8868\\uff0c\\u8bf7\\u56de\\u590d\\u201c\\u67e5\\u8be2\\u5728\\u7ebf\\u5ba2\\u670d\\u201d","model":"1","model2":"2","model3":"0","tcrg":"\\u9000\\u51fa\\u4eba\\u5de5\\u5ba2\\u670d","type":"1","title":"","description":"\\u60a8\\u597d\\uff0c\\u4eba\\u5de5\\u5ba2\\u670d\\u5df2\\u5173\\u95ed\\uff01\\u8bf7\\u9009\\u62e9\\u5176\\u4ed6\\u65b9\\u5f0f\\u8ddf\\u6211\\u4eec\\u8054\\u7cfb\\uff01","pic_url":"","url":"","type2":"1","title2":"","description2":"\\u60a8\\u597d\\uff0c\\u4eba\\u5de5\\u5ba2\\u670d\\u5df2\\u5f00\\u542f\\uff0c\\u6709\\u4ec0\\u4e48\\u95ee\\u9898\\u53ef\\u8f6c\\u4eba\\u5de5\\u5ba2\\u670d\\u3002\\u8f93\\u5165\\u76f8\\u5173\\u7684\\u5173\\u952e\\u8bcd\\u6307\\u5b9a\\u76f8\\u5173\\u5ba2\\u670d\\uff01","pic_url2":"","url2":"","cxkey":"\\u67e5\\u8be2\\u5728\\u7ebf\\u5ba2\\u670d","type3":"1","title3":"\\u5728\\u7ebf\\u5ba2\\u670d\\u5217\\u8868","pic_url3":"","description_head":"\\u5ba2\\u670d\\u5217\\u8868\\u9876\\u90e8\\u5185\\u5bb9\\u533a","description_foot":"\\u5ba2\\u670d\\u5217\\u8868\\u5e95\\u90e8\\u5185\\u5bb9\\u533a","tuling_key":"d812d695a5e0df258df952698faca6cc","tuling_url":"http:\\/\\/www.tuling123.com\\/openapi\\/api"}', '梦醒', '0.1', 1451825104, 1, 0, 2, 1),
(202, 'Tmplmsg', '模板消息', '通用的模板消息发送插件', 1, 'null', '艾逗笔', '1.0', 1451825112, 1, 0, 2, 1),
(204, 'SceneQrcode', '场景二维码', '设置不同的场景生成对应的二维码，用于营销推广、用户绑定、数据统计等场景。', 1, 'null', '艾逗笔', '1.0', 1451825121, 1, 0, 2, 1),
(205, 'UserCenter', '微信用户中心', '实现3G首页、微信登录，微信用户绑定，微信用户信息初始化等基本功能', 1, '{"score":"100","experience":"100","need_bind":"0","bind_start":"0","jumpurl":""}', '凡星', '0.1', 1451825125, 1, 0, NULL, 1),
(206, 'Shop', '微商城', '支持后台发布商品 banner管理 前端多模板选择 订单管理等', 1, 'null', '艾逗笔', '1.0', 1451825141, 1, 0, 5, 1),
(207, 'Example', '功能演示', '对豆信框架的功能进行演示', 1, '{"random":"1"}', '艾逗笔', '1.0', 1451825144, 0, 0, 4, 1),
(208, 'Donations', '微捐赠', '在线捐赠功能，用户可以在微信端捐赠', 1, '{"title":"\\u6350\\u8d60\\u6211\\u4eec","cover":"","desc":"\\u60a8\\u7684\\u652f\\u6301\\uff0c\\u662f\\u6211\\u4eec\\u524d\\u8fdb\\u7684\\u52a8\\u529b"}', '洛杉矶豪哥', '1.0', 1451825173, 0, 0, 4, 1),
(209, 'Extensions', '融合第三方', '第三方功能扩展', 1, 'null', '凡星', '0.1', 1451825178, 1, 0, 4, 1),
(210, 'Forms', '通用表单', '管理员可以轻松地增加一个表单用于收集用户的信息，如活动报名、调查反馈、预约填单等', 1, 'null', '凡星', '0.1', 1451825181, 1, 0, 4, 1),
(211, 'Dg', '在线点歌', '使用百度音乐api实现微信端在线点歌功能', 1, '{"keyword":"\\u70b9\\u6b4c"}', '艾逗笔', '1.0', 1451825183, 0, 0, 4, 1),
(212, 'Suggestions', '意见反馈', '用户在微信里输入“意见反馈”四个字时，返回一个图文信息，引导用户进入填写建议意见的3G页面，用户填写信息提交后显示感谢之意并提示关闭页面返回微信\r\n管理员可以在管理中心里看到用户反馈的内容列表，并对内容进行编辑，删除操作', 1, '{"title":"\\u610f\\u89c1\\u53cd\\u9988","cover":"","desc":"\\u70b9\\u6b64\\u8fdb\\u5165","need_nickname":"1","need_mobile":"1","admin_id":""}', '艾逗笔', '1.0', 1451825186, 0, 0, 4, 1),
(213, 'Leaflets', '微信宣传页', '微信公众号二维码推广页面，用作推广或者制作广告易拉宝，可以发布到QQ群微博博客论坛等等...', 1, '{"title":"\\u8c46\\u4fe1\\u5b98\\u65b9\\u5fae\\u4fe1\\u516c\\u4f17\\u53f7","img":"","info":"\\u8c46\\u4fe1\\u662f\\u4e00\\u4e2a\\u4f18\\u96c5\\u7684\\u5fae\\u4fe1\\u516c\\u4f17\\u53f7\\u5f00\\u53d1\\u6846\\u67b6\\uff0c\\u4ea7\\u54c1\\u7406\\u5ff5\\u662f\\u201c\\u9ad8\\u5ea6\\u5c01\\u88c5\\u3001\\u7075\\u6d3b\\u8c03\\u7528\\u201d","copyright":"\\u00a92015 \\u8c46\\u4fe1\\u7248\\u6743\\u6240\\u6709"}', '凡星', '1.0', 1451825189, 0, 0, 4, 1),
(214, 'AddressManage', '地址管理', '通用地址管理插件', 1, 'null', '艾逗笔', '1.0', 1452417210, 1, 0, 2, 1),
(215, 'Payment', '支付通', '微信支付,财富通,支付宝', 1, '{"isopen":"1","isopenload":"1","isopenwx":"1"}', '拉帮姐派(陌路生人)', '0.1', 1452417237, 1, 0, 2, 1),
(216, 'Idioms', '成语接龙', 'weiphp成语接龙插件，当用户在微信中回复“成语接龙”时开始成语接龙游戏', 1, 'null', '艾逗笔', '1.0', 1452417267, 0, 0, 4, 1),
(217, 'Tuling', '图灵机器人', '使用图灵机器人接口实现微信端智能聊天，支持语音识别', 1, '{"tuling_key":"d812d695a5e0df258df952698faca6cc","tuling_url":"http:\\/\\/www.tuling123.com\\/openapi\\/api","rand_reply":"\\r\\n\\u6211\\u4eca\\u5929\\u7d2f\\u4e86\\uff0c\\u660e\\u5929\\u518d\\u966a\\u4f60\\u804a\\u5929\\u5427\\r\\n\\u54c8\\u54c8~~\\r\\n\\u4f60\\u8bdd\\u597d\\u591a\\u554a\\uff0c\\u4e0d\\u8ddf\\u4f60\\u804a\\u4e86\\r\\n\\u867d\\u7136\\u4e0d\\u61c2\\uff0c\\u4f46\\u89c9\\u5f97\\u4f60\\u8bf4\\u5f97\\u5f88\\u5bf9"}', '艾逗笔', '2.0', 1452477316, 0, 0, 4, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_addon_category`
--

CREATE TABLE IF NOT EXISTS `dc_addon_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '分类图标',
  `title` varchar(255) DEFAULT NULL COMMENT '分类名',
  `sort` int(10) DEFAULT '0' COMMENT '排序号',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='插件分类表' AUTO_INCREMENT=10 ;

--
-- 转存表中的数据 `dc_addon_category`
--

INSERT INTO `dc_addon_category` (`id`, `icon`, `title`, `sort`) VALUES
(1, 0, '基础功能', 1),
(2, 0, '通用功能', 2),
(3, 0, '高级功能', 3),
(4, 0, '扩展功能', 4),
(5, 0, '解决方案', 5);

-- --------------------------------------------------------

--
-- 表的结构 `dc_address`
--

CREATE TABLE IF NOT EXISTS `dc_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(255) NOT NULL COMMENT '公众号token',
  `openid` varchar(255) NOT NULL COMMENT '微信用户id',
  `name` varchar(255) NOT NULL COMMENT '姓名',
  `sex` int(10) NOT NULL COMMENT '性别',
  `mobile` varchar(255) NOT NULL COMMENT '手机号',
  `address` varchar(255) NOT NULL COMMENT '详细地址',
  `country` varchar(255) NOT NULL COMMENT '国家',
  `province` varchar(255) NOT NULL COMMENT '省份',
  `city` varchar(255) NOT NULL COMMENT '城市',
  `area` varchar(255) NOT NULL COMMENT '地区',
  `is_default` int(10) NOT NULL DEFAULT '0' COMMENT '是否默认',
  `postcode` varchar(255) DEFAULT NULL COMMENT '邮政编码',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_analysis`
--

CREATE TABLE IF NOT EXISTS `dc_analysis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sports_id` int(10) DEFAULT NULL COMMENT 'sports_id',
  `type` varchar(30) DEFAULT NULL COMMENT 'type',
  `time` varchar(50) DEFAULT NULL COMMENT 'time',
  `total_count` int(10) DEFAULT '0' COMMENT 'total_count',
  `follow_count` int(10) DEFAULT '0' COMMENT 'follow_count',
  `aver_count` int(10) DEFAULT '0' COMMENT 'aver_count',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_article_style`
--

CREATE TABLE IF NOT EXISTS `dc_article_style` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` int(10) DEFAULT '0' COMMENT '分组样式',
  `style` text COMMENT '样式内容',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- 转存表中的数据 `dc_article_style`
--

INSERT INTO `dc_article_style` (`id`, `group_id`, `style`) VALUES
(1, 1, '<section style="border: 0px none; padding: 0px; box-sizing: border-box; margin: 0px; font-family: 微软雅黑;"><section class="main" style="border: none rgb(0,187,236); margin: 0.8em 5% 0.3em; box-sizing: border-box; padding: 0px;"><section class="main2 wxqq-color wxqq-bordertopcolor wxqq-borderleftcolor wxqq-borderrightcolor wxqq-borderbottomcolor" data-brushtype="text" style="color: rgb(0,187,236); font-size: 20px; letter-spacing: 3px; padding: 9px 4px 14px; text-align: center; margin: 0px auto; border: 4px solid rgb(0,187,236); border-top-left-radius: 8px; border-top-right-radius: 8px; border-bottom-right-radius: 8px; border-bottom-left-radius: 8px; box-sizing: border-box;">理念<span class="main3 wxqq-color" data-brushtype="text" style="display: block; font-size: 10px; line-height: 12px; border-color: rgb(0,187,236); color: inherit; box-sizing: border-box; padding: 0px; margin: 0px;">PHILOSOPHY</span></section><section class="main4 wxqq-bordertopcolor wxqq-borderbottomcolor" style="width: 0px; margin-right: auto; margin-left: auto; border-top-width: 0.6em; border-top-style: solid; border-bottom-color: rgb(0,187,236); border-top-color: rgb(0,187,236); height: 10px; color: inherit; border-left-width: 0.7em !important; border-left-style: solid !important; border-left-color: transparent !important; border-right-width: 0.7em !important; border-right-style: solid !important; border-right-color: transparent !important; box-sizing: border-box; padding: 0px;" data-width="0px"></section></section></section>'),
(2, 3, '<section label="Copyright © 2015 playhudong All Rights Reserved." style="\r\nmargin:1em auto;\r\npadding: 1em 2em;\r\nborder-style: none;" id="shifu_c_001"><span style="\r\nfloat: left;\r\nmargin-left: 19px;\r\nmargin-top: -9px;\r\noverflow: hidden;\r\ndisplay:block;"><img style="\r\nvertical-align: top;\r\ndisplay:inline-block;" src="http://1251001145.cdn.myqcloud.com/1251001145/style/images/card-3.gif"><section class="color" style="\r\nmin-height: 30px;\r\ncolor: #fff;\r\ndisplay: inline-block;\r\ntext-align: center;\r\nbackground: #999999;\r\nfont-size: 15px;\r\npadding: 7px 5px;\r\nmin-width: 30px;"><span style="font-size:15px;"> 01 </span></section></span><section style="\r\npadding: 16px;\r\npadding-top: 28px;\r\nborder: 2px solid #999999;\r\nwidth: 100%;\r\nfont-size: 14px;\r\nline-height: 1.4;"><span>星期一天气晴我离开你／不带任何行李／除了一本陪我放逐的日记／今天天晴／心情很低／突然决定离开你</span></section></section>'),
(3, 1, '<section><section class="wxqq-borderleftcolor wxqq-borderRightcolor wxqq-bordertopcolor wxqq-borderbottomcolor" style="border:5px solid #A50003;padding:5px;width:100%;"><section class="wxqq-borderleftcolor wxqq-borderRightcolor wxqq-bordertopcolor wxqq-borderbottomcolor" style="border:1px solid #A50003;padding:15px 20px;"><p style="color:#A50003;text-align:center;border-bottom:1px solid #A50003"><span class="wxqq-color" data-brushtype="text" style="font-size:48px">情人节快乐</span></p><section data-style="color:#A50003;text-align:center;font-size:18px" style="color:#A50003;text-align:center;width:96%;margin-left:5px;"><p class="wxqq-color" style="color:#A50003;text-align:center;font-size:18px">happy valentine''s day<span style="color:inherit; font-size:24px; line-height:1.6em; text-align:right; text-indent:2em"></span><span style="color:rgb(227, 108, 9); font-size:24px; line-height:1.6em; text-align:right; text-indent:2em"></span></p><section style="width:100%;"><section><section><p style="color:#000;text-align:left;">我们没有秘密，整天花前月下，别人以为我们不懂爱情，我们乐呵呵地笑大人们都太傻。</p></section></section></section></section></section></section></section>'),
(4, 4, '<p><img src="http://www.wxbj.cn//ys/gz/gx2.gif"></p>'),
(5, 5, '<section class="tn-Powered-by-XIUMI" style="margin-top: 0.5em; margin-bottom: 0.5em; border: none rgb(142, 201, 101); font-size: 14px; font-family: inherit; font-weight: inherit; text-decoration: inherit; color: rgb(142, 201, 101);"><img data-src="http://mmbiz.qpic.cn/mmbiz/4HiaqFGEibVwaxcmNMU5abRHm7bkZ9icUxC3DrlItWpOnXSjEpZXIeIr2K0923xw43aKw8oibucqm8wkMYZvmibqDkg/0?wx_fmt=png" class="tn-Powered-by-XIUMI" data-type="png" data-ratio="0.8055555555555556" data-w="36" _width="2.6em" src="https://mmbiz.qlogo.cn/mmbiz/4HiaqFGEibVwaxcmNMU5abRHm7bkZ9icUxC3DrlItWpOnXSjEpZXIeIr2K0923xw43aKw8oibucqm8wkMYZvmibqDkg/640?wx_fmt=png" style="float: right; width: 2.6em !important; visibility: visible !important; background-color: rgb(142, 201, 101);"><section class="tn-Powered-by-XIUMI" style="clear: both;"></section><section class="tn-Powered-by-XIUMI" style="padding-right: 10px; padding-left: 10px; text-align: center;"><section class="tn-Powered-by-XIUMI" style="text-align: left;">炎热的夏季，应该吃点什么好呢！我们为您打造7月盛夏美食狂欢季，清暑解渴的热带水果之王【芒果下午茶】，海鲜盛宴上的【生蚝狂欢】，肉食者的天堂【澳洲之夜】，呼朋唤友，户外聚餐的最佳攻略【夏季BBQ】，消暑瘦身利器【迷你冬瓜盅】，清淡亦或重口味，总有一款是你所爱！</section></section><img data-src="http://mmbiz.qpic.cn/mmbiz/4HiaqFGEibVwaxcmNMU5abRHm7bkZ9icUxCkEmrfLmAXYYOXO0q4RGYsQqfzhO6SOdoFCTqYqwlS87ovGrQjCYmWw/0?wx_fmt=png" class="tn-Powered-by-XIUMI" data-type="png" data-ratio="0.8055555555555556" data-w="36" _width="2.6em" src="https://mmbiz.qlogo.cn/mmbiz/4HiaqFGEibVwaxcmNMU5abRHm7bkZ9icUxCkEmrfLmAXYYOXO0q4RGYsQqfzhO6SOdoFCTqYqwlS87ovGrQjCYmWw/640?wx_fmt=png" style="width: 2.6em !important; visibility: visible !important; background-color: rgb(142, 201, 101);"><p><br></p></section>'),
(8, 6, '<blockquote class="wxqq-borderTopColor wxqq-borderRightColor wxqq-borderBottomColor wxqq-borderLeftColor" style="border: 3px dotted rgb(230, 37, 191); padding: 10px; margin: 10px 0px; font-weight: normal; border-top-left-radius: 5px !important; border-top-right-radius: 5px !important; border-bottom-right-radius: 5px !important; border-bottom-left-radius: 5px !important;"><h3 style="color:rgb(89,89,89);font-size:14px;margin:0;"><span class="wxqq-bg" style="background-color: rgb(230, 37, 191); color: rgb(255, 255, 255); padding: 2px 5px; font-size: 14px; margin-right: 15px; border-top-left-radius: 5px !important; border-top-right-radius: 5px !important; border-bottom-right-radius: 5px !important; border-bottom-left-radius: 5px !important;">微信编辑器</span>微信号：<span class="wxqq-bg" style="background-color: rgb(230, 37, 191); color: rgb(255, 255, 255); padding: 2px 5px; font-size: 14px; border-top-left-radius: 5px !important; border-top-right-radius: 5px !important; border-bottom-right-radius: 5px !important; border-bottom-left-radius: 5px !important;">wxbj.cn</span></h3><p style="margin:10px 0 5px 0;">微信公众号简介，欢迎使用微信在线图文排版编辑器助手！</p></blockquote>'),
(9, 8, '<p><img src="http://www.wxbj.cn/ys/gz/yw1.gif"></p>'),
(7, 7, '<p><img src="https://mmbiz.qlogo.cn/mmbiz/cZV2hRpuAPhuxibIOsThcH7HF1lpQ0Yvkvh88U3ia9AbTPJSmriawnJ7W7S5iblSlSianbHLGO6IvD0N4g2y2JEFRoA/0/mmbizgif"></p>');

-- --------------------------------------------------------

--
-- 表的结构 `dc_article_style_group`
--

CREATE TABLE IF NOT EXISTS `dc_article_style_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_name` varchar(255) DEFAULT NULL COMMENT '分组名称',
  `desc` text COMMENT '说明',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- 转存表中的数据 `dc_article_style_group`
--

INSERT INTO `dc_article_style_group` (`id`, `group_name`, `desc`) VALUES
(1, '标题', '标题样式'),
(3, '卡片', '类卡片样式'),
(4, '关注', '引导关注公众号的样式'),
(5, '内容', '内容样式'),
(6, '互推', '互推公众号的样式'),
(7, '分割', '分割样式'),
(8, '原文引导', '原文引导样式');

-- --------------------------------------------------------

--
-- 表的结构 `dc_attachment`
--

CREATE TABLE IF NOT EXISTS `dc_attachment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) DEFAULT '0' COMMENT '用户ID',
  `title` char(30) NOT NULL DEFAULT '' COMMENT '附件显示名',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '附件类型',
  `source` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '资源ID',
  `record_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联记录ID',
  `download` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下载次数',
  `size` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '附件大小',
  `dir` int(12) unsigned NOT NULL DEFAULT '0' COMMENT '上级目录ID',
  `sort` int(8) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_record_status` (`record_id`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='附件表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_attribute`
--

CREATE TABLE IF NOT EXISTS `dc_attribute` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '字段名',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '字段注释',
  `field` varchar(100) NOT NULL DEFAULT '' COMMENT '字段定义',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '数据类型',
  `value` varchar(100) NOT NULL DEFAULT '' COMMENT '字段默认值',
  `remark` varchar(100) NOT NULL DEFAULT '' COMMENT '备注',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否显示',
  `extra` text NOT NULL COMMENT '参数',
  `model_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模型id',
  `is_must` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否必填',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `validate_rule` varchar(255) NOT NULL DEFAULT '',
  `validate_time` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `error_info` varchar(100) NOT NULL DEFAULT '',
  `validate_type` varchar(25) NOT NULL DEFAULT '',
  `auto_rule` varchar(100) NOT NULL DEFAULT '',
  `auto_time` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `auto_type` varchar(25) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `model_id` (`model_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='模型属性表' AUTO_INCREMENT=12430 ;

--
-- 转存表中的数据 `dc_attribute`
--

INSERT INTO `dc_attribute` (`id`, `name`, `title`, `field`, `type`, `value`, `remark`, `is_show`, `extra`, `model_id`, `is_must`, `status`, `update_time`, `create_time`, `validate_rule`, `validate_time`, `error_info`, `validate_type`, `auto_rule`, `auto_time`, `auto_type`) VALUES
(5, 'nickname', '用户名', 'text NULL', 'string', '', '', 0, '', 1, 1, 1, 1447302832, 1436929161, '', 3, '', 'regex', '', 3, 'function'),
(6, 'password', '登录密码', 'varchar(100) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302859, 1436929210, '', 3, '', 'regex', '', 3, 'function'),
(7, 'truename', '真实姓名', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302886, 1436929252, '', 3, '', 'regex', '', 3, 'function'),
(8, 'mobile', '联系电话', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302825, 1436929280, '', 3, '', 'regex', '', 3, 'function'),
(9, 'email', '邮箱地址', 'varchar(100) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302817, 1436929305, '', 3, '', 'regex', '', 3, 'function'),
(10, 'sex', '性别', 'tinyint(2) NULL', 'radio', '', '', 0, '0:保密\r\n1:男\r\n2:女', 1, 0, 1, 1447302800, 1436929397, '', 3, '', 'regex', '', 3, 'function'),
(11, 'headimgurl', '头像地址', 'varchar(255) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302811, 1436929482, '', 3, '', 'regex', '', 3, 'function'),
(12, 'city', '城市', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302793, 1436929506, '', 3, '', 'regex', '', 3, 'function'),
(13, 'province', '省份', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302787, 1436929524, '', 3, '', 'regex', '', 3, 'function'),
(14, 'country', '国家', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302781, 1436929541, '', 3, '', 'regex', '', 3, 'function'),
(15, 'language', '语言', 'varchar(20) NULL', 'string', 'zh-cn', '', 0, '', 1, 0, 1, 1447302725, 1436929571, '', 3, '', 'regex', '', 3, 'function'),
(16, 'score', '金币值', 'int(10) NULL', 'num', '0', '', 0, '', 1, 0, 1, 1447302731, 1436929597, '', 3, '', 'regex', '', 3, 'function'),
(17, 'experience', '经验值', 'int(10) NULL', 'num', '0', '', 0, '', 1, 0, 1, 1447302738, 1436929619, '', 3, '', 'regex', '', 3, 'function'),
(18, 'unionid', '微信第三方ID', 'varchar(50) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302717, 1436929681, '', 3, '', 'regex', '', 3, 'function'),
(19, 'login_count', '登录次数', 'int(10) NULL', 'num', '0', '', 0, '', 1, 0, 1, 1447302710, 1436930011, '', 3, '', 'regex', '', 3, 'function'),
(20, 'reg_ip', '注册IP', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302746, 1436930035, '', 3, '', 'regex', '', 3, 'function'),
(21, 'reg_time', '注册时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1, 0, 1, 1447302754, 1436930051, '', 3, '', 'regex', '', 3, 'function'),
(22, 'last_login_ip', '最近登录IP', 'varchar(30) NULL', 'string', '', '', 0, '', 1, 0, 1, 1447302761, 1436930072, '', 3, '', 'regex', '', 3, 'function'),
(23, 'last_login_time', '最近登录时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1, 0, 1, 1447302770, 1436930087, '', 3, '', 'regex', '', 3, 'function'),
(24, 'status', '状态', 'tinyint(2) NULL', 'bool', '1', '', 0, '0:禁用\r\n1:启用', 1, 0, 1, 1447302703, 1436930138, '', 3, '', 'regex', '', 3, 'function'),
(25, 'is_init', '初始化状态', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:未初始化\r\n1:已初始化', 1, 0, 1, 1447302696, 1436930184, '', 3, '', 'regex', '', 3, 'function'),
(26, 'is_audit', '审核状态', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:未审核\r\n1:已审核', 1, 0, 1, 1447302688, 1436930216, '', 3, '', 'regex', '', 3, 'function'),
(27, 'subscribe_time', '用户关注公众号时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1, 0, 1, 1437720655, 1437720655, '', 3, '', 'regex', '', 3, 'function'),
(28, 'remark', '微信用户备注', 'varchar(100) NULL', 'string', '', '', 0, '', 1, 0, 1, 1437720686, 1437720686, '', 3, '', 'regex', '', 3, 'function'),
(29, 'groupid', '微信端的分组ID', 'int(10) NULL', 'num', '', '', 0, '', 1, 0, 1, 1437720714, 1437720714, '', 3, '', 'regex', '', 3, 'function'),
(4, 'come_from', '来源', 'tinyint(1) NULL', 'select', '0', '', 0, '0:PC注册用户\r\n1:微信同步用户\r\n2:手机注册用户', 1, 0, 1, 1447302852, 1438331357, '', 3, '', 'regex', '', 3, 'function'),
(31, 'uid', '用户ID', 'int(10) NULL', 'num', '', '', 1, '', 2, 1, 1, 1436932588, 1436932588, '', 3, '', 'regex', '', 3, 'function'),
(32, 'has_public', '是否配置公众号', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:否\r\n1:是', 2, 0, 1, 1436933464, 1436933464, '', 3, '', 'regex', '', 3, 'function'),
(33, 'headface_url', '管理员头像', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 2, 0, 1, 1436933503, 1436933503, '', 3, '', 'regex', '', 3, 'function'),
(34, 'GammaAppId', '摇电视的AppId', 'varchar(30) NULL', 'string', '', '', 1, '', 2, 0, 1, 1436933562, 1436933562, '', 3, '', 'regex', '', 3, 'function'),
(35, 'GammaSecret', '摇电视的Secret', 'varchar(100) NULL', 'string', '', '', 1, '', 2, 0, 1, 1436933602, 1436933602, '', 3, '', 'regex', '', 3, 'function'),
(36, 'copy_right', '授权信息', 'varchar(255) NULL', 'string', '', '', 1, '', 2, 0, 1, 1436933690, 1436933690, '', 3, '', 'regex', '', 3, 'function'),
(37, 'tongji_code', '统计代码', 'text NULL', 'textarea', '', '', 1, '', 2, 0, 1, 1436933778, 1436933778, '', 3, '', 'regex', '', 3, 'function'),
(38, 'website_logo', '网站LOGO', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 2, 0, 1, 1436934006, 1436934006, '', 3, '', 'regex', '', 3, 'function'),
(39, 'menu_type', '菜单类型', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:顶级菜单|pid@hide\r\n1:侧栏菜单|pid@show', 3, 0, 1, 1435218508, 1435216049, '', 3, '', 'regex', '', 3, 'function'),
(40, 'pid', '上级菜单', 'varchar(50) NULL', 'cascade', '0', '', 1, 'type=db&table=manager_menu&menu_type=0&uid=[manager_id]', 3, 0, 1, 1438858450, 1435216147, '', 3, '', 'regex', '', 3, 'function'),
(41, 'title', '菜单名', 'varchar(50) NULL', 'string', '', '', 1, '', 3, 1, 1, 1435216185, 1435216185, '', 3, '', 'regex', '', 3, 'function'),
(42, 'url_type', '链接类型', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:插件|addon_name@show,url@hide\r\n1:外链|addon_name@hide,url@show', 3, 0, 1, 1435218596, 1435216291, '', 3, '', 'regex', '', 3, 'function'),
(43, 'addon_name', '插件名', 'varchar(30) NULL', 'dynamic_select', '', '', 1, 'table=addons&type=0&value_field=name&title_field=title&order=id asc', 3, 0, 1, 1439433250, 1435216373, '', 3, '', 'regex', '', 3, 'function'),
(44, 'url', '外链', 'varchar(255) NULL', 'string', '', '', 1, '', 3, 0, 1, 1435216436, 1435216436, '', 3, '', 'regex', '', 3, 'function'),
(45, 'target', '打开方式', 'char(50) NULL', 'select', '_self', '', 1, '_self:当前窗口打开\r\n_blank:在新窗口打开', 3, 0, 1, 1435216626, 1435216626, '', 3, '', 'regex', '', 3, 'function'),
(46, 'is_hide', '是否隐藏', 'tinyint(2) NULL', 'radio', '0', '', 1, '0:否\r\n1:是', 3, 0, 1, 1435216697, 1435216697, '', 3, '', 'regex', '', 3, 'function'),
(47, 'sort', '排序号', 'int(10) NULL', 'num', '0', '值越小越靠前', 1, '', 3, 0, 1, 1435217270, 1435217270, '', 3, '', 'regex', '', 3, 'function'),
(48, 'uid', '管理员ID', 'int(10) NULL', 'num', '', '', 4, '', 3, 0, 1, 1435224916, 1435223957, '', 3, '', 'regex', '', 3, 'function'),
(49, 'keyword', '关键词', 'varchar(100) NOT NULL ', 'string', '', '', 1, '', 4, 1, 1, 1388815953, 1388815953, '', 3, '', 'regex', '', 3, 'function'),
(50, 'addon', '关键词所属插件', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 4, 1, 1, 1388816207, 1388816207, '', 3, '', 'regex', '', 3, 'function'),
(51, 'aim_id', '插件表里的ID值', 'int(10) unsigned NOT NULL ', 'num', '', '', 1, '', 4, 1, 1, 1388816287, 1388816287, '', 3, '', 'regex', '', 3, 'function'),
(52, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 4, 0, 1, 1407251221, 1388816392, '', 1, '', 'regex', 'time', 1, 'function'),
(53, 'token', 'Token', 'varchar(100) NULL ', 'string', '', '', 0, '', 4, 0, 1, 1408945788, 1391399528, '', 3, '', 'regex', 'get_token', 3, 'function'),
(54, 'keyword_length', '关键词长度', 'int(10) unsigned NULL ', 'num', '0', '', 1, '', 4, 0, 1, 1407251147, 1393918566, '', 3, '', 'regex', '', 3, 'function'),
(55, 'keyword_type', '匹配类型', 'tinyint(2) NULL ', 'select', '0', '', 1, '0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配\r\n4:正则匹配\r\n5:随机匹配', 4, 0, 1, 1417745067, 1393919686, '', 3, '', 'regex', '', 3, 'function'),
(56, 'extra_text', '文本扩展', 'text NULL ', 'textarea', '', '', 0, '', 4, 0, 1, 1407251248, 1393919736, '', 3, '', 'regex', '', 3, 'function'),
(57, 'extra_int', '数字扩展', 'int(10) NULL ', 'num', '', '', 0, '', 4, 0, 1, 1407251240, 1393919798, '', 3, '', 'regex', '', 3, 'function'),
(58, 'request_count', '请求数', 'int(10) NULL', 'num', '0', '用户回复的次数', 0, '', 4, 0, 1, 1401938983, 1401938983, '', 3, '', 'regex', '', 3, 'function'),
(59, 'qr_code', '二维码', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 5, 1, 1, 1406127577, 1388815953, '', 3, '', 'regex', '', 3, 'function'),
(60, 'addon', '二维码所属插件', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 5, 1, 1, 1406127594, 1388816207, '', 3, '', 'regex', '', 3, 'function'),
(61, 'aim_id', '插件表里的ID值', 'int(10) unsigned NOT NULL ', 'num', '', '', 1, '', 5, 1, 1, 1388816287, 1388816287, '', 3, '', 'regex', '', 3, 'function'),
(62, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 1, '', 5, 0, 1, 1388816392, 1388816392, '', 1, '', 'regex', 'time', 1, 'function'),
(63, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 5, 0, 1, 1391399528, 1391399528, '', 3, '', 'regex', '', 3, 'function'),
(64, 'action_name', '二维码类型', 'char(30) NULL', 'select', 'QR_SCENE', 'QR_SCENE为临时,QR_LIMIT_SCENE为永久 ', 1, 'QR_SCENE:临时二维码\r\nQR_LIMIT_SCENE:永久二维码', 5, 0, 1, 1406130162, 1393919686, '', 3, '', 'regex', '', 3, 'function'),
(65, 'extra_text', '文本扩展', 'text NULL ', 'textarea', '', '', 1, '', 5, 0, 1, 1393919736, 1393919736, '', 3, '', 'regex', '', 3, 'function'),
(66, 'extra_int', '数字扩展', 'int(10) NULL ', 'num', '', '', 1, '', 5, 0, 1, 1393919798, 1393919798, '', 3, '', 'regex', '', 3, 'function'),
(67, 'request_count', '请求数', 'int(10) NULL', 'num', '0', '用户回复的次数', 0, '', 5, 0, 1, 1402547625, 1401938983, '', 3, '', 'regex', '', 3, 'function'),
(68, 'scene_id', '场景ID', 'int(10) NULL', 'num', '0', '', 1, '', 5, 0, 1, 1406127542, 1406127542, '', 3, '', 'regex', '', 3, 'function'),
(69, 'is_use', '是否为当前公众号', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:否\r\n1:是', 6, 0, 1, 1391682184, 1391682184, '', 3, '', 'regex', '', 3, 'function'),
(70, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 6, 0, 1, 1402453598, 1391597344, '', 3, '', 'regex', '', 3, 'function'),
(71, 'uid', '用户ID', 'int(10) NULL ', 'num', '', '', 0, '', 6, 1, 1, 1391575873, 1391575210, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(72, 'public_name', '公众号名称', 'varchar(50) NOT NULL', 'string', '', '', 1, '', 6, 1, 1, 1391576452, 1391575955, '', 3, '', 'regex', '', 3, 'function'),
(73, 'public_id', '公众号原始id', 'varchar(100) NOT NULL', 'string', '', '请正确填写，保存后不能再修改，且无法接收到微信的信息', 1, '', 6, 1, 1, 1402453976, 1391576015, '', 1, '公众号原始ID已经存在，请不要重复增加', 'unique', '', 3, 'function'),
(74, 'wechat', '微信号', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 6, 1, 1, 1391576484, 1391576144, '', 3, '', 'regex', '', 3, 'function'),
(75, 'interface_url', '接口地址', 'varchar(255) NULL', 'string', '', '', 0, '', 6, 0, 1, 1392946881, 1391576234, '', 3, '', 'regex', '', 3, 'function'),
(76, 'headface_url', '公众号头像', 'varchar(255) NULL', 'picture', '', '', 1, '', 6, 0, 1, 1429847363, 1391576300, '', 3, '', 'regex', '', 3, 'function'),
(77, 'area', '地区', 'varchar(50) NULL', 'string', '', '', 0, '', 6, 0, 1, 1392946934, 1391576435, '', 3, '', 'regex', '', 3, 'function'),
(78, 'addon_config', '插件配置', 'text NULL', 'textarea', '', '', 0, '', 6, 0, 1, 1391576537, 1391576537, '', 3, '', 'regex', '', 3, 'function'),
(79, 'addon_status', '插件状态', 'text NULL', 'textarea', '', '', 0, '198:微官网\r\n199:自动回复\r\n218:自定义菜单\r\n201:多客服\r\n202:模板消息\r\n204:场景二维码\r\n205:微信用户中心\r\n206:微商城\r\n207:功能演示\r\n208:微捐赠\r\n209:融合第三方\r\n210:通用表单\r\n211:在线点歌\r\n212:意见反馈\r\n213:微信宣传页\r\n214:地址管理\r\n215:支付通\r\n216:成语接龙\r\n217:图灵机器人\r\n', 6, 0, 1, 1391576571, 1391576571, '', 3, '', 'regex', '', 3, 'function'),
(12114, 'qrcode_url', '二维码地址', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1448957495, 1448957495, '', 3, '', 'regex', '', 3, 'function'),
(80, 'type', '公众号类型', 'char(10) NULL', 'radio', '0', '', 1, '0:普通订阅号\r\n1:认证订阅号/普通服务号\r\n2:认证服务号', 6, 0, 1, 1416904702, 1393718575, '', 3, '', 'regex', '', 3, 'function'),
(81, 'appid', 'AppID', 'varchar(255) NULL', 'string', '', '应用ID', 1, '', 6, 0, 1, 1416904750, 1393718735, '', 3, '', 'regex', '', 3, 'function'),
(82, 'secret', 'AppSecret', 'varchar(255) NULL', 'string', '', '应用密钥', 1, '', 6, 0, 1, 1416904771, 1393718806, '', 3, '', 'regex', '', 3, 'function'),
(83, 'group_id', '等级', 'int(10) unsigned NULL ', 'select', '0', '', 0, '', 6, 0, 1, 1393753499, 1393724468, '', 3, '', 'regex', '', 3, 'function'),
(84, 'is_audit', '是否审核', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:否\r\n1:是', 6, 1, 1, 1430879018, 1430879007, '', 3, '', 'regex', '', 3, 'function'),
(85, 'is_init', '是否初始化', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:否\r\n1:是', 6, 1, 1, 1430888244, 1430878899, '', 3, '', 'regex', '', 3, 'function'),
(86, 'encodingaeskey', 'EncodingAESKey', 'varchar(255) NULL', 'string', '', '安全模式下必填', 1, '', 6, 0, 1, 1419775850, 1419775850, '', 3, '', 'regex', '', 3, 'function'),
(87, 'tips_url', '提示关注公众号的文章地址', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1420789769, 1420789769, '', 3, '', 'regex', '', 3, 'function'),
(88, 'GammaAppId', 'GammaAppId', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1424529968, 1424529968, '', 3, '', 'regex', '', 3, 'function'),
(89, 'GammaSecret', 'GammaSecret', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1424529990, 1424529990, '', 3, '', 'regex', '', 3, 'function'),
(90, 'public_copy_right', '版权信息', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1431141576, 1431141576, '', 3, '', 'regex', '', 3, 'function'),
(91, 'domain', '自定义域名', 'varchar(30) NULL', 'string', '', '', 0, '', 6, 0, 1, 1439698931, 1439698931, '', 3, '', 'regex', '', 3, 'function'),
(92, 'title', '等级名', 'varchar(50) NULL', 'string', '', '', 1, '', 7, 0, 1, 1393724854, 1393724854, '', 3, '', 'regex', '', 3, 'function'),
(93, 'addon_status', '插件权限', 'text NULL', 'checkbox', '', '', 1, '198:微官网\r\n199:自动回复\r\n218:自定义菜单\r\n201:多客服\r\n202:模板消息\r\n204:场景二维码\r\n205:微信用户中心\r\n206:微商城\r\n207:功能演示\r\n208:微捐赠\r\n209:融合第三方\r\n210:通用表单\r\n211:在线点歌\r\n212:意见反馈\r\n213:微信宣传页\r\n214:地址管理\r\n215:支付通\r\n216:成语接龙\r\n217:图灵机器人\r\n', 7, 0, 1, 1393731903, 1393725072, '', 3, '', 'regex', '', 3, 'function'),
(12113, 'mp_token', '公众号接入验证Token', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1448956397, 1448956397, '', 3, '', 'regex', '', 3, 'function'),
(94, 'uid', '管理员UID', 'int(10) NULL ', 'admin', '', '', 1, '', 8, 1, 1, 1447215599, 1398933236, '', 3, '', 'regex', '', 3, 'function'),
(95, 'mp_id', '公众号ID', 'int(10) unsigned NOT NULL ', 'num', '', '', 4, '', 8, 1, 1, 1398933300, 1398933300, '', 3, '', 'regex', '', 3, 'function'),
(96, 'is_creator', '是否为创建者', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:不是\r\n1:是', 8, 0, 1, 1398933380, 1398933380, '', 3, '', 'regex', '', 3, 'function'),
(97, 'addon_status', '插件权限', 'text NULL', 'checkbox', '', '', 1, '198:微官网\r\n199:自动回复\r\n218:自定义菜单\r\n201:多客服\r\n202:模板消息\r\n204:场景二维码\r\n205:微信用户中心\r\n206:微商城\r\n207:功能演示\r\n208:微捐赠\r\n209:融合第三方\r\n210:通用表单\r\n211:在线点歌\r\n212:意见反馈\r\n213:微信宣传页\r\n214:地址管理\r\n215:支付通\r\n216:成语接龙\r\n217:图灵机器人\r\n', 8, 0, 1, 1398933475, 1398933475, '', 3, '', 'regex', '', 3, 'function'),
(12111, 'mp_username', '公众号登陆用户名', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1448956330, 1448956330, '', 3, '', 'regex', '', 3, 'function'),
(12112, 'mp_password', '公众号登陆密码', 'varchar(255) NULL', 'string', '', '', 1, '', 6, 0, 1, 1448956378, 1448956378, '', 3, '', 'regex', '', 3, 'function'),
(98, 'is_use', '是否为当前管理的公众号', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:不是\r\n1:是', 8, 0, 1, 1398996982, 1398996975, '', 3, '', 'regex', '', 3, 'function'),
(99, 'attach', '上传文件', 'int(10) unsigned NOT NULL ', 'file', '', '支持xls,xlsx两种格式', 1, '', 9, 1, 1, 1407554177, 1407554177, '', 3, '', 'regex', '', 3, 'function'),
(100, 'icon', '分类图标', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 10, 0, 1, 1400047745, 1400047745, '', 3, '', 'regex', '', 3, 'function'),
(101, 'title', '分类名', 'varchar(255) NULL', 'string', '', '', 1, '', 10, 0, 1, 1400047764, 1400047764, '', 3, '', 'regex', '', 3, 'function'),
(102, 'sort', '排序号', 'int(10) NULL', 'num', '0', '值越小越靠前', 1, '', 10, 0, 1, 1400050453, 1400047786, '', 3, '', 'regex', '', 3, 'function'),
(110, 'name', '分类标识', 'varchar(255) NULL', 'string', '', '只能使用英文', 0, '', 12, 0, 1, 1403711345, 1397529355, '', 3, '只能输入由数字、26个英文字母或者下划线组成的标识名', 'regex', '', 3, 'function'),
(111, 'title', '分类标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 12, 1, 1, 1397529407, 1397529407, '', 3, '', 'regex', '', 3, 'function'),
(112, 'icon', '分类图标', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 12, 0, 1, 1397529461, 1397529461, '', 3, '', 'regex', '', 3, 'function'),
(113, 'pid', '上一级分类', 'int(10) unsigned NULL ', 'select', '0', '如果你要增加一级分类，这里选择“无”即可', 1, '0:无', 12, 0, 1, 1398266132, 1397529555, '', 3, '', 'regex', '', 3, 'function'),
(114, 'path', '分类路径', 'varchar(255) NULL', 'string', '', '', 0, '', 12, 0, 1, 1397529604, 1397529604, '', 3, '', 'regex', '', 3, 'function'),
(115, 'module', '分类所属功能', 'varchar(255) NULL', 'string', '', '', 0, '', 12, 0, 1, 1397529671, 1397529671, '', 3, '', 'regex', '', 3, 'function'),
(116, 'sort', '排序号', 'int(10) unsigned NULL ', 'num', '0', '数值越小越靠前', 1, '', 12, 0, 1, 1397529705, 1397529705, '', 3, '', 'regex', '', 3, 'function'),
(117, 'is_show', '是否显示', 'tinyint(2) NULL', 'bool', '1', '', 1, '0:不显示\r\n1:显示', 12, 0, 1, 1397532496, 1397529809, '', 3, '', 'regex', '', 3, 'function'),
(118, 'intro', '分类描述', 'varchar(255) NULL', 'string', '', '', 1, '', 12, 0, 1, 1398414247, 1398414247, '', 3, '', 'regex', '', 3, 'function'),
(119, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 12, 0, 1, 1398593086, 1398523502, '', 3, '', 'regex', 'get_token', 3, 'function'),
(120, 'code', '分类扩展编号', 'varchar(255) NULL', 'string', '', '原分类或者导入分类的扩展编号', 0, '', 12, 0, 1, 1404182741, 1404182630, '', 3, '', 'regex', '', 3, 'function'),
(121, 'cTime', '发布时间', 'int(10) UNSIGNED NULL', 'datetime', '', '', 0, '', 13, 0, 1, 1396624612, 1396075102, '', 3, '', 'regex', 'time', 1, 'function'),
(122, 'name', '分组标识', 'varchar(100) NOT NULL', 'string', '', '英文字母或者下划线，长度不超过30', 1, '', 13, 1, 1, 1403624543, 1396061575, '', 3, '', 'regex', '', 3, 'function'),
(123, 'title', '分组标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 13, 1, 1, 1403624556, 1396061859, '', 3, '', 'regex', '', 3, 'function'),
(124, 'level', '最多级数', 'tinyint(1) unsigned NULL', 'select', '3', '', 1, '1:1级\r\n2:2级\r\n3:3级\r\n4:4级\r\n5:5级\r\n6:6级\r\n7:7级', 13, 0, 1, 1404193097, 1404192897, '', 3, '', 'regex', '', 3, 'function'),
(125, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 13, 1, 1, 1408947244, 1396602859, '', 3, '', 'regex', 'get_token', 3, 'function'),
(126, 'title', '积分描述', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 14, 1, 1, 1438589622, 1396061859, '', 3, '', 'regex', '', 3, 'function'),
(127, 'name', '积分标识', 'varchar(50) NULL', 'string', '', '', 1, '', 14, 0, 1, 1438589601, 1396061947, '', 3, '', 'regex', '', 3, 'function'),
(128, 'mTime', '修改时间', 'int(10) NULL', 'datetime', '', '', 0, '', 14, 0, 1, 1396624664, 1396624664, '', 3, '', 'regex', 'time', 3, 'function'),
(129, 'experience', '经验值', 'int(10) NULL', 'num', '0', '可以是正数，也可以是负数，如 -10 表示减10个经验值', 1, '', 14, 0, 1, 1398564024, 1396062093, '', 3, '', 'regex', '', 3, 'function'),
(130, 'score', '金币值', 'int(10) NULL', 'num', '0', '可以是正数，也可以是负数，如 -10 表示减10个金币值', 1, '', 14, 0, 1, 1398564097, 1396062146, '', 3, '', 'regex', '', 3, 'function'),
(131, 'token', 'Token', 'varchar(255) NULL', 'string', '0', '', 0, '', 14, 0, 1, 1398564146, 1396602859, '', 3, '', 'regex', '', 1, 'function'),
(132, 'credit_name', '积分标识', 'varchar(50) NULL', 'string', '', '', 1, '', 15, 0, 1, 1398564405, 1398564405, '', 3, '', 'regex', '', 3, 'function'),
(133, 'uid', '用户ID', 'int(10) NULL', 'num', '0', '', 1, '', 15, 0, 1, 1398564351, 1398564351, '', 3, '', 'regex', '', 3, 'function'),
(134, 'experience', '经验值', 'int(10) NULL', 'num', '0', '', 1, '', 15, 0, 1, 1398564448, 1398564448, '', 3, '', 'regex', '', 3, 'function'),
(135, 'score', '金币值', 'int(10) NULL', 'num', '0', '', 1, '', 15, 0, 1, 1398564486, 1398564486, '', 3, '', 'regex', '', 3, 'function'),
(136, 'cTime', '记录时间', 'int(10) NULL', 'datetime', '', '', 0, '', 15, 0, 1, 1398564567, 1398564567, '', 3, '', 'regex', 'time', 1, 'function'),
(137, 'admin_uid', '操作者UID', 'int(10) NULL', 'num', '0', '', 0, '', 15, 0, 1, 1398564629, 1398564629, '', 3, '', 'regex', '', 3, 'function'),
(138, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 15, 0, 1, 1400603451, 1400603451, '', 3, '', 'regex', 'get_token', 1, 'function'),
(139, 'cover_id', '图片在本地的ID', 'int(10) NULL', 'num', '', '', 0, '', 16, 0, 1, 1438684652, 1438684652, '', 3, '', 'regex', '', 3, 'function'),
(140, 'cover_url', '本地URL', 'varchar(255) NULL', 'string', '', '', 0, '', 16, 0, 1, 1438684692, 1438684692, '', 3, '', 'regex', '', 3, 'function'),
(141, 'media_id', '微信端图文消息素材的media_id', 'varchar(100) NULL', 'string', '0', '', 0, '', 16, 0, 1, 1438744962, 1438684776, '', 3, '', 'regex', '', 3, 'function'),
(142, 'wechat_url', '微信端的图片地址', 'varchar(255) NULL', 'string', '', '', 0, '', 16, 0, 1, 1439973558, 1438684807, '', 3, '', 'regex', '', 3, 'function'),
(143, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 16, 0, 1, 1438684829, 1438684829, '', 3, '', 'regex', '', 3, 'function'),
(144, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 16, 0, 1, 1438684847, 1438684847, '', 3, '', 'regex', '', 3, 'function'),
(145, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 16, 0, 1, 1438684865, 1438684865, '', 3, '', 'regex', '', 3, 'function'),
(146, 'title', '标题', 'varchar(100) NULL', 'string', '', '', 1, '', 17, 1, 1, 1438670933, 1438670933, '', 3, '', 'regex', '', 3, 'function'),
(147, 'author', '作者', 'varchar(30) NULL', 'string', '', '', 1, '', 17, 0, 1, 1438670961, 1438670961, '', 3, '', 'regex', '', 3, 'function'),
(148, 'cover_id', '封面', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 17, 0, 1, 1438674438, 1438670980, '', 3, '', 'regex', '', 3, 'function'),
(149, 'intro', '摘要', 'varchar(255) NULL', 'textarea', '', '', 1, '', 17, 0, 1, 1438671024, 1438671024, '', 3, '', 'regex', '', 3, 'function'),
(150, 'content', '内容', 'longtext  NULL', 'editor', '', '', 1, '', 17, 0, 1, 1440473839, 1438671049, '', 3, '', 'regex', '', 3, 'function'),
(151, 'link', '外链', 'varchar(255) NULL', 'string', '', '', 1, '', 17, 0, 1, 1438671066, 1438671066, '', 3, '', 'regex', '', 3, 'function'),
(152, 'group_id', '多图文组的ID', 'int(10) NULL', 'num', '0', '0 表示单图文，多于0 表示多图文中的第一个图文的ID值', 0, '', 17, 0, 1, 1438671163, 1438671163, '', 3, '', 'regex', '', 3, 'function'),
(153, 'thumb_media_id', '图文消息的封面图片素材id（必须是永久mediaID）', 'varchar(100) NULL', 'string', '', '', 0, '', 17, 0, 1, 1438671302, 1438671285, '', 3, '', 'regex', '', 3, 'function'),
(154, 'media_id', '微信端图文消息素材的media_id', 'varchar(100) NULL', 'string', '0', '', 1, '', 17, 0, 1, 1438744941, 1438671373, '', 3, '', 'regex', '', 3, 'function'),
(155, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 17, 0, 1, 1438683172, 1438683172, '', 3, '', 'regex', '', 3, 'function'),
(156, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 17, 0, 1, 1438683194, 1438683194, '', 3, '', 'regex', '', 3, 'function'),
(157, 'cTime', '发布时间', 'int(10) NULL', 'datetime', '', '', 0, '', 17, 0, 1, 1438683499, 1438683499, '', 3, '', 'regex', '', 3, 'function'),
(158, 'bind_keyword', '关联关键词', 'varchar(50) NULL', 'string', '', '先在自定义回复里增加图文，多图文或者文本内容，再把它的关键词填写到这里', 1, '', 18, 0, 1, 1437984209, 1437984184, '', 3, '', 'regex', '', 3, 'function'),
(159, 'preview_openids', '预览人OPENID', 'text NULL', 'textarea', '', '选填，多个可用逗号或者换行分开，OpenID值可在微信用户的列表中找到', 1, '', 18, 0, 1, 1438049470, 1437985038, '', 3, '', 'regex', '', 3, 'function'),
(160, 'group_id', '群发对象', 'int(10) NULL', 'dynamic_select', '0', '全部用户或者某分组用户', 1, 'table=auth_group&manager_id=[manager_id]&token=[token]&value_field=id&title_field=title&first_option=全部用户', 18, 0, 1, 1438049058, 1437985498, '', 3, '', 'regex', '', 3, 'function'),
(161, 'type', '素材来源', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:站内关键词|bind_keyword@show,media_id@hide\r\n1:微信永久素材ID|bind_keyword@hide,media_id@show', 18, 0, 1, 1437988869, 1437988869, '', 3, '', 'regex', '', 3, 'function'),
(162, 'media_id', '微信素材ID', 'varchar(100) NULL', 'string', '', '微信后台的素材管理里永久素材的media_id值', 1, '', 18, 0, 1, 1437988973, 1437988973, '', 3, '', 'regex', '', 3, 'function'),
(163, 'send_type', '发送方式', 'tinyint(1) NULL', 'bool', '0', '', 1, '0:按用户组发送|group_id@show,send_openids@hide\r\n1:指定OpenID发送|group_id@hide,send_openids@show', 18, 0, 1, 1438049241, 1438049241, '', 3, '', 'regex', '', 3, 'function'),
(164, 'send_openids', '要发送的OpenID', 'text NULL', 'textarea', '', '多个可用逗号或者换行分开，OpenID值可在微信用户的列表中找到', 1, '', 18, 0, 1, 1438049362, 1438049362, '', 3, '', 'regex', '', 3, 'function'),
(165, 'msg_id', 'msg_id', 'varchar(255) NULL', 'string', '', '', 0, '', 18, 0, 1, 1439980539, 1438054616, '', 3, '', 'regex', '', 3, 'function'),
(166, 'publicid', '公众号ID', 'int(10) NULL', 'num', '0', '', 0, '', 19, 0, 1, 1439448400, 1439448400, '', 3, '', 'regex', '', 3, 'function'),
(167, 'module_name', '类型名', 'varchar(30) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448516, 1439448516, '', 3, '', 'regex', '', 3, 'function'),
(168, 'controller_name', '控制器名', 'varchar(30) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448567, 1439448567, '', 3, '', 'regex', '', 3, 'function'),
(169, 'action_name', '方法名', 'varchar(30) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448616, 1439448616, '', 3, '', 'regex', '', 3, 'function'),
(170, 'uid', '访问者ID', 'varchar(255) NULL', 'string', '0', '', 0, '', 19, 0, 1, 1439448654, 1439448654, '', 3, '', 'regex', '', 3, 'function'),
(171, 'ip', 'ip地址', 'varchar(30) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448742, 1439448742, '', 3, '', 'regex', '', 3, 'function'),
(172, 'brower', '浏览器', 'varchar(30) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448792, 1439448792, '', 3, '', 'regex', '', 3, 'function'),
(173, 'param', '其它GET参数', 'text NULL', 'textarea', '', '', 0, '', 19, 0, 1, 1439448834, 1439448834, '', 3, '', 'regex', '', 3, 'function'),
(174, 'referer', '访问的URL', 'varchar(255) NULL', 'string', '', '', 0, '', 19, 0, 1, 1439448886, 1439448874, '', 3, '', 'regex', '', 3, 'function'),
(175, 'cTime', '时间', 'int(10) NULL', 'datetime', '', '', 0, '', 19, 0, 1, 1439450668, 1439450668, '', 3, '', 'regex', '', 3, 'function'),
(176, 'wechat_group_name', '微信端的分组名', 'varchar(100) NULL', 'string', '', '', 0, '', 20, 0, 1, 1437635205, 1437635205, '', 3, '', 'regex', '', 3, 'function'),
(177, 'wechat_group_id', '微信端的分组ID', 'int(10) NULL', 'num', '-1', '', 0, '', 20, 0, 1, 1447659224, 1437635149, '', 3, '', 'regex', '', 3, 'function'),
(178, 'qr_code', '微信二维码', 'varchar(255) NULL', 'string', '', '', 0, '', 20, 0, 1, 1437635117, 1437635117, '', 3, '', 'regex', '', 3, 'function'),
(179, 'is_default', '是否默认自动加入', 'tinyint(1) NULL', 'radio', '0', '只有设置一个默认组，设置当前为默认组后之前的默认组将取消', 0, '0:否\r\n1:是', 20, 0, 1, 1437642358, 1437635042, '', 3, '', 'regex', '', 3, 'function'),
(180, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 20, 0, 1, 1437634089, 1437634089, '', 3, '', 'regex', '', 3, 'function'),
(181, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '0', '为0时表示系统用户组', 0, '', 20, 0, 1, 1437634309, 1437634062, '', 3, '', 'regex', '', 3, 'function'),
(182, 'rules', '权限', 'text NULL', 'textarea', '', '', 0, '', 20, 0, 1, 1437634022, 1437634022, '', 3, '', 'regex', '', 3, 'function'),
(183, 'type', '类型', 'tinyint(2) NULL', 'bool', '1', '', 0, '0:普通用户组\r\n1:微信用户组\r\n2:等级用户组\r\n3:认证用户组', 20, 0, 1, 1437633981, 1437633981, '', 3, '', 'regex', '', 3, 'function'),
(184, 'status', '状态', 'tinyint(2) NULL', 'bool', '1', '', 0, '1:正常\r\n0:禁用\r\n-1:删除', 20, 0, 1, 1437633826, 1437633826, '', 3, '', 'regex', '', 3, 'function'),
(185, 'description', '描述信息', 'text NULL', 'textarea', '', '', 1, '', 20, 0, 1, 1437633751, 1437633751, '', 3, '', 'regex', '', 3, 'function'),
(186, 'icon', '图标', 'int(10) UNSIGNED NULL', 'picture', '', '', 0, '', 20, 0, 1, 1437633711, 1437633711, '', 3, '', 'regex', '', 3, 'function'),
(187, 'title', '分组名称', 'varchar(30) NULL', 'string', '', '', 1, '', 20, 1, 1, 1437641907, 1437633598, '', 3, '', 'regex', '', 3, 'function'),
(188, 'wechat_group_count', '微信端用户数', 'int(10) NULL', 'num', '', '', 0, '', 20, 0, 1, 1437644061, 1437644061, '', 3, '', 'regex', '', 3, 'function'),
(189, 'is_del', '是否已删除', 'tinyint(1) NULL', 'bool', '0', '', 0, '0:否\r\n1:是', 20, 0, 1, 1437650054, 1437650044, '', 3, '', 'regex', '', 3, 'function'),
(190, 'sports_id', 'sports_id', 'int(10) NULL', 'num', '', '', 0, '', 21, 0, 1, 1432806979, 1432806979, '', 3, '', 'regex', '', 3, 'function'),
(191, 'type', 'type', 'varchar(30) NULL', 'string', '', '', 0, '', 21, 0, 1, 1432807001, 1432807001, '', 3, '', 'regex', '', 3, 'function'),
(192, 'time', 'time', 'varchar(50) NULL', 'string', '', '', 0, '', 21, 0, 1, 1432807028, 1432807028, '', 3, '', 'regex', '', 3, 'function'),
(193, 'total_count', 'total_count', 'int(10) NULL', 'num', '0', '', 0, '', 21, 0, 1, 1432807049, 1432807049, '', 3, '', 'regex', '', 3, 'function'),
(194, 'follow_count', 'follow_count', 'int(10) NULL', 'num', '0', '', 0, '', 21, 0, 1, 1432807063, 1432807063, '', 3, '', 'regex', '', 3, 'function'),
(195, 'aver_count', 'aver_count', 'int(10) NULL', 'num', '0', '', 0, '', 21, 0, 1, 1432807079, 1432807079, '', 3, '', 'regex', '', 3, 'function'),
(196, 'group_id', '分组样式', 'int(10) NULL', 'num', '0', '', 1, '', 22, 0, 1, 1436845570, 1436845570, '', 3, '', 'regex', '', 3, 'function'),
(197, 'style', '样式内容', 'text NULL', 'textarea', '', '请填写html', 1, '', 22, 1, 1, 1436846111, 1436846111, '', 3, '', 'regex', '', 3, 'function'),
(198, 'group_name', '分组名称', 'varchar(255) NULL', 'string', '', '', 1, '', 23, 1, 1, 1436845332, 1436845332, '', 3, '', 'regex', '', 3, 'function'),
(199, 'desc', '说明', 'text NULL', 'textarea', '', '', 1, '', 23, 0, 1, 1436845361, 1436845361, '', 3, '', 'regex', '', 3, 'function'),
(723, 'sn', 'SN码', 'varchar(255) NULL', 'string', '', '', 0, '', 81, 0, 1, 1399272236, 1399272228, '', 3, '', 'regex', 'uniqid', 1, 'function'),
(724, 'uid', '粉丝UID', 'int(10) NULL', 'num', '', '', 0, '', 81, 0, 1, 1399772738, 1399272401, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(725, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 81, 0, 1, 1399272456, 1399272456, '', 3, '', 'regex', 'time', 3, 'function'),
(726, 'is_use', '是否已使用', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:未使用\r\n1:已使用', 81, 0, 1, 1400601159, 1399272514, '', 3, '', 'regex', '', 3, 'function'),
(727, 'use_time', '使用时间', 'int(10) NULL', 'datetime', '', '', 0, '', 81, 0, 1, 1399272560, 1399272537, '', 3, '', 'regex', '', 3, 'function'),
(728, 'addon', '来自的插件', 'varchar(255) NULL', 'string', 'Coupon', '', 4, '', 81, 0, 1, 1399272651, 1399272651, '', 3, '', 'regex', '', 3, 'function'),
(729, 'target_id', '来源ID', 'int(10) unsigned NULL ', 'num', '', '', 4, '', 81, 0, 1, 1399272705, 1399272705, '', 3, '', 'regex', '', 3, 'function'),
(730, 'prize_id', '奖项ID', 'int(10) unsigned NULL ', 'num', '', '', 0, '', 81, 0, 1, 1399686317, 1399686317, '', 3, '', 'regex', '', 3, 'function'),
(731, 'prize_title', '奖项', 'varchar(255) NULL', 'string', '', '', 1, '', 81, 0, 1, 1399790367, 1399790367, '', 3, '', 'regex', '', 3, 'function'),
(732, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 81, 0, 1, 1404525481, 1404525481, '', 3, '', 'regex', 'get_token', 1, 'function'),
(733, 'can_use', '是否可用', 'tinyint(2) NULL', 'bool', '1', '', 0, '0:不可用\r\n1:可用', 81, 0, 1, 1418890020, 1418890020, '', 3, '', 'regex', '', 3, 'function'),
(734, 'server_addr', '服务器IP', 'varchar(50) NULL', 'string', '', '', 1, '', 81, 0, 1, 1425807865, 1425807865, '', 3, '', 'regex', '', 3, 'function'),
(776, 'title', '应用标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 87, 1, 1, 1402758132, 1394033402, '', 3, '', 'regex', '', 3, 'function'),
(777, 'uid', '用户ID', 'int(10) NULL ', 'num', '0', '', 0, '', 87, 0, 1, 1394087733, 1394033447, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(778, 'content', '应用详细介绍', 'text NULL ', 'editor', '', '', 1, '', 87, 1, 1, 1402758118, 1394033484, '', 3, '', 'regex', '', 3, 'function'),
(779, 'cTime', '发布时间', 'int(10) NULL ', 'datetime', '', '', 0, '', 87, 0, 1, 1394033571, 1394033571, '', 3, '', 'regex', 'time', 1, 'function'),
(780, 'attach', '应用压缩包', 'varchar(255) NULL ', 'file', '', '需要上传zip文件', 1, '', 87, 0, 1, 1402758100, 1394033674, '', 3, '', 'regex', '', 3, 'function'),
(781, 'is_top', '置顶', 'int(10) NULL ', 'bool', '0', '0表示不置顶，否则其它值表示置顶且值是置顶的时间', 1, '0:不置顶\r\n1:置顶', 87, 0, 1, 1402800009, 1394068787, '', 3, '', 'regex', '', 3, 'function'),
(782, 'cid', '分类', 'tinyint(4) NULL ', 'select', '', '', 0, '1:基础模块\r\n2:行业模块\r\n3:会议活动\r\n4:娱乐模块\r\n5:其它模块', 87, 0, 1, 1402758069, 1394069964, '', 3, '', 'regex', '', 3, 'function'),
(783, 'view_count', '浏览数', 'int(11) unsigned NULL ', 'num', '0', '', 0, '', 87, 0, 1, 1394072168, 1394072168, '', 3, '', 'regex', '', 3, 'function'),
(784, 'download_count', '下载数', 'int(10) unsigned NULL ', 'num', '0', '', 0, '', 87, 0, 1, 1394085763, 1394085763, '', 3, '', 'regex', '', 3, 'function'),
(785, 'img_2', '应用截图2', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 87, 0, 1, 1402758035, 1394084714, '', 3, '', 'regex', '', 3, 'function'),
(786, 'img_1', '应用截图1', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 87, 0, 1, 1402758046, 1394084635, '', 3, '', 'regex', '', 3, 'function'),
(787, 'img_3', '应用截图3', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 87, 0, 1, 1402758021, 1394084757, '', 3, '', 'regex', '', 3, 'function'),
(788, 'img_4', '应用截图4', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 87, 0, 1, 1402758011, 1394084797, '', 3, '', 'regex', '', 3, 'function'),
(789, 'uid', 'uid', 'int(10) NULL', 'num', '', '', 1, '', 24, 0, 1, 1430880974, 1430880974, '', 3, '', 'regex', '', 3, 'function'),
(790, 'name', '素材名称', 'varchar(100) NULL', 'string', '', '', 1, '', 24, 0, 1, 1424612322, 1424611929, '', 3, '', 'regex', '', 3, 'function'),
(791, 'status', '状态', 'char(10) NULL', 'radio', 'UnSubmit', '', 1, 'UnSubmit:未提交\r\nWaiting:入库中\r\nSuccess:入库成功\r\nFailure:入库失败', 24, 0, 1, 1424612039, 1424612039, '', 3, '', 'regex', '', 3, 'function'),
(792, 'cTime', '提交时间', 'int(10) NULL', 'datetime', '', '', 1, '', 24, 0, 1, 1424612114, 1424612114, '', 3, '', 'regex', 'time', 1, 'function'),
(793, 'url', '实际摇一摇所使用的页面URL', 'varchar(255) NULL', 'string', '', '', 1, '', 24, 0, 1, 1424612483, 1424612154, '', 3, '', 'regex', '', 3, 'function'),
(794, 'type', '素材类型', 'varchar(255) NULL', 'string', '', '', 1, '', 24, 0, 1, 1424612421, 1424612421, '', 3, '', 'regex', '', 3, 'function'),
(795, 'detail', '素材内容', 'text NULL', 'textarea', '', '', 1, '', 24, 0, 1, 1424612456, 1424612456, '', 3, '', 'regex', '', 3, 'function'),
(796, 'reason', '入库失败的原因', 'text NULL', 'textarea', '', '', 1, '', 24, 0, 1, 1424612509, 1424612509, '', 3, '', 'regex', '', 3, 'function'),
(797, 'create_time', '申请时间', 'int(10) NULL', 'datetime', '', '', 1, '', 24, 0, 1, 1424612542, 1424612542, '', 3, '', 'regex', '', 3, 'function'),
(798, 'checked_time', '入库时间', 'int(10) NULL', 'datetime', '', '', 1, '', 24, 0, 1, 1424612571, 1424612571, '', 3, '', 'regex', '', 3, 'function'),
(799, 'source', '来源', 'varchar(50) NULL', 'string', '', '', 1, '', 24, 0, 1, 1424836818, 1424836818, '', 3, '', 'regex', '', 3, 'function'),
(800, 'source_id', '来源ID', 'int(10) NULL', 'num', '', '', 1, '', 24, 0, 1, 1424836842, 1424836842, '', 3, '', 'regex', '', 3, 'function'),
(801, 'wechat_id', '微信端的素材ID', 'int(10) NULL', 'num', '', '', 0, '', 24, 0, 1, 1425370605, 1425370605, '', 3, '', 'regex', '', 3, 'function'),
(802, 'uid', '管理员id', 'int(10) NULL', 'num', '', '', 1, '', 25, 0, 1, 1431575588, 1431575588, '', 3, '', 'regex', '', 3, 'function'),
(803, 'token', '用户token', 'varchar(255) NULL', 'string', '', '', 1, '', 25, 0, 1, 1431575617, 1431575617, '', 3, '', 'regex', '', 3, 'function'),
(804, 'addons', '插件名称', 'varchar(255) NULL', 'string', '', '', 1, '', 25, 0, 1, 1431590322, 1431575667, '', 3, '', 'regex', '', 3, 'function'),
(805, 'template', '模版名称', 'varchar(255) NULL', 'string', '', '', 1, '', 25, 0, 1, 1431575691, 1431575691, '', 3, '', 'regex', '', 3, 'function'),
(832, 'title', '公告标题', 'varchar(255) NULL', 'string', '', '', 1, '', 26, 1, 1, 1431143985, 1431143985, '', 3, '', 'regex', '', 3, 'function'),
(833, 'content', '公告内容', 'text  NULL', 'editor', '', '', 1, '', 26, 1, 1, 1431144020, 1431144020, '', 3, '', 'regex', '', 3, 'function'),
(834, 'create_time', '发布时间', 'int(10) NULL', 'datetime', '', '', 4, '', 26, 0, 1, 1431146373, 1431144069, '', 3, '', 'regex', '', 3, 'function'),
(835, 'version', '版本号', 'int(10) unsigned NOT NULL ', 'num', '', '', 1, '', 27, 1, 1, 1393770457, 1393770457, '', 3, '', 'regex', '', 3, 'function'),
(836, 'title', '升级包名', 'varchar(50) NOT NULL', 'string', '', '', 1, '', 27, 1, 1, 1393770499, 1393770499, '', 3, '', 'regex', '', 3, 'function'),
(837, 'description', '描述', 'text NULL', 'textarea', '', '', 1, '', 27, 0, 1, 1393770546, 1393770546, '', 3, '', 'regex', '', 3, 'function'),
(838, 'create_date', '创建时间', 'int(10) NULL', 'datetime', '', '', 1, '', 27, 0, 1, 1393770591, 1393770591, '', 3, '', 'regex', '', 3, 'function'),
(839, 'download_count', '下载统计', 'int(10) unsigned NULL ', 'num', '0', '', 0, '', 27, 0, 1, 1393770659, 1393770659, '', 3, '', 'regex', '', 3, 'function'),
(840, 'package', '升级包地址', 'varchar(255) NOT NULL', 'textarea', '', '', 1, '', 27, 1, 1, 1393812247, 1393770727, '', 3, '', 'regex', '', 3, 'function'),
(896, 'ToUserName', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143065, 1438143065, '', 3, '', 'regex', '', 3, 'function'),
(897, 'FromUserName', 'OpenID', 'varchar(100) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143098, 1438143098, '', 3, '', 'regex', '', 3, 'function'),
(898, 'CreateTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 28, 0, 1, 1438143120, 1438143120, '', 3, '', 'regex', '', 3, 'function'),
(899, 'MsgType', '消息类型', 'varchar(30) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143139, 1438143139, '', 3, '', 'regex', '', 3, 'function'),
(900, 'MsgId', '消息ID', 'varchar(100) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143182, 1438143182, '', 3, '', 'regex', '', 3, 'function'),
(901, 'Content', '文本消息内容', 'text NULL', 'textarea', '', '', 0, '', 28, 0, 1, 1438143218, 1438143218, '', 3, '', 'regex', '', 3, 'function'),
(902, 'PicUrl', '图片链接', 'varchar(255) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143273, 1438143273, '', 3, '', 'regex', '', 3, 'function'),
(903, 'MediaId', '多媒体文件ID', 'varchar(100) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143357, 1438143357, '', 3, '', 'regex', '', 3, 'function'),
(904, 'Format', '语音格式', 'varchar(30) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143397, 1438143397, '', 3, '', 'regex', '', 3, 'function'),
(905, 'ThumbMediaId', '缩略图的媒体id', 'varchar(30) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143445, 1438143426, '', 3, '', 'regex', '', 3, 'function'),
(906, 'Title', '消息标题', 'varchar(100) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143471, 1438143471, '', 3, '', 'regex', '', 3, 'function'),
(907, 'Description', '消息描述', 'text NULL', 'textarea', '', '', 0, '', 28, 0, 1, 1438143535, 1438143535, '', 3, '', 'regex', '', 3, 'function'),
(908, 'Url', 'Url', 'varchar(255) NULL', 'string', '', '', 0, '', 28, 0, 1, 1438143558, 1438143558, '', 3, '', 'regex', '', 3, 'function'),
(909, 'collect', '收藏状态', 'tinyint(1) NULL', 'bool', '0', '', 0, '0:未收藏\r\n1:已收藏', 28, 0, 1, 1438153936, 1438153936, '', 3, '', 'regex', '', 3, 'function'),
(910, 'deal', '处理状态', 'tinyint(1) NULL', 'bool', '0', '', 0, '0:未处理\r\n1:已处理', 28, 0, 1, 1438165005, 1438153991, '', 3, '', 'regex', '', 3, 'function'),
(911, 'is_read', '是否已读', 'tinyint(1) NULL', 'bool', '0', '', 1, '0:未读\r\n1:已读', 28, 0, 1, 1438165062, 1438165062, '', 3, '', 'regex', '', 3, 'function'),
(912, 'type', '消息分类', 'tinyint(1) NULL', 'bool', '0', '', 1, '0:用户消息\r\n1:管理员回复消息', 28, 0, 1, 1438168301, 1438168301, '', 3, '', 'regex', '', 3, 'function'),
(1062, 'login_name', 'login_name', 'varchar(100) NULL', 'string', '', '', 1, '', 1, 0, 1, 1447302647, 1439978705, '', 3, '', 'regex', '', 3, 'function'),
(1063, 'content', '文本消息内容', 'text NULL', 'textarea', '', '', 0, '', 18, 0, 1, 1439980070, 1439980070, '', 3, '', 'regex', '', 3, 'function'),
(1071, 'is_bind', '是否为微信开放平台绑定账号', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:否\r\n1:是', 6, 0, 1, 1440746890, 1440746890, '', 3, '', 'regex', '', 3, 'function'),
(1101, 'url', '图文页url', 'varchar(255) NULL', 'string', '', '', 0, '', 17, 0, 1, 1441077355, 1441077355, '', 3, '', 'regex', '', 3, 'function'),
(1825, 'ToUserName', 'token', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447241964, 1447241964, '', 3, '', 'regex', '', 3, 'function'),
(1826, 'FromUserName', 'openid', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242006, 1447242006, '', 3, '', 'regex', '', 3, 'function'),
(1827, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 1, '', 29, 0, 1, 1447242030, 1447242030, '', 3, '', 'regex', '', 3, 'function'),
(1828, 'msgType', '消息类型', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242059, 1447242059, '', 3, '', 'regex', '', 3, 'function'),
(1829, 'manager_id', '管理员id', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242090, 1447242090, '', 3, '', 'regex', '', 3, 'function'),
(1830, 'content', '内容', 'text NULL', 'textarea', '', '', 1, '', 29, 0, 1, 1447242120, 1447242120, '', 3, '', 'regex', '', 3, 'function'),
(1831, 'media_id', '多媒体文件id', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242146, 1447242146, '', 3, '', 'regex', '', 3, 'function'),
(1832, 'is_send', '是否已经发送', 'int(10) NULL', 'num', '', '', 1, '0:未发\r\n1:已发', 29, 0, 1, 1447242181, 1447242181, '', 3, '', 'regex', '', 3, 'function'),
(1833, 'uid', '粉丝uid', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242202, 1447242202, '', 3, '', 'regex', '', 3, 'function'),
(1834, 'news_group_id', '图文组id', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242229, 1447242229, '', 3, '', 'regex', '', 3, 'function'),
(1835, 'video_title', '视频标题', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242267, 1447242267, '', 3, '', 'regex', '', 3, 'function'),
(1836, 'video_description', '视频描述', 'text NULL', 'textarea', '', '', 1, '', 29, 0, 1, 1447242291, 1447242291, '', 3, '', 'regex', '', 3, 'function'),
(1837, 'video_thumb', '视频缩略图', 'varchar(255) NULL', 'string', '', '', 1, '', 29, 0, 1, 1447242366, 1447242366, '', 3, '', 'regex', '', 3, 'function'),
(1844, 'voice_id', '语音id', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242400, 1447242400, '', 3, '', 'regex', '', 3, 'function'),
(1845, 'image_id', '图片id', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242440, 1447242440, '', 3, '', 'regex', '', 3, 'function'),
(1846, 'video_id', '视频id', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242464, 1447242464, '', 3, '', 'regex', '', 3, 'function'),
(1847, 'send_type', '发送方式', 'int(10) NULL', 'num', '', '', 1, '0:分组\r\n1:指定用户', 29, 0, 1, 1447242498, 1447242498, '', 3, '', 'regex', '', 3, 'function'),
(1848, 'send_opends', '指定用户', 'text NULL', 'textarea', '', '', 1, '', 29, 0, 1, 1447242529, 1447242529, '', 3, '', 'regex', '', 3, 'function'),
(1849, 'group_id', '分组id', 'int(10) NULL', 'num', '', '', 1, '', 29, 0, 1, 1447242553, 1447242553, '', 3, '', 'regex', '', 3, 'function'),
(1850, 'diff', '区分消息标识', 'int(10) NULL', 'num', '0', '', 1, '', 29, 0, 1, 1447242584, 1447242584, '', 3, '', 'regex', '', 3, 'function'),
(1326, 'content', '文本内容', 'text NULL', 'textarea', '', '', 1, '', 30, 1, 1, 1442976151, 1442976151, '', 3, '', 'regex', '', 3, 'function'),
(1327, 'token', 'Token', 'varchar(50) NULL', 'string', '', '', 0, '', 30, 0, 1, 1442978004, 1442978004, '', 3, '', 'regex', 'get_token', 1, 'function'),
(1328, 'uid', 'uid', 'int(10) NULL', 'num', '', '', 0, '', 30, 0, 1, 1442978041, 1442978041, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(1820, 'is_use', '可否使用', 'int(10) NULL', 'num', '1', '', 0, '0:不可用\r\n1:可用', 30, 0, 1, 1445496947, 1445496947, '', 3, '', 'regex', '', 3, 'function'),
(1821, 'aim_id', '添加来源标识id', 'int(10) NULL', 'num', '', '', 0, '', 30, 0, 1, 1445497010, 1445497010, '', 3, '', 'regex', '', 3, 'function'),
(1822, 'aim_table', '来源表名', 'varchar(255) NULL', 'string', '', '', 0, '', 30, 0, 1, 1445497218, 1445497218, '', 3, '', 'regex', '', 3, 'function'),
(1329, 'file_id', '上传文件', 'int(10) NULL', 'file', '', '', 1, '', 31, 0, 1, 1442982169, 1438684652, '', 3, '', 'regex', '', 3, 'function'),
(1330, 'cover_url', '本地URL', 'varchar(255) NULL', 'string', '', '', 0, '', 31, 0, 1, 1438684692, 1438684692, '', 3, '', 'regex', '', 3, 'function'),
(1331, 'media_id', '微信端图文消息素材的media_id', 'varchar(100) NULL', 'string', '0', '', 0, '', 31, 0, 1, 1438744962, 1438684776, '', 3, '', 'regex', '', 3, 'function'),
(1332, 'wechat_url', '微信端的文件地址', 'varchar(255) NULL', 'string', '', '', 0, '', 31, 0, 1, 1439973558, 1438684807, '', 3, '', 'regex', '', 3, 'function'),
(1333, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 31, 0, 1, 1443004484, 1438684829, '', 3, '', 'regex', 'time', 1, 'function'),
(1334, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 31, 0, 1, 1442982446, 1438684847, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(1335, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 31, 0, 1, 1442982460, 1438684865, '', 3, '', 'regex', 'get_token', 1, 'function'),
(1336, 'title', '素材名称', 'varchar(100) NULL', 'string', '', '', 1, '', 31, 0, 1, 1442981165, 1442981165, '', 3, '', 'regex', '', 3, 'function'),
(1341, 'type', '类型', 'int(10) NULL', 'num', '', '', 0, '1:语音素材\r\n2:视频素材', 31, 0, 1, 1445599238, 1443006101, '', 3, '', 'regex', '', 3, 'function'),
(1838, 'introduction', '描述', 'text NULL', 'textarea', '', '', 0, '', 31, 0, 1, 1447299133, 1445684769, '', 3, '', 'regex', '', 3, 'function'),
(1121, 'level', '管理等级', 'tinyint(2) NULL', 'num', '0', '', 0, '', 1, 0, 1, 1441522953, 1441522953, '', 3, '', 'regex', '', 3, 'function'),
(1112, 'login_password', '登录密码', 'varchar(255) NULL', 'string', '', '', 1, '', 1, 0, 1, 1441187439, 1441187439, '', 3, '', 'regex', '', 3, 'function');
INSERT INTO `dc_attribute` (`id`, `name`, `title`, `field`, `type`, `value`, `remark`, `is_show`, `extra`, `model_id`, `is_must`, `status`, `update_time`, `create_time`, `validate_rule`, `validate_time`, `error_info`, `validate_type`, `auto_rule`, `auto_time`, `auto_type`) VALUES
(1114, 'manager_id', '公众号管理员ID', 'int(10) NULL', 'num', '0', '', 0, '', 1, 0, 1, 1441512815, 1441512815, '', 3, '', 'regex', '', 3, 'function'),
(1155, 'membership', '会员等级', 'char(50) NULL', 'select', '0', '请在会员等级 添加会员级别名称', 0, '', 1, 0, 1, 1447302405, 1441795509, '', 3, '', 'regex', '', 3, 'function'),
(1542, 'score', '修改积分', 'int(10) NULL', 'num', '', '', 1, '', 32, 1, 1, 1444302622, 1444302410, '', 3, '', 'regex', '', 3, 'function'),
(1543, 'branch_id', '修改门店', 'int(10) NULL', 'num', '', '', 1, '', 32, 0, 1, 1444302450, 1444302450, '', 3, '', 'regex', '', 3, 'function'),
(1544, 'operator', '操作员', 'varchar(255) NULL', 'string', '', '', 1, '', 32, 0, 1, 1444302474, 1444302474, '', 3, '', 'regex', '', 3, 'function'),
(1545, 'cTime', '修改时间', 'int(10) NULL', 'datetime', '', '', 0, '', 32, 0, 1, 1444302508, 1444302508, '', 3, '', 'regex', 'time', 3, 'function'),
(1546, 'token', 'token', 'varchar(255) NULL', 'string', '', '', 1, '', 32, 0, 1, 1444302539, 1444302539, '', 3, '', 'regex', 'get_token', 3, 'function'),
(1547, 'member_id', '会员卡id', 'int(10) NULL', 'num', '', '', 4, '', 32, 0, 1, 1444302566, 1444302566, '', 3, '', 'regex', '', 3, 'function'),
(1548, 'manager_id', '管理员id', 'int(10) NULL', 'num', '', '', 1, '', 32, 0, 1, 1444302595, 1444302595, '', 3, '', 'regex', 'get_mid', 3, 'function'),
(1663, 'credit_title', '积分标题', 'varchar(50) NULL', 'string', '', '', 0, '', 15, 0, 1, 1444731976, 1444731976, '', 3, '', 'regex', '', 3, 'function'),
(1823, 'is_material', '设置为文本素材', 'int(10) NULL', 'num', '0', '', 0, '0:不设置\r\n1:设置', 28, 0, 1, 1445497359, 1445497359, '', 3, '', 'regex', '', 3, 'function'),
(1824, 'admin_uid', '核销管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 81, 0, 1, 1445504807, 1445504807, '', 3, '', 'regex', '', 3, 'function'),
(1839, 'msgtype', '消息类型', 'varchar(255) NULL', 'string', '', '', 1, '', 18, 0, 1, 1445833955, 1445833955, '', 3, '', 'regex', '', 3, 'function'),
(1840, 'token', 'token', 'varchar(255) NULL', 'string', '', '', 1, '', 18, 0, 1, 1445834006, 1445834006, '', 3, '', 'regex', 'get_token', 3, 'function'),
(1841, 'appmsg_id', '图文id', 'int(10) NULL', 'num', '', '', 1, '', 18, 0, 1, 1445840292, 1445834101, '', 3, '', 'regex', '', 3, 'function'),
(1842, 'voice_id', '语音id', 'int(10) NULL', 'num', '', '', 1, '', 18, 0, 1, 1445834144, 1445834144, '', 3, '', 'regex', '', 3, 'function'),
(1843, 'video_id', '视频id', 'int(10) NULL', 'num', '', '', 1, '', 18, 0, 1, 1445834174, 1445834174, '', 3, '', 'regex', '', 3, 'function'),
(1851, 'cTime', '群发时间', 'int(10) NULL', 'datetime', '', '', 1, '', 18, 0, 1, 1445856491, 1445856442, '', 3, '', 'regex', 'time', 3, 'function'),
(11242, 'is_use', '可否使用', 'int(10) NULL', 'num', '1', '', 0, '0:不可用\r\n1:可用', 31, 0, 1, 1447405173, 1447403730, '', 3, '', 'regex', '', 3, 'function'),
(11243, 'aim_id', '添加来源标识id', 'int(10) NULL', 'num', '', '', 0, '', 31, 0, 1, 1447404930, 1447404930, '', 3, '', 'regex', '', 3, 'function'),
(11244, 'aim_table', '来源表名', 'varchar(255) NULL', 'string', '', '', 1, '', 31, 0, 1, 1447405156, 1447405156, '', 3, '', 'regex', '', 3, 'function'),
(11245, 'is_use', '可否使用', 'int(10) NULL', 'num', '1', '', 0, '0:不可用\r\n1:可用', 16, 0, 1, 1447405234, 1447405234, '', 3, '', 'regex', '', 3, 'function'),
(11246, 'aim_id', '添加来源标识id', 'int(10) NULL', 'num', '', '', 0, '', 16, 0, 1, 1447405283, 1447405283, '', 3, '', 'regex', '', 3, 'function'),
(11247, 'aim_table', '来源表名', 'varchar(255) NULL', 'string', '', '', 1, '', 16, 0, 1, 1447405301, 1447405301, '', 3, '', 'regex', '', 3, 'function'),
(11248, 'is_use', '可否使用', 'int(10) NULL', 'num', '1', '', 0, '0:不可用\r\n1:可用', 17, 0, 1, 1447405553, 1447405510, '', 3, '', 'regex', '', 3, 'function'),
(11249, 'aim_id', '添加来源标识id', 'int(10) NULL', 'num', '', '', 0, '', 17, 0, 1, 1447405545, 1447405545, '', 3, '', 'regex', '', 3, 'function'),
(11250, 'aim_table', '来源表名', 'varchar(255) NULL', 'string', '', '', 0, '', 17, 0, 1, 1447405577, 1447405577, '', 3, '', 'regex', '', 3, 'function'),
(12088, 'keyword', '关键词', 'varchar(50) NOT NULL', 'string', '', '用户在微信里回复此关键词将会触发此投票。', 1, '', 1232, 1, 1, 1392969972, 1388930888, 'keyword_unique', 1, '此关键词已经存在，请换成别的关键词再试试', 'function', '', 3, 'function'),
(12089, 'title', '投票标题', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1232, 1, 1, 1388931041, 1388931041, '', 3, '', 'regex', '', 3, 'function'),
(12090, 'description', '投票描述', 'text NULL', 'textarea', '', '', 1, '', 1232, 0, 1, 1400633517, 1388931173, '', 3, '', 'regex', '', 3, 'function'),
(12091, 'picurl', '封面图片', 'int(10) unsigned NULL ', 'picture', '', '支持JPG、PNG格式，较好的效果为大图360*200，小图200*200', 1, '', 1232, 0, 1, 1388931285, 1388931285, '', 3, '', 'regex', '', 3, 'function'),
(12092, 'type', '选择类型', 'char(10) NOT NULL', 'radio', '0', '', 0, '0:单选\r\n1:多选', 1232, 1, 1, 1430376146, 1388931487, '', 3, '', 'regex', '', 3, 'function'),
(12093, 'start_date', '开始日期', 'int(10) NULL', 'datetime', '', '', 1, '', 1232, 0, 1, 1388931734, 1388931734, '', 3, '', 'regex', '', 3, 'function'),
(12094, 'end_date', '结束日期', 'int(10) NULL', 'datetime', '', '', 1, '', 1232, 0, 1, 1388931769, 1388931769, '', 3, '', 'regex', '', 3, 'function'),
(12095, 'is_img', '文字/图片投票', 'tinyint(2) NULL', 'radio', '0', '', 0, '0:文字投票\r\n1:图片投票', 1232, 1, 1, 1389081985, 1388931941, '', 3, '', 'regex', '', 3, 'function'),
(12096, 'vote_count', '投票数', 'int(10) unsigned NULL ', 'num', '0', '', 0, '', 1232, 0, 1, 1388932035, 1388932035, '', 3, '', 'regex', '', 3, 'function'),
(12097, 'cTime', '投票创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1232, 1, 1, 1388932128, 1388932128, '', 1, '', 'regex', 'time', 3, 'function'),
(12098, 'mTime', '更新时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1232, 0, 1, 1430379170, 1390634006, '', 3, '', 'regex', 'time', 1, 'function'),
(12099, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1232, 0, 1, 1391397388, 1391397388, '', 3, '', 'regex', '', 3, 'function'),
(12100, 'template', '素材模板', 'varchar(255) NULL', 'string', 'default', '', 1, '', 1232, 0, 1, 1430188739, 1430188739, '', 3, '', 'regex', '', 3, 'function'),
(12101, 'vote_id', '投票ID', 'int(10) unsigned NULL ', 'num', '', '', 1, '', 1233, 1, 1, 1429846753, 1388934189, '', 3, '', 'regex', '', 3, 'function'),
(12102, 'user_id', '用户ID', 'int(10) NULL ', 'num', '', '', 1, '', 1233, 1, 1, 1429855665, 1388934265, '', 3, '', 'regex', '', 3, 'function'),
(12103, 'token', '用户TOKEN', 'varchar(255) NULL', 'string', '', '', 0, '', 1233, 1, 1, 1429855713, 1388934296, '', 3, '', 'regex', '', 3, 'function'),
(12104, 'options', '选择选项', 'varchar(255) NULL', 'string', '', '', 1, '', 1233, 1, 1, 1429855086, 1388934351, '', 3, '', 'regex', '', 3, 'function'),
(12105, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1233, 0, 1, 1429874378, 1388934392, '', 3, '', 'regex', '', 3, 'function'),
(12106, 'order', '选项排序', 'int(10) unsigned NULL ', 'num', '0', '', 1, '', 1234, 0, 1, 1388933951, 1388933951, '', 3, '', 'regex', '', 3, 'function'),
(12107, 'opt_count', '当前选项投票数', 'int(10) unsigned NULL ', 'num', '0', '', 1, '', 1234, 0, 1, 1429861248, 1388933860, '', 3, '', 'regex', '', 3, 'function'),
(12108, 'image', '图片选项', 'int(10) unsigned NULL ', 'picture', '', '', 5, '', 1234, 0, 1, 1388984467, 1388933679, '', 3, '', 'regex', '', 3, 'function'),
(12109, 'name', '选项标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1234, 1, 1, 1388933552, 1388933552, '', 3, '', 'regex', '', 3, 'function'),
(12110, 'vote_id', '投票ID', 'int(10) unsigned NOT NULL ', 'num', '', '', 4, '', 1234, 1, 1, 1388982678, 1388933478, '', 3, '', 'regex', '$_REQUEST[''vote_id'']', 3, 'string'),
(12115, 'keyword', '关键词', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1235, 1, 1, 1396061575, 1396061575, '', 3, '', 'regex', '', 3, 'function'),
(12116, 'keyword_type', '关键词类型', 'tinyint(2) NULL', 'select', '', '', 1, '0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配\r\n4:正则匹配\r\n5:随机匹配', 1235, 0, 1, 1396061814, 1396061765, '', 3, '', 'regex', '', 3, 'function'),
(12117, 'title', '标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1235, 1, 1, 1396061877, 1396061859, '', 3, '', 'regex', '', 3, 'function'),
(12118, 'intro', '简介', 'text NULL', 'textarea', '', '', 1, '', 1235, 0, 1, 1396061947, 1396061947, '', 3, '', 'regex', '', 3, 'function'),
(12119, 'cate_id', '所属类别', 'int(10) unsigned NULL ', 'select', '0', '要先在微官网分类里配置好分类才可选择', 1, '0:请选择分类', 1235, 0, 1, 1396078914, 1396062003, '', 3, '', 'regex', '', 3, 'function'),
(12120, 'cover', '封面图片', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 1235, 0, 1, 1396062093, 1396062093, '', 3, '', 'regex', '', 3, 'function'),
(12121, 'content', '内容', 'text NULL', 'editor', '', '', 1, '', 1235, 0, 1, 1396062146, 1396062146, '', 3, '', 'regex', '', 3, 'function'),
(12122, 'cTime', '发布时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1235, 0, 1, 1396075102, 1396075102, '', 3, '', 'regex', 'time', 1, 'function'),
(12123, 'sort', '排序号', 'int(10) unsigned NULL ', 'num', '0', '数值越小越靠前', 1, '', 1235, 0, 1, 1396510508, 1396510508, '', 3, '', 'regex', '', 3, 'function'),
(12124, 'view_count', '浏览数', 'int(10) unsigned NULL ', 'num', '0', '', 0, '', 1235, 0, 1, 1396510630, 1396510630, '', 3, '', 'regex', '', 3, 'function'),
(12125, 'title', '分类标题', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1236, 1, 1, 1408950771, 1395988016, '', 3, '', 'regex', '', 3, 'function'),
(12126, 'icon', '分类图片', 'int(10) unsigned NULL ', 'picture', '', '', 1, '', 1236, 0, 1, 1395988966, 1395988966, '', 3, '', 'regex', '', 3, 'function'),
(12127, 'url', '外链', 'varchar(255) NULL', 'string', '', '为空时默认跳转到该分类的文章列表页面', 1, '', 1236, 0, 1, 1401408363, 1395989660, '', 3, '', 'regex', '', 3, 'function'),
(12128, 'is_show', '显示', 'tinyint(2) NULL', 'bool', '1', '', 1, '0: 不显示\r\n1: 显示', 1236, 0, 1, 1395989709, 1395989709, '', 3, '', 'regex', '', 3, 'function'),
(12129, 'token', 'Token', 'varchar(100) NULL ', 'string', '', '', 0, '', 1236, 0, 1, 1395989760, 1395989760, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12130, 'sort', '排序号', 'int(10) NULL ', 'num', '0', '数值越小越靠前', 1, '', 1236, 0, 1, 1396340334, 1396340334, '', 3, '', 'regex', '', 3, 'function'),
(12131, 'pid', '一级目录', 'int(10) NULL', 'cascade', '0', '', 1, 'type=db&table=weisite_category&pid=id', 1236, 0, 1, 1439522271, 1439469294, '', 3, '', 'regex', '', 3, 'function'),
(12132, 'title', '标题', 'varchar(255) NULL', 'string', '', '可为空', 1, '', 1237, 0, 1, 1396098316, 1396098316, '', 3, '', 'regex', '', 3, 'function'),
(12133, 'img', '图片', 'int(10) unsigned NOT NULL ', 'picture', '', '', 1, '', 1237, 1, 1, 1396098349, 1396098349, '', 3, '', 'regex', '', 3, 'function'),
(12134, 'url', '链接地址', 'varchar(255) NULL', 'string', '', '', 1, '', 1237, 0, 1, 1396098380, 1396098380, '', 3, '', 'regex', '', 3, 'function'),
(12135, 'is_show', '是否显示', 'tinyint(2) NULL', 'bool', '1', '', 1, '0:不显示\r\n1:显示', 1237, 0, 1, 1396098464, 1396098464, '', 3, '', 'regex', '', 3, 'function'),
(12136, 'sort', '排序', 'int(10) unsigned NULL ', 'num', '0', '值越小越靠前', 1, '', 1237, 0, 1, 1396098682, 1396098682, '', 3, '', 'regex', '', 3, 'function'),
(12137, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 1237, 0, 1, 1396098747, 1396098747, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12138, 'url', '关联URL', 'varchar(255) NULL ', 'string', '', '', 1, '', 1238, 0, 1, 1394519090, 1394519090, '', 3, '', 'regex', '', 3, 'function'),
(12139, 'title', '菜单名', 'varchar(50) NOT NULL', 'string', '', '可创建最多 3 个一级菜单，每个一级菜单下可创建最多 5 个二级菜单。编辑中的菜单不会马上被用户看到，请放心调试。', 1, '', 1238, 1, 1, 1408950832, 1394518988, '', 3, '', 'regex', '', 3, 'function'),
(12140, 'pid', '一级菜单', 'tinyint(2) NULL', 'select', '0', '如果是一级菜单，选择“无”即可', 1, '0:无', 1238, 0, 1, 1409045931, 1394518930, '', 3, '', 'regex', '', 3, 'function'),
(12141, 'sort', '排序号', 'tinyint(4) NULL ', 'num', '0', '数值越小越靠前', 1, '', 1238, 0, 1, 1394523288, 1394519175, '', 3, '', 'regex', '', 3, 'function'),
(12142, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1238, 0, 1, 1394526820, 1394526820, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12143, 'icon', '图标', 'int(10) unsigned NULL ', 'picture', '', '根据选择的底部模板决定是否需要上传图标', 1, '', 1238, 0, 1, 1396506297, 1396506297, '', 3, '', 'regex', '', 3, 'function'),
(12144, 'keyword', '关键词', 'varchar(255) NULL', 'string', '', '多个关键词可以用空格分开，如“高富帅 白富美”', 1, '', 1239, 1, 1, 1439194858, 1439194849, '', 3, '', 'regex', '', 3, 'function'),
(12145, 'msg_type', '消息类型', 'char(50) NULL', 'select', 'text', '', 0, 'text:文本|content@show,group_id@hide,image_id@hide\r\nnews:图文|content@hide,group_id@show,image_id@hide\r\nimage:图片|content@hide,group_id@hide,image_id@show', 1239, 1, 1, 1439204529, 1439194979, '', 3, '', 'regex', '', 3, 'function'),
(12146, 'content', '文本内容', 'text NULL', 'textarea', '', '', 1, '', 1239, 0, 1, 1439195826, 1439195091, '', 3, '', 'regex', '', 3, 'function'),
(12147, 'group_id', '图文', 'int(10) NULL', 'news', '', '', 1, '', 1239, 0, 1, 1439204192, 1439195901, '', 3, '', 'regex', '', 3, 'function'),
(12148, 'image_id', '上传图片', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 1239, 0, 1, 1439195945, 1439195945, '', 3, '', 'regex', '', 3, 'function'),
(12149, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 1239, 0, 1, 1439203621, 1439203575, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(12150, 'token', 'Token', 'varchar(50) NULL', 'string', '', '', 0, '', 1239, 0, 1, 1439203612, 1439203612, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12151, 'image_material', '素材图片id', 'int(10) NULL', 'num', '', '', 0, '', 1239, 0, 1, 1447738833, 1447738833, '', 3, '', 'regex', '', 3, 'function'),
(12152, 'voice_id', '语音id', 'int(10) NULL', 'num', '0', '', 0, '', 1239, 0, 1, 1449152539, 1449150873, '', 3, '', 'regex', '', 3, 'function'),
(12153, 'video_id', '视频id', 'int(10) NULL', 'num', '0', '', 0, '', 1239, 0, 1, 1449152532, 1449150935, '', 3, '', 'regex', '', 3, 'function'),
(12154, 'reply_scene', '回复场景（0：关注时回复；1：默认回复；2：关键词回复）', 'int(10) NULL', 'num', '', '', 1, '', 1239, 0, 1, 1449154529, 1449154529, '', 3, '', 'regex', '', 3, 'function'),
(12415, 'sucai_type', '素材类型', 'char(50) NULL', 'select', '0', '', 1, '0:请选择\r\n1:图文\r\n2:文本\r\n3:图片\r\n4:语音\r\n5:视频', 1268, 0, 1, 1447208890, 1447208890, '', 3, '', 'regex', '', 3, 'function'),
(12414, 'target_id', '选择内容', 'int(10) NULL', 'num', '', '', 4, '0:请选择', 1268, 0, 1, 1447208825, 1447208825, '', 3, '', 'regex', '', 3, 'function'),
(12413, 'addon', '选择插件', 'char(50) NULL', 'select', '0', '', 1, '0:请选择', 1268, 0, 1, 1447208750, 1447208750, '', 3, '', 'regex', '', 3, 'function'),
(12412, 'from_type', '配置动作', 'char(50) NULL', 'select', '-1', '', 1, '0:站内信息|keyword@hide,url@hide,type@hide,sucai_type@hide,addon@show,jump_type@show\r\n1:站内素材|keyword@hide,url@hide,type@hide,sucai_type@show,addon@hide,jump_type@hide\r\n9:自定义|keyword@show,url@hide,type@show,addon@hide,sucai_type@hide,jump_type@hide\r\n-1:请选择|keyword@hide,url@hide,type@hide,addon@hide,sucai_type@hide,jump_type@hide', 1268, 0, 1, 1447318552, 1447208677, '', 3, '', 'regex', '', 3, 'function'),
(12408, 'keyword', '关联关键词', 'varchar(100) NULL', 'string', '', '', 1, '', 1268, 0, 1, 1416812109, 1394519054, '', 3, '', 'regex', '', 3, 'function'),
(12409, 'url', '关联URL', 'varchar(255) NULL ', 'string', '', '', 1, '', 1268, 0, 1, 1394519090, 1394519090, '', 3, '', 'regex', '', 3, 'function'),
(12410, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1268, 0, 1, 1394526820, 1394526820, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12411, 'type', '类型', 'varchar(30) NULL', 'bool', 'click', '', 1, 'click:点击推事件|keyword@show,url@hide\r\nview:跳转URL|keyword@hide,url@show\r\nscancode_push:扫码推事件|keyword@show,url@hide\r\nscancode_waitmsg:扫码带提示|keyword@show,url@hide\r\npic_sysphoto:弹出系统拍照发图|keyword@show,url@hide\r\npic_photo_or_album:弹出拍照或者相册发图|keyword@show,url@hide\r\npic_weixin:弹出微信相册发图器|keyword@show,url@hide\r\nlocation_select:弹出地理位置选择器|keyword@show,url@hide\r\nnone:无事件的一级菜单|keyword@hide,url@hide', 1268, 0, 1, 1416812039, 1416810588, '', 3, '', 'regex', '', 3, 'function'),
(12407, 'title', '菜单名', 'varchar(50) NOT NULL', 'string', '', '可创建最多 3 个一级菜单，每个一级菜单下可创建最多 5 个二级菜单。编辑中的菜单不会马上被用户看到，请放心调试。', 1, '', 1268, 1, 1, 1408951570, 1394518988, '', 3, '', 'regex', '', 3, 'function'),
(12405, 'sort', '排序号', 'tinyint(4) NULL ', 'num', '0', '数值越小越靠前', 1, '', 1268, 0, 1, 1394523288, 1394519175, '', 3, '', 'regex', '', 3, 'function'),
(12406, 'pid', '一级菜单', 'int(10) NULL', 'select', '0', '如果是一级菜单，选择“无”即可', 1, '0:无', 1268, 0, 1, 1416810279, 1394518930, '', 3, '', 'regex', '', 3, 'function'),
(12167, 'token', 'token', 'varchar(255) NULL', 'string', '', '', 0, '', 1241, 0, 1, 1404485505, 1404475530, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12168, 'groupname', '分组名称', 'varchar(255) NULL', 'string', '', '', 1, '', 1241, 0, 1, 1404475556, 1404475556, '', 3, '', 'regex', '', 3, 'function'),
(12169, 'groupdata', '分组数据源', 'text NULL', 'textarea', '', '', 0, '', 1241, 0, 1, 1404476127, 1404476127, '', 3, '', 'regex', '', 3, 'function'),
(12170, 'msgkeyword', '消息关键字', 'varchar(555) NULL', 'string', '', '当用户发送的消息中含有关键字时,将自动转到分配的客服人员', 1, '', 1242, 0, 1, 1404399336, 1404399336, '', 3, '', 'regex', '', 3, 'function'),
(12171, 'msgkeyword_type', '关键字类型', 'char(50) NULL', 'select', '3', '选择关键字匹配的类型', 1, '0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配\r\n4:正则匹配\r\n5:随机匹配', 1242, 0, 1, 1404399466, 1404399466, '', 3, '', 'regex', '', 3, 'function'),
(12172, 'msgkfaccount', '接待的客服人员', 'varchar(255) NULL', 'string', '', '', 0, '', 1242, 0, 1, 1404403340, 1404399587, '', 3, '', 'regex', '', 3, 'function'),
(12173, 'cTime', '创建时间', 'int(10) NULL', 'date', '', '', 0, '', 1242, 0, 1, 1404399629, 1404399629, '', 3, '', 'regex', 'time', 3, 'function'),
(12174, 'token', 'token', 'varchar(255) NULL', 'string', '', '', 0, '', 1242, 0, 1, 1404399656, 1404399656, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12175, 'msgstate', '关键字状态', 'tinyint(2) NULL', 'bool', '1', '停用后用户将不会触发此关键词', 1, '0:停用\r\n1:启用', 1242, 0, 1, 1404399749, 1404399749, '', 3, '', 'regex', '', 3, 'function'),
(12176, 'zjnum', '转接次数', 'int(10) NULL', 'num', '', '', 0, '', 1242, 0, 1, 1404399784, 1404399784, '', 3, '', 'regex', '', 3, 'function'),
(12177, 'zdtype', '指定类型', 'char(10) NULL', 'radio', '0', '选择关键字匹配时是按指定人员或者指定客服组', 1, '0:指定客服人员\r\n1:指定客服组', 1242, 0, 1, 1404474672, 1404474672, '', 3, '', 'regex', '', 3, 'function'),
(12178, 'kfgroupid', '客服分组id', 'int(10) NULL', 'num', '0', '', 0, '', 1242, 0, 1, 1404474777, 1404474777, '', 3, '', 'regex', '', 3, 'function'),
(12179, 'kf_explain', '客服说明', 'varchar(255) NULL', 'string', '', '客服说明', 1, '', 1242, 0, 1, 1450018523, 1450018523, '', 3, '', 'regex', '', 3, 'function'),
(12180, 'name', '客服昵称', 'varchar(60) NULL ', 'string', '', '', 1, '', 1243, 0, 1, 1403959775, 1403947255, '', 0, '', 'regex', '', 0, 'function'),
(12181, 'token', 'token', 'varchar(60) NULL ', 'string', '', '', 0, '', 1243, 0, 1, 1403959638, 1403947256, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12182, 'userName', '客服帐号', 'varchar(60) NULL ', 'string', '', '', 1, '', 1243, 0, 1, 1403959752, 1403947256, '', 3, '', 'regex', '', 0, 'function'),
(12183, 'userPwd', '客服密码', 'varchar(32) NULL ', 'string', '', '', 1, '', 1243, 0, 1, 1403959722, 1403947257, '', 0, '', 'regex', '', 0, 'function'),
(12184, 'endJoinDate', '客服加入时间', 'int(11) NULL ', 'string', '', '', 0, '', 1243, 0, 1, 1403959825, 1403947257, '', 3, '', 'regex', 'time', 3, 'function'),
(12185, 'status', '客服在线状态', 'tinyint(1) NULL ', 'bool', '0', '', 0, '0:离线\r\n1:在线', 1243, 0, 1, 1404016782, 1403947258, '', 0, '', 'regex', '', 0, 'function'),
(12186, 'state', '客服状态', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:停用\r\n1:启用', 1243, 0, 1, 1404016877, 1404016877, '', 3, '', 'regex', '', 3, 'function'),
(12187, 'isdelete', '是否删除', 'tinyint(2) NULL', 'bool', '0', '', 0, '0:正常\r\n1:已被删除', 1243, 0, 1, 1404016931, 1404016931, '', 3, '', 'regex', '', 3, 'function'),
(12188, 'kfid', '客服编号', 'varchar(255) NULL', 'string', '', '', 1, '', 1243, 0, 1, 1404398387, 1404398387, '', 3, '', 'regex', '', 3, 'function'),
(12189, 'openid', 'openid', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1244, 0, 1, 1409247462, 1409247462, '', 3, '', 'regex', '', 3, 'function'),
(12190, 'template_id', '模板ID', 'varchar(500) NOT NULL', 'string', '', '', 1, '', 1244, 0, 1, 1409247489, 1409247489, '', 3, '', 'regex', '', 3, 'function'),
(12191, 'message', '消息内容', 'text NOT NULL', 'textarea', '', '', 1, '', 1244, 0, 1, 1409247512, 1409247512, '', 3, '', 'regex', '', 3, 'function'),
(12192, 'MsgID', '消息ID', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1244, 0, 1, 1409247552, 1409247552, '', 3, '', 'regex', '', 3, 'function'),
(12193, 'sendstatus', '发送状态', 'char(50) NOT NULL', 'select', '', '', 1, '0:成功\r\n1:失败', 1244, 0, 1, 1409247862, 1409247608, '', 3, '', 'regex', '', 3, 'function'),
(12194, 'Status', '送达报告', 'char(50) NOT NULL', 'select', '', '', 1, '0:成功\r\n1:失败：用户拒收\r\n2:失败：其他原因', 1244, 0, 1, 1409247873, 1409247697, '', 3, '', 'regex', '', 3, 'function'),
(12195, 'token', 'token', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1244, 0, 1, 1409247732, 1409247713, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12196, 'ctime', '发送时间', 'int(10) NOT NULL', 'datetime', '', '', 1, '', 1244, 0, 1, 1409247759, 1409247759, '', 3, '', 'regex', 'time', 3, 'function'),
(12203, 'token', '公众号Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1246, 0, 1, 1448517984, 1448517984, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12204, 'scene_name', '场景名称', 'varchar(255) NULL', 'string', '', '', 1, '', 1246, 1, 1, 1448518657, 1448518006, '', 3, '', 'regex', '', 3, 'function'),
(12205, 'keyword', '关联关键词', 'varchar(255) NULL', 'string', '', '', 1, '', 1246, 0, 1, 1448518039, 1448518039, '', 3, '', 'regex', '', 3, 'function'),
(12206, 'scene_type', '二维码类型', 'char(10) NULL', 'radio', '0', '', 1, '0:临时二维码\r\n1:永久二维码', 1246, 0, 1, 1448518150, 1448518150, '', 3, '', 'regex', '', 3, 'function'),
(12207, 'scene_id', '场景值ID', 'int(32) NULL', 'num', '', '', 0, '', 1246, 0, 1, 1448518272, 1448518252, '', 3, '', 'regex', '', 3, 'function'),
(12208, 'scene_str', '场景值字符串', 'varchar(255) NULL', 'string', '', '临时二维码不用填。永久二维码填写字符串或汉字，也可以不填。', 1, '', 1246, 0, 1, 1448518467, 1448518467, '', 3, '', 'regex', '', 3, 'function'),
(12209, 'expire', '过期时间', 'int(10) NULL', 'num', '', '以秒为单位， 最大不超过604800（即7天）。 只对临时二维码有效，永久二维码不用填。', 1, '', 1246, 0, 1, 1448526699, 1448518643, '', 3, '', 'regex', '', 3, 'function'),
(12210, 'ticket', '二维码Ticket', 'varchar(255) NULL', 'string', '', '', 0, '', 1246, 0, 1, 1448519266, 1448519266, '', 3, '', 'regex', '', 3, 'function'),
(12211, 'url', '二维码图片解析后的地址', 'varchar(255) NULL', 'string', '', '', 0, '', 1246, 0, 1, 1448519304, 1448519304, '', 3, '', 'regex', '', 3, 'function'),
(12212, 'ctime', '二维码创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1246, 0, 1, 1448519406, 1448519406, '', 3, '', 'regex', 'time', 3, 'function'),
(12213, 'short_url', '二维码短地址', 'varchar(255) NULL', 'string', '', '', 0, '', 1246, 0, 1, 1448526642, 1448524998, '', 3, '', 'regex', '', 3, 'function'),
(12214, 'token', '公众号Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1247, 0, 1, 1448529447, 1448529447, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12215, 'openid', '扫码者openid', 'varchar(255) NULL', 'string', '', '', 0, '', 1247, 0, 1, 1448529507, 1448529507, '', 3, '', 'regex', 'get_openid', 3, 'function'),
(12216, 'scene_name', '场景名称', 'varchar(255) NULL', 'string', '', '', 1, '', 1247, 0, 1, 1448529541, 1448529541, '', 3, '', 'regex', '', 3, 'function'),
(12217, 'keyword', '关联关键词', 'varchar(255) NULL', 'string', '', '', 1, '', 1247, 0, 1, 1448529562, 1448529562, '', 3, '', 'regex', '', 3, 'function'),
(12218, 'scene_id', '场景ID/场景字符串', 'varchar(255) NULL', 'string', '', '', 1, '', 1247, 0, 1, 1448529722, 1448529722, '', 3, '', 'regex', '', 3, 'function'),
(12219, 'scan_type', '扫描类型', 'varchar(255) NULL', 'string', '', '', 1, '', 1247, 0, 1, 1448529758, 1448529758, '', 3, '', 'regex', '', 3, 'function'),
(12220, 'ctime', '扫描时间', 'int(10) NULL', 'datetime', '', '', 1, '', 1247, 0, 1, 1448529808, 1448529808, '', 3, '', 'regex', '', 3, 'function'),
(12221, 'qrcode_id', '二维码ID', 'int(10) NULL', 'num', '', '', 0, '', 1247, 0, 1, 1448534367, 1448533103, '', 3, '', 'regex', '', 3, 'function'),
(12222, 'title', '商店名称', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1248, 1, 1, 1422671603, 1422671261, '', 3, '', 'regex', '', 3, 'function'),
(12223, 'logo', '商店LOGO', 'int(10) NULL', 'picture', '', '', 1, '', 1248, 0, 1, 1422950521, 1422671295, '', 3, '', 'regex', '', 3, 'function'),
(12224, 'intro', '店铺简介', 'text NULL', 'textarea', '', '', 1, '', 1248, 0, 1, 1422671570, 1422671345, '', 3, '', 'regex', '', 3, 'function'),
(12225, 'mobile', '联系电话', 'varchar(30) NULL', 'string', '', '', 1, '', 1248, 0, 1, 1422671410, 1422671410, '', 3, '', 'regex', '', 3, 'function'),
(12226, 'qq', 'QQ', 'int(10) NULL', 'num', '', '', 1, '', 1248, 0, 1, 1422671498, 1422671498, '', 3, '', 'regex', '', 3, 'function'),
(12227, 'wechat', '微信', 'varchar(50) NULL', 'string', '', '', 1, '', 1248, 0, 1, 1422671544, 1422671544, '', 3, '', 'regex', '', 3, 'function'),
(12228, 'template', '模板', 'varchar(30) NULL', 'string', '', '', 0, '', 1248, 0, 1, 1422950165, 1422950165, '', 3, '', 'regex', '', 3, 'function'),
(12229, 'content', '店铺介绍', 'text  NULL', 'editor', '', '', 1, '', 1248, 0, 1, 1423108654, 1423108654, '', 3, '', 'regex', '', 3, 'function'),
(12230, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 1248, 0, 1, 1439456512, 1439455806, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12231, 'manager_id', '管理员ID', 'int(10) NULL', 'num', '', '', 0, '', 1248, 0, 1, 1439456496, 1439455828, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(12232, 'cover', '商品封面图', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 1249, 0, 1, 1431071756, 1422672306, '', 3, '', 'regex', '', 3, 'function'),
(12233, 'content', '商品介绍', 'text NOT NULL', 'editor', '', '', 1, '', 1249, 0, 1, 1422672255, 1422672255, '', 3, '', 'regex', '', 3, 'function'),
(12234, 'title', '商品名称', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1249, 1, 1, 1422672113, 1422672113, '', 3, '', 'regex', '', 3, 'function'),
(12235, 'price', '价格', 'decimal(10,2) NULL', 'num', '0', '', 1, '', 1249, 0, 1, 1439468076, 1422672186, '', 3, '', 'regex', '', 3, 'function'),
(12236, 'imgs', '商品图片', 'varchar(255) NOT NULL', 'mult_picture', '', '可以上传多个图片', 1, '', 1249, 0, 1, 1438331467, 1422672449, '', 3, '', 'regex', '', 3, 'function'),
(12237, 'inventory', '库存数量', 'int(10) NULL', 'num', '0', '', 1, '', 1249, 0, 1, 1422935578, 1422672560, '', 3, '', 'regex', '', 3, 'function'),
(12238, 'shop_id', '商店ID', 'int(10) NULL', 'num', '0', '', 4, '', 1249, 0, 1, 1422934861, 1422931951, '', 3, '', 'regex', '', 3, 'function'),
(12239, 'is_show', '是否上架', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:否\r\n1:是', 1249, 0, 1, 1422935533, 1422935533, '', 3, '', 'regex', '', 3, 'function'),
(12240, 'sale_count', '销售量', 'int(10) NULL', 'num', '0', '', 0, '', 1249, 0, 1, 1422935712, 1422935600, '', 3, '', 'regex', '', 3, 'function'),
(12241, 'is_recommend', '是否推荐', 'tinyint(2) NULL', 'bool', '', '推荐后首页的推荐商品里显示', 1, '0:否\r\n1:是', 1249, 0, 1, 1423107236, 1423107213, '', 3, '', 'regex', '', 3, 'function'),
(12242, 'rank', '热销度', 'int(10) NULL', 'num', '0', '热销度由发布时间、推荐状态、销量三个维度进行计算得到', 0, '', 1249, 0, 1, 1423474955, 1423126715, '', 3, '', 'regex', '', 3, 'function'),
(12243, 'show_time', '上架时间', 'int(10) NULL', 'datetime', '0', '', 0, '', 1249, 0, 1, 1423127849, 1423127833, '', 3, '', 'regex', 'time', 3, 'function'),
(12244, 'old_price', '原价', 'int(10) NULL', 'num', '', '', 1, '', 1249, 0, 1, 1423132272, 1423132272, '', 3, '', 'regex', '', 3, 'function'),
(12245, 'type', '商品类型', 'tinyint(2) NULL', 'bool', '0', '注：虚拟商品不支持货到付款', 0, '0:实物商品（需要快递）\r\n1:虚拟商品（不需要快递）', 1249, 0, 1, 1439549244, 1439458735, '', 3, '', 'regex', '', 3, 'function'),
(12246, 'category_id', '商品分类', 'char(50) NULL', 'select', '', '', 1, '', 1249, 0, 1, 1440126604, 1440066901, '', 3, '', 'regex', '', 3, 'function'),
(12247, 'uid', '使用UID', 'int(10) NULL', 'num', '', '', 0, '', 1250, 0, 1, 1423471296, 1423471296, '', 3, '', 'regex', '', 3, 'function'),
(12248, 'goods_id', '商品ID', 'int(10) NULL', 'num', '', '', 0, '', 1250, 0, 1, 1423471321, 1423471321, '', 3, '', 'regex', '', 3, 'function'),
(12249, 'cTime', '收藏时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1250, 0, 1, 1423471348, 1423471348, '', 3, '', 'regex', '', 3, 'function'),
(12250, 'uid', '用户ID', 'int(10) UNSIGNED NOT NULL', 'num', '', '', 0, '', 1251, 0, 1, 1419577913, 1419577913, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(12251, 'shop_id', '商店id', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1251, 0, 1, 1419578098, 1419577949, '', 3, '', 'regex', '', 3, 'function'),
(12252, 'goods_id', '商品id', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1251, 0, 1, 1419578025, 1419578025, '', 3, '', 'regex', '', 3, 'function'),
(12253, 'num', '数量', 'int(10) UNSIGNED NOT NULL', 'num', '', '', 1, '', 1251, 0, 1, 1419578075, 1419578075, '', 3, '', 'regex', '', 3, 'function'),
(12254, 'price', '单价', 'varchar(30) NOT NULL', 'num', '', '', 0, '', 1251, 0, 1, 1419578162, 1419578154, '', 3, '', 'regex', '', 3, 'function'),
(12255, 'goods_type', '商品类型', 'tinyint(2) NOT NULL', 'bool', '0', '', 1, '', 1251, 0, 1, 1420551825, 1420551825, '', 3, '', 'regex', '', 3, 'function'),
(12256, 'openid', 'openid', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1251, 0, 1, 1420195356, 1420195356, '', 3, '', 'regex', 'get_openid', 3, 'function'),
(12257, 'uid', '用户ID', 'int(10) NULL', 'num', '', '', 0, '', 1252, 1, 1, 1429522999, 1423477509, '', 3, '', 'regex', 'get_mid', 3, 'function'),
(12258, 'truename', '收货人姓名', 'varchar(100) NULL', 'string', '', '', 1, '', 1252, 1, 1, 1423477690, 1423477548, '', 3, '', 'regex', '', 3, 'function'),
(12259, 'mobile', '手机号码', 'varchar(50) NULL', 'string', '', '', 1, '', 1252, 1, 1, 1423477580, 1423477580, '', 3, '', 'regex', '', 3, 'function'),
(12260, 'city', '城市', 'varchar(255) NULL', 'cascade', '', '', 1, 'module=city', 1252, 1, 1, 1423477660, 1423477660, '', 3, '', 'regex', '', 3, 'function'),
(12261, 'address', '具体地址', 'varchar(255) NULL', 'string', '', '', 1, '', 1252, 1, 1, 1423477681, 1423477681, '', 3, '', 'regex', '', 3, 'function'),
(12262, 'is_use', '是否设置为默认', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:否\r\n1:是', 1252, 0, 1, 1423536697, 1423477729, '', 3, '', 'regex', '', 3, 'function'),
(12263, 'title', '标题', 'varchar(255) NULL', 'string', '', '可为空', 1, '', 1253, 0, 1, 1396098316, 1396098316, '', 3, '', 'regex', '', 3, 'function'),
(12264, 'img', '图片', 'int(10) unsigned NOT NULL ', 'picture', '', '', 1, '', 1253, 1, 1, 1396098349, 1396098349, '', 3, '', 'regex', '', 3, 'function'),
(12265, 'url', '链接地址', 'varchar(255) NULL', 'string', '', '', 1, '', 1253, 0, 1, 1396098380, 1396098380, '', 3, '', 'regex', '', 3, 'function'),
(12266, 'is_show', '是否显示', 'tinyint(2) NULL', 'bool', '1', '', 1, '0:不显示\r\n1:显示', 1253, 0, 1, 1396098464, 1396098464, '', 3, '', 'regex', '', 3, 'function'),
(12267, 'sort', '排序', 'int(10) unsigned NULL ', 'num', '0', '值越小越靠前', 1, '', 1253, 0, 1, 1396098682, 1396098682, '', 3, '', 'regex', '', 3, 'function'),
(12268, 'token', 'Token', 'varchar(100) NULL', 'string', '', '', 0, '', 1253, 0, 1, 1396098747, 1396098747, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12269, 'shop_id', '商店ID', 'int(10) NULL', 'num', '0', '', 4, '', 1253, 0, 1, 1422934490, 1422932093, '', 3, '', 'regex', '', 3, 'function'),
(12270, 'order_id', '订单ID', 'int(10) NULL', 'num', '', '', 0, '', 1254, 0, 1, 1439525588, 1439525588, '', 3, '', 'regex', '', 3, 'function'),
(12271, 'status_code', '状态码', 'char(50) NULL', 'select', '0', '', 0, '0:待支付\r\n1:待商家确认\r\n2:待发货\r\n3:配送中\r\n4:确认已收货\r\n5:确认已收款\r\n6:待评价\r\n7:已评价', 1254, 0, 1, 1439536678, 1439525934, '', 3, '', 'regex', '', 3, 'function'),
(12272, 'remark', '备注内容', 'varchar(255) NULL', 'string', '', '', 0, '', 1254, 0, 1, 1439525979, 1439525979, '', 3, '', 'regex', '', 3, 'function'),
(12273, 'cTime', '时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1254, 0, 1, 1439526002, 1439526002, '', 3, '', 'regex', '', 3, 'function'),
(12274, 'extend', '扩展信息', 'varchar(255) NULL', 'string', '', '', 0, '', 1254, 0, 1, 1439526038, 1439526038, '', 3, '', 'regex', '', 3, 'function'),
(12275, 'goods_datas', '商品序列化数据', 'text NOT NULL', 'textarea', '', '', 1, '', 1255, 0, 1, 1423534050, 1420269321, '', 3, '', 'regex', '', 3, 'function'),
(12276, 'uid', '用户id', 'int(10) UNSIGNED NOT NULL', 'num', '', '', 1, '', 1255, 0, 1, 1420269348, 1420269348, '', 3, '', 'regex', '', 3, 'function'),
(12277, 'remark', '备注', 'text NOT NULL', 'textarea', '', '', 1, '', 1255, 0, 1, 1423534071, 1420269399, '', 3, '', 'regex', '', 3, 'function'),
(12278, 'order_number', '订单编号', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1255, 0, 1, 1423534179, 1420269451, '', 3, '', 'regex', '', 3, 'function'),
(12279, 'cTime', '订单时间', 'int(10) NOT NULL', 'datetime', '', '', 1, '', 1255, 0, 1, 1423534102, 1420269666, '', 3, '', 'regex', '', 3, 'function'),
(12280, 'total_price', '总价', 'decimal(10,2) NULL', 'num', '', '', 1, '', 1255, 0, 1, 1439812371, 1420272711, '', 3, '', 'regex', '', 3, 'function'),
(12281, 'openid', 'OpenID', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1255, 0, 1, 1420526437, 1420526437, '', 3, '', 'regex', '', 3, 'function'),
(12282, 'pay_status', '支付状态', 'int(10)  NULL', 'num', '', '', 0, '', 1255, 0, 1, 1423537847, 1420596969, '', 3, '', 'regex', '', 3, 'function'),
(12283, 'pay_type', '支付类型', 'int(10) NULL', 'num', '', '', 0, '', 1255, 0, 1, 1423537868, 1420596998, '', 3, '', 'regex', '', 3, 'function'),
(12284, 'address_id', '配送信息', 'int(10) NULL', 'num', '', '', 1, '', 1255, 0, 1, 1423534264, 1423534264, '', 3, '', 'regex', '', 3, 'function'),
(12285, 'is_send', '是否发货', 'int(10) NULL', 'num', '0', '', 1, '', 1255, 0, 1, 1438336095, 1438336095, '', 3, '', 'regex', '', 3, 'function'),
(12286, 'send_code', '快递公司编号', 'varchar(255) NULL', 'string', '', '', 1, '', 1255, 0, 1, 1438336511, 1438336511, '', 3, '', 'regex', '', 3, 'function'),
(12287, 'send_number', '快递单号', 'varchar(255) NULL', 'string', '', '', 1, '', 1255, 0, 1, 1438336556, 1438336556, '', 3, '', 'regex', '', 3, 'function'),
(12288, 'send_type', '发货类型', 'char(10) NULL', 'radio', '', '', 1, '0|线上发货\r\n1|物流公司发货', 1255, 0, 1, 1438336756, 1438336756, '', 3, '', 'regex', '', 3, 'function'),
(12289, 'is_new', '是否为新订单', 'tinyint(2) NULL', 'bool', '1', '', 0, '0:否\r\n1:是', 1255, 0, 1, 1439435979, 1439435969, '', 3, '', 'regex', '', 3, 'function'),
(12290, 'shop_id', '商店编号', 'int(10) NULL', 'num', '0', '', 1, '', 1255, 0, 1, 1439455026, 1439455026, '', 3, '', 'regex', '', 3, 'function'),
(12291, 'status_code', '订单跟踪状态码', 'char(50) NULL', 'select', '0', '', 0, '0:待支付\r\n1:待商家确认\r\n2:待发货\r\n3:配送中\r\n4:确认已收货\r\n5:确认已收款\r\n6:待评价\r\n7:已评价', 1255, 0, 1, 1439536746, 1439526095, '', 3, '', 'regex', '', 3, 'function'),
(12292, 'uid', '用户ID', 'int(10) NULL', 'num', '', '', 0, '', 1256, 0, 1, 1422931055, 1422930936, '', 3, '', 'regex', '', 3, 'function'),
(12293, 'goods_id', '商品ID', 'int(10) NULL', 'num', '', '', 0, '', 1256, 0, 1, 1422930970, 1422930970, '', 3, '', 'regex', '', 3, 'function'),
(12294, 'score', '得分', 'int(10) NULL', 'num', '0', '', 0, '', 1256, 0, 1, 1422931004, 1422931004, '', 3, '', 'regex', '', 3, 'function'),
(12295, 'cTime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1256, 0, 1, 1422931044, 1422931044, '', 3, '', 'regex', '', 3, 'function'),
(12296, 'title', '分类标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1257, 1, 1, 1397529407, 1397529407, '', 3, '', 'regex', '', 3, 'function'),
(12297, 'icon', '分类图标', 'int(10) unsigned NULL ', 'picture', '', '建议上传100X100的正方形图片', 1, '', 1257, 0, 1, 1431072029, 1397529461, '', 3, '', 'regex', '', 3, 'function'),
(12298, 'pid', '上一级分类', 'int(10) unsigned NULL ', 'select', '0', '如果你要增加一级分类，这里选择“无”即可', 0, '0:无', 1257, 0, 1, 1422934148, 1397529555, '', 3, '', 'regex', '', 3, 'function'),
(12299, 'path', '分类路径', 'varchar(255) NULL', 'string', '', '', 0, '', 1257, 0, 1, 1397529604, 1397529604, '', 3, '', 'regex', '', 3, 'function'),
(12300, 'sort', '排序号', 'int(10) unsigned NULL ', 'num', '0', '数值越小越靠前', 1, '', 1257, 0, 1, 1397529705, 1397529705, '', 3, '', 'regex', '', 3, 'function'),
(12301, 'is_show', '是否显示', 'tinyint(2) NULL', 'bool', '1', '', 1, '0:不显示\r\n1:显示', 1257, 0, 1, 1397532496, 1397529809, '', 3, '', 'regex', '', 3, 'function'),
(12302, 'shop_id', '商店ID', 'int(10) NOT NULL', 'num', '0', '', 4, '', 1257, 0, 1, 1422934193, 1422672025, '', 3, '', 'regex', '', 3, 'function'),
(12303, 'is_recommend', '是否推荐', 'tinyint(2) NULL', 'bool', '0', '', 1, '0:否\r\n1:是', 1257, 0, 1, 1423106432, 1423106432, '', 3, '', 'regex', '', 3, 'function'),
(12304, 'content', '捐赠者留言', 'text NULL', 'textarea', '', '', 1, '', 1258, 0, 1, 1446095026, 1446095026, '', 3, '', 'regex', '', 3, 'function'),
(12305, 'money', '捐赠金额', 'float(10) NULL', 'num', '', '', 1, '', 1258, 0, 1, 1446094995, 1446094995, '', 3, '', 'regex', '', 3, 'function'),
(12306, 'email', '捐赠者邮箱', 'varchar(255) NULL', 'string', '', '', 1, '', 1258, 0, 1, 1446094966, 1446094966, '', 3, '', 'regex', '', 3, 'function'),
(12307, 'nickname', '捐赠者昵称', 'varchar(255) NULL', 'string', '', '', 1, '', 1258, 0, 1, 1446094946, 1446094946, '', 3, '', 'regex', '', 3, 'function'),
(12308, 'ctime', '捐赠时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1258, 0, 1, 1446094933, 1446094933, '', 3, '', 'regex', 'time', 1, 'function'),
(12309, 'openid', '捐赠者openid', 'varchar(255) NULL', 'string', '', '', 0, '', 1258, 0, 1, 1446094904, 1446094904, '', 3, '', 'regex', 'get_openid', 3, 'function'),
(12310, 'token', '公众号token', 'varchar(255) NULL', 'string', '', '', 0, '', 1258, 0, 1, 1446094880, 1446094880, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12311, 'desc', '描述', 'text NULL', 'textarea', '', '', 1, '', 1259, 0, 1, 1446094736, 1446094736, '', 3, '', 'regex', '', 3, 'function'),
(12312, 'money', '金额', 'int(10) NULL', 'num', '', '', 1, '', 1259, 0, 1, 1446094722, 1446094722, '', 3, '', 'regex', '', 3, 'function'),
(12313, 'token', '公众号token', 'varchar(255) NULL', 'string', '', '', 0, '', 1259, 0, 1, 1446094688, 1446094688, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12314, 'keyword_type', '关键词匹配类型', 'tinyint(2) NULL', 'select', '0', '', 1, '0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配', 1260, 0, 1, 1394268247, 1393921586, '', 3, '', 'regex', '', 3, 'function'),
(12315, 'api_token', 'Token', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1260, 0, 1, 1393922455, 1393912408, '', 3, '', 'regex', '', 3, 'function'),
(12316, 'cTime', '创建时间', 'int(10) NOT NULL', 'datetime', '', '', 0, '', 1260, 0, 1, 1393913608, 1393913608, '', 3, '', 'regex', 'time', 1, 'function'),
(12317, 'api_url', '第三方URL', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1260, 0, 1, 1393912354, 1393912354, '', 3, '', 'regex', '', 3, 'function'),
(12318, 'output_format', '数据输出格式', 'tinyint(1) NULL', 'select', '0', '', 1, '0:标准微信xml\r\n1:json格式', 1260, 0, 1, 1394268422, 1393912288, '', 3, '', 'regex', '', 3, 'function'),
(12319, 'keyword_filter', '关键词过滤', 'tinyint(2) NOT NULL', 'bool', '0', '如设置电影为触发词,用户输入 电影 美国派 时，如果启用过滤只将美国派这个词发送到的你的接口，如果不过滤 就是整个 电影 美国派全部发送到的接口', 1, '0:不过滤\r\n1:过滤', 1260, 0, 1, 1394268410, 1393912057, '', 3, '', 'regex', '', 3, 'function'),
(12320, 'keyword', '关键词', 'varchar(255) NOT NULL', 'string', '', '多个关键词请用空格格开', 1, '', 1260, 1, 1, 1393912492, 1393911842, '', 3, '', 'regex', '', 3, 'function'),
(12321, 'token', 'Token', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1260, 0, 1, 1402454223, 1402454223, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12322, 'title', '标题', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1261, 1, 1, 1396624461, 1396061859, '', 3, '', 'regex', '', 3, 'function'),
(12323, 'cTime', '发布时间', 'int(10) UNSIGNED NULL', 'datetime', '', '', 0, '', 1261, 0, 1, 1396624612, 1396075102, '', 3, '', 'regex', 'time', 1, 'function'),
(12324, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1261, 0, 1, 1396602871, 1396602859, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12325, 'password', '表单密码', 'varchar(255) NULL', 'string', '', '如要用户输入密码才能进入表单，则填写此项。否则留空，用户可直接进入表单', 0, '', 1261, 0, 1, 1396871497, 1396672643, '', 3, '', 'regex', '', 3, 'function'),
(12326, 'keyword_type', '关键词类型', 'tinyint(2) NOT NULL', 'select', '0', '', 1, '0:完全匹配\r\n1:左边匹配\r\n2:右边匹配\r\n3:模糊匹配', 1261, 1, 1, 1396624426, 1396061765, '', 3, '', 'regex', '', 3, 'function'),
(12327, 'jump_url', '提交后跳转的地址', 'varchar(255) NULL', 'string', '', '要以http://开头的完整地址，为空时不跳转', 1, '', 1261, 0, 1, 1402458121, 1399800276, '', 3, '', 'regex', '', 3, 'function'),
(12328, 'content', '详细介绍', 'text NULL', 'editor', '', '可不填', 1, '', 1261, 0, 1, 1396865295, 1396865295, '', 3, '', 'regex', '', 3, 'function'),
(12329, 'finish_tip', '用户提交后提示内容', 'text NULL', 'string', '', '为空默认为：提交成功，谢谢参与', 1, '', 1261, 0, 1, 1447497102, 1396673689, '', 3, '', 'regex', '', 3, 'function'),
(12330, 'can_edit', '是否允许编辑', 'tinyint(2) NULL', 'bool', '0', '用户提交表单是否可以再编辑', 1, '0:不允许\r\n1:允许', 1261, 0, 1, 1396688624, 1396688624, '', 3, '', 'regex', '', 3, 'function'),
(12331, 'intro', '封面简介', 'text NULL', 'textarea', '', '', 1, '', 1261, 1, 1, 1439371986, 1396061947, '', 3, '', 'regex', '', 3, 'function'),
(12332, 'mTime', '修改时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1261, 0, 1, 1396624664, 1396624664, '', 3, '', 'regex', 'time', 3, 'function'),
(12333, 'cover', '封面图片', 'int(10) UNSIGNED NULL', 'picture', '', '', 1, '', 1261, 1, 1, 1439372018, 1396062093, '', 3, '', 'regex', '', 3, 'function'),
(12334, 'keyword', '关键词', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1261, 1, 1, 1396866048, 1396061575, '', 3, '', 'regex', '', 3, 'function'),
(12335, 'template', '模板', 'varchar(255) NULL', 'string', 'default', '', 1, '', 1261, 0, 1, 1431661124, 1431661124, '', 3, '', 'regex', '', 3, 'function'),
(12336, 'is_show', '是否显示', 'tinyint(2) NULL', 'select', '1', '是否显示在表单中', 1, '1:显示\r\n0:不显示', 1262, 0, 1, 1396848437, 1396848437, '', 3, '', 'regex', '', 3, 'function'),
(12337, 'forms_id', '表单ID', 'int(10) UNSIGNED NULL', 'num', '', '', 4, '', 1262, 0, 1, 1396710040, 1396690613, '', 3, '', 'regex', '', 3, 'function'),
(12338, 'error_info', '出错提示', 'varchar(255) NULL', 'string', '', '验证不通过时的提示语', 1, '', 1262, 0, 1, 1396685920, 1396685920, '', 3, '', 'regex', '', 3, 'function'),
(12339, 'sort', '排序号', 'int(10) UNSIGNED NULL', 'num', '0', '值越小越靠前', 1, '', 1262, 0, 1, 1396685825, 1396685825, '', 3, '', 'regex', '', 3, 'function'),
(12340, 'validate_rule', '正则验证', 'varchar(255) NULL', 'string', '', '为空表示不作验证', 1, '', 1262, 0, 1, 1396685776, 1396685776, '', 3, '', 'regex', '', 3, 'function'),
(12341, 'is_must', '是否必填', 'tinyint(2) NULL', 'bool', '', '用于自动验证', 1, '0:否\r\n1:是', 1262, 0, 1, 1396685579, 1396685579, '', 3, '', 'regex', '', 3, 'function'),
(12342, 'remark', '字段备注', 'varchar(255) NULL', 'string', '', '用于表单中的提示', 1, '', 1262, 0, 1, 1396685482, 1396685482, '', 3, '', 'regex', '', 3, 'function'),
(12343, 'name', '字段名', 'varchar(100) NULL', 'string', '', '请输入字段名 英文字母开头，长度不超过30', 1, '', 1262, 1, 1, 1447638080, 1396676792, '', 3, '', 'regex', '', 3, 'function'),
(12344, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1262, 0, 1, 1396602871, 1396602859, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12345, 'value', '默认值', 'varchar(255) NULL', 'string', '', '字段的默认值', 1, '', 1262, 0, 1, 1396685291, 1396685291, '', 3, '', 'regex', '', 3, 'function'),
(12346, 'title', '字段标题', 'varchar(255) NOT NULL', 'string', '', '请输入字段标题，用于表单显示', 1, '', 1262, 1, 1, 1396676830, 1396676830, '', 3, '', 'regex', '', 3, 'function'),
(12347, 'mTime', '修改时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1262, 0, 1, 1396624664, 1396624664, '', 3, '', 'regex', 'time', 3, 'function'),
(12348, 'extra', '参数', 'text NULL', 'textarea', '', '字段类型为单选、多选、下拉选择和级联选择时的定义数据，其它字段类型为空', 1, '', 1262, 0, 1, 1396835020, 1396685105, '', 3, '', 'regex', '', 3, 'function'),
(12349, 'type', '字段类型', 'char(50) NOT NULL', 'select', 'string', '用于表单中的展示方式', 1, 'string:单行输入\r\ntextarea:多行输入\r\nradio:单选\r\ncheckbox:多选\r\nselect:下拉选择\r\ndatetime:时间\r\npicture:上传图片', 1262, 1, 1, 1396871262, 1396683600, '', 3, '', 'regex', '', 3, 'function'),
(12350, 'forms_id', '表单ID', 'int(10) UNSIGNED NULL', 'num', '', '', 4, '', 1263, 0, 1, 1396710064, 1396688308, '', 3, '', 'regex', '', 1, 'function'),
(12351, 'value', '表单值', 'text NULL', 'textarea', '', '', 0, '', 1263, 0, 1, 1396688355, 1396688355, '', 3, '', 'regex', '', 3, 'function'),
(12352, 'cTime', '增加时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1263, 0, 1, 1396688434, 1396688434, '', 3, '', 'regex', 'time', 1, 'function'),
(12353, 'openid', 'OpenId', 'varchar(255) NULL', 'string', '', '', 0, '', 1263, 0, 1, 1396688187, 1396688187, '', 3, '', 'regex', 'get_openid', 1, 'function'),
(12354, 'uid', '用户ID', 'int(10) NULL', 'num', '', '', 0, '', 1263, 0, 1, 1396688042, 1396688042, '', 3, '', 'regex', '', 3, 'function'),
(12355, 'token', 'Token', 'varchar(255) NULL', 'string', '', '', 0, '', 1263, 0, 1, 1396690911, 1396690911, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12356, 'cTime', '创建时间', 'int(10) NOT NULL', 'datetime', '', '', 0, '', 1264, 0, 1, 1393234678, 1393234678, '', 3, '', 'regex', 'time', 1, 'function'),
(12357, 'content', '内容', 'text NOT NULL', 'textarea', '', '', 1, '', 1264, 1, 1, 1393234583, 1393234583, '', 3, '', 'regex', '', 3, 'function'),
(12358, 'uid', '用户ID', 'int(10) NOT NULL', 'num', '0', '', 0, '', 1264, 0, 1, 1393234534, 1393234534, '', 3, '', 'regex', 'get_mid', 1, 'function'),
(12359, 'nickname', '用户昵称', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1264, 0, 1, 1400687052, 1400687052, '', 3, '', 'regex', '', 3, 'function');
INSERT INTO `dc_attribute` (`id`, `name`, `title`, `field`, `type`, `value`, `remark`, `is_show`, `extra`, `model_id`, `is_must`, `status`, `update_time`, `create_time`, `validate_rule`, `validate_time`, `error_info`, `validate_type`, `auto_rule`, `auto_time`, `auto_type`) VALUES
(12360, 'mobile', '手机号', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1264, 0, 1, 1400687075, 1400687075, '', 3, '', 'regex', '', 3, 'function'),
(12361, 'token', 'Token', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1264, 0, 1, 1400687900, 1400687900, '', 3, '', 'regex', 'get_token', 1, 'function'),
(12362, 'public_count', '可创建公众号数', 'int(10) NULL', 'num', '', '', 1, '', 1, 0, 1, 1452417198, 1452417198, '', 3, '', 'regex', '', 3, 'function'),
(12363, 'token', '公众号token', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1265, 0, 1, 1447736812, 1447736812, '', 3, '', 'regex', 'get_token', 3, 'function'),
(12364, 'openid', '微信用户id', 'varchar(255) NOT NULL', 'string', '', '', 0, '', 1265, 0, 1, 1447736895, 1447736895, '', 3, '', 'regex', 'get_openid', 3, 'function'),
(12365, 'name', '姓名', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447736947, 1447736947, '', 3, '', 'regex', '', 3, 'function'),
(12366, 'sex', '性别', 'int(10) NOT NULL', 'select', '', '', 1, '0:保密\r\n1:男性\r\n2:女性', 1265, 0, 1, 1452331282, 1447737042, '', 3, '', 'regex', '', 3, 'function'),
(12367, 'mobile', '手机号', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737168, 1447737168, '', 3, '', 'regex', '', 3, 'function'),
(12368, 'address', '详细地址', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737246, 1447737246, '', 3, '', 'regex', '', 3, 'function'),
(12369, 'country', '国家', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737319, 1447737319, '', 3, '', 'regex', '', 3, 'function'),
(12370, 'province', '省份', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737345, 1447737345, '', 3, '', 'regex', '', 3, 'function'),
(12371, 'city', '城市', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737405, 1447737405, '', 3, '', 'regex', '', 3, 'function'),
(12372, 'area', '地区', 'varchar(255) NOT NULL', 'string', '', '', 1, '', 1265, 0, 1, 1447737430, 1447737430, '', 3, '', 'regex', '', 3, 'function'),
(12373, 'is_default', '是否默认', 'int(10) NOT NULL', 'select', '0', '', 1, '0:否\r\n1:是', 1265, 0, 1, 1452331302, 1447737493, '', 3, '', 'regex', '', 3, 'function'),
(12374, 'postcode', '邮政编码', 'varchar(255) NULL', 'string', '', '', 1, '', 1265, 0, 1, 1452324019, 1452324019, '', 3, '', 'regex', '', 3, 'function'),
(12375, 'wxmchid', '微信支付商户号', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 1, 1, 1439364696, 1436437067, '', 3, '', 'regex', '', 3, 'function'),
(12376, 'shop_id', '商店ID', 'int(10) NULL', 'num', '0', '', 0, '', 1266, 0, 1, 1436437020, 1436437003, '', 3, '', 'regex', '', 3, 'function'),
(12377, 'quick_merid', '银联在线merid', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436949, 1436436949, '', 3, '', 'regex', '', 3, 'function'),
(12378, 'quick_merabbr', '商户名称', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436970, 1436436970, '', 3, '', 'regex', '', 3, 'function'),
(12379, 'wxpartnerid', '微信partnerid', 'varchar(255) NULL', 'string', '', '', 0, '', 1266, 0, 1, 1436437196, 1436436910, '', 3, '', 'regex', '', 3, 'function'),
(12380, 'wxpartnerkey', '微信partnerkey', 'varchar(255) NULL', 'string', '', '', 0, '', 1266, 0, 1, 1436437236, 1436436888, '', 3, '', 'regex', '', 3, 'function'),
(12381, 'partnerid', '财付通标识', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436798, 1436436798, '', 3, '', 'regex', '', 3, 'function'),
(12382, 'key', 'KEY', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436771, 1436436771, '', 3, '', 'regex', '', 3, 'function'),
(12383, 'ctime', '创建时间', 'int(10) NULL', 'datetime', '', '', 0, '', 1266, 0, 1, 1436436498, 1436436498, '', 3, '', 'regex', '', 3, 'function'),
(12384, 'quick_security_key', '银联在线Key', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436931, 1436436931, '', 3, '', 'regex', '', 3, 'function'),
(12385, 'wappartnerkey', 'WAP财付通Key', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436863, 1436436863, '', 3, '', 'regex', '', 3, 'function'),
(12386, 'wappartnerid', '财付通标识WAP', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436834, 1436436834, '', 3, '', 'regex', '', 3, 'function'),
(12387, 'partnerkey', '财付通Key', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436816, 1436436816, '', 3, '', 'regex', '', 3, 'function'),
(12388, 'pid', 'PID', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436707, 1436436707, '', 3, '', 'regex', '', 3, 'function'),
(12389, 'zfbname', '帐号', 'varchar(255) NULL', 'string', '', '', 1, '', 1266, 0, 1, 1436436653, 1436436653, '', 3, '', 'regex', '', 3, 'function'),
(12390, 'wxappsecret', 'AppSecret', 'varchar(255) NULL', 'string', '', '微信支付中的公众号应用密钥', 1, '', 1266, 1, 1, 1439364612, 1436436618, '', 3, '', 'regex', '', 3, 'function'),
(12391, 'wxpaysignkey', '支付密钥', 'varchar(255) NULL', 'string', '', 'PartnerKey', 1, '', 1266, 1, 1, 1439364810, 1436436569, '', 3, '', 'regex', '', 3, 'function'),
(12392, 'wxappid', 'AppID', 'varchar(255) NULL', 'string', '', '微信支付中的公众号应用ID', 1, '', 1266, 1, 1, 1439364573, 1436436534, '', 3, '', 'regex', '', 3, 'function'),
(12393, 'token', 'token', 'varchar(255) NULL', 'string', '', '', 0, '', 1266, 0, 1, 1436436415, 1436436415, '', 3, '', 'regex', '', 3, 'function'),
(12394, 'wx_cert_pem', '上传证书', 'int(10) UNSIGNED NULL', 'file', '', 'apiclient_cert.pem', 1, '', 1266, 0, 1, 1439804529, 1439550487, '', 3, '', 'regex', '', 3, 'function'),
(12395, 'wx_key_pem', '上传密匙', 'int(10) UNSIGNED NULL', 'file', '', 'apiclient_key.pem', 1, '', 1266, 0, 1, 1439804544, 1439804014, '', 3, '', 'regex', '', 3, 'function'),
(12396, 'from', '回调地址', 'varchar(50) NOT NULL', 'string', '', '', 1, '', 1267, 0, 1, 1420596347, 1420596347, '', 3, '', 'regex', '', 3, 'function'),
(12397, 'orderName', '订单名称', 'varchar(255) NULL', 'string', '', '', 1, '', 1267, 0, 1, 1439976366, 1420596373, '', 3, '', 'regex', '', 3, 'function'),
(12398, 'single_orderid', '订单号', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1267, 0, 1, 1420596415, 1420596415, '', 3, '', 'regex', '', 3, 'function'),
(12399, 'price', '价格', 'decimal(10,2) NULL', 'num', '', '', 1, '', 1267, 0, 1, 1439812508, 1420596472, '', 3, '', 'regex', '', 3, 'function'),
(12400, 'token', 'Token', 'varchar(100) NOT NULL', 'string', '', '', 1, '', 1267, 0, 1, 1420596492, 1420596492, '', 3, '', 'regex', '', 3, 'function'),
(12401, 'wecha_id', 'OpenID', 'varchar(200) NOT NULL', 'string', '', '', 1, '', 1267, 0, 1, 1420596530, 1420596530, '', 3, '', 'regex', '', 3, 'function'),
(12402, 'paytype', '支付方式', 'varchar(30) NOT NULL', 'string', '', '', 1, '', 1267, 0, 1, 1420596929, 1420596929, '', 3, '', 'regex', '', 3, 'function'),
(12403, 'showwxpaytitle', '是否显示标题', 'tinyint(2) NOT NULL', 'bool', '0', '', 1, '0:不显示\r\n1:显示', 1267, 0, 1, 1420596980, 1420596980, '', 3, '', 'regex', '', 3, 'function'),
(12404, 'status', '支付状态', 'tinyint(2) NOT NULL', 'bool', '0', '', 1, '0:未支付\r\n1:已支付\r\n2:支付失败', 1267, 0, 1, 1420597026, 1420597026, '', 3, '', 'regex', '', 3, 'function'),
(12416, 'jump_type', '推送类型', 'char(10) NULL', 'radio', '0', '', 1, '1:URL|keyword@hide,url@show\r\n0:关键词|keyword@show,url@hide', 1268, 0, 1, 1447208981, 1447208981, '', 3, '', 'regex', '', 3, 'function'),
(12417, 'menu_id', '对应菜单ID，禁止修改', 'int(10) NULL', 'num', '', '', 1, '', 1268, 0, 1, 1453345667, 1453345667, '', 3, '', 'regex', '', 3, 'function'),
(12418, 'title', '菜单标题', 'varchar(255) NULL', 'string', '', '用于区分菜单类型', 1, '', 1269, 1, 1, 1453098869, 1453098869, '', 3, '', 'regex', '', 3, 'function'),
(12419, 'type', '菜单类型', 'char(50) NULL', 'select', '0', '菜单类型', 1, '0:默认菜单\r\n1:个性菜单', 1269, 1, 1, 1453098999, 1453098999, '', 3, '', 'regex', '', 3, 'function'),
(12420, 'group_id', '用户分组id', 'varchar(255) NULL', 'string', '', '', 1, '', 1269, 0, 1, 1453305419, 1453099301, '', 3, '', 'regex', '', 3, 'function'),
(12421, 'sex', '性别', 'char(50) NULL', 'select', '', '', 1, '1:男\r\n2:女', 1269, 0, 1, 1453099368, 1453099368, '', 3, '', 'regex', '', 3, 'function'),
(12422, 'country', '国家信息', 'varchar(255) NULL', 'string', '', '国家信息', 1, '', 1269, 0, 1, 1453099469, 1453099469, '', 3, '', 'regex', '', 3, 'function'),
(12423, 'province', '省份信息', 'varchar(255) NULL', 'string', '', '省份信息', 1, '', 1269, 0, 1, 1453099495, 1453099495, '', 3, '', 'regex', '', 3, 'function'),
(12424, 'city', '城市信息', 'varchar(255) NULL', 'string', '', '城市信息', 1, '', 1269, 0, 1, 1453099551, 1453099551, '', 3, '', 'regex', '', 3, 'function'),
(12425, 'client_platform_type', '手机操作系统类型', 'char(50) NULL', 'select', '', '手机操作系统类型', 1, '1:IOS\r\n2:Android\r\n3:Others', 1269, 0, 1, 1453099676, 1453099676, '', 3, '', 'regex', '', 3, 'function'),
(12426, 'menuid', '微信端菜单ID', 'varchar(255) NULL', 'string', '', '', 1, '', 1269, 0, 1, 1453307372, 1453100271, '', 3, '', 'regex', '', 3, 'function'),
(12427, 'token', 'Token', 'varchar(255) NULL', 'string', '', 'Token', 0, '', 1269, 0, 1, 1453116330, 1453116321, '', 3, '', 'regex', '', 3, 'function'),
(12428, 'cTime', '菜单发布时间', 'int(10) NULL', 'datetime', '', '菜单发布时间', 1, '', 1269, 0, 1, 1453116920, 1453116525, '', 3, '', 'regex', '', 3, 'function'),
(12429, 'show', '是否发布', 'char(50) NULL', 'select', '0', '是否发布', 1, '0:未发布\r\n1:已发布', 1269, 0, 1, 1453306537, 1453219041, '', 3, '', 'regex', '', 3, 'function');

-- --------------------------------------------------------

--
-- 表的结构 `dc_auth_extend`
--

CREATE TABLE IF NOT EXISTS `dc_auth_extend` (
  `group_id` mediumint(10) unsigned NOT NULL COMMENT '用户id',
  `extend_id` mediumint(8) unsigned NOT NULL COMMENT '扩展表中数据的id',
  `type` tinyint(1) unsigned NOT NULL COMMENT '扩展类型标识 1:栏目分类权限;2:模型权限',
  UNIQUE KEY `group_extend_type` (`group_id`,`extend_id`,`type`),
  KEY `uid` (`group_id`),
  KEY `group_id` (`extend_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户组与分类的对应关系表';

-- --------------------------------------------------------

--
-- 表的结构 `dc_auth_group`
--

CREATE TABLE IF NOT EXISTS `dc_auth_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(30) DEFAULT NULL COMMENT '分组名称',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '图标',
  `description` text COMMENT '描述信息',
  `status` tinyint(2) DEFAULT '1' COMMENT '状态',
  `type` tinyint(2) DEFAULT '1' COMMENT '类型',
  `rules` text COMMENT '权限',
  `manager_id` int(10) DEFAULT '0' COMMENT '管理员ID',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认自动加入',
  `qr_code` varchar(255) DEFAULT NULL COMMENT '微信二维码',
  `wechat_group_id` int(10) DEFAULT '-1' COMMENT '微信端的分组ID',
  `wechat_group_name` varchar(100) DEFAULT NULL COMMENT '微信端的分组名',
  `wechat_group_count` int(10) DEFAULT NULL COMMENT '微信端用户数',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否已删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- 转存表中的数据 `dc_auth_group`
--

INSERT INTO `dc_auth_group` (`id`, `title`, `icon`, `description`, `status`, `type`, `rules`, `manager_id`, `token`, `is_default`, `qr_code`, `wechat_group_id`, `wechat_group_name`, `wechat_group_count`, `is_del`) VALUES
(1, '默认用户组', NULL, '通用的用户组', 1, 0, '1,2,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,79,80,81,82,83,84,86,87,88,89,90,91,92,93,94,95,96,97,100,102,103,105,106', 0, '', 0, '', NULL, '', NULL, 0),
(2, '公众号粉丝组', NULL, '所有从公众号自动注册的粉丝用户都会自动加入这个用户组', 1, 0, '1,2,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,79,80,82,83,84,88,89,90,91,92,93,96,97,100,102,103,195', 0, '', 0, '', NULL, '', NULL, 0),
(3, '公众号管理组', NULL, '公众号管理员注册时会自动加入这个用户组', 1, 0, '', 0, '', 0, '', NULL, '', NULL, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dc_auth_group_access`
--

CREATE TABLE IF NOT EXISTS `dc_auth_group_access` (
  `uid` int(10) DEFAULT NULL COMMENT '用户id',
  `group_id` mediumint(8) unsigned NOT NULL COMMENT '用户组id',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `dc_auth_group_access`
--

INSERT INTO `dc_auth_group_access` (`uid`, `group_id`) VALUES
(1, 3);

-- --------------------------------------------------------

--
-- 表的结构 `dc_auth_rule`
--

CREATE TABLE IF NOT EXISTS `dc_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识',
  `title` char(100) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(300) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  `group` char(30) DEFAULT '默认分组',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=280 ;

--
-- 转存表中的数据 `dc_auth_rule`
--

INSERT INTO `dc_auth_rule` (`id`, `name`, `title`, `status`, `condition`, `group`) VALUES
(241, 'Admin/Rule/createRule', '权限节点管理', 1, '', '默认分组'),
(242, 'Admin/AuthManager/index', '用户组管理', 1, '', '默认分组'),
(243, 'Admin/User/index', '用户信息', 1, '', '用户管理');

-- --------------------------------------------------------

--
-- 表的结构 `dc_auto_reply`
--

CREATE TABLE IF NOT EXISTS `dc_auto_reply` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `keyword` varchar(255) DEFAULT NULL COMMENT '关键词',
  `msg_type` char(50) DEFAULT 'text' COMMENT '消息类型',
  `content` text COMMENT '文本内容',
  `group_id` int(10) DEFAULT NULL COMMENT '图文',
  `image_id` int(10) unsigned DEFAULT NULL COMMENT '上传图片',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员ID',
  `token` varchar(50) DEFAULT NULL COMMENT 'Token',
  `image_material` int(10) DEFAULT NULL COMMENT '素材图片id',
  `voice_id` int(10) DEFAULT '0' COMMENT '语音id',
  `video_id` int(10) DEFAULT '0' COMMENT '视频id',
  `reply_scene` int(10) DEFAULT NULL COMMENT '回复场景（0：关注时回复；1：默认回复；2：关键词回复）',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_channel`
--

CREATE TABLE IF NOT EXISTS `dc_channel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '频道ID',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级频道ID',
  `title` char(30) NOT NULL COMMENT '频道标题',
  `url` char(100) NOT NULL COMMENT '频道连接',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '导航排序',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `target` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '新窗口打开',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_common_category`
--

CREATE TABLE IF NOT EXISTS `dc_common_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) DEFAULT NULL COMMENT '分类标识',
  `title` varchar(255) NOT NULL COMMENT '分类标题',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '分类图标',
  `pid` int(10) unsigned DEFAULT '0' COMMENT '上一级分类',
  `path` varchar(255) DEFAULT NULL COMMENT '分类路径',
  `module` varchar(255) DEFAULT NULL COMMENT '分类所属功能',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序号',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '是否显示',
  `intro` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `code` varchar(255) DEFAULT NULL COMMENT '分类扩展编号',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_common_category_group`
--

CREATE TABLE IF NOT EXISTS `dc_common_category_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '分组标识',
  `title` varchar(255) NOT NULL COMMENT '分组标题',
  `cTime` int(10) unsigned DEFAULT NULL COMMENT '发布时间',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `level` tinyint(1) unsigned DEFAULT '3' COMMENT '最多级数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_config`
--

CREATE TABLE IF NOT EXISTS `dc_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '配置名称',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置类型',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '配置说明',
  `group` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '配置分组',
  `extra` varchar(255) NOT NULL DEFAULT '' COMMENT '配置值',
  `remark` varchar(100) NOT NULL COMMENT '配置说明',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `value` text NOT NULL COMMENT '配置值',
  `sort` smallint(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='系统配置表' AUTO_INCREMENT=66 ;

--
-- 转存表中的数据 `dc_config`
--

INSERT INTO `dc_config` (`id`, `name`, `type`, `title`, `group`, `extra`, `remark`, `create_time`, `update_time`, `status`, `value`, `sort`) VALUES
(1, 'WEB_SITE_TITLE', 1, '网站标题', 1, '', '网站标题前台显示标题', 1378898976, 1430825115, 1, '豆信公众号管理平台', 0),
(2, 'WEB_SITE_DESCRIPTION', 2, '网站描述', 1, '', '网站搜索引擎描述', 1378898976, 1379235841, 1, '最好用的微信公众号管理平台', 1),
(3, 'WEB_SITE_KEYWORD', 2, '网站关键字', 1, '', '网站搜索引擎关键字', 1378898976, 1381390100, 1, '豆信,微信公众号,微信第三方', 8),
(4, 'WEB_SITE_CLOSE', 4, '关闭站点', 1, '0:关闭\r\n1:开启', '站点关闭后其他用户不能访问，管理员可以正常访问', 1378898976, 1406859591, 1, '1', 1),
(9, 'CONFIG_TYPE_LIST', 3, '配置类型列表', 4, '', '主要用于数据解析和页面表单的生成', 1378898976, 1379235348, 1, '0:数字\r\n1:字符\r\n2:文本\r\n3:数组\r\n4:枚举', 2),
(10, 'WEB_SITE_ICP', 1, '网站备案号', 1, '', '设置在网站底部显示的备案号，如“沪ICP备12007941号-2', 1378900335, 1379235859, 1, '', 9),
(11, 'DOCUMENT_POSITION', 3, '文档推荐位', 2, '', '文档推荐位，推荐到多个位置KEY值相加即可', 1379053380, 1379235329, 1, '1:列表页推荐\r\n2:频道页推荐\r\n4:网站首页推荐', 3),
(12, 'DOCUMENT_DISPLAY', 3, '文档可见性', 2, '', '文章可见性仅影响前台显示，后台不收影响', 1379056370, 1379235322, 1, '0:所有人可见\r\n1:仅注册会员可见\r\n2:仅管理员可见', 4),
(13, 'COLOR_STYLE', 4, '后台色系', 1, 'default_color:默认\r\nblue_color:紫罗兰', '后台颜色风格', 1379122533, 1379235904, 1, 'blue_color', 10),
(20, 'CONFIG_GROUP_LIST', 3, '配置分组', 4, '', '配置分组', 1379228036, 1384418383, 1, '1:基本\r\n3:用户\r\n4:系统\r\n5:站点', 4),
(21, 'HOOKS_TYPE', 3, '钩子的类型', 4, '', '类型 1-用于扩展显示内容，2-用于扩展业务处理', 1379313397, 1379313407, 1, '1:视图\r\n2:控制器', 6),
(22, 'AUTH_CONFIG', 3, 'Auth配置', 4, '', '自定义Auth.class.php类配置', 1379409310, 1379409564, 1, 'AUTH_ON:1\r\nAUTH_TYPE:2', 8),
(23, 'OPEN_DRAFTBOX', 4, '是否开启草稿功能', 2, '0:关闭草稿功能\r\n1:开启草稿功能\r\n', '新增文章时的草稿功能配置', 1379484332, 1379484591, 1, '1', 1),
(24, 'DRAFT_AOTOSAVE_INTERVAL', 0, '自动保存草稿时间', 2, '', '自动保存草稿的时间间隔，单位：秒', 1379484574, 1386143323, 1, '60', 2),
(25, 'LIST_ROWS', 0, '后台每页记录数', 4, '', '后台数据每页显示记录数', 1379503896, 1391938052, 1, '20', 10),
(26, 'USER_ALLOW_REGISTER', 4, '是否允许用户注册', 3, '0:关闭注册\r\n1:允许注册', '是否开放用户注册', 1379504487, 1379504580, 1, '1', 0),
(27, 'CODEMIRROR_THEME', 4, '预览插件的CodeMirror主题', 4, '3024-day:3024 day\r\n3024-night:3024 night\r\nambiance:ambiance\r\nbase16-dark:base16 dark\r\nbase16-light:base16 light\r\nblackboard:blackboard\r\ncobalt:cobalt\r\neclipse:eclipse\r\nelegant:elegant\r\nerlang-dark:erlang-dark\r\nlesser-dark:lesser-dark\r\nmidnight:midnight', '详情见CodeMirror官网', 1379814385, 1384740813, 1, 'ambiance', 3),
(28, 'DATA_BACKUP_PATH', 1, '数据库备份根路径', 4, '', '路径必须以 / 结尾', 1381482411, 1381482411, 1, './Data/', 5),
(29, 'DATA_BACKUP_PART_SIZE', 0, '数据库备份卷大小', 4, '', '该值用于限制压缩后的分卷最大长度。单位：B；建议设置20M', 1381482488, 1381729564, 1, '20971520', 7),
(30, 'DATA_BACKUP_COMPRESS', 4, '数据库备份文件是否启用压缩', 4, '0:不压缩\r\n1:启用压缩', '压缩备份文件需要PHP环境支持gzopen,gzwrite函数', 1381713345, 1381729544, 1, '1', 9),
(31, 'DATA_BACKUP_COMPRESS_LEVEL', 4, '数据库备份文件压缩级别', 4, '1:普通\r\n4:一般\r\n9:最高', '数据库备份文件的压缩级别，该配置在开启压缩时生效', 1381713408, 1381713408, 1, '9', 10),
(32, 'DEVELOP_MODE', 4, '开启开发者模式', 4, '0:关闭\r\n1:开启', '是否开启开发者模式', 1383105995, 1440555973, 1, '0', 0),
(33, 'ALLOW_VISIT', 3, '不受限控制器方法', 0, '', '', 1386644047, 1386644741, 1, '0:article/draftbox\r\n1:article/mydocument\r\n2:Category/tree\r\n3:Index/verify\r\n4:file/upload\r\n5:file/download\r\n6:user/updatePassword\r\n7:user/updateNickname\r\n8:user/submitPassword\r\n9:user/submitNickname', 0),
(34, 'DENY_VISIT', 3, '超管专限控制器方法', 0, '', '仅超级管理员可访问的控制器方法', 1386644141, 1386644659, 1, '0:Addons/addhook\r\n1:Addons/edithook\r\n2:Addons/delhook\r\n3:Addons/updateHook\r\n4:Admin/getMenus\r\n5:Admin/recordList\r\n6:AuthManager/updateRules\r\n7:AuthManager/tree', 0),
(35, 'REPLY_LIST_ROWS', 0, '回复列表每页条数', 2, '', '', 1386645376, 1387178083, 1, '20', 0),
(36, 'ADMIN_ALLOW_IP', 2, '后台允许访问IP', 4, '', '多个用逗号分隔，如果不配置表示不限制IP访问', 1387165454, 1387165553, 1, '', 12),
(37, 'SHOW_PAGE_TRACE', 4, '是否显示页面Trace', 4, '0:关闭\r\n1:开启', '是否显示页面Trace信息', 1387165685, 1387165685, 1, '0', 1),
(38, 'WEB_SITE_VERIFY', 4, '登录验证码', 1, '0:关闭\r\n1:开启', '登录时是否需要验证码', 1378898976, 1406859544, 1, '0', 2),
(42, 'ACCESS', 2, '未登录时可访问的页面', 4, '', '不区分大小写', 1390656601, 1390664079, 1, 'Home/User/*\r\nHome/Index/*\r\nhome/weixin/*\r\nadmin/File/*\r\nhome/File/*\r\nhome/Forum/*\r\nHome/Material/detail', 0),
(44, 'DEFAULT_PUBLIC_GROUP_ID', 0, '公众号默认等级ID', 3, '', '前台新增加的公众号的默认等级，值为0表示不做权限控制，公众号拥有全部插件的权限', 1393759885, 1393759981, 1, '0', 2),
(45, 'SYSTEM_UPDATE_REMIND', 4, '系统升级提醒', 4, '0:关闭\r\n1:开启', '开启后官方有新升级信息会及时在后台的网站设置页面头部显示升级提醒', 1393764263, 1393764263, 1, '0', 5),
(46, 'SYSTEM_UPDATRE_VERSION', 0, '系统升级最新版本号', 4, '', '记录当前系统的版本号，这是与官方比较是否有升级包的唯一标识，不熟悉者只勿改变其数值', 1393764702, 1394337646, 1, '1.0.20160101', 0),
(47, 'FOLLOW_YOUKE_UID', 0, '粉丝游客ID', 0, '', '', 1398927704, 1398927704, 1, '-11884', 0),
(48, 'DEFAULT_PUBLIC', 0, '注册后默认可管理的公众号ID', 3, '', '可为空。配置用户注册后即可管理的公众号ID，多个时用英文逗号分割', 1398928794, 1398929088, 1, '', 3),
(49, 'DEFAULT_PUBLIC_CREATE_MAX_NUMB', 0, '默认用户最多可创建的公众号数', 3, '', '注册用户最多的创建数，也可以在用户管理里对每个用户设置不同的值', 1398949652, 1398950115, 1, '5', 4),
(50, 'COPYRIGHT', 1, '版权信息', 1, '', '', 1401018910, 1401018910, 1, '武汉市艾豆网络科技有限公司所有', 3),
(51, 'WEIPHP_STORE_LICENSE', 1, '应用商店授权许可证', 1, '', '要与 应用商店》网站信息 里的授权许可证保持一致', 1402972720, 1402977473, 1, '', 0),
(52, 'SYSTEM_LOGO', 1, '网站LOGO', 5, '', '填写LOGO的网址，为空时默认显示豆信的logo', 1403566699, 1403566746, 1, '', 0),
(53, 'SYSTEM_CLOSE_REGISTER', 4, '前台注册开关', 5, '0:不关闭\r\n1:关闭', '关闭后在登录页面不再显示注册链接', 1403568006, 1403568006, 1, '0', 0),
(54, 'SYSTEM_CLOSE_ADMIN', 4, '后台管理开关', 5, '0:不关闭\r\n1:关闭', '关闭后在登录页面不再显示后台登录链接', 1403568006, 1403568006, 1, '0', 0),
(55, 'SYSTEM_CLOSE_WIKI', 4, '二次开发开关', 5, '0:不关闭\r\n1:关闭', '关闭后在登录页面不再显示二次开发链接', 1403568006, 1403568006, 1, '0', 0),
(56, 'SYSTEM_CLOSE_BBS', 4, '官方论坛开关', 5, '0:不关闭\r\n1:关闭', '关闭后在登录页面不再显示官方论坛链接', 1403568006, 1403568006, 1, '0', 0),
(57, 'LOGIN_BACKGROUP', 1, '登录界面背景图', 5, '', '请输入图片网址，为空时默认使用自带的背景图', 1403568006, 1403570059, 1, '', 0),
(60, 'TONGJI_CODE', 2, '第三方统计JS代码', 5, '', '', 1428634717, 1428634717, 1, '', 0),
(61, 'SENSITIVE_WORDS', 1, '敏感词', 0, '', '当出现有敏感词的地方，会用*号代替, (多个敏感词用 , 隔开 )', 1433125977, 1435062628, 1, 'bitch,shit', 0),
(63, 'PUBLIC_BIND', 4, '公众号第三方平台', 5, '0:关闭\r\n1:开启', '申请审核通过微信开放平台里的公众号第三方平台账号后，就可以开启体验了', 1434542818, 1434542818, 1, '0', 0),
(64, 'COMPONENT_APPID', 1, '公众号开放平台的AppID', 5, '', '公众号第三方平台开启后必填的参数', 1434542891, 1434542975, 1, '', 0),
(65, 'COMPONENT_APPSECRET', 1, '公众号开放平台的AppSecret', 5, '', '公众号第三方平台开启后必填的参数', 1434542936, 1434542984, 1, '', 0),
(62, 'REG_AUDIT', 4, '注册审核', 3, '0:需要审核\r\n1:不需要审核', '', 1439811099, 1439811099, 1, '1', 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_credit_config`
--

CREATE TABLE IF NOT EXISTS `dc_credit_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '积分描述',
  `name` varchar(50) DEFAULT NULL COMMENT '积分标识',
  `mTime` int(10) DEFAULT NULL COMMENT '修改时间',
  `experience` varchar(30) DEFAULT '0' COMMENT '经验值',
  `score` varchar(30) DEFAULT '0' COMMENT '金币值',
  `token` varchar(255) DEFAULT '0' COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=40 ;

--
-- 转存表中的数据 `dc_credit_config`
--

INSERT INTO `dc_credit_config` (`id`, `title`, `name`, `mTime`, `experience`, `score`, `token`) VALUES
(1, '关注公众号', 'subscribe', 1438587911, '100', '100', '0'),
(2, '取消关注公众号', 'unsubscribe', 1438596459, '-100', '-100', '0'),
(3, '参与投票', 'vote', 1398565597, '0', '0', '0'),
(4, '参与调研', 'survey', 1398565640, '0', '0', '0'),
(5, '参与考试', 'exam', 1398565659, '0', '0', '0'),
(6, '参与测试', 'test', 1398565681, '0', '0', '0'),
(7, '微信聊天', 'chat', 1398565740, '0', '0', '0'),
(8, '建议意见反馈', 'suggestions', 1398565798, '0', '0', '0'),
(9, '会员卡绑定', 'card_bind', 1438596438, '0', '0', '0'),
(10, '获取优惠卷', 'coupons', 1398565926, '0', '0', '0'),
(11, '访问微网站', 'weisite', 1398565973, '0', '0', '0'),
(12, '查看自定义回复内容', 'custom_reply', 1398566068, '0', '0', '0'),
(13, '填写通用表单', 'forms', 1398566118, '0', '0', '0'),
(14, '访问微商店', 'shop', 1398566206, '0', '0', '0'),
(32, '程序自由增加', 'auto_add', 1442659667, '￥', '￥', '0');

-- --------------------------------------------------------

--
-- 表的结构 `dc_credit_data`
--

CREATE TABLE IF NOT EXISTS `dc_credit_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT '0' COMMENT '用户ID',
  `credit_name` varchar(50) DEFAULT NULL COMMENT '积分标识',
  `experience` int(10) DEFAULT '0' COMMENT '体力值',
  `score` int(10) DEFAULT '0' COMMENT '积分值',
  `cTime` int(10) DEFAULT NULL COMMENT '记录时间',
  `admin_uid` int(10) DEFAULT '0' COMMENT '操作者UID',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `credit_title` varchar(50) DEFAULT NULL COMMENT '积分标题',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_customer`
--

CREATE TABLE IF NOT EXISTS `dc_customer` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `name` varchar(50) DEFAULT '',
  `sex` varchar(4) DEFAULT '',
  `mobile` varchar(200) DEFAULT '',
  `tel` varchar(200) DEFAULT '',
  `email` varchar(200) DEFAULT '',
  `company` varchar(100) DEFAULT '',
  `job` varchar(20) DEFAULT '',
  `address` varchar(120) DEFAULT '',
  `website` varchar(200) DEFAULT '',
  `qq` varchar(16) DEFAULT '',
  `weixin` varchar(50) DEFAULT '',
  `yixin` varchar(50) DEFAULT '',
  `weibo` varchar(50) DEFAULT '',
  `laiwang` varchar(50) DEFAULT '',
  `remark` varchar(255) DEFAULT '',
  `origin` bigint(20) unsigned NOT NULL DEFAULT '0',
  `originName` varchar(50) NOT NULL DEFAULT '',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `createUser` varchar(32) NOT NULL DEFAULT '',
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  `groupId` varchar(20) NOT NULL DEFAULT '',
  `groupName` varchar(200) DEFAULT '',
  `group` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_custom_menu`
--

CREATE TABLE IF NOT EXISTS `dc_custom_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sort` tinyint(4) DEFAULT '0' COMMENT '排序号',
  `pid` int(10) DEFAULT '0' COMMENT '一级菜单',
  `title` varchar(50) NOT NULL COMMENT '菜单名',
  `keyword` varchar(100) DEFAULT NULL COMMENT '关联关键词',
  `url` varchar(255) DEFAULT NULL COMMENT '关联URL',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `type` varchar(30) DEFAULT 'click' COMMENT '类型',
  `from_type` char(50) DEFAULT '-1' COMMENT '配置动作',
  `addon` char(50) DEFAULT '0' COMMENT '选择插件',
  `target_id` int(10) DEFAULT NULL COMMENT '选择内容',
  `sucai_type` char(50) DEFAULT '0' COMMENT '素材类型',
  `jump_type` char(10) DEFAULT '0' COMMENT '推送类型',
  `menu_id` int(10) DEFAULT NULL COMMENT '对应菜单ID，禁止修改',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_custom_menu_type`
--

CREATE TABLE IF NOT EXISTS `dc_custom_menu_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '菜单标题',
  `type` char(50) DEFAULT '0' COMMENT '菜单类型',
  `group_id` varchar(255) DEFAULT NULL COMMENT '用户分组id',
  `sex` char(50) DEFAULT NULL COMMENT '性别',
  `country` varchar(255) DEFAULT NULL COMMENT '国家信息',
  `province` varchar(255) DEFAULT NULL COMMENT '省份信息',
  `city` varchar(255) DEFAULT NULL COMMENT '城市信息',
  `client_platform_type` char(50) DEFAULT NULL COMMENT '手机操作系统类型',
  `menuid` varchar(255) DEFAULT NULL COMMENT '微信端菜单ID',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `cTime` int(10) DEFAULT NULL COMMENT '菜单发布时间',
  `show` char(50) DEFAULT '0' COMMENT '是否发布',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_custom_sendall`
--

CREATE TABLE IF NOT EXISTS `dc_custom_sendall` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ToUserName` varchar(255) DEFAULT NULL COMMENT 'token',
  `FromUserName` varchar(255) DEFAULT NULL COMMENT 'openid',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `msgType` varchar(255) DEFAULT NULL COMMENT '消息类型',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员id',
  `content` text COMMENT '内容',
  `media_id` varchar(255) DEFAULT NULL COMMENT '多媒体文件id',
  `is_send` int(10) DEFAULT NULL COMMENT '是否已经发送',
  `uid` int(10) DEFAULT NULL COMMENT '粉丝uid',
  `news_group_id` varchar(10) DEFAULT NULL COMMENT '图文组id',
  `video_title` varchar(255) DEFAULT NULL COMMENT '视频标题',
  `video_description` text COMMENT '视频描述',
  `video_thumb` varchar(255) DEFAULT NULL COMMENT '视频缩略图',
  `voice_id` int(10) DEFAULT NULL COMMENT '语音id',
  `image_id` int(10) DEFAULT NULL COMMENT '图片id',
  `video_id` int(10) DEFAULT NULL COMMENT '视频id',
  `send_type` int(10) DEFAULT NULL COMMENT '发送方式',
  `send_opends` text COMMENT '指定用户',
  `group_id` int(10) DEFAULT NULL COMMENT '分组id',
  `diff` int(10) DEFAULT '0' COMMENT '区分消息标识',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_donations_list`
--

CREATE TABLE IF NOT EXISTS `dc_donations_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` text COMMENT '捐赠者留言',
  `money` float DEFAULT NULL COMMENT '捐赠金额',
  `email` varchar(255) DEFAULT NULL COMMENT '捐赠者邮箱',
  `nickname` varchar(255) DEFAULT NULL COMMENT '捐赠者昵称',
  `ctime` int(10) DEFAULT NULL COMMENT '捐赠时间',
  `openid` varchar(255) DEFAULT NULL COMMENT '捐赠者openid',
  `token` varchar(255) DEFAULT NULL COMMENT '公众号token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_donations_money`
--

CREATE TABLE IF NOT EXISTS `dc_donations_money` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `desc` text COMMENT '描述',
  `money` int(10) DEFAULT NULL COMMENT '金额',
  `token` varchar(255) DEFAULT NULL COMMENT '公众号token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_extensions`
--

CREATE TABLE IF NOT EXISTS `dc_extensions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `keyword_type` tinyint(2) DEFAULT '0' COMMENT '关键词匹配类型',
  `api_token` varchar(255) NOT NULL COMMENT 'Token',
  `cTime` int(10) NOT NULL COMMENT '创建时间',
  `api_url` varchar(255) NOT NULL COMMENT '第三方URL',
  `output_format` tinyint(1) DEFAULT '0' COMMENT '数据输出格式',
  `keyword_filter` tinyint(2) NOT NULL DEFAULT '0' COMMENT '关键词过滤',
  `keyword` varchar(255) NOT NULL COMMENT '关键词',
  `token` varchar(255) NOT NULL COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_file`
--

CREATE TABLE IF NOT EXISTS `dc_file` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `savename` char(20) NOT NULL DEFAULT '' COMMENT '保存名称',
  `savepath` char(30) NOT NULL DEFAULT '' COMMENT '文件保存路径',
  `ext` char(5) NOT NULL DEFAULT '' COMMENT '文件后缀',
  `mime` char(40) NOT NULL DEFAULT '' COMMENT '文件mime类型',
  `size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文件大小',
  `md5` char(32) DEFAULT '' COMMENT '文件md5',
  `sha1` char(40) NOT NULL DEFAULT '' COMMENT '文件 sha1编码',
  `location` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '文件保存位置',
  `create_time` int(10) unsigned NOT NULL COMMENT '上传时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_md5` (`md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文件表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_forms`
--

CREATE TABLE IF NOT EXISTS `dc_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `cTime` int(10) unsigned DEFAULT NULL COMMENT '发布时间',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `password` varchar(255) DEFAULT NULL COMMENT '表单密码',
  `keyword_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '关键词类型',
  `jump_url` varchar(255) DEFAULT NULL COMMENT '提交后跳转的地址',
  `content` text COMMENT '详细介绍',
  `finish_tip` text COMMENT '用户提交后提示内容',
  `can_edit` tinyint(2) DEFAULT '0' COMMENT '是否允许编辑',
  `intro` text COMMENT '封面简介',
  `mTime` int(10) DEFAULT NULL COMMENT '修改时间',
  `cover` int(10) unsigned DEFAULT NULL COMMENT '封面图片',
  `keyword` varchar(100) NOT NULL COMMENT '关键词',
  `template` varchar(255) DEFAULT 'default' COMMENT '模板',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_forms_attribute`
--

CREATE TABLE IF NOT EXISTS `dc_forms_attribute` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '是否显示',
  `forms_id` int(10) unsigned DEFAULT NULL COMMENT '表单ID',
  `error_info` varchar(255) DEFAULT NULL COMMENT '出错提示',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序号',
  `validate_rule` varchar(255) DEFAULT NULL COMMENT '正则验证',
  `is_must` tinyint(2) DEFAULT NULL COMMENT '是否必填',
  `remark` varchar(255) DEFAULT NULL COMMENT '字段备注',
  `name` varchar(100) DEFAULT NULL COMMENT '字段名',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `value` varchar(255) DEFAULT NULL COMMENT '默认值',
  `title` varchar(255) NOT NULL COMMENT '字段标题',
  `mTime` int(10) DEFAULT NULL COMMENT '修改时间',
  `extra` text COMMENT '参数',
  `type` char(50) NOT NULL DEFAULT 'string' COMMENT '字段类型',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_forms_value`
--

CREATE TABLE IF NOT EXISTS `dc_forms_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `forms_id` int(10) unsigned DEFAULT NULL COMMENT '表单ID',
  `value` text COMMENT '表单值',
  `cTime` int(10) DEFAULT NULL COMMENT '增加时间',
  `openid` varchar(255) DEFAULT NULL COMMENT 'OpenId',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_forum`
--

CREATE TABLE IF NOT EXISTS `dc_forum` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `uid` int(10) DEFAULT '0' COMMENT '用户ID',
  `content` text COMMENT '内容',
  `cTime` int(10) DEFAULT NULL COMMENT '发布时间',
  `attach` varchar(255) DEFAULT NULL COMMENT '附件',
  `is_top` int(10) DEFAULT '0' COMMENT '置顶',
  `cid` tinyint(4) DEFAULT NULL COMMENT '分类',
  `view_count` int(11) unsigned DEFAULT '0' COMMENT '浏览数',
  `reply_count` int(11) unsigned DEFAULT '0' COMMENT '回复数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_hooks`
--

CREATE TABLE IF NOT EXISTS `dc_hooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(40) NOT NULL DEFAULT '' COMMENT '钩子名称',
  `description` text NOT NULL COMMENT '描述',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '类型',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `addons` text NOT NULL COMMENT '钩子挂载的插件 ''，''分割',
  PRIMARY KEY (`id`),
  UNIQUE KEY `搜索索引` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='插件钩子表' AUTO_INCREMENT=22 ;

--
-- 转存表中的数据 `dc_hooks`
--

INSERT INTO `dc_hooks` (`id`, `name`, `description`, `type`, `update_time`, `addons`) VALUES
(1, 'pageHeader', '页面header钩子，一般用于加载插件CSS文件和代码', 1, 0, ''),
(2, 'pageFooter', '页面footer钩子，一般用于加载插件JS文件和JS代码', 1, 0, 'ReturnTop'),
(3, 'documentEditForm', '添加编辑表单的 扩展内容钩子', 1, 0, ''),
(4, 'documentDetailAfter', '文档末尾显示', 1, 0, 'SocialComment'),
(5, 'documentDetailBefore', '页面内容前显示用钩子', 1, 0, ''),
(6, 'documentSaveComplete', '保存文档数据后的扩展钩子', 2, 0, ''),
(7, 'documentEditFormContent', '添加编辑表单的内容显示钩子', 1, 0, 'Editor'),
(8, 'adminArticleEdit', '后台内容编辑页编辑器', 1, 1378982734, 'EditorForAdmin'),
(13, 'AdminIndex', '首页小格子个性化显示', 1, 1382596073, 'SiteStat,SystemInfo,DevTeam'),
(14, 'topicComment', '评论提交方式扩展钩子。', 1, 1380163518, 'Editor'),
(16, 'app_begin', '应用开始', 2, 1384481614, ''),
(17, 'weixin', '微信插件必须加载的钩子', 1, 1388810858, 'Hitegg,Diy,RedBag,WeMedia,ShopCoupon,Card,SingIn,Seckill,WeiSite,AutoReply,YouaskService,Tmplmsg,SceneQrcode,UserCenter,Shop,Example,Donations,Extensions,Forms,Dg,Suggestions,Leaflets,AddressManage,Payment,Idioms,Tuling,CustomMenu'),
(18, 'cascade', '级联菜单', 1, 1398694587, 'Cascade'),
(19, 'page_diy', '万能页面的钩子', 1, 1399040364, 'Diy'),
(20, 'dynamic_select', '动态下拉菜单', 1, 1435223189, 'DynamicSelect'),
(21, 'news', '图文素材选择', 1, 1439196828, 'News');

-- --------------------------------------------------------

--
-- 表的结构 `dc_import`
--

CREATE TABLE IF NOT EXISTS `dc_import` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `attach` int(10) unsigned NOT NULL COMMENT '上传文件',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_invite_code`
--

CREATE TABLE IF NOT EXISTS `dc_invite_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(100) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_join_count`
--

CREATE TABLE IF NOT EXISTS `dc_join_count` (
  `follow_id` int(10) DEFAULT NULL,
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aim_id` int(10) DEFAULT NULL,
  `count` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fid_aim` (`follow_id`,`aim_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_keyword`
--

CREATE TABLE IF NOT EXISTS `dc_keyword` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `keyword` varchar(100) NOT NULL COMMENT '关键词',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `addon` varchar(255) NOT NULL COMMENT '关键词所属插件',
  `aim_id` int(10) unsigned NOT NULL COMMENT '插件表里的ID值',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `keyword_length` int(10) unsigned DEFAULT '0' COMMENT '关键词长度',
  `keyword_type` tinyint(2) DEFAULT '0' COMMENT '匹配类型',
  `extra_text` text COMMENT '文本扩展',
  `extra_int` int(10) DEFAULT NULL COMMENT '数字扩展',
  `request_count` int(10) DEFAULT '0' COMMENT '请求数',
  PRIMARY KEY (`id`),
  KEY `keyword_token` (`keyword`,`token`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_manager`
--

CREATE TABLE IF NOT EXISTS `dc_manager` (
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `has_public` tinyint(2) DEFAULT '0' COMMENT '是否配置公众号',
  `headface_url` int(10) unsigned DEFAULT NULL COMMENT '管理员头像',
  `GammaAppId` varchar(30) DEFAULT NULL COMMENT '摇电视的AppId',
  `GammaSecret` varchar(100) DEFAULT NULL COMMENT '摇电视的Secret',
  `copy_right` varchar(255) DEFAULT NULL COMMENT '授权信息',
  `tongji_code` text COMMENT '统计代码',
  `website_logo` int(10) unsigned DEFAULT NULL COMMENT '网站LOGO',
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `dc_manager`
--

INSERT INTO `dc_manager` (`uid`, `has_public`, `headface_url`, `GammaAppId`, `GammaSecret`, `copy_right`, `tongji_code`, `website_logo`) VALUES
(1, 0, 1, NULL, NULL, '', '', 2);

-- --------------------------------------------------------

--
-- 表的结构 `dc_manager_menu`
--

CREATE TABLE IF NOT EXISTS `dc_manager_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `menu_type` tinyint(2) DEFAULT '0' COMMENT '菜单类型',
  `pid` varchar(50) DEFAULT '0' COMMENT '上级菜单',
  `title` varchar(50) DEFAULT NULL COMMENT '菜单名',
  `url_type` tinyint(2) DEFAULT '0' COMMENT '链接类型',
  `addon_name` varchar(30) DEFAULT NULL COMMENT '插件名',
  `url` varchar(255) DEFAULT NULL COMMENT '外链',
  `target` char(50) DEFAULT '_self' COMMENT '打开方式',
  `is_hide` tinyint(2) DEFAULT '0' COMMENT '是否隐藏',
  `sort` int(10) DEFAULT '0' COMMENT '排序号',
  `uid` int(10) DEFAULT NULL COMMENT '管理员ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=356 ;

--
-- 转存表中的数据 `dc_manager_menu`
--

INSERT INTO `dc_manager_menu` (`id`, `menu_type`, `pid`, `title`, `url_type`, `addon_name`, `url`, `target`, `is_hide`, `sort`, `uid`) VALUES
(1, 0, '', '豆信官网', 1, '', 'http://douchat.cc/', '_blank', 0, 1, 1),
(2, 0, '', '应用商城', 1, '', 'http://douchat.cc/wenda/?/shop/', '_blank', 0, 2, 1),
(3, 0, '', '交流社区', 1, '', 'http://douchat.cc/wenda/?/question/', '_blank', 0, 3, 1),
(4, 0, '', '开发手册', 1, '', 'http://doc.douchat.cc/', '_blank', 0, 4, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_material_file`
--

CREATE TABLE IF NOT EXISTS `dc_material_file` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_id` int(10) DEFAULT NULL COMMENT '上传文件',
  `cover_url` varchar(255) DEFAULT NULL COMMENT '本地URL',
  `media_id` varchar(100) DEFAULT '0' COMMENT '微信端图文消息素材的media_id',
  `wechat_url` varchar(255) DEFAULT NULL COMMENT '微信端的文件地址',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员ID',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `title` varchar(100) DEFAULT NULL COMMENT '素材名称',
  `type` int(10) DEFAULT NULL COMMENT '类型',
  `introduction` text COMMENT '描述',
  `is_use` int(10) DEFAULT '1' COMMENT '可否使用',
  `aim_id` int(10) DEFAULT NULL COMMENT '添加来源标识id',
  `aim_table` varchar(255) DEFAULT NULL COMMENT '来源表名',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_material_image`
--

CREATE TABLE IF NOT EXISTS `dc_material_image` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cover_id` int(10) DEFAULT NULL COMMENT '图片在本地的ID',
  `cover_url` varchar(255) DEFAULT NULL COMMENT '本地URL',
  `media_id` varchar(100) DEFAULT '0' COMMENT '微信端图文消息素材的media_id',
  `wechat_url` varchar(255) DEFAULT NULL COMMENT '微信端的图片地址',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员ID',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `is_use` int(10) DEFAULT '1' COMMENT '可否使用',
  `aim_id` int(10) DEFAULT NULL COMMENT '添加来源标识id',
  `aim_table` varchar(255) DEFAULT NULL COMMENT '来源表名',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_material_news`
--

CREATE TABLE IF NOT EXISTS `dc_material_news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `author` varchar(30) DEFAULT NULL COMMENT '作者',
  `cover_id` int(10) unsigned DEFAULT NULL COMMENT '封面',
  `intro` varchar(255) DEFAULT NULL COMMENT '摘要',
  `content` longtext COMMENT '内容',
  `link` varchar(255) DEFAULT NULL COMMENT '外链',
  `group_id` int(10) DEFAULT '0' COMMENT '多图文组的ID',
  `thumb_media_id` varchar(100) DEFAULT NULL COMMENT '图文消息的封面图片素材id（必须是永久mediaID）',
  `media_id` varchar(100) DEFAULT '0' COMMENT '微信端图文消息素材的media_id',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员ID',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `cTime` int(10) DEFAULT NULL COMMENT '发布时间',
  `url` varchar(255) DEFAULT NULL COMMENT '图文页url',
  `is_use` int(10) DEFAULT '1' COMMENT '可否使用',
  `aim_id` int(10) DEFAULT NULL COMMENT '添加来源标识id',
  `aim_table` varchar(255) DEFAULT NULL COMMENT '来源表名',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_material_text`
--

CREATE TABLE IF NOT EXISTS `dc_material_text` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` text COMMENT '文本内容',
  `token` varchar(50) DEFAULT NULL COMMENT 'Token',
  `uid` int(10) DEFAULT NULL COMMENT 'uid',
  `is_use` int(10) DEFAULT '1' COMMENT '可否使用',
  `aim_id` int(10) DEFAULT NULL COMMENT '添加来源标识id',
  `aim_table` varchar(255) DEFAULT NULL COMMENT '来源表名',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_menu`
--

CREATE TABLE IF NOT EXISTS `dc_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序（同级有效）',
  `url` char(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `hide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `tip` varchar(255) NOT NULL DEFAULT '' COMMENT '提示',
  `group` varchar(50) DEFAULT '' COMMENT '分组',
  `is_dev` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否仅开发者模式可见',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台导航数据表' AUTO_INCREMENT=153 ;

--
-- 转存表中的数据 `dc_menu`
--

INSERT INTO `dc_menu` (`id`, `title`, `pid`, `sort`, `url`, `hide`, `tip`, `group`, `is_dev`) VALUES
(4, '新增', 3, 0, 'article/add', 0, '', '', 0),
(5, '编辑', 3, 0, 'article/edit', 0, '', '', 0),
(6, '改变状态', 3, 0, 'article/setStatus', 0, '', '', 0),
(7, '保存', 3, 0, 'article/update', 0, '', '', 0),
(8, '保存草稿', 3, 0, 'article/autoSave', 0, '', '', 0),
(9, '移动', 3, 0, 'article/move', 0, '', '', 0),
(10, '复制', 3, 0, 'article/copy', 0, '', '', 0),
(11, '粘贴', 3, 0, 'article/paste', 0, '', '', 0),
(12, '导入', 3, 0, 'article/batchOperate', 0, '', '', 0),
(14, '还原', 13, 0, 'article/permit', 0, '', '', 0),
(15, '清空', 13, 0, 'article/clear', 0, '', '', 0),
(16, '用户', 0, 2, 'User/index', 0, '', '', 0),
(17, '用户信息', 16, 0, 'User/index', 0, '', '用户管理', 0),
(18, '新增用户', 17, 0, 'User/add', 0, '添加新用户', '', 0),
(19, '用户行为', 16, 0, 'User/action', 0, '', '行为管理', 0),
(20, '新增用户行为', 19, 0, 'User/addaction', 0, '', '', 0),
(21, '编辑用户行为', 19, 0, 'User/editaction', 0, '', '', 0),
(22, '保存用户行为', 19, 0, 'User/saveAction', 0, '"用户->用户行为"保存编辑和新增的用户行为', '', 0),
(23, '变更行为状态', 19, 0, 'User/setStatus', 0, '"用户->用户行为"中的启用,禁用和删除权限', '', 0),
(24, '禁用会员', 19, 0, 'User/changeStatus?method=forbidUser', 0, '"用户->用户信息"中的禁用', '', 0),
(25, '启用会员', 19, 0, 'User/changeStatus?method=resumeUser', 0, '"用户->用户信息"中的启用', '', 0),
(26, '删除会员', 19, 0, 'User/changeStatus?method=deleteUser', 0, '"用户->用户信息"中的删除', '', 0),
(27, '用户组管理', 16, 0, 'AuthManager/index', 0, '', '用户管理', 0),
(28, '删除', 27, 0, 'AuthManager/changeStatus?method=deleteGroup', 0, '删除用户组', '', 0),
(29, '禁用', 27, 0, 'AuthManager/changeStatus?method=forbidGroup', 0, '禁用用户组', '', 0),
(30, '恢复', 27, 0, 'AuthManager/changeStatus?method=resumeGroup', 0, '恢复已禁用的用户组', '', 0),
(31, '新增', 27, 0, 'AuthManager/createGroup', 0, '创建新的用户组', '', 0),
(32, '编辑', 27, 0, 'AuthManager/editGroup', 0, '编辑用户组名称和描述', '', 0),
(33, '保存用户组', 27, 0, 'AuthManager/writeGroup', 0, '新增和编辑用户组的"保存"按钮', '', 0),
(34, '授权', 27, 0, 'AuthManager/group', 0, '"后台 \\ 用户 \\ 用户信息"列表页的"授权"操作按钮,用于设置用户所属用户组', '', 0),
(35, '访问授权', 27, 0, 'AuthManager/access', 0, '"后台 \\ 用户 \\ 权限管理"列表页的"访问授权"操作按钮', '', 0),
(36, '成员授权', 27, 0, 'AuthManager/user', 0, '"后台 \\ 用户 \\ 权限管理"列表页的"成员授权"操作按钮', '', 0),
(37, '解除授权', 27, 0, 'AuthManager/removeFromGroup', 0, '"成员授权"列表页内的解除授权操作按钮', '', 0),
(38, '保存成员授权', 27, 0, 'AuthManager/addToGroup', 0, '"用户信息"列表页"授权"时的"保存"按钮和"成员授权"里右上角的"添加"按钮)', '', 0),
(39, '分类授权', 27, 0, 'AuthManager/category', 0, '"后台 \\ 用户 \\ 权限管理"列表页的"分类授权"操作按钮', '', 0),
(40, '保存分类授权', 27, 0, 'AuthManager/addToCategory', 0, '"分类授权"页面的"保存"按钮', '', 0),
(41, '模型授权', 27, 0, 'AuthManager/modelauth', 0, '"后台 \\ 用户 \\ 权限管理"列表页的"模型授权"操作按钮', '', 0),
(42, '保存模型授权', 27, 0, 'AuthManager/addToModel', 0, '"分类授权"页面的"保存"按钮', '', 0),
(43, '插件管理', 0, 7, 'Addons/index', 0, '', '', 0),
(44, '插件管理', 43, 1, 'Admin/Plugin/index', 0, '', '扩展', 0),
(45, '创建', 44, 0, 'Addons/create', 0, '服务器上创建插件结构向导', '', 0),
(46, '检测创建', 44, 0, 'Addons/checkForm', 0, '检测插件是否可以创建', '', 0),
(47, '预览', 44, 0, 'Addons/preview', 0, '预览插件定义类文件', '', 0),
(48, '快速生成插件', 44, 0, 'Addons/build', 0, '开始生成插件结构', '', 0),
(49, '设置', 44, 0, 'Addons/config', 0, '设置插件配置', '', 0),
(50, '禁用', 44, 0, 'Addons/disable', 0, '禁用插件', '', 0),
(51, '启用', 44, 0, 'Addons/enable', 0, '启用插件', '', 0),
(52, '安装', 44, 0, 'Addons/install', 0, '安装插件', '', 0),
(53, '卸载', 44, 0, 'Addons/uninstall', 0, '卸载插件', '', 0),
(54, '更新配置', 44, 0, 'Addons/saveconfig', 0, '更新插件配置处理', '', 0),
(55, '插件后台列表', 44, 0, 'Addons/adminList', 0, '', '', 0),
(56, 'URL方式访问插件', 44, 0, 'Addons/execute', 0, '控制是否有权限通过url访问插件控制器方法', '', 0),
(57, '钩子管理', 43, 3, 'Addons/hooks', 0, '', '扩展', 0),
(58, '模型管理', 68, 3, 'Model/index', 0, '', '系统设置', 0),
(59, '新增', 58, 0, 'model/add', 0, '', '', 0),
(60, '编辑', 58, 0, 'model/edit', 0, '', '', 0),
(61, '改变状态', 58, 0, 'model/setStatus', 0, '', '', 0),
(62, '保存数据', 58, 0, 'model/update', 0, '', '', 0),
(64, '新增', 63, 0, 'Attribute/add', 0, '', '', 0),
(65, '编辑', 63, 0, 'Attribute/edit', 0, '', '', 0),
(66, '改变状态', 63, 0, 'Attribute/setStatus', 0, '', '', 0),
(67, '保存数据', 63, 0, 'Attribute/update', 0, '', '', 0),
(68, '系统', 0, 1, 'Config/group', 0, '', '', 0),
(69, '网站设置', 68, 1, 'Config/group', 0, '', '系统设置', 0),
(70, '配置管理', 68, 4, 'Config/index', 0, '', '系统设置', 0),
(71, '编辑', 70, 0, 'Config/edit', 0, '新增编辑和保存配置', '', 0),
(72, '删除', 70, 0, 'Config/del', 0, '删除配置', '', 0),
(73, '新增', 70, 0, 'Config/add', 0, '新增配置', '', 0),
(74, '保存', 70, 0, 'Config/save', 0, '保存配置', '', 0),
(75, '菜单管理', 68, 5, 'Menu/index', 0, '', '系统设置', 0),
(76, '导航管理', 68, 6, 'Channel/index', 0, '', '系统设置', 0),
(77, '新增', 76, 0, 'Channel/add', 0, '', '', 0),
(78, '编辑', 76, 0, 'Channel/edit', 0, '', '', 0),
(79, '删除', 76, 0, 'Channel/del', 0, '', '', 0),
(146, '权限节点', 16, 0, 'Admin/Rule/index', 0, '', '用户管理', 1),
(81, '编辑', 80, 0, 'Category/edit', 0, '编辑和保存栏目分类', '', 0),
(82, '新增', 80, 0, 'Category/add', 0, '新增栏目分类', '', 0),
(83, '删除', 80, 0, 'Category/remove', 0, '删除栏目分类', '', 0),
(84, '移动', 80, 0, 'Category/operate/type/move', 0, '移动栏目分类', '', 0),
(85, '合并', 80, 0, 'Category/operate/type/merge', 0, '合并栏目分类', '', 0),
(86, '备份数据库', 68, 0, 'Database/index?type=export', 0, '', '数据备份', 0),
(87, '备份', 86, 0, 'Database/export', 0, '备份数据库', '', 0),
(88, '优化表', 86, 0, 'Database/optimize', 0, '优化数据表', '', 0),
(89, '修复表', 86, 0, 'Database/repair', 0, '修复数据表', '', 0),
(90, '还原数据库', 68, 0, 'Database/index?type=import', 0, '', '数据备份', 0),
(91, '恢复', 90, 0, 'Database/import', 0, '数据库恢复', '', 0),
(92, '删除', 90, 0, 'Database/del', 0, '删除备份文件', '', 0),
(96, '新增', 75, 0, 'Menu/add', 0, '', '系统设置', 0),
(98, '编辑', 75, 0, 'Menu/edit', 0, '', '', 0),
(104, '下载管理', 102, 0, 'Think/lists?model=download', 0, '', '', 0),
(105, '配置管理', 102, 0, 'Think/lists?model=config', 0, '', '', 0),
(106, '行为日志', 16, 0, 'Action/actionlog', 0, '', '行为管理', 0),
(108, '修改密码', 16, 0, 'User/updatePassword', 0, '', '', 0),
(109, '修改昵称', 16, 0, 'User/updateNickname', 0, '', '', 0),
(110, '查看行为日志', 106, 0, 'action/edit', 0, '', '', 0),
(112, '新增数据', 58, 0, 'think/add', 0, '', '', 0),
(113, '编辑数据', 58, 0, 'think/edit', 0, '', '', 0),
(114, '导入', 75, 0, 'Menu/import', 0, '', '', 0),
(115, '生成', 58, 0, 'Model/generate', 0, '', '', 0),
(116, '新增钩子', 57, 0, 'Addons/addHook', 0, '', '', 0),
(117, '编辑钩子', 57, 0, 'Addons/edithook', 0, '', '', 0),
(118, '文档排序', 3, 0, 'Article/sort', 0, '', '', 0),
(119, '排序', 70, 0, 'Config/sort', 0, '', '', 0),
(120, '排序', 75, 0, 'Menu/sort', 0, '', '', 0),
(121, '排序', 76, 0, 'Channel/sort', 0, '', '', 0),
(124, '微信插件', 43, 0, 'Admin/Addons/index', 0, '', '扩展', 0),
(126, '公众号等级', 16, 0, 'admin/PublicGroup/PublicGroup', 0, '', '公众号管理', 0),
(127, '公众号管理', 16, 1, 'admin/PublicGroup/PublicAdmin', 0, '', '公众号管理', 0),
(128, '在线升级', 68, 5, 'Admin/Update/index', 0, '', '系统设置', 0),
(129, '清除缓存', 68, 10, 'Admin/Update/delcache', 0, '', '系统设置', 0),
(130, '应用商店', 0, 8, 'admin/store/index', 0, '', '', 1),
(131, '素材图标', 130, 2, 'admin/store/index?type=material', 0, '', '应用类型', 0),
(132, '微站模板', 130, 1, 'admin/store/index?type=template', 0, '', '应用类型', 0),
(133, '我是开发者', 130, 1, '/index.php?s=/home/developer/myApps', 0, '', '开发者', 0),
(134, '新手安装指南', 130, 0, 'admin/store/index?type=help', 0, '', '我是站长', 0),
(135, '万能页面', 130, 3, 'admin/store/index?type=diy', 0, '', '应用类型', 0),
(136, '上传新应用', 130, 2, '/index.php?s=/home/developer/submitApp', 0, '', '开发者', 0),
(137, '二次开发教程', 130, 3, '/wiki', 0, '', '开发者', 0),
(138, '网站信息', 130, 0, 'admin/store/index?type=home', 0, '', '我是站长', 0),
(139, '充值记录', 130, 0, 'admin/store/index?type=recharge', 0, '', '我是站长', 0),
(140, '消费记录', 130, 0, 'admin/store/index?type=bug', 0, '', '我是站长', 0),
(141, '官方交流论坛', 130, 4, '/bbs', 0, '', '开发者', 0),
(142, '在线充值', 130, 0, 'admin/store/index?type=online_recharge', 0, '', '我是站长', 0),
(143, '微信插件', 130, 0, 'admin/store/index?type=addon', 0, '', '应用类型', 0),
(144, '公告管理', 68, 4, 'Notice/lists', 0, '', '系统设置', 0),
(147, '图文样式编辑', 68, 4, 'ArticleStyle/lists', 0, '', '系统设置', 0),
(148, '增加', 147, 0, 'ArticleStyle/add', 0, '', '', 0),
(149, '分组管理', 147, 0, 'ArticleStyle/group', 0, '', '', 0),
(150, '微信接口节点', 16, 0, 'Admin/Rule/wechat', 0, '', '用户管理', 0),
(151, '公众号组管理', 16, 0, 'Admin/AuthManager/wechat', 0, '', '用户管理', 0),
(152, '积分选项管理', 16, 6, 'Admin/Credit/lists', 0, '', '用户管理', 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_message`
--

CREATE TABLE IF NOT EXISTS `dc_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `bind_keyword` varchar(50) DEFAULT NULL COMMENT '关联关键词',
  `preview_openids` text COMMENT '预览人OPENID',
  `group_id` int(10) DEFAULT '0' COMMENT '群发对象',
  `type` tinyint(2) DEFAULT '0' COMMENT '素材来源',
  `media_id` varchar(100) DEFAULT NULL COMMENT '微信素材ID',
  `send_type` tinyint(1) DEFAULT '0' COMMENT '发送方式',
  `send_openids` text COMMENT '要发送的OpenID',
  `msg_id` varchar(255) DEFAULT NULL COMMENT 'msg_id',
  `content` text COMMENT '文本消息内容',
  `msgtype` varchar(255) DEFAULT NULL COMMENT '消息类型',
  `token` varchar(255) DEFAULT NULL COMMENT 'token',
  `appmsg_id` int(10) DEFAULT NULL COMMENT '图文id',
  `voice_id` int(10) DEFAULT NULL COMMENT '语音id',
  `video_id` int(10) DEFAULT NULL COMMENT '视频id',
  `cTime` int(10) DEFAULT NULL COMMENT '群发时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_model`
--

CREATE TABLE IF NOT EXISTS `dc_model` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '模型ID',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '模型标识',
  `title` char(30) NOT NULL DEFAULT '' COMMENT '模型名称',
  `extend` int(10) unsigned DEFAULT '0' COMMENT '继承的模型',
  `relation` varchar(30) DEFAULT '' COMMENT '继承与被继承模型的关联字段',
  `need_pk` tinyint(1) unsigned DEFAULT '1' COMMENT '新建表时是否需要主键字段',
  `field_sort` text COMMENT '表单字段排序',
  `field_group` varchar(255) DEFAULT '1:基础' COMMENT '字段分组',
  `attribute_list` text COMMENT '属性列表（表的字段）',
  `template_list` varchar(100) DEFAULT '' COMMENT '列表模板',
  `template_add` varchar(100) DEFAULT '' COMMENT '新增模板',
  `template_edit` varchar(100) DEFAULT '' COMMENT '编辑模板',
  `list_grid` text COMMENT '列表定义',
  `list_row` smallint(2) unsigned DEFAULT '10' COMMENT '列表数据长度',
  `search_key` varchar(50) DEFAULT '' COMMENT '默认搜索字段',
  `search_list` varchar(255) DEFAULT '' COMMENT '高级搜索的字段',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `engine_type` varchar(25) DEFAULT 'MyISAM' COMMENT '数据库引擎',
  `addon` varchar(50) DEFAULT NULL COMMENT '所属插件',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='系统模型表' AUTO_INCREMENT=1270 ;

--
-- 转存表中的数据 `dc_model`
--

INSERT INTO `dc_model` (`id`, `name`, `title`, `extend`, `relation`, `need_pk`, `field_sort`, `field_group`, `attribute_list`, `template_list`, `template_add`, `template_edit`, `list_grid`, `list_row`, `search_key`, `search_list`, `create_time`, `update_time`, `status`, `engine_type`, `addon`) VALUES
(1, 'user', '用户信息表', 0, '', 0, '["come_from","nickname","password","truename","mobile","email","sex","headimgurl","city","province","country","language","score","experience","unionid","login_count","reg_ip","reg_time","last_login_ip","last_login_time","status","is_init","is_audit"]', '1:基础', '', '', '', '', 'headimgurl|url_img_html:头像\r\nlogin_name:登录账号\r\nlogin_password:登录密码\r\nnickname|deal_emoji:用户昵称\r\nsex|get_name_by_status:性别\r\ngroup:分组\r\nscore:金币值\r\nexperience:经历值\r\nids:操作:set_login?uid=[uid]|设置登录账号,detail?uid=[uid]|详细资料,[EDIT]|编辑', 20, '', '', 1436929111, 1441187405, 1, 'MyISAM', 'Core'),
(2, 'manager', '公众号管理员配置', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1436932532, 1436942362, 1, 'MyISAM', 'Core'),
(3, 'manager_menu', '公众号管理员菜单', 0, '', 1, '["menu_type","pid","title","url_type","addon_name","url","target","is_hide","sort"]', '1:基础', '', '', '', '', 'title:菜单名\r\nmenu_type|get_name_by_status:菜单类型\r\naddon_name:插件名\r\nurl:外链\r\ntarget|get_name_by_status:打开方式\r\nis_hide|get_name_by_status:隐藏\r\nsort:排序号\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, '', '', 1435215960, 1437623073, 1, 'MyISAM', 'Core'),
(4, 'keyword', '关键词表', 0, '', 1, '["keyword","keyword_type","addon","aim_id","keyword_length","cTime","extra_text","extra_int"]', '1:基础', '', '', '', '', 'id:编号\r\nkeyword:关键词\r\naddon:所属插件\r\naim_id:插件数据ID\r\ncTime|time_format:增加时间\r\nrequest_count|intval:请求数\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'keyword', '', 1388815871, 1407251192, 1, 'MyISAM', 'Core'),
(5, 'qr_code', '二维码表', 0, '', 1, '["qr_code","addon","aim_id","cTime","extra_text","extra_int","scene_id","action_name"]', '1:基础', '', '', '', '', 'scene_id:事件KEY值\r\nqr_code|get_code_img:二维码\r\naction_name|get_name_by_status:  二维码类型\r\naddon:所属插件\r\naim_id:插件数据ID\r\ncTime|time_format:增加时间\r\nrequest_count|intval:请求数\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'qr_code', '', 1388815871, 1406130247, 1, 'MyISAM', 'Core'),
(6, 'public', '公众号管理', 0, '', 1, '["public_name","public_id","wechat","headface_url","type","appid","secret","encodingaeskey","tips_url","GammaAppId","GammaSecret","public_copy_right"]', '1:基础', '', '', '', '', 'id:公众号ID\r\npublic_name:公众号名称\r\ntoken:Token\r\ncount:管理员数\r\nids:操作:[EDIT]|编辑,[DELETE]|删除,main&public_id=[id]|进入管理', 20, 'public_name', '', 1391575109, 1447231672, 1, 'MyISAM', 'Core'),
(7, 'public_group', '公众号等级', 0, '', 1, '["title","addon_status"]', '1:基础', '', '', '', '', 'id:等级ID\r\ntitle:等级名\r\naddon_status:授权的插件\r\npublic_count:公众号数\r\nids:操作:editPublicGroup&id=[id]|编辑,delPublicGroup&id=[id]|删除', 20, 'title', '', 1393724788, 1393730663, 1, 'MyISAM', 'Core'),
(8, 'public_link', '公众号与管理员的关联关系', 0, '', 1, '["uid","addon_status"]', '1:基础', '', '', '', '', 'uid|get_nickname|deal_emoji:15%管理员(不包括创始人)\r\naddon_status:授权的插件\r\nids:10%操作:[EDIT]|编辑,[DELETE]|删除', 20, '', '', 1398933192, 1447233745, 1, 'MyISAM', 'Core'),
(9, 'import', '导入数据', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1407554076, 1407554076, 1, 'MyISAM', 'Core'),
(10, 'addon_category', '插件分类', 0, '', 1, '["icon","title","sort"]', '1:基础', '', '', '', '', 'icon|get_img_html:分类图标\r\ntitle:分类名\r\nsort:排序号\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1400047655, 1437451028, 1, 'MyISAM', 'Core'),
(12, 'common_category', '通用分类', 0, '', 1, '["pid","title","icon","intro","sort","is_show"]', '1:基础', '', '', '', '', 'code:编号\r\ntitle:标题\r\nicon|get_img_html:图标\r\nsort:排序号\r\nis_show|get_name_by_status:显示\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1397529095, 1404182789, 1, 'MyISAM', 'Core'),
(13, 'common_category_group', '通用分类分组', 0, '', 1, '["name","title"]', '1:基础', '', '', '', '', 'name:分组标识\r\ntitle:分组标题\r\nids:操作:cascade?target=_blank&module=[name]|数据管理,[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1396061373, 1403664378, 1, 'MyISAM', 'Core'),
(14, 'credit_config', '积分配置', 0, '', 1, '["name","title","score","experience"]', '1:基础', '', '', '', '', 'title:积分描述\r\nname:积分标识\r\nexperience:经验值\r\nscore:金币值\r\nids:操作:[EDIT]|配置', 20, 'title', '', 1396061373, 1438591151, 1, 'MyISAM', 'Core'),
(15, 'credit_data', '用户积分记录', 0, '', 1, '["uid","experience","score","credit_name"]', '1:基础', '', '', '', '', 'uid:用户\r\ncredit_title:积分来源\r\nexperience:经验值\r\nscore:金币值\r\ncTime|time_format:记录时间\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'uid', '', 1398564291, 1447250833, 1, 'MyISAM', 'Core'),
(16, 'material_image', '图片素材', 0, '', 1, '', '1:基础', '', '', '', '', '', 10, '', '', 1438684613, 1438684613, 1, 'MyISAM', 'Core'),
(17, 'material_news', '图文素材', 0, '', 1, '', '1:基础', '', '', '', '', '', 10, '', '', 1438670890, 1438670890, 1, 'MyISAM', 'Core'),
(18, 'message', '群发消息', 0, '', 1, '["type","bind_keyword","media_id","openid","send_type","group_id","send_openids"]', '1:基础', '', '', '', '', '', 20, '', '', 1437984111, 1438049406, 1, 'MyISAM', 'Core'),
(19, 'visit_log', '网站访问日志', 0, '', 1, '', '1:基础', '', '', '', '', '', 10, '', '', 1439448351, 1439448351, 1, 'MyISAM', 'Core'),
(20, 'auth_group', '用户组', 0, '', 1, '["title","description"]', '1:基础', '', '', '', '', 'title:分组名称\r\ndescription:描述\r\nqr_code:二维码\r\nids:操作:export?id=[id]|导出用户,[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1437633503, 1447660681, 1, 'MyISAM', 'Core'),
(21, 'analysis', '统计分析', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1432806941, 1432806941, 1, 'MyISAM', 'Core'),
(22, 'article_style', '图文样式', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1436845488, 1436845488, 1, 'MyISAM', 'Core'),
(23, 'article_style_group', '图文样式分组', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1436845186, 1436845186, 1, 'MyISAM', 'Core'),
(24, 'sucai', '素材管理', 0, '', 1, '["name","status","cTime","url","type","detail","reason","create_time","checked_time","source","source_id"]', '1:基础', '', '', '', '', 'name:素材名称\r\nstatus|get_name_by_status:状态\r\nurl:页面URL\r\ncreate_time|time_format:申请时间\r\nchecked_time|time_format:入库时间\r\nids:操作', 20, 'name', '', 1424611702, 1425386629, 1, 'MyISAM', 'Core'),
(25, 'sucai_template', '素材模板库', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1431575544, 1431575544, 1, 'MyISAM', 'Core'),
(26, 'system_notice', '系统公告表', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1431141043, 1431141043, 1, 'MyISAM', 'Core'),
(27, 'update_version', '系统版本升级', 0, '', 1, '["version","title","description","create_date","package"]', '1:基础', '', '', '', '', 'version:版本号\r\ntitle:升级包名\r\ndescription:描述\r\ncreate_date|time_format:创建时间\r\ndownload_count:下载统计数\r\nids:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除', 20, '', '', 1393770420, 1393771807, 1, 'MyISAM', 'Core'),
(28, 'weixin_message', '微信消息管理', 0, '', 1, '', '1:基础', '', '', '', '', 'FromUserName:用户\r\ncontent:内容\r\nCreateTime:时间', 20, '', '', 1438142999, 1438151555, 1, 'MyISAM', 'Core'),
(29, 'custom_sendall', '客服群发消息', 0, '', 1, '', '1:基础', NULL, '', '', '', NULL, 10, '', '', 1447241925, 1447241925, 1, 'MyISAM', 'Core'),
(30, 'material_text', '文本素材', 0, '', 1, '["content"]', '1:基础', '', '', '', '', 'id:编号\r\ncontent:文本内容\r\nids:操作:text_edit?id=[id]|编辑,text_del?id=[id]|删除', 10, 'content:请输入文本内容搜索', '', 1442976119, 1442977453, 1, 'MyISAM', 'Core'),
(31, 'material_file', '文件素材', 0, '', 1, '["title","file_id"]', '1:基础', '', '', '', '', '', 10, '', '', 1438684613, 1442982212, 1, 'MyISAM', 'Core'),
(32, 'update_score_log', '修改积分记录', 0, '', 1, '', '1:基础', NULL, '', '', '', NULL, 10, '', '', 1444302325, 1444302325, 1, 'MyISAM', 'Core'),
(1235, 'weisite_cms', '文章管理', 0, '', 1, '["keyword","keyword_type","title","intro","cate_id","cover","content","sort"]', '1:基础', '', '', '', '', 'keyword:关键词\r\nkeyword_type|get_name_by_status:关键词类型\r\ntitle:标题\r\ncate_id:所属分类\r\nsort:排序号\r\nview_count:浏览数\r\nids:操作:[EDIT]&module_id=[pid]|编辑,[DELETE]|删除', 20, 'title', '', 1396061373, 1408326292, 1, 'MyISAM', NULL),
(1236, 'weisite_category', '微官网分类', 0, '', 1, '["title","icon","url","is_show","sort","pid"]', '1:基础', '', '', '', '', 'title:15%分类标题\r\nicon|get_img_html:分类图片\r\nurl:30%外链\r\nsort:10%排序号\r\npid:10%一级目录\r\nis_show|get_name_by_status:10%显示\r\nid:10%操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1395987942, 1439522869, 1, 'MyISAM', NULL),
(1237, 'weisite_slideshow', '幻灯片', 0, '', 1, '["title","img","url","is_show","sort"]', '1:基础', '', '', '', '', 'title:标题\r\nimg:图片\r\nurl:链接地址\r\nis_show|get_name_by_status:显示\r\nsort:排序\r\nids:操作:[EDIT]&module_id=[pid]|编辑,[DELETE]|删除', 20, 'title', '', 1396098264, 1408323347, 1, 'MyISAM', NULL),
(1238, 'weisite_footer', '底部导航', 0, '', 1, '["pid","title","url","sort"]', '1:基础', '', '', '', '', 'title:菜单名\r\nicon:图标\r\nurl:关联URL\r\nsort:排序号\r\nids:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1394518309, 1396507698, 1, 'MyISAM', NULL),
(1239, 'auto_reply', '自动回复', 0, '', 1, '["keyword","content","group_id","image_id","reply_scene"]', '1:基础', '', '', '', '', 'keyword:关键词\r\nmsg_type:回复类型\r\ncontent:文本\r\ngroup_id:图文\r\nimage_id:图片\r\nid:操作:add&id=[id]|编辑,[DELETE]|删除', 10, 'keyword:请输入关键词', '', 1439194522, 1449200272, 1, 'MyISAM', 'AutoReply'),
(1268, 'custom_menu', '自定义菜单', 0, '', 1, '["pid","title","from_type","type","jump_type","addon","sucai_type","keyword","url","sort"]', '1:基础', '', '', '', '', 'title:10%菜单名\r\nkeyword:10%关联关键词\r\nurl:50%关联URL\r\nsort:5%排序号\r\nid:10%操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1394518309, 1447317015, 1, 'MyISAM', 'CustomMenu'),
(1241, 'youaskservice_group', '你问我答-客服分组', 0, '', 1, '["groupname"]', '1:基础', '', '', '', '', 'id:编号\r\ngroupname:分组名称\r\ntoken:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'groupname', '', 1404475456, 1404491410, 1, 'MyISAM', 'YouaskService'),
(1242, 'youaskservice_keyword', '你问我答-关键词指配', 0, '', 1, '["msgkeyword","msgkeyword_type","zdtype","msgstate"]', '1:基础', '', '', '', '', 'id:编号\r\nmsgkeyword:关键字\r\nkf_explain:客服说明\r\nmsgkeyword_type|get_name_by_status:匹配类型\r\nmsgkfaccount:指定的接待客服或分组\r\nmsgstate|get_name_by_status:状态\r\nzdtype:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'msgkeyword', '', 1404399143, 1450018481, 1, 'MyISAM', 'YouaskService'),
(1243, 'youaskservice_user', '你问我答-客服工号', 0, '', 1, '["name","userName","userPwd","state","kfid"]', '1:基础', '', '', '', '', 'kfid:客服编号\r\nname:客服昵称\r\nuserName:客服帐号\r\ntoken:操作:[EDIT]|编辑,[DELETE]|删除', 20, 'name', 'userName', 1403947253, 1450018368, 1, 'MyISAM', 'YouaskService'),
(1244, 'tmplmsg', '模板消息', 0, '', 1, '{"1":["openid","template_id","message","MsgID","sendstatus","Status","ctime"]}', '1:基础', '', '', '', '', 'id:ID\r\nopenid:OPENID\r\ntemplate_id:模板ID\r\nsendstatus|get_name_by_status:发送状态\r\nStatus|get_name_by_status:送达报告\r\nMsgID:消息ID\r\nctime|time_format:发送时间\r\nid:操作:[DELETE]|删除', 10, 'openid', '', 1409247434, 1409276606, 1, 'MyISAM', NULL),
(1246, 'scene_qrcode', '场景二维码', 0, '', 1, '["scene_name","keyword","scene_type","scene_str","expire"]', '1:基础', '', '', '', '', 'scene_name:场景名称\r\nkeyword:关联关键词\r\nscene_type:类型\r\nid|getSceneIdOrStr:场景值ID/字符串\r\nshort_url:二维码\r\nexpire:过期时间\r\nid|getScanTimes:扫描次数\r\nid|getScanPersons:扫描人数\r\nctime|time_format:创建时间\r\nid|getExpiretime:到期时间\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除,viewScan&id=[id]|查看扫描统计', 10, 'scene_name', '', 1448517943, 1448544430, 1, 'MyISAM', NULL),
(1247, 'scene_qrcode_statistics', '场景二维码扫描统计', 0, '', 1, '["scene_name","keyword","scene_id","scan_type","ctime"]', '1:基础', '', '', '', '', 'scene_name:场景名称\r\nkeyword:关联关键词\r\nopenid|getFollowNickname:扫码者昵称\r\nopenid|getFollowHeadimg:扫码者头像\r\nscan_type|getScanType:扫码类型\r\nctime|time_format:扫码时间', 10, 'scene_name', '', 1448529386, 1448530035, 1, 'MyISAM', NULL),
(1248, 'shop', '微商城', 0, '', 1, '["title","logo","intro","mobile","qq","wechat","content"]', '1:基础', '', '', '', '', 'title:商店名称\r\nlogo|get_img_html:商店LOGO\r\nmobile:联系电话\r\nqq:QQ号\r\nwechat:微信号\r\nids:操作:[EDIT]&id=[id]|编辑,lists&_controller=Category&target=_blank&shop_id=[id]|商品分类,lists&_controller=Slideshow&target=_blank&shop_id=[id]|幻灯片,lists&_controller=Goods&target=_blank&shop_id=[id]|商品管理,lists&_controller=Order&target=_blank&shop_id=[id]|订单管理,lists&_addons=Payment&_controller=Payment&target=_blank&shop_id=[id]|支付配置,lists&_controller=Template&target=_blank&shop_id=[id]|模板选择,[DELETE]|删除,index&_controller=Wap&target=_blank&shop_id=[id]|预览', 20, 'title:请输入商店名称', '', 1422670956, 1423640744, 1, 'MyISAM', NULL),
(1249, 'shop_goods', '商品列表', 0, '', 1, '["title","imgs","category_id","price","is_recommend","content","cover","inventory","is_show","old_price"]', '1:基础', '', '', '', '', 'category_id:商品分类\r\ncover|get_img_html:封面图\r\ntitle:商品名称\r\nprice:价格\r\ninventory:库存量\r\nsale_count:销售量\r\nis_show|get_name_by_status:是否上架\r\nids:操作:set_show?id=[id]&is_show=[is_show]|改变上架状态,[EDIT]|编辑,[DELETE]|删除', 20, 'title:请输入商品名称', '', 1422672084, 1440124560, 1, 'MyISAM', NULL),
(1250, 'shop_collect', '商品收藏', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1423471275, 1423471275, 1, 'MyISAM', NULL),
(1251, 'shop_cart', '购物车', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1419577864, 1419577864, 1, 'MyISAM', NULL),
(1252, 'shop_address', '收货地址', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1423477477, 1423477477, 1, 'MyISAM', NULL),
(1253, 'shop_slideshow', '幻灯片', 0, '', 1, '["title","img","url","is_show","sort"]', '1:基础', '', '', '', '', 'title:标题\r\nimg:图片\r\nurl:链接地址\r\nis_show|get_name_by_status:显示\r\nsort:排序\r\nids:操作:[EDIT]&module_id=[pid]|编辑,[DELETE]|删除', 20, 'title', '', 1396098264, 1408323347, 1, 'MyISAM', NULL),
(1254, 'shop_order_log', '订单跟踪', 0, '', 1, '', '1:基础', '', '', '', '', '', 10, '', '', 1439525562, 1439525562, 1, 'MyISAM', NULL),
(1255, 'shop_order', '订单记录', 0, '', 1, '["uid","goods_datas","remark","order_number","cTime","total_price","address_id","is_send","send_code","send_number","send_type","shop_id"]', '1:基础', '', '', '', '', 'order_number:15%订单编号\r\ngoods:20%下单商品\r\nuid:10%客户\r\ntotal_price:7%总价\r\ncTime|time_format:17%下单时间\r\ncommon|get_name_by_status:10%支付类型\r\nstatus_code|get_name_by_status:10%订单跟踪\r\naction:11%操作', 20, 'order_number:请输入订单编号 或 客户昵称', '', 1420269240, 1440147136, 1, 'MyISAM', NULL),
(1256, 'shop_goods_score', '商品评分记录', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1422930901, 1422930901, 1, 'MyISAM', NULL),
(1257, 'shop_goods_category', '商品分类', 0, '', 1, '["title","icon","sort","is_show","is_recommend"]', '1:基础', '', '', '', '', 'title:20%分组\r\nicon|get_img_html:20%图标\r\nsort:20%排序号\r\nis_show|get_name_by_status:20%显示\r\nids:20%操作:[EDIT]|编辑,[DELETE]|删除', 20, 'title', '', 1397529095, 1438326713, 1, 'MyISAM', NULL),
(1258, 'donations_list', '捐赠列表', 0, '', 1, '["nickname","email","money","content"]', '1:基础', '', '', '', '', 'nickname:捐赠者姓名\r\nmoney:捐赠金额\r\nemail:捐赠者邮箱\r\ncontent:捐赠者留言\r\nctime|time_format:捐赠时间\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除', 10, 'nickname', '', 1446094856, 1446095155, 1, 'MyISAM', NULL),
(1259, 'donations_money', '捐赠说明', 0, '', 1, '["money","desc"]', '1:基础', '', '', '', '', 'money:金额\r\ndesc:回报\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除', 10, 'money', '', 1446094664, 1446094831, 1, 'MyISAM', NULL),
(1260, 'extensions', '融合第三方', 0, '', 1, '', '1:基础', '', '', '', '', 'keyword:关键词\r\nkeyword_filter|get_name_by_status:关键词过滤\r\noutput_format|get_name_by_status:数据输出格式\r\napi_url:第三方地址\r\napi_token:Token\r\ncTime|time_format:增加时间\r\nid:操作:[EDIT]|编辑,[DELETE]|删除', 10, 'keyword', '', 1393911774, 1394267850, 1, 'MyISAM', 'Extensions'),
(1261, 'forms', '通用表单', 0, '', 1, '["keyword","keyword_type","title","intro","cover","can_edit","finish_tip","jump_url","content","template"]', '1:基础', '', '', '', '', 'id:通用表单ID\r\nkeyword:关键词\r\nkeyword_type|get_name_by_status:关键词类型\r\ntitle:标题\r\ncTime|time_format:发布时间\r\nids:操作:[EDIT]|编辑,[DELETE]|删除,forms_attribute&id=[id]|字段管理,forms_value&id=[id]|数据管理,preview&id=[id]|预览', 20, 'title', '', 1396061373, 1437450012, 1, 'MyISAM', 'Forms'),
(1262, 'forms_attribute', '表单字段', 0, '', 1, '["name","title","type","extra","value","remark","is_must","validate_rule","error_info","sort"]', '1:基础', '', '', '', '', 'title:字段标题\r\nname:字段名\r\ntype|get_name_by_status:字段类型\r\nids:操作:[EDIT]&forms_id=[forms_id]|编辑,[DELETE]|删除', 20, 'title', '', 1396061373, 1396710959, 1, 'MyISAM', 'Forms'),
(1263, 'forms_value', '通用表单数据', 0, '', 1, '', '1:基础', '', '', '', '', '', 20, '', '', 1396687959, 1396687959, 1, 'MyISAM', 'Forms'),
(1264, 'suggestions', '建议意见', 0, '', 1, '{"1":["content","nickname","mobile"]}', '1:基础', '', '', '', '', 'nickname:昵称\r\ncontent:内容\r\nmobile:联系方式\r\ncTime|time_format:创建时间\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除', 10, 'content', '', 1393234169, 1400687145, 1, 'MyISAM', NULL),
(1265, 'address', '用户地址表', 0, '', 1, '["name","sex","mobile","address","country","province","city","area","is_default","postcode"]', '1:基础', '', '', '', '', 'openid|get_nickname:用户昵称\r\nname:用户姓名\r\nsex|getSex:用户性别\r\nmobile:用户手机号\r\nprovince:所在省份\r\ncity:所在城市\r\narea:所在地区\r\naddress:详细地址\r\npostcode:邮政编码\r\nis_default|getYesOrNo:是否默认\r\nid:操作:[EDIT]&id=[id]|编辑,[DELETE]&id=[id]|删除', 10, 'name', '', 1447736688, 1452331063, 1, 'MyISAM', ''),
(1266, 'payment_set', '支付配置', 0, '', 1, '["wxappid","wxappsecret","wxpaysignkey","zfbname","pid","key","partnerid","partnerkey","wappartnerid","wappartnerkey","quick_security_key","quick_merid","quick_merabbr","wxmchid"]', '1:基础', '', '', '', '', '', 10, '', '', 1406958084, 1439364636, 1, 'MyISAM', NULL),
(1267, 'payment_order', '订单支付记录', 0, '', 1, '["from","orderName","single_orderid","price","token","wecha_id","paytype","showwxpaytitle","status"]', '1:基础', '', '', '', '', '', 20, '', '', 1420596259, 1423534012, 1, 'MyISAM', NULL),
(1269, 'custom_menu_type', '自定义菜单类型', 0, '', 1, '["title","type","group_id","sex","country","province","city","client_platform_type","menuid","cTime","show"]', '1:基础', '', '', '', '', 'type:菜单类型\r\ntitle:菜单标题\r\nmenuid:微信端菜单ID\r\nsex:性别筛选\r\nshow:是否发布\r\ngroup_id:用户分组\r\ncountry:国家信息\r\nprovince:省份信息\r\ncity:城市信息\r\nclient_platform_type:手机操作系统\r\nid:操作:[EDIT]&[id]|编辑,[DELETE]&id=[id]|删除', 20, 'title', '', 1453098567, 1453281147, 1, 'MyISAM', 'CustomMenu');

-- --------------------------------------------------------

--
-- 表的结构 `dc_model_copy`
--

CREATE TABLE IF NOT EXISTS `dc_model_copy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '模型ID',
  `name` char(30) NOT NULL DEFAULT '' COMMENT '模型标识',
  `title` char(30) NOT NULL DEFAULT '' COMMENT '模型名称',
  `extend` int(10) unsigned DEFAULT '0' COMMENT '继承的模型',
  `relation` varchar(30) DEFAULT '' COMMENT '继承与被继承模型的关联字段',
  `need_pk` tinyint(1) unsigned DEFAULT '1' COMMENT '新建表时是否需要主键字段',
  `field_sort` text COMMENT '表单字段排序',
  `field_group` varchar(255) DEFAULT '1:基础' COMMENT '字段分组',
  `attribute_list` text COMMENT '属性列表（表的字段）',
  `template_list` varchar(100) DEFAULT '' COMMENT '列表模板',
  `template_add` varchar(100) DEFAULT '' COMMENT '新增模板',
  `template_edit` varchar(100) DEFAULT '' COMMENT '编辑模板',
  `list_grid` text COMMENT '列表定义',
  `list_row` smallint(2) unsigned DEFAULT '10' COMMENT '列表数据长度',
  `search_key` varchar(50) DEFAULT '' COMMENT '默认搜索字段',
  `search_list` varchar(255) DEFAULT '' COMMENT '高级搜索的字段',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `engine_type` varchar(25) DEFAULT 'MyISAM' COMMENT '数据库引擎',
  `addon` varchar(50) DEFAULT NULL COMMENT '所属插件',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='系统模型表' AUTO_INCREMENT=1144 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_online_count`
--

CREATE TABLE IF NOT EXISTS `dc_online_count` (
  `publicid` int(11) DEFAULT NULL,
  `addon` varchar(30) DEFAULT NULL,
  `aim_id` int(11) DEFAULT NULL,
  `time` bigint(12) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  KEY `tc` (`time`,`count`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `dc_payment_order`
--

CREATE TABLE IF NOT EXISTS `dc_payment_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `from` varchar(50) NOT NULL COMMENT '回调地址',
  `orderName` varchar(255) DEFAULT NULL COMMENT '订单名称',
  `single_orderid` varchar(100) NOT NULL COMMENT '订单号',
  `price` decimal(10,2) DEFAULT NULL COMMENT '价格',
  `token` varchar(100) NOT NULL COMMENT 'Token',
  `wecha_id` varchar(200) NOT NULL COMMENT 'OpenID',
  `paytype` varchar(30) NOT NULL COMMENT '支付方式',
  `showwxpaytitle` tinyint(2) NOT NULL DEFAULT '0' COMMENT '是否显示标题',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '支付状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_payment_set`
--

CREATE TABLE IF NOT EXISTS `dc_payment_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `wxmchid` varchar(255) DEFAULT NULL COMMENT '微信支付商户号',
  `shop_id` int(10) DEFAULT '0' COMMENT '商店ID',
  `quick_merid` varchar(255) DEFAULT NULL COMMENT '银联在线merid',
  `quick_merabbr` varchar(255) DEFAULT NULL COMMENT '商户名称',
  `wxpartnerid` varchar(255) DEFAULT NULL COMMENT '微信partnerid',
  `wxpartnerkey` varchar(255) DEFAULT NULL COMMENT '微信partnerkey',
  `partnerid` varchar(255) DEFAULT NULL COMMENT '财付通标识',
  `key` varchar(255) DEFAULT NULL COMMENT 'KEY',
  `ctime` int(10) DEFAULT NULL COMMENT '创建时间',
  `quick_security_key` varchar(255) DEFAULT NULL COMMENT '银联在线Key',
  `wappartnerkey` varchar(255) DEFAULT NULL COMMENT 'WAP财付通Key',
  `wappartnerid` varchar(255) DEFAULT NULL COMMENT '财付通标识WAP',
  `partnerkey` varchar(255) DEFAULT NULL COMMENT '财付通Key',
  `pid` varchar(255) DEFAULT NULL COMMENT 'PID',
  `zfbname` varchar(255) DEFAULT NULL COMMENT '帐号',
  `wxappsecret` varchar(255) DEFAULT NULL COMMENT 'AppSecret',
  `wxpaysignkey` varchar(255) DEFAULT NULL COMMENT '支付密钥',
  `wxappid` varchar(255) DEFAULT NULL COMMENT 'AppID',
  `token` varchar(255) DEFAULT NULL COMMENT 'token',
  `wx_cert_pem` int(10) unsigned DEFAULT NULL COMMENT '上传证书',
  `wx_key_pem` int(10) unsigned DEFAULT NULL COMMENT '上传密匙',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_picture`
--

CREATE TABLE IF NOT EXISTS `dc_picture` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id自增',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '图片链接',
  `md5` char(32) NOT NULL DEFAULT '' COMMENT '文件md5',
  `sha1` char(40) NOT NULL DEFAULT '' COMMENT '文件 sha1编码',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `token` varchar(255) NOT NULL DEFAULT '' COMMENT 'Token',
  PRIMARY KEY (`id`),
  KEY `status` (`id`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_plugin`
--

CREATE TABLE IF NOT EXISTS `dc_plugin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(40) NOT NULL COMMENT '插件名或标识',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '中文名',
  `description` text COMMENT '插件描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `config` text COMMENT '配置',
  `author` varchar(40) DEFAULT '' COMMENT '作者',
  `version` varchar(20) DEFAULT '' COMMENT '版本号',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '安装时间',
  `has_adminlist` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否有后台列表',
  `cate_id` int(11) DEFAULT NULL,
  `is_show` tinyint(2) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `sti` (`status`,`is_show`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='系统插件表' AUTO_INCREMENT=126 ;

--
-- 转存表中的数据 `dc_plugin`
--

INSERT INTO `dc_plugin` (`id`, `name`, `title`, `description`, `status`, `config`, `author`, `version`, `create_time`, `has_adminlist`, `cate_id`, `is_show`) VALUES
(15, 'EditorForAdmin', '后台编辑器', '用于增强整站长文本的输入和显示', 1, '{"editor_type":"2","editor_wysiwyg":"2","editor_height":"500px","editor_resize_type":"1"}', 'thinkphp', '0.1', 1383126253, 0, NULL, 1),
(2, 'SiteStat', '站点统计信息', '统计站点的基础信息', 0, '{"title":"\\u7cfb\\u7edf\\u4fe1\\u606f","width":"2","display":"1"}', 'thinkphp', '0.1', 1379512015, 0, NULL, 1),
(22, 'DevTeam', '开发团队信息', '开发团队成员信息', 0, '{"title":"OneThink\\u5f00\\u53d1\\u56e2\\u961f","width":"2","display":"1"}', 'thinkphp', '0.1', 1391687096, 0, NULL, 1),
(4, 'SystemInfo', '系统环境信息', '用于显示一些服务器的信息', 1, '{"title":"\\u7cfb\\u7edf\\u4fe1\\u606f","width":"2","display":"1"}', 'thinkphp', '0.1', 1379512036, 0, NULL, 1),
(5, 'Editor', '前台编辑器', '用于增强整站长文本的输入和显示', 1, '{"editor_type":"2","editor_wysiwyg":"1","editor_height":"300px","editor_resize_type":"1"}', 'thinkphp', '0.1', 1379830910, 0, NULL, 1),
(9, 'SocialComment', '通用社交化评论', '集成了各种社交化评论插件，轻松集成到系统中。', 1, '{"comment_type":"1","comment_uid_youyan":"1669260","comment_short_name_duoshuo":"","comment_form_pos_duoshuo":"buttom","comment_data_list_duoshuo":"10","comment_data_order_duoshuo":"asc"}', 'thinkphp', '0.1', 1380273962, 0, NULL, 1),
(58, 'Cascade', '级联菜单', '支持无级级联菜单，用于地区选择、多层分类选择等场景。菜单的数据来源支持查询数据库和直接用户按格式输入两种方式', 1, 'null', '凡星', '0.1', 1398694996, 0, NULL, 1),
(120, 'DynamicSelect', '动态下拉菜单', '支持动态从数据库里取值显示', 1, 'null', '凡星', '0.1', 1435223177, 0, NULL, 1),
(125, 'News', '图文素材选择器', '', 1, 'null', '凡星', '0.1', 1439198046, 0, NULL, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_public`
--

CREATE TABLE IF NOT EXISTS `dc_public` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `public_name` varchar(50) DEFAULT NULL COMMENT '公众号名称',
  `public_id` varchar(100) DEFAULT NULL COMMENT '公众号原始id',
  `wechat` varchar(100) DEFAULT NULL COMMENT '微信号',
  `interface_url` varchar(255) DEFAULT NULL COMMENT '接口地址',
  `headface_url` varchar(255) DEFAULT NULL COMMENT '公众号头像',
  `area` varchar(50) DEFAULT NULL COMMENT '地区',
  `addon_config` text COMMENT '插件配置',
  `addon_status` text COMMENT '插件状态',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `is_use` tinyint(2) DEFAULT '0' COMMENT '是否为当前公众号',
  `type` char(10) DEFAULT '0' COMMENT '公众号类型',
  `appid` varchar(255) DEFAULT NULL COMMENT 'AppID',
  `secret` varchar(255) DEFAULT NULL COMMENT 'AppSecret',
  `group_id` int(10) unsigned DEFAULT '0' COMMENT '等级',
  `encodingaeskey` varchar(255) DEFAULT NULL COMMENT 'EncodingAESKey',
  `tips_url` varchar(255) DEFAULT NULL COMMENT '提示关注公众号的文章地址',
  `domain` varchar(30) DEFAULT NULL COMMENT '自定义域名',
  `is_bind` tinyint(2) DEFAULT '0' COMMENT '是否为微信开放平台绑定账号',
  `mp_username` varchar(255) DEFAULT NULL COMMENT '公众号登陆用户名',
  `mp_password` varchar(255) DEFAULT NULL COMMENT '公众号登陆密码',
  `mp_token` varchar(255) DEFAULT NULL COMMENT '公众号接入验证Token',
  `qrcode_url` varchar(255) DEFAULT NULL COMMENT '二维码地址',
  PRIMARY KEY (`id`),
  KEY `token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_public_auth`
--

CREATE TABLE IF NOT EXISTS `dc_public_auth` (
  `name` char(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `type_0` tinyint(1) DEFAULT '0' COMMENT '普通订阅号的开关',
  `type_1` tinyint(1) DEFAULT '0' COMMENT '微信认证订阅号的开关',
  `type_2` tinyint(1) DEFAULT '0' COMMENT '普通服务号的开关',
  `type_3` tinyint(1) DEFAULT '0' COMMENT '微信认证服务号的开关',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `dc_public_auth`
--

INSERT INTO `dc_public_auth` (`name`, `title`, `type_0`, `type_1`, `type_2`, `type_3`) VALUES
('GET_ACCESS_TOKEN', '基础支持-获取access_token', 1, 1, 1, 1),
('GET_WECHAT_IP', '基础支持-获取微信服务器IP地址', 1, 1, 1, 1),
('GET_MSG', '接收消息-验证消息真实性、接收普通消息、接收事件推送、接收语音识别结果', 1, 1, 1, 1),
('SEND_REPLY_MSG', '发送消息-被动回复消息', 1, 1, 1, 1),
('SEND_CUSTOM_MSG', '发送消息-客服接口', 0, 1, 0, 1),
('SEND_GROUP_MSG', '发送消息-群发接口', 0, 1, 0, 1),
('SEND_NOTICE', '发送消息-模板消息接口（发送业务通知）', 0, 0, 0, 1),
('USER_GROUP', '用户管理-用户分组管理', 0, 1, 0, 1),
('USER_REMARK', '用户管理-设置用户备注名', 0, 1, 0, 1),
('USER_BASE_INFO', '用户管理-获取用户基本信息', 0, 1, 0, 1),
('USER_LIST', '用户管理-获取用户列表', 0, 1, 0, 1),
('USER_LOCATION', '用户管理-获取用户地理位置', 0, 0, 0, 1),
('USER_OAUTH', '用户管理-网页授权获取用户openid/用户基本信息', 0, 0, 0, 1),
('QRCODE', '推广支持-生成带参数二维码', 0, 0, 0, 1),
('LONG_URL', '推广支持-长链接转短链接口', 0, 0, 0, 1),
('MENU', '界面丰富-自定义菜单', 0, 1, 1, 1),
('MATERIAL', '素材管理-素材管理接口', 0, 1, 0, 1),
('SEMANTIC', '智能接口-语义理解接口', 0, 0, 0, 1),
('CUSTOM_SERVICE', '多客服-获取多客服消息记录、客服管理', 0, 0, 0, 1),
('PAYMENT', '微信支付接口', 0, 0, 0, 1),
('SHOP', '微信小店接口', 0, 0, 0, 1),
('CARD', '微信卡券接口', 0, 1, 0, 1),
('DEVICE', '微信设备功能接口', 0, 0, 0, 1),
('JSSKD_BASE', '微信JS-SDK-基础接口', 1, 1, 1, 1),
('JSSKD_SHARE', '微信JS-SDK-分享接口', 0, 1, 0, 1),
('JSSKD_IMG', '微信JS-SDK-图像接口', 1, 1, 1, 1),
('JSSKD_AUDIO', '微信JS-SDK-音频接口', 1, 1, 1, 1),
('JSSKD_SEMANTIC', '微信JS-SDK-智能接口（网页语音识别）', 1, 1, 1, 1),
('JSSKD_DEVICE', '微信JS-SDK-设备信息', 1, 1, 1, 1),
('JSSKD_LOCATION', '微信JS-SDK-地理位置', 1, 1, 1, 1),
('JSSKD_MENU', '微信JS-SDK-界面操作', 1, 1, 1, 1),
('JSSKD_SCAN', '微信JS-SDK-微信扫一扫', 1, 1, 1, 1),
('JSSKD_SHOP', '微信JS-SDK-微信小店', 0, 0, 0, 1),
('JSSKD_CARD', '微信JS-SDK-微信卡券', 0, 1, 0, 1),
('JSSKD_PAYMENT', '微信JS-SDK-微信支付', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dc_public_follow`
--

CREATE TABLE IF NOT EXISTS `dc_public_follow` (
  `openid` varchar(100) NOT NULL,
  `token` varchar(100) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `has_subscribe` tinyint(1) DEFAULT '0',
  `syc_status` tinyint(1) DEFAULT '2' COMMENT '0 开始同步中 1 更新用户信息中 2 完成同步',
  `remark` varchar(100) DEFAULT NULL,
  UNIQUE KEY `openid` (`openid`,`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `dc_public_group`
--

CREATE TABLE IF NOT EXISTS `dc_public_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(50) DEFAULT NULL COMMENT '等级名',
  `addon_status` text COMMENT '插件权限',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_public_link`
--

CREATE TABLE IF NOT EXISTS `dc_public_link` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '管理员UID',
  `mp_id` int(10) unsigned NOT NULL COMMENT '公众号ID',
  `is_creator` tinyint(2) DEFAULT '0' COMMENT '是否为创建者',
  `addon_status` text COMMENT '插件权限',
  `is_use` tinyint(2) DEFAULT '0' COMMENT '是否为当前管理的公众号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `um` (`uid`,`mp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_qr_code`
--

CREATE TABLE IF NOT EXISTS `dc_qr_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qr_code` varchar(255) NOT NULL COMMENT '二维码',
  `addon` varchar(255) NOT NULL COMMENT '二维码所属插件',
  `aim_id` int(10) unsigned NOT NULL COMMENT '插件表里的ID值',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `action_name` char(30) DEFAULT 'QR_SCENE' COMMENT '二维码类型',
  `extra_text` text COMMENT '文本扩展',
  `extra_int` int(10) DEFAULT NULL COMMENT '数字扩展',
  `request_count` int(10) DEFAULT '0' COMMENT '请求数',
  `scene_id` int(10) DEFAULT '0' COMMENT '场景ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_scene_qrcode`
--

CREATE TABLE IF NOT EXISTS `dc_scene_qrcode` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(255) DEFAULT NULL COMMENT '公众号Token',
  `scene_name` varchar(255) DEFAULT NULL COMMENT '场景名称',
  `keyword` varchar(255) DEFAULT NULL COMMENT '关联关键词',
  `scene_type` char(10) DEFAULT '0' COMMENT '二维码类型',
  `scene_id` int(32) DEFAULT NULL COMMENT '场景值ID',
  `scene_str` varchar(255) DEFAULT NULL COMMENT '场景值字符串',
  `expire` int(10) DEFAULT NULL COMMENT '过期时间',
  `ticket` varchar(255) DEFAULT NULL COMMENT '二维码Ticket',
  `url` varchar(255) DEFAULT NULL COMMENT '二维码图片解析后的地址',
  `ctime` int(10) DEFAULT NULL COMMENT '二维码创建时间',
  `short_url` varchar(255) DEFAULT NULL COMMENT '二维码短地址',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_scene_qrcode_statistics`
--

CREATE TABLE IF NOT EXISTS `dc_scene_qrcode_statistics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(255) DEFAULT NULL COMMENT '公众号Token',
  `openid` varchar(255) DEFAULT NULL COMMENT '扫码者openid',
  `scene_name` varchar(255) DEFAULT NULL COMMENT '场景名称',
  `keyword` varchar(255) DEFAULT NULL COMMENT '关联关键词',
  `scene_id` varchar(255) DEFAULT NULL COMMENT '场景ID/场景字符串',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫描类型',
  `ctime` int(10) DEFAULT NULL COMMENT '扫描时间',
  `qrcode_id` int(10) DEFAULT NULL COMMENT '二维码ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop`
--

CREATE TABLE IF NOT EXISTS `dc_shop` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '商店名称',
  `logo` int(10) DEFAULT NULL COMMENT '商店LOGO',
  `intro` text COMMENT '店铺简介',
  `mobile` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `qq` int(10) DEFAULT NULL COMMENT 'QQ',
  `wechat` varchar(50) DEFAULT NULL COMMENT '微信',
  `template` varchar(30) DEFAULT NULL COMMENT '模板',
  `content` text COMMENT '店铺介绍',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_address`
--

CREATE TABLE IF NOT EXISTS `dc_shop_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `truename` varchar(100) DEFAULT NULL COMMENT '收货人姓名',
  `mobile` varchar(50) DEFAULT NULL COMMENT '手机号码',
  `city` varchar(255) DEFAULT NULL COMMENT '城市',
  `address` varchar(255) DEFAULT NULL COMMENT '具体地址',
  `is_use` tinyint(2) DEFAULT '0' COMMENT '是否设置为默认',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_cart`
--

CREATE TABLE IF NOT EXISTS `dc_shop_cart` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `shop_id` varchar(255) NOT NULL COMMENT '商店id',
  `goods_id` varchar(255) NOT NULL COMMENT '商品id',
  `num` int(10) unsigned NOT NULL COMMENT '数量',
  `price` varchar(30) NOT NULL COMMENT '单价',
  `goods_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '商品类型',
  `openid` varchar(255) NOT NULL COMMENT 'openid',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_collect`
--

CREATE TABLE IF NOT EXISTS `dc_shop_collect` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '使用UID',
  `goods_id` int(10) DEFAULT NULL COMMENT '商品ID',
  `cTime` int(10) DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_goods`
--

CREATE TABLE IF NOT EXISTS `dc_shop_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cover` int(10) unsigned DEFAULT NULL COMMENT '商品封面图',
  `content` text NOT NULL COMMENT '商品介绍',
  `title` varchar(255) NOT NULL COMMENT '商品名称',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `imgs` varchar(255) NOT NULL COMMENT '商品图片',
  `inventory` int(10) DEFAULT '0' COMMENT '库存数量',
  `shop_id` int(10) DEFAULT '0' COMMENT '商店ID',
  `is_show` tinyint(2) DEFAULT '0' COMMENT '是否上架',
  `sale_count` int(10) DEFAULT '0' COMMENT '销售量',
  `is_recommend` tinyint(2) DEFAULT NULL COMMENT '是否推荐',
  `rank` int(10) DEFAULT '0' COMMENT '热销度',
  `show_time` int(10) DEFAULT '0' COMMENT '上架时间',
  `old_price` int(10) DEFAULT NULL COMMENT '原价',
  `type` tinyint(2) DEFAULT '0' COMMENT '商品类型',
  `category_id` char(50) DEFAULT NULL COMMENT '商品分类',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_goods_category`
--

CREATE TABLE IF NOT EXISTS `dc_shop_goods_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '分类标题',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '分类图标',
  `pid` int(10) unsigned DEFAULT '0' COMMENT '上一级分类',
  `path` varchar(255) DEFAULT NULL COMMENT '分类路径',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序号',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '是否显示',
  `shop_id` int(10) NOT NULL DEFAULT '0' COMMENT '商店ID',
  `is_recommend` tinyint(2) DEFAULT '0' COMMENT '是否推荐',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_goods_score`
--

CREATE TABLE IF NOT EXISTS `dc_shop_goods_score` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '用户ID',
  `goods_id` int(10) DEFAULT NULL COMMENT '商品ID',
  `score` int(10) DEFAULT '0' COMMENT '得分',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_order`
--

CREATE TABLE IF NOT EXISTS `dc_shop_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `goods_datas` text NOT NULL COMMENT '商品序列化数据',
  `uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `remark` text NOT NULL COMMENT '备注',
  `order_number` varchar(255) NOT NULL COMMENT '订单编号',
  `cTime` int(10) NOT NULL COMMENT '订单时间',
  `total_price` decimal(10,2) DEFAULT NULL COMMENT '总价',
  `openid` varchar(255) NOT NULL COMMENT 'OpenID',
  `pay_status` int(10) DEFAULT NULL COMMENT '支付状态',
  `pay_type` int(10) DEFAULT NULL COMMENT '支付类型',
  `address_id` int(10) DEFAULT NULL COMMENT '配送信息',
  `is_send` int(10) DEFAULT '0' COMMENT '是否发货',
  `send_code` varchar(255) DEFAULT NULL COMMENT '快递公司编号',
  `send_number` varchar(255) DEFAULT NULL COMMENT '快递单号',
  `send_type` char(10) DEFAULT NULL COMMENT '发货类型',
  `is_new` tinyint(2) DEFAULT '1' COMMENT '是否为新订单',
  `shop_id` int(10) DEFAULT '0' COMMENT '商店编号',
  `status_code` char(50) DEFAULT '0' COMMENT '订单跟踪状态码',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_order_log`
--

CREATE TABLE IF NOT EXISTS `dc_shop_order_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` int(10) DEFAULT NULL COMMENT '订单ID',
  `status_code` char(50) DEFAULT '0' COMMENT '状态码',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注内容',
  `cTime` int(10) DEFAULT NULL COMMENT '时间',
  `extend` varchar(255) DEFAULT NULL COMMENT '扩展信息',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_shop_slideshow`
--

CREATE TABLE IF NOT EXISTS `dc_shop_slideshow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `img` int(10) unsigned NOT NULL COMMENT '图片',
  `url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '是否显示',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `shop_id` int(10) DEFAULT '0' COMMENT '商店ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_smalltools`
--

CREATE TABLE IF NOT EXISTS `dc_smalltools` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tooltype` tinyint(2) DEFAULT '0' COMMENT '工具类型',
  `keyword` varchar(255) DEFAULT NULL COMMENT ' 关键词 ',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `toolname` varchar(255) DEFAULT NULL COMMENT '工具名称',
  `tooldes` text COMMENT '工具描述',
  `toolnum` varchar(255) DEFAULT NULL COMMENT '工具唯一编号',
  `toolstate` tinyint(2) DEFAULT '0' COMMENT '工具状态',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_sucai`
--

CREATE TABLE IF NOT EXISTS `dc_sucai` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) DEFAULT NULL COMMENT '素材名称',
  `status` char(10) DEFAULT 'UnSubmit' COMMENT '状态',
  `cTime` int(10) DEFAULT NULL COMMENT '提交时间',
  `url` varchar(255) DEFAULT NULL COMMENT '实际摇一摇所使用的页面URL',
  `type` varchar(255) DEFAULT NULL COMMENT '素材类型',
  `detail` text COMMENT '素材内容',
  `reason` text COMMENT '入库失败的原因',
  `create_time` int(10) DEFAULT NULL COMMENT '申请时间',
  `checked_time` int(10) DEFAULT NULL COMMENT '入库时间',
  `source` varchar(50) DEFAULT NULL COMMENT '来源',
  `source_id` int(10) DEFAULT NULL COMMENT '来源ID',
  `wechat_id` int(10) DEFAULT NULL COMMENT '微信端的素材ID',
  `uid` int(10) DEFAULT NULL COMMENT 'uid',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_sucai_template`
--

CREATE TABLE IF NOT EXISTS `dc_sucai_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) DEFAULT NULL COMMENT '管理员id',
  `token` varchar(255) DEFAULT NULL COMMENT '用户token',
  `addons` varchar(255) DEFAULT NULL COMMENT '插件名称',
  `template` varchar(255) DEFAULT NULL COMMENT '模版名称',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_suggestions`
--

CREATE TABLE IF NOT EXISTS `dc_suggestions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cTime` int(10) NOT NULL COMMENT '创建时间',
  `content` text NOT NULL COMMENT '内容',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `nickname` varchar(255) NOT NULL COMMENT '用户昵称',
  `mobile` varchar(255) NOT NULL COMMENT '手机号',
  `token` varchar(255) NOT NULL COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_system_notice`
--

CREATE TABLE IF NOT EXISTS `dc_system_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '公告标题',
  `content` text COMMENT '公告内容',
  `create_time` int(10) DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_tmplmsg`
--

CREATE TABLE IF NOT EXISTS `dc_tmplmsg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(255) NOT NULL COMMENT 'openid',
  `template_id` varchar(500) NOT NULL COMMENT '模板ID',
  `message` text NOT NULL COMMENT '消息内容',
  `MsgID` varchar(255) NOT NULL COMMENT '消息ID',
  `sendstatus` char(50) NOT NULL COMMENT '发送状态',
  `Status` char(50) NOT NULL COMMENT '送达报告',
  `token` varchar(255) NOT NULL COMMENT 'token',
  `ctime` int(10) NOT NULL COMMENT '发送时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_update_score_log`
--

CREATE TABLE IF NOT EXISTS `dc_update_score_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `score` int(10) DEFAULT NULL COMMENT '修改积分',
  `branch_id` int(10) DEFAULT NULL COMMENT '修改门店',
  `operator` varchar(255) DEFAULT NULL COMMENT '操作员',
  `cTime` int(10) DEFAULT NULL COMMENT '修改时间',
  `token` varchar(255) DEFAULT NULL COMMENT 'token',
  `member_id` int(10) DEFAULT NULL COMMENT '会员卡id',
  `manager_id` int(10) DEFAULT NULL COMMENT '管理员id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_update_version`
--

CREATE TABLE IF NOT EXISTS `dc_update_version` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `version` int(10) unsigned NOT NULL COMMENT '版本号',
  `title` varchar(50) NOT NULL COMMENT '升级包名',
  `description` text COMMENT '描述',
  `create_date` int(10) DEFAULT NULL COMMENT '创建时间',
  `download_count` int(10) unsigned DEFAULT '0' COMMENT '下载统计',
  `package` varchar(255) NOT NULL COMMENT '升级包地址',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_user`
--

CREATE TABLE IF NOT EXISTS `dc_user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` text COMMENT '用户名',
  `password` varchar(100) DEFAULT NULL COMMENT '登录密码',
  `truename` varchar(30) DEFAULT NULL COMMENT '真实姓名',
  `mobile` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱地址',
  `sex` tinyint(2) DEFAULT NULL COMMENT '性别',
  `headimgurl` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `city` varchar(30) DEFAULT NULL COMMENT '城市',
  `province` varchar(30) DEFAULT NULL COMMENT '省份',
  `country` varchar(30) DEFAULT NULL COMMENT '国家',
  `language` varchar(20) DEFAULT 'zh-cn' COMMENT '语言',
  `score` int(10) DEFAULT '0' COMMENT '金币值',
  `experience` int(10) DEFAULT '0' COMMENT '经验值',
  `unionid` varchar(50) DEFAULT NULL COMMENT '微信第三方ID',
  `login_count` int(10) DEFAULT '0' COMMENT '登录次数',
  `reg_ip` varchar(30) DEFAULT NULL COMMENT '注册IP',
  `reg_time` int(10) DEFAULT NULL COMMENT '注册时间',
  `last_login_ip` varchar(30) DEFAULT NULL COMMENT '最近登录IP',
  `last_login_time` int(10) DEFAULT NULL COMMENT '最近登录时间',
  `status` tinyint(2) DEFAULT '1' COMMENT '状态',
  `is_init` tinyint(2) DEFAULT '0' COMMENT '初始化状态',
  `is_audit` tinyint(2) DEFAULT '0' COMMENT '审核状态',
  `subscribe_time` int(10) DEFAULT NULL COMMENT '用户关注公众号时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '微信用户备注',
  `groupid` int(10) DEFAULT NULL COMMENT '微信端的分组ID',
  `come_from` tinyint(1) DEFAULT '0' COMMENT '来源',
  `login_name` varchar(100) DEFAULT NULL COMMENT 'login_name',
  `login_password` varchar(255) DEFAULT NULL COMMENT '登录密码',
  `manager_id` int(10) DEFAULT '0' COMMENT '公众号管理员ID',
  `level` tinyint(2) DEFAULT '0' COMMENT '管理等级',
  `membership` char(50) DEFAULT '0' COMMENT '会员等级',
  `public_count` int(10) DEFAULT NULL COMMENT '可创建公众号数',
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;


-- --------------------------------------------------------

--
-- 表的结构 `dc_user_follow`
--

CREATE TABLE IF NOT EXISTS `dc_user_follow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `publicid` int(11) DEFAULT NULL,
  `follow_id` int(11) DEFAULT NULL,
  `url` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_visit_log`
--

CREATE TABLE IF NOT EXISTS `dc_visit_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `publicid` int(10) DEFAULT '0' COMMENT 'publicid',
  `module_name` varchar(30) DEFAULT NULL COMMENT 'module_name',
  `controller_name` varchar(30) DEFAULT NULL COMMENT 'controller_name',
  `action_name` varchar(30) DEFAULT NULL COMMENT 'action_name',
  `uid` varchar(255) DEFAULT '0' COMMENT 'uid',
  `ip` varchar(30) DEFAULT NULL COMMENT 'ip',
  `brower` varchar(30) DEFAULT NULL COMMENT 'brower',
  `param` text COMMENT 'param',
  `referer` varchar(255) DEFAULT NULL COMMENT 'referer',
  `cTime` int(10) DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weisite_category`
--

CREATE TABLE IF NOT EXISTS `dc_weisite_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(100) NOT NULL COMMENT '分类标题',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '分类图片',
  `url` varchar(255) DEFAULT NULL COMMENT '外链',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '显示',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  `sort` int(10) DEFAULT '0' COMMENT '排序号',
  `pid` int(10) DEFAULT '0' COMMENT '一级目录',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weisite_cms`
--

CREATE TABLE IF NOT EXISTS `dc_weisite_cms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `keyword` varchar(100) NOT NULL COMMENT '关键词',
  `keyword_type` tinyint(2) DEFAULT NULL COMMENT '关键词类型',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `intro` text COMMENT '简介',
  `cate_id` int(10) unsigned DEFAULT '0' COMMENT '所属类别',
  `cover` int(10) unsigned DEFAULT NULL COMMENT '封面图片',
  `content` text COMMENT '内容',
  `cTime` int(10) DEFAULT NULL COMMENT '发布时间',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序号',
  `view_count` int(10) unsigned DEFAULT '0' COMMENT '浏览数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weisite_footer`
--

CREATE TABLE IF NOT EXISTS `dc_weisite_footer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `url` varchar(255) DEFAULT NULL COMMENT '关联URL',
  `title` varchar(50) NOT NULL COMMENT '菜单名',
  `pid` tinyint(2) DEFAULT '0' COMMENT '一级菜单',
  `sort` tinyint(4) DEFAULT '0' COMMENT '排序号',
  `token` varchar(255) DEFAULT NULL COMMENT 'Token',
  `icon` int(10) unsigned DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weisite_slideshow`
--

CREATE TABLE IF NOT EXISTS `dc_weisite_slideshow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `img` int(10) unsigned NOT NULL COMMENT '图片',
  `url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `is_show` tinyint(2) DEFAULT '1' COMMENT '是否显示',
  `sort` int(10) unsigned DEFAULT '0' COMMENT '排序',
  `token` varchar(100) DEFAULT NULL COMMENT 'Token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weixin_log`
--

CREATE TABLE IF NOT EXISTS `dc_weixin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cTime` int(11) DEFAULT NULL,
  `cTime_format` varchar(30) DEFAULT NULL,
  `data` text,
  `data_post` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_weixin_message`
--

CREATE TABLE IF NOT EXISTS `dc_weixin_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ToUserName` varchar(100) DEFAULT NULL COMMENT 'Token',
  `FromUserName` varchar(100) DEFAULT NULL COMMENT 'OpenID',
  `CreateTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `MsgType` varchar(30) DEFAULT NULL COMMENT '消息类型',
  `MsgId` varchar(100) DEFAULT NULL COMMENT '消息ID',
  `Content` text COMMENT '文本消息内容',
  `PicUrl` varchar(255) DEFAULT NULL COMMENT '图片链接',
  `MediaId` varchar(100) DEFAULT NULL COMMENT '多媒体文件ID',
  `Format` varchar(30) DEFAULT NULL COMMENT '语音格式',
  `ThumbMediaId` varchar(30) DEFAULT NULL COMMENT '缩略图的媒体id',
  `Title` varchar(100) DEFAULT NULL COMMENT '消息标题',
  `Description` text COMMENT '消息描述',
  `Url` varchar(255) DEFAULT NULL COMMENT 'Url',
  `collect` tinyint(1) DEFAULT '0' COMMENT '收藏状态',
  `deal` tinyint(1) DEFAULT '0' COMMENT '处理状态',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `type` tinyint(1) DEFAULT '0' COMMENT '消息分类',
  `is_material` int(10) DEFAULT '0' COMMENT '设置为文本素材',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_xdlog`
--

CREATE TABLE IF NOT EXISTS `dc_xdlog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid_int` int(11) NOT NULL,
  `biztitle` text,
  `biztype` int(11) NOT NULL DEFAULT '0',
  `opttime` bigint(20) DEFAULT NULL,
  `xd` bigint(20) DEFAULT NULL,
  `sceneid` bigint(20) DEFAULT '0',
  `remark` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_youaskservice_group`
--

CREATE TABLE IF NOT EXISTS `dc_youaskservice_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(255) DEFAULT NULL COMMENT 'token',
  `groupname` varchar(255) DEFAULT NULL COMMENT '分组名称',
  `groupdata` text COMMENT '分组数据源',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_youaskservice_keyword`
--

CREATE TABLE IF NOT EXISTS `dc_youaskservice_keyword` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msgkeyword` varchar(555) DEFAULT NULL COMMENT '消息关键字',
  `msgkeyword_type` char(50) DEFAULT '3' COMMENT '关键字类型',
  `msgkfaccount` varchar(255) DEFAULT NULL COMMENT '接待的客服人员',
  `cTime` int(10) DEFAULT NULL COMMENT '创建时间',
  `token` varchar(255) DEFAULT NULL COMMENT 'token',
  `msgstate` tinyint(2) DEFAULT '1' COMMENT '关键字状态',
  `zjnum` int(10) DEFAULT NULL COMMENT '转接次数',
  `zdtype` char(10) DEFAULT '0' COMMENT '指定类型',
  `kfgroupid` int(10) DEFAULT '0' COMMENT '客服分组id',
  `kf_explain` varchar(255) DEFAULT NULL COMMENT '客服说明',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dc_youaskservice_user`
--

CREATE TABLE IF NOT EXISTS `dc_youaskservice_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(60) DEFAULT NULL COMMENT '客服昵称',
  `token` varchar(60) DEFAULT NULL COMMENT 'token',
  `userName` varchar(60) DEFAULT NULL COMMENT '客服帐号',
  `userPwd` varchar(32) DEFAULT NULL COMMENT '客服密码',
  `endJoinDate` int(11) DEFAULT NULL COMMENT '客服加入时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '客服在线状态',
  `state` tinyint(2) DEFAULT '0' COMMENT '客服状态',
  `isdelete` tinyint(2) DEFAULT '0' COMMENT '是否删除',
  `kfid` varchar(255) DEFAULT NULL COMMENT '客服编号',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
