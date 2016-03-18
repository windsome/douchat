<?php
        	
namespace Addons\Farm\Model;
use Home\Model\WeixinModel;
        	
/**
 * Farm的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'Farm' ); // 获取后台插件的配置参数	
		//dump($config);
	}
}
        	