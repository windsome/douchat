<?php
        	
namespace Addons\Example\Model;
use Home\Model\WeixinModel;
        	
/**
 * Example的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'Example' ); // 获取后台插件的配置参数	
		//dump($config);
		replyText("这是功能演示插件默认文本回复");
	}

	// 用户发送文本消息处理钩子
	function text($data){

		if ($data['Content'] == '功能演示') {
			// replyText("这是文本消息处理钩子里设置的文本回复");
		}

		if ($data['Content'] == '微捐赠') {
			// replyText('weijuanz');
		}

		if ($data['Content'] == 'jssdk' || $data['Content'] == 'demo' || $data['Content'] == '功能演示') {
			$params['token'] = get_token();
			$jump_url = addons_url('Example://Example/demo', $params);
			replyText('<a href="' . $jump_url . '">功能演示</a>');
		}

		if($data['Content'] == '获取消息数组'){
			$revData = getRevData();
			replyText('消息数组：'.json_encode($revData));
		}

		if($data['Content'] == '获取用户ID'){
			$revFrom = getRevFrom();
			replyText('用户id是：'.$revFrom);
		}

		if($data['Content'] == '获取公众号ID'){
			$revTo = getRevTo();
			replyText('公众号id是：'.$revTo);
		}

		if($data['Content'] == '获取消息类型'){
			$revType = getRevType();
			replyText('你发送的消息类型是：'.$revType);
		}

		if($data['Content'] == '获取消息ID'){
			$revId = getRevId();
			replyText('你发送的消息ID是：'.$revId);
		}

		if($data['Content'] == '获取消息发送时间'){
			$revCtime = getRevCtime();
			replyText('你发送的消息发送时间是：'.$revCtime);
		}

		if($data['Content'] == '获取消息内容'){
			$revContent = getRevContent();
			replyText('你发送的消息内容是：'.$revContent);
		}

		if($data['Content'] == '回复文本'){
			replyText("这是文本回复");
		}

		if($data['Content'] == '回复单图文'){
			$articles[0] = array(
				'Title' => '单图文消息标题',
				'Description' => '单图文消息描述',
				'PicUrl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'Url' => 'http://idouly.com/wenda/'
			);
			replyNews($articles);
		}

		if($data['Content'] == '回复多图文'){
			$articles[0] = array(
				'Title' => '单图文消息标题1',
				'Description' => '单图文消息描述1',
				'PicUrl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'Url' => 'http://idouly.com/wenda/'
			);
			$articles[1] = array(
				'Title' => '单图文消息标题2',
				'Description' => '单图文消息描述2',
				'PicUrl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'Url' => 'http://idouly.com/wenda/'
			);
			$articles[2] = array(
				'Title' => '单图文消息标题3',
				'Description' => '单图文消息描述3',
				'PicUrl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'Url' => 'http://idouly.com/wenda/'
			);
			$articles[3] = array(
				'Title' => '单图文消息标题4',
				'Description' => '单图文消息描述4',
				'PicUrl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'Url' => 'http://idouly.com/wenda/'
			);
			replyNews($articles);
		}

		if($data['Content'] == '回复音乐'){
			replyMusic('我的歌声里','曲婉婷','http://yinyueshiting.baidu.com/data2/music/5a5631832313a6007da895d12994e311/255967781/255704757248400128.mp3?xcode=67dd7bdbf2d520d5bd5cc648288db746');
		}

		if($data['Content'] == '转接客服'){
			transferCustomerService();
		}

		if($data['Content'] == '获取菜单'){
			$menu = getMenu();
			replyText(json_encode($menu));
		}

		if ($data['Content'] == '删除菜单'){
			if (deleteMenu()) {
				replyText('删除菜单成功');
			}
		}

		if ($data['Content'] == '创建菜单'){
			$btn1 = array(
				'name' => 'button1',
				'type' => 'click',
				'key' => 'button1_key'
			);
			$data['button'][0] = $btn1;
			if (createMenu($data)) {
				replyText('创建菜单成功');
			} else {
				replyText('创建菜单失败');
			}
		}

		if ($data['Content'] == '发送模板消息'){

			$temp_data['touser'] = getRevFrom();
			$temp_data['template_id'] = 'A93dk7bWn9W4oSvM7UcXm95X-WehNeLeegRq4RaKF8g';
			$temp_data['url'] = 'http://idouly.com/wenda/';
			$temp_data['topcolor'] = '#44b549';
			$temp_data['data']['first']['value'] = '有新的用户捐赠，请注意查收';
			$temp_data['data']['first']['color'] = '#da4224';
			$temp_data['data']['keyword1']['value'] = '用户捐赠通知';
			$temp_data['data']['keyword1']['color'] = '#0baae4';
			$temp_data['data']['keyword2']['value'] = '2015年1月7日';
			$temp_data['data']['keyword2']['color'] = '#0baae4';
			$temp_data['data']['remark']['value'] = '用户昵称：艾逗笔，捐赠额：66元';
			$temp_data['data']['remark']['color'] = '#333';

			//replyText(json_encode($temp_data));
			sendTemplateMessage($temp_data);
			// replyText(json_encode($temp_data));
			exit();
		}

		if ($data['Content'] == '发送文本客服消息'){
			$kf_data['touser'] = getRevFrom();
			$kf_data['msgtype'] = 'text';
			$kf_data['text']['content'] = '你好啊，亲~';
			//replyText(json_encode($kf_data));
			sendCustomMessage($kf_data);
			exit();
		}

		if ($data['Content'] == '发送图文客服消息'){

			$articles[0] = array(
				'title' => '单图文消息标题1',
				'description' => '单图文消息描述1',
				'picurl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'url' => 'http://idouly.com/wenda/'
			);
			$articles[1] = array(
				'title' => '单图文消息标题2',
				'description' => '单图文消息描述2',
				'picurl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'url' => 'http://idouly.com/wenda/'
			);
			$articles[2] = array(
				'title' => '单图文消息标题3',
				'description' => '单图文消息描述3',
				'picurl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'url' => 'http://idouly.com/wenda/'
			);
			$articles[3] = array(
				'title' => '单图文消息标题4',
				'description' => '单图文消息描述4',
				'picurl' => 'https://mmbiz.qlogo.cn/mmbiz/bcPR8rBzAQhibbpsMEC1WOYIaD1l85XJRWCoricvUnfricBXO9eIuPEJgB2EsucewMYWjE3dLxohzINoxoaD6R6aA/0?wx_fmt=jpeg',
				'url' => 'http://idouly.com/wenda/'
			);

			$kf_data['touser'] = getRevFrom();
			$kf_data['msgtype'] = 'news';
			$kf_data['news']['articles'] = $articles;
			//replyText(json_encode($kf_data));
			sendCustomMessage($kf_data);
			exit();
		}

		if ($data['Content'] == '获取二维码') {
			$qrCode = getQRCode(88,2);
			replyText(json_encode($qrCode));
		}
	}

	//public function templatesendjobfinish($data){
	//	replyText(json_encode($data));
	//}

	// 用户发送图片消息处理钩子
	//public function image($data){
	//	replyImage($data['MediaId']);
	//}

	// 用户发送语音消息处理钩子
	//public function voice($data){
	//	replyText("你发送的语音内容是:".$data['Recognition']);
	//}

	// 用户发送短视频消息处理钩子
	//public function shortvideo($data){
	//	replyText(json_encode($data));
	//}

	// 用户发送短视频消息处理钩子
	// TODO
	//public function video($data){
		//replyText(json_encode($data));
	//}

	// 用户发送链接消息处理钩子
	//public function link($data){
	//	replyText("你发的链接\n标题为：".$data['Title']."\n描述为：".$data['Description']."\n链接地址为：".$data['Url']);
	//}

	// 用户发送位置消息处理钩子
	//public function location($data){
	//	replyText("你发的位置所处的\n经度为：".$data['Location_Y']."\n纬度为：".$data['Location_X']."\n位置名为：".$data['Label']);
	//}

	// 用户上报地理位置事件处理钩子
	//public function reportLocation($data){
	//	$revEventGeo = getRevEventGeo();
	//	replyText(json_encode($revEventGeo));
	//}

	// 用户点击菜单事件处理钩子
	//public function click($data){
	//	$revEvent = getRevEvent();
		// replyText(json_encode($revEvent));
	//}

	// 用户扫码带参数二维码处理钩子
	// public function scan($data) {
	// 	replyText(json_encode($data));
	// }

	// 用户关注事件
	// public function subscribe($data) {
	// 	replyText(json_encode($data));
	// }

	// 用户扫码推事件处理钩子
	// TODO
	//public function scancode_push($data){
	//	$revScanInfo = getRevScanInfo();
		//replyText(json_encode($revScanInfo));
	//	replyText(json_encode($data));
	//}

	// 用户扫码带提示事件处理钩子
	//public function scancode_waitmsg($data){
	//	$revScanInfo = getRevScanInfo();
		//replyText(json_encode($revScanInfo));
	//	replyText(json_encode($data));
	//}

	//public function pic_photo_or_album($data){
	//	$revSendPicsInfo = getRevSendPicsInfo();
		//replyText(json_encode($data));
	//	replyText(json_encode($revSendPicsInfo));
	//}

	//public function location_select($data){
	//	$revSendGeoInfo = getRevSendGeoInfo();
	//	replyText($revSendGeoInfo);
	//}
}
        	