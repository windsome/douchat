<?php
        	
namespace Addons\Suggestions\Model;
use Home\Model\WeixinModel;
        	
/**
 * Suggestions的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {	
		$param ['token'] = get_token ();
		$param ['openid'] = get_openid ();
		$config = getAddonConfig('Suggestions');
		$url = addons_url ( 'Suggestions://Suggestions/suggest', $param );
		$articles [0] = array (
				'Title' => $config['title']?$config['title']:'意见反馈',
				'Description' => $config['desc']?$config['desc']:'点此进入填写反馈内容',
				'PicUrl' => $config['cover']?get_cover_url($config['cover']):__ROOT__ . '/Public/Home/images/logo.png',
				'Url' => $url
		);
		
		$res = $this->replyNews ( $articles );
	}  	
}
        	