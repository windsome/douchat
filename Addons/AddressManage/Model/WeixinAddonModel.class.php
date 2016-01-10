<?php
        	
namespace Addons\AddressManage\Model;
use Home\Model\WeixinModel;
        	
/**
 * AddressManage的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'AddressManage' ); // 获取后台插件的配置参数	
		//dump($config);
		$params['token'] = get_token();
		$params['openid'] = get_openid();
		$url = addons_url('AddressManage://AddressManage/addList',$params);
		$this->replyText($url);

	} 

	
}
        	