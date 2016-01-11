<?php
return array (
		'state' => array (
				'title' => '开启微信人工客服:',
				'type' => 'radio',
				'options'=>array(
					'1'=>'开启',
					'0'=>'关闭',
				),
				'value' => '0',
				'tip' => '开启和关闭客服接待功能' 
		),
		'zrg' => array (
				'title' => '转人工客服',
				'type' => 'text',				
				'value' => '人工客服|转在线客服|客服',
				'tip' => '设置用户手动转人工客服关键词' 
		),
		'jrkf' => array (
				'title' => '接入客服后的回复',
				'type' => 'text',				
				'value' => '您好，成功接入客服，客服[name]为您服务！',
				'tip' => '成功接入客服后的自动回复' 
		),
		'gbkf' => array (
				'title' => '关闭客服后的回复',
				'type' => 'text',				
				'value' => '您好，客服会话已关闭，感谢您的来访！',
				'tip' => '会话关闭后的自动回复' 
		),
		'zjkf' => array (
				'title' => '转接客服后的回复',
				'type' => 'text',				
				'value' => '您好，客服转接成功，客服[name]为您服务！！',
				'tip' => '转接成功后的自动回复' 
		),
		'kfbz' => array (
				'title' => '客服不在线的回复',
				'type' => 'text',				
				'value' => '您好，客服工作时间：周一至周五8:00-17:00',
				'tip' => '客服不在线时候，用户转接人工客服时，设定的自动回复' 
		),
		'zdkfbz' => array (
				'title' => '指定客服不在线的回复',
				'type' => 'text',				
				'value' => '您好，您指定的客服暂时不在线，请选择其他客服,查询在线客服列表，请回复“查询在线客服”',
				'tip' => '指定客服不在线时候，设定的自动回复' 
		),
		'model' => array (
				'title' => '客服模式:',
				'type' => 'radio',
				'options'=>array(
					'1'=>'多客服',
					'0'=>'系统处理(暂时无效)',
				),
				'value' => '1',
				'tip' => '启用多客服模式只能客服结束会话或者2小时内无互动才能关闭会话' 
		),
		'model2' => array (
				'title' => '开启多客服助手接待:',
				'type' => 'radio',
				'options'=>array(
					'0'=>'开启',
					'2'=>'关闭',
				),
				'value' => '2',
				'tip' => '启用后，可以用手机微信多客服助手接待，需要多客服助手绑定客服账号' 
		),
		'tcrg' => array (
				'title' => '退出人工客服',
				'type' => 'text',				
				'value' => '退出人工客服',
				'tip' => '设置用户手动退出人工客服关键词(系统处理模式有效)' 
		),
		'cxkey' => array ( // 配置在表单中的键名 ,这个会是config[random]
				'title' => '查询在线客服列表关键词:', // 表单的文字
				'type' => 'text', // 表单的类型：text、textarea、checkbox、radio、select等
				'value' => '查询在线客服|在线客服|查询客服' 
		) ,// 表单的默认值
		//查询在线客服列表配置
		'type3' => array ( // 配置在表单中的键名 ,这个会是config[random]
				'title' => '类型:', // 表单的文字
				'type' => 'select', // 表单的类型：text、textarea、checkbox、radio、select等
				'options' => array (
						'1' => '文本',
						// 
						'3' => '图文',
				),
				'value' => '1' 
		) ,// 表单的默认值
		'title3' => array ( // 配置在表单中的键名 ,这个会是config[random]
				'title' => '标题:', // 表单的文字
				'type' => 'text', // 表单的类型：text、textarea、checkbox、radio、select等
				'value' => '在线客服列表' 
		) ,// 表单的默认值
		'pic_url3' => array (
				'title' => '图片:',
				'type' => 'text',
				'value' => '',
				'tip' => '图片链接，支持JPG、PNG格式，较好的效果为大图360*200，小图200*200' 
		),
		'description_head' => array (
				'title' => '客服列表顶部内容区:',
				'type' => 'textarea',
				'value' => '客服列表顶部内容区' 
		),
		'description_foot' => array (
				'title' => '客服列表底部内容区:',
				'type' => 'textarea',
				'value' => '客服列表底部内容区' 
		),
		
);
					