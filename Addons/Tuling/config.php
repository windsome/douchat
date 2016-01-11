<?php
return array (
		'tuling_key' => array ( // 配置在表单中的键名 ,这个会是config[random]
				'title' => '图灵机器人KEY:', // 表单的文字
				'type' => 'text', // 表单的类型：text、textarea、checkbox、radio、select等
				'value' => 'd812d695a5e0df258df952698faca6cc', // 表单的默认值
				'tip' => '格式如：d812d695a5e0df258df952698faca6cc' 
		),
		'tuling_url' => array (
				'title' => '图灵机器人地址:',
				'type' => 'text',
				'value' => 'http://www.tuling123.com/openapi/api' 
		),
		
		'rand_reply' => array (
				'title' => '随机回复内容:',
				'type' => 'textarea',
				'value' => '
我今天累了，明天再陪你聊天吧
哈哈~~
你话好多啊，不跟你聊了
虽然不懂，但觉得你说得很对',
				'tip' => '当上面接口返回内容异常时会随机取当前的内容进行回复，按行一条回复输入' 
		) 
);
					