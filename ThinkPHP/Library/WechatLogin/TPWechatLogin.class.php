<?php 

/**
 * ThinkPHP框架下的微信模拟登陆类
 * @author 艾逗笔<765532665@qq.com>
 * @version 1.0
 */

namespace WechatLogin;

class TPWechatLogin extends WechatLogin {

	public function setCache($cachename, $value, $expired) {
		
		S($cachename, $value, $expired);

	}

	public function getCache($cachename) {
		
		return S($cachename);

	}
}


 ?>