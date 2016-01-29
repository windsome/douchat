<?php

namespace Home\Controller;
use Wechat\TPWechat;
/**
 * 微信交互控制器
 * 主要获取和反馈微信平台的数据
 */
class WeixinController extends HomeController
{

	// 微信SDK参数
	private $options = array(
    	'token'=>'', 		//填写你设定的key
    	'encodingaeskey'=>'', 		//填写加密用的EncodingAESKey
    	'appid'=>'', 				//填写高级调用功能的app id
    	'appsecret'=>'' 			//填写高级调用功能的密钥
    );

	var $token;

	private $data = array ();

	public function index( $id )
	{

		$mpInfo = M('public')->where(array('id'=>$id))->find();

		$this->options['token'] = $mpInfo['mp_token'];

		/**
		 * 微信接入验证
		 */
		if (! empty ( $_GET ['echostr'] ) && ! empty ( $_GET ["signature"] ) && ! empty ( $_GET ["nonce"] )) {
			$wechatObj = new TPWechat($this->options);
	        $wechatObj->valid();
	        $wechatObj->getRev();
	        exit();
		}

		// 删除微信传递的token干扰
		unset ( $_REQUEST ['token'] );
		
		$weixin = D ( 'Weixin' ); 
		// 获取数据
		// $data = $weixin->getData ();

		// 获取数据
		$wechatObj = new TPWechat($this->options);
        $wechatObj->valid();
        $wechatObj->getRev();

		$data = $wechatObj->getRevData ();
		$this->data = $data;

		if (! empty ( $data ['ToUserName'] ))
		{
			get_token ( $data ['ToUserName'] );
		}
		if (! empty ( $data ['FromUserName'] ))
		{
			get_openid ( $data ['FromUserName'] );
		}
		
		$this->token = $data ['ToUserName'];
		
		// 记录日志
		// addWeixinLog ( $data, $GLOBALS ['HTTP_RAW_POST_DATA'] );
		
		// 初始化用户
		// $data ['ToUserName'] == 'gh_3c884a361561' || $this->init_follow ( $data );
		$this->init_follow ( $data );

		// 回复数据
		$this->reply ( $data, $weixin );
		
		// 客服接口群发消息：未发送成功的消息给用户重新发
		$this->sendOldMessage ( $data ['ToUserName'], $data ['FromUserName'] );
		// 结束程序。防止oneThink框架的调试信息输出
		exit ();
	}

