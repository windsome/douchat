<?php
        	
namespace Addons\IdouExample\Model;
use Home\Model\WeixinModel;
        	
/**
 * IdouExample的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'IdouExample' ); // 获取后台插件的配置参数	
		//dump($config);
	}
}
        	