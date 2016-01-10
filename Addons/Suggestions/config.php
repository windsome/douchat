<?php
return array (
		'title' => array(
			'title'=>'标题',
			'type'=>'text',
			'value'=>'意见反馈',
			'tip'=>'微信回复的图文消息标题'
		),
		'cover' => array(
			'title'=>'封面',
			'type'=>'picture',
			'value'=>'',
			'tip'=>'微信回复的图文消息封面'
		),
		'desc' => array(
			'title'=>'描述',
			'type'=>'textarea',
			'value'=>'点此进入',
			'tip'=>'微信回复的图文消息描述'
		),
		'need_nickname' => array (
				'title' => '是否需要填写昵称:',
				'type' => 'radio',
				'options' => array (
						'1' => '是',
						'0' => '否' 
				),
				'value' => '1' 
		),
		'need_mobile' => array (
				'title' => '是否需要填写联系方式:',
				'type' => 'radio',
				'options' => array (
						'1' => '是',
						'0' => '否' 
				),
				'value' => '1' 
		),

		'admin_id' => array(
			'title' => '接收反馈通知的管理员',
			'type' => 'user',
			'value' => '',
		),
);
					