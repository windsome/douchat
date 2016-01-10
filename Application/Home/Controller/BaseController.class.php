<?php

namespace Home\Controller;
use Wechat\JsSdk;

class BaseController extends HomeController {


	// 根据media_id从微信服务器下载图片
	public function downMedia() {
		$media_id = I('media_id');
		$cover_id = down_media($media_id);

		if ($cover_id) {
			$res['errcode'] = 40001; 
			$res['errmsg'] = 'download picture success';
			$res['cover_id'] = $cover_id;
			$res['media_id'] = $media_id;
			$res['picture_url'] = get_cover_url($cover_id);
		} else {
			$res['errcode'] = 40002;
			$res['errmsg'] = 'download picture fail';
		}

		echo json_encode($res);

	}


	// 通过ajax调起微信支付
	public function json_pay(){
		
		$data['orderid'] = I('orderid');
		$data['price'] = I('price');
		
		$jsApiParameters = getJsApiParameters($data);
		
		echo json_encode($jsApiParameters);
	}
}


?>