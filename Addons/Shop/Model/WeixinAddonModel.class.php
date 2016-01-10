<?php
        	
namespace Addons\Shop\Model;
use Home\Model\WeixinModel;
        	
/**
 * Shop的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'Shop' ); // 获取后台插件的配置参数	
		//dump($config);
		$articles[0] = array(
			'Title' => '微商城演示',
			'Description' => '点此进入',
			'PicUrl' => 'http://img3.imgtn.bdimg.com/it/u=332202090,1013300913&fm=21&gp=0.jpg',
			'Url' => addons_url('Shop://Wap/index/')
		);
		replyNews($articles);

	} 

	// 关注公众号事件
	public function subscribe() {
		return true;
	}
	
	// 取消关注公众号事件
	public function unsubscribe() {
		return true;
	}
	
	// 扫描带参数二维码事件
	public function scan() {
		return true;
	}
	
	// 上报地理位置事件
	public function location() {
		return true;
	}
	
	// 自定义菜单事件
	public function click() {
		return true;
	}	

	// 文本消息处理
	public function text( $data ) {
		// if ( $data['Content'] == '微商城' || $data['Content'] == '商城' || $data['Content'] == 'Shop' ) {
		// 	replyText( addons_url('Shop://Wap/index/') );
		// }
	}
}
        	