	/**
	 * 微信回复数据
	 *
	 */
	private function reply($data, $weixin)
	{
		$key = $data ['Content'];

		$keywordArr = array ();
		
		// 插件权限控制
		$token_status = D ( 'Common/AddonStatus' )->getList ();

		foreach ( $token_status as $a => $s )
		{
			$s == 1 || $forbit_addon [$a] = $a;
		}
		
		// 所有安装过的微信插件
		$addon_list = ( array ) D ( 'Addons' )->getWeixinList ( false, $token_status );
		/**
		 * 微信事件转化成特定的关键词来处理
		 * event可能的值：
		 * subscribe : 关注公众号
		 * unsubscribe : 取消关注公众号
		 * scan : 扫描带参数二维码事件
		 * LOCATION : 上报地理位置事件
		 * click : 自定义菜单事件
		 */
		if ($data ['MsgType'] == 'event') {
			
			if ( $data['Event'] == 'LOCATION' ) {
				$event = 'reportLocation';
			} else {
				$event = strtolower ( $data ['Event'] );
			}
			
			if ($event == 'click' && ! empty ( $data ['EventKey'] )) {
				$key = $data ['Content'] = $data ['EventKey'];
			} else {
				$key = $data ['Content'] = $event;
			}
		} else {

			/**
			 * 非事件型消息处理逻辑
			 * event可能的值：
			 * text : 文本消息
			 * image : 图片消息
			 * voice : 语音消息
			 * video : 视频消息
			 * shortvideo : 短视频消息
			 * location : 地理位置消息
			 * link : 链接消息
			 */
			$event = strtolower ( $data ['MsgType'] );
			
			// 数据保存到消息管理中
			M ( 'weixin_message' )->add ( $data );
		}

		foreach ( $addon_list as $vo ) {
			require_once ONETHINK_ADDON_PATH . $vo ['name'] . '/Model/WeixinAddonModel.class.php';
			$model = D ( 'Addons://' . $vo ['name'] . '/WeixinAddon' );
			! method_exists ( $model, $event ) || $model->$event ( $data );
		}

		// if ($data ['ToUserName'] == 'gh_3c884a361561' || $data ['appid'] == 'wx570bc396a51b8ff8') 
		// {
		// 	$addons[$key] = 'PublicBind';
		// }
		
		// 通过获取上次缓存的用户状态来定位处理的插件
		$openid = $data ['FromUserName'];

		$user_status = S ( 'user_status_' . $openid );
		
		$accept = $user_status ['keywordArr'] ['accept'];

		if (  ($accept ['type'] == 'regex' 
				&& ! preg_match ( $accept ['data'], $key ) ) 
				|| ($accept ['type'] == 'array' 
				&& ! in_array ( $key, $accept ['data'] )) ) 
		{
			$user_status = false;
			S ( 'user_status_' . $openid, null ); 
			// 可设置规定只能接收某些值，如果用户输入的内容不是规定的值，则放弃当前状态,支持正则和数组两种规定方式
		}

		
		if (! isset ( $addons[$key] ) && $user_status ) 
		{
			$addons [$key] = $user_status ['addon'];

			$keywordArr = $user_status ['keywordArr'];

			S ( 'user_status_' . $openid, null );
		}

		if (! isset ( $addons [$key] ) )
		{
			$map ['keyword'] = $key;
			$map ['from_type'] = array (
					'neq',
					9 
			);
			$map ['token'] = $data ['ToUserName'];
			$map ['type'] = 'click';

			$customMenu = M ( 'custom_menu' )->where ( $map )->order ( 'id desc' )->find ();

			if (! empty ( $customMenu ))
			{
				if ($customMenu ['addon'])
				{
					$addons [$key] = $customMenu ['addon'];

					$keywordArr ['aim_id'] = $customMenu ['target_id'];

					$this->request_count ( $keywordArr );
				}
				else if ($customMenu ['sucai_type'])
				{
					$map ['token'] = get_token ();
					$map ['openid'] = $openid;
					$uid = M ( 'public_follow' )->where ( $map )->getField ( 'uid' );

					switch ($customMenu ['sucai_type']) 
					{
						case 1 :
							// 1:图文
							D ( 'Common/Custom' )->replyNews ( $uid, $customMenu ['target_id'] );
							break;
						case 2 :
							// 2:文本
							$textMap ['id'] = $customMenu ['target_id'];
							$content = M ( 'material_text' )->where ( $textMap )->getField ( 'content' );
							D ( 'Common/Custom' )->replyText ( $uid, $content );
							break;
						case 3 :
							// 3:图片
							$textMap ['id'] = $customMenu ['target_id'];
							D ( 'Common/Custom' )->replyImage ( $uid, $customMenu ['target_id'], 'material_image' );
							break;
						case 4 :
							// 4:语音
							D ( 'Common/Custom' )->replyVoice ( $uid, $customMenu ['target_id'], 'material_file' );
							break;
						case 5 :
							// 5:视频
							D ( 'Common/Custom' )->replyVideo ( $uid, $customMenu ['target_id'], 'material_file', '', '', '' );
							break;
					}
		           exit();
				}
			}
		}

		// 通过插件标识名、插件名或者自定义关键词来定位处理的插件
		if (! isset ( $addons [$key] ))
		{
			$keyword_cache = F ( 'keyword_cache' );

			if ($keyword_cache === false || APP_DEBUG)
			{
				foreach ( $addon_list as $k => $vo )
				{
					$keyword_cache [$vo ['name']] = $k;
					$keyword_cache [$vo ['title']] = $k;
					
					$path = ONETHINK_ADDON_PATH . $vo ['name'] . '/keyword.php';

					if (file_exists ( $path ))
					{
						$keywords = include $path;

						if (! empty ( $keywords ))
						{
							$keyword_cache = array_merge ( $keyword_cache, $keywords );
						}
					}

					F ( 'keyword_cache', $keyword_cache );
				}

			}
			foreach ( $keyword_cache as $k => $val )
			{
				$addons [$k] = $val;
			}

		}
		// 通过精准关键词来定位处理的插件 token=0是插件安装时初始化的模糊关键词，所有公众号都可以用
		if (! empty ( $forbit_addon ))
		{
			$like ['addon'] = array (
					'not in',
					$forbit_addon 
			);
		}

		$like ['token'] = array (
				'in',
				array('0',$this->token)
		);

		// 完全匹配
		if (! isset ( $addons [$key] ))
		{
			$like ['keyword'] = $key;
			$like ['keyword_type'] = 0;
			
			$keywordArr = M ( 'keyword' )->where ( $like )->order ( 'id desc' )->find();//select(false);

			if (! empty ( $keywordArr ['addon'] ) )
			{
				$addons [$key] = $keywordArr ['addon'];
				$this->request_count ( $keywordArr );
			}

		}

		// 随机匹配（前提是关键词是完全匹配）
		if (! isset ( $addons [$key] ))
		{
			$like ['keyword'] = $key;

			$like ['keyword_type'] = 5;

			$keywordArr = M ( 'keyword' )->where ( $like )->order ( 'RAND()' )->find ();

			if (! empty ( $keywordArr ['addon'] ))
			{
				$addons [$key] = $keywordArr ['addon'];

				$this->request_count ( $keywordArr );
			}
		}

		// 通过模糊关键词来定位处理的插件
		if (! isset ( $addons [$key] ))
		{
			unset ( $like ['keyword'] );

			$like ['keyword_type'] = array (
					'exp',
					'in (1,2,3,4)' 
			);

			$list = M ( 'keyword' )->where ( $like )->order ( 'keyword_length desc, id desc' )->select ();

			foreach ( $list as $keywordInfo )
			{
				$this->_contain_keyword ( $keywordInfo, $key, $addons, $keywordArr );
			}
		}

		// 通过通配符，查找默认处理方式
		
		if (! isset ( $addons [$key] ))
		{
			unset ( $like ['keyword_type'] );

			$like ['keyword'] = '*';

			$keywordArr = M ( 'keyword' )->where ( $like )->order ( 'id desc' )->find ();

			if (! empty ( $keywordArr ['addon'] ))
			{
				$addons [$key] = $keywordArr ['addon'];

				$this->request_count ( $keywordArr );
			}
		}

		// 以上都无法定位插件时，如果开启了多客服聊天，则默认使用多客服插件
		if (! isset ( $addons [$key] ) && isset ( $addon_list ['YouaskService'] ))
		{
			// 您问我答插件特殊处理
			$YouaskServiceconfig = getAddonConfig ( 'YouaskService' ); // 获取后台插件的配置参数

			$addons [$key] = 'YouaskService';
			
		}
		
		// 最终也无法定位到插件，终止操作
		if (! isset ( $addons [$key] ) 
				|| ! file_exists ( ONETHINK_ADDON_PATH . $addons [$key] . '/Model/WeixinAddonModel.class.php' )) 
		{
			return false;
		}

		// 加载相应的插件来处理并反馈信息
		require_once ONETHINK_ADDON_PATH . $addons [$key] . '/Model/WeixinAddonModel.class.php';

		$model = D ( 'Addons://' . $addons [$key] . '/WeixinAddon' );

		// addWeixinLog($keywordArr,'textmankey');
		$model->reply ( $data, $keywordArr );
		
		// 运营统计
		// tongji ( $addons [$key] );
	}
	
