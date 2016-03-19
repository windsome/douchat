<?php
        	
namespace Addons\HelloWorld\Model;
use Home\Model\WeixinModel;
        	
/**
 * HelloWorld的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
        $ticket = getJsTicket();
        $sign = getJsSign();
        $access_token = get_access_token ();				
		$this->replyText ( '欢迎您来到Fucker的世界-_- <'.$ticket.'> <' .$access_token . '> <' . json_encode ($sign) . '>');
	}
    
    public function device_subscribe_status ($data) {
        $this->replyDeviceStatus($data['DeviceType'], $data['DeviceID'], '1');
    }

    public function device_unsubscribe_status ($data) {
        $this->replyDeviceStatus($data['DeviceType'], $data['DeviceID'], '0');
    }

    public function device_bind ($data) {
        $access_token = get_access_token ();				
        $url = 'https://api.weixin.qq.com/device/compel_bind?access_token=' . $access_token;
        //$param['ticket'] = $data['SessionID'];
        $param['device_id'] = $data['DeviceID'];
        $param['openid'] = $data['OpenID'];
        
        addWeixinLog ( json_encode($param), 'device_bind: '.$url );
        
        $this->http_post($url, json_encode ($param));
    }

    public function device_unbind ($data) {
        $access_token = get_access_token ();				
        $url = 'https://api.weixin.qq.com/device/compel_unbind?access_token=' . $access_token;
        $param['device_id'] = $data['DeviceID'];
        $param['openid'] = $data['OpenID'];
        
        addWeixinLog ( json_encode($param), 'device_unbind: '.$url );
        
        $this->http_post($url, json_encode ($param));
    }

	private function http_post($url, $param) {
		$oCurl = curl_init ();
		if (stripos ( $url, "https://" ) !== FALSE) {
			curl_setopt ( $oCurl, CURLOPT_SSL_VERIFYPEER, FALSE );
			curl_setopt ( $oCurl, CURLOPT_SSL_VERIFYHOST, false );
		}
		if (is_string ( $param )) {
			$strPOST = $param;
		} else {
			$aPOST = array ();
			foreach ( $param as $key => $val ) {
				$aPOST [] = $key . "=" . urlencode ( $val );
			}
			$strPOST = join ( "&", $aPOST );
		}
		curl_setopt ( $oCurl, CURLOPT_URL, $url );
		curl_setopt ( $oCurl, CURLOPT_RETURNTRANSFER, 1 );
		curl_setopt ( $oCurl, CURLOPT_POST, true );
		curl_setopt ( $oCurl, CURLOPT_POSTFIELDS, $strPOST );
		$sContent = curl_exec ( $oCurl );
		$aStatus = curl_getinfo ( $oCurl );
		curl_close ( $oCurl );
		if (intval ( $aStatus ["http_code"] ) == 200) {
            addWeixinLog ( $sContent, 'http_post: '.$url );
			return $sContent;
		} else {
            addWeixinLog ( $sContent, 'http_post: '.$url );
			return false;
		}
	}
}
        	