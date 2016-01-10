<?php

namespace Addons\Tmplmsg\Controller;
use Home\Controller\AddonsController;

class TmplmsgController extends AddonsController{

	Public function _initialize() {

		parent::_initialize();
		
		$controller = strtolower ( _ACTION );
		
		$res ['title'] = '模板消息';
		$res ['url'] = addons_url ( 'Tmplmsg://Tmplmsg/lists' );
		$res ['class'] = $controller == 'lists' ? 'current' : '';
		$nav [] = $res;
		
		$res ['title'] = '模板消息测试';
		$res ['url'] = addons_url ( 'Tmplmsg://Tmplmsg/test' );
		$res ['class'] = $controller == 'test' ? 'current' : '';
		$nav [] = $res;
				
		$this->assign ( 'nav', $nav );
	}

	public function lists() {
	
		$this->assign ( 'add_button', false );
		$model = $this->getModel ();
		parent::common_lists ( $model );
	}
	
	public function test() {
		if(IS_POST){
			sendtempmsg(I('post.openid'), I('post.template_id'), I('post.url'), I('post.data'), $topcolor='#FF0000');
		}else{
			$this->display();
		}
	}
	
	//发送模板消息
	public function sendtempmsg($openid, $template_id, $url, $data, $topcolor='#FF0000') {
	
		$json = $this->get_access_token();
		if ($json ['errcode'] == 0) {
			$xml = '{"touser":"'.$openid.'","template_id":"'.$template_id.'","url":"'.$url.'","topcolor":"'.$topcolor.'","data":'.$data.'}';
			$res = $this->curlPost('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$json['access_token'],$xml);
			$res = json_decode($res, true);
			// 记录日志
			if ($res ['errcode'] == 0) {
				addWeixinLog ( $xml, 'post' );
			}
			$senddata = array(
				'openid' => $openid,
				'template_id' => $template_id,
				'MsgID' => $res['msgid'],
				'message' => $data,
				'sendstatus' => $res['errcode']==0 ? 0 : 1,
				'token' => get_token(),
				'ctime' => time(),
			);
			M ('tmplmsg')->add ( $senddata );
			return $res;
		}else{
			return $json;
		}
		
	}
	
	//获取access_token
	public function get_access_token(){
	
		$map ['token'] = get_token ();
		$info = M ( 'member_public' )->where ( $map )->find ();
		$url_get = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=' . $info ['appid'] . '&secret=' . $info ['secret'];
		$data = json_decode($this->curlGet($url_get), true);
		if ($data ['errcode'] == 0) {

			return $data;
		}else{
		
			return $data;
		}
	}
	
	public function curlPost($url, $data){
		$ch = curl_init();
		$header = "Accept-Charset: utf-8";
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
		curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (compatible; MSIE 5.01; Windows NT 5.0)');
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$tmpInfo = curl_exec($ch);
		$errorno=curl_errno($ch);
		return $tmpInfo;
	}
	
    public function curlGet($url){
		$ch = curl_init();
		$header = "Accept-Charset: utf-8";
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
		curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (compatible; MSIE 5.01; Windows NT 5.0)');
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$temp = curl_exec($ch);
		return $temp;
	}
}