	// 处理关键词包含的算法
	private function _contain_keyword($keywordInfo, $key, &$addons, &$keywordArr)
	{
		if (isset ( $addons [$key] ))
			return false;
			
			// 支持正则匹配
		if ($keywordInfo ['keyword_type'] == 4)
		{
			if (preg_match ( $keywordInfo ['keyword'], $key ))
			{
				$addons [$key] = $keywordInfo ['addon'];
				$keywordArr = $keywordInfo;
				$this->request_count ( $keywordArr );
			}
			return false;
		}
		
		$arr = explode ( $keywordInfo ['keyword'], $key );

		if (count ( $arr ) > 1)
		{
			// 在关键词不相等的情况下进行左右匹配判断，否则相等的情况肯定都匹配
			if ($keywordInfo ['keyword'] != $key)
			{
				// 左边匹配
				if ($keywordInfo ['keyword_type'] == 1 && ! empty ( $arr [0] ))
					return false;
					
					// 右边 匹配
				if ($keywordInfo ['keyword_type'] == 2 && ! empty ( $arr [1] ))
					return false;
			}
			
			$addons [$key] = $keywordInfo ['addon'];
			
			$keywordArr = $keywordInfo;
			$keywordArr ['prefix'] = trim ( $arr [0] ); // 关键词前缀，即包含关键词的前面部分
			$keywordArr ['suffix'] = trim ( $arr [1] ); // 关键词后缀，即包含关键词的后面部分
			
			$this->request_count ( $keywordArr );
		}
	}
	
