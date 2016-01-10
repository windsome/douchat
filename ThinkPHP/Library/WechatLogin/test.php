<?php
// +----------------------------------------------------------------------
// | [ Code is not cold ] [Keep on going never give up]
// +----------------------------------------------------------------------
// | Copyright (c) 2010-2015 http://www.xxdgaming.com All rights reserved.
// +----------------------------------------------------------------------
// | Author: 薛兴东 <306947352@qq.com> <http://www.xxdgaming.com>
// +----------------------------------------------------------------------
// | This is not a free software, unauthorized no use and dissemination.
// +----------------------------------------------------------------------
// | Date 2015-12-01
// +----------------------------------------------------------------------
/**
*@version 1.0
*
*/

namespace WechatLogin;

class MyWechatLogin extends WechatLogin {

	public function getCache($cachename) {
		
		if (!file_exists('cache/'.$cachename.'.txt')) {
			return false;
		}
		$string = file_get_contents('cache/'.$cachename.'.txt');
		if (!$string) {
			return false;
		}
		$data = unserialize($string);
		if ($data['createtime']+$data['expired']<time()) {
			return false;
		}
		return $data['value'];
	}

	public function setCache($cachename, $value, $expired) {
		$data['value'] = $value;
		$data['createtime'] = time();
		$data['expired'] = $expired;
		if (!file_exists('cache')) {
			mkdir('cache', 0777, true);
		}
		file_put_contents('cache/'.$cachename.'.txt',serialize($data));
	}
}

$wechat = new MyWechatLogin('idouly@163.com','idouly123');
$wechat->setImgPath('image');
$wechat->getMpInfo();