	// 保存关键词的请求数
	private function request_count($keywordArr)
	{

		return false; // TODO 高并发下关闭此功能

		$map ['id'] = $keywordArr ['id'];

		D ( 'Common/Keyword' )->where ( $map )->setInc ( 'request_count' );
	}


	private function init_follow($data)
	{
		$info = get_token_appinfo ( $data ['ToUserName'] );

		$config = S ( 'PUBLIC_AUTH_' . $info ['type'] );


		if (! $config)
		{
			$config = M ( 'public_auth' )->getField ( 'name,type_' . $info ['type'] . ' as val' );
			
			S ( 'PUBLIC_AUTH_' . $info ['type'], $config, 86400 );
		}
		C ( $config ); // 公众号接口权限
		               
		//用户开启上送地理位置后，打开微信公众号就会自动回复，需要屏蔽掉 location
		if ($data['Event'] == 'LOCATION') {
			exit();
		}
		
		// 初始化用户信息
		$map ['token'] = $data ['ToUserName'];
		$map ['openid'] = $data ['FromUserName'];
		D ( 'Common/Follow' )->init_follow ( $data ['FromUserName'], $data ['ToUserName'] );

		$user = M ( 'public_follow' )->where ( $map )->find ();

		
		// 绑定配置
		$config = getAddonConfig ( 'UserCenter', $map ['token'] );

		$userNeed = ($user ['uid'] > 0 && $user ['has_subscribe'] < 2) || (empty ( $user ) );

		if ($config ['need_bind'] == 1 && $userNeed && C ( 'USER_OAUTH' ))
		{
			unset ( $map ['uid'] );
			$bind_url = addons_url ( 'UserCenter://Wap/userCenter', $map );
		    if ($config ['bind_start'] != 0 && strtolower ( $_REQUEST ['_addons'] ) != 'usercenter') {
	
				 replyText ( '请先<a href="' . $bind_url . '">绑定账号</a>再使用' );
				 exit ();
			}

		}
		
	}


	function downloadPic()
	{
		$mediaId = I ( 'media_id' );
		if ($mediaId)
		{
			$id = down_media ( $mediaId );
			if ($id)
			{
				$this->ajaxReturn ( array (
						'picUrl' => get_cover_url($id),
						'id' => $id,
						'result' => 'success' 
				), 'JSON' );
			}
			else
			{
				$this->ajaxReturn ( array (
						'id' => 0,
						'result' => 'fail' 
				), 'JSON' );
			}
		}
		else
		{
			$this->ajaxReturn ( array (
					'id' => 0,
					'result' => 'fail' 
			), 'JSON' );
		}
	}
	
	// 未发送成功的消息重新发
	function sendOldMessage($token, $openid)
	{
		$map ['ToUserName'] = $token;
		$map ['is_send'] = 0;
		$map ['FromUserName'] = $openid;
		
		$messageData = M ( 'custom_sendall' )->where ( $map )->select ();
		$count = 0;
		if (! empty ( $messageData ))
		{
			foreach ( $messageData as $data )
			{
				if ($data ['msgType'] == 'text')
				{
					// 文本
					$result = D ( 'Common/Custom' )->replyText ( $data ['uid'], $data ['content'] );
				} 
				else if ($data ['msgType'] == 'news')
				{
					// 图文
					$result = D ( 'Common/Custom' )->replyNews ( $data ['uid'], $data ['news_group_id'] );
				}
				else if ($data ['msgType'] == 'image')
				{
					// 图片
					$result = D ( 'Common/Custom' )->replyImage ( $data ['uid'], $data ['media_id'], '' );
				}
				else if ($data ['msgType'] == 'voice')
				{
					// 语言
					$result = D ( 'Common/Custom' )->replyVoice ( $data ['uid'], $data ['media_id'], '' );
				}
				else if ($data ['msgType'] == 'video')
				{
					// 视频
					$result = D ( 'Common/Custom' )->replyVoice ( $data ['uid'], $data ['media_id'], '', $data ['video_thumb'], $data ['video_title'], $data ['video_description'] );
				}
				
				if ($result ['status'] == 1)
				{
					$ids [$data ['id']] = $data ['id'];
				}
			}
			if ($ids)
			{
				$map1 ['id'] = array (
						'in',
						$ids 
				);
				$save ['is_send'] = 1;
				$res = M ( 'custom_sendall' )->where ( $map1 )->save ( $save );
				if ($res)
				{
					$count ++;
				}
			}
		}
	}
}
?>