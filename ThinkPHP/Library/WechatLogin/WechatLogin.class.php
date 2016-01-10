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

include_once('Curl.class.php');
include_once('simple_html_dom.class.php');

abstract class WechatLogin {
	
	const HOST = 'https://mp.weixin.qq.com';

	const URL_SETTING = '/settingpage?t=setting/index&action=index&lang=zh_CN';

	const URL_LOGIN = '/cgi-bin/login';
	
	const URL_INTERFACE = '/advanced/advanced?action=interface&t=advanced/interface&lang=zh_CN';
	
	const URL_BIND = '/advanced/callbackprofile?t=ajax-response&lang=zh_CN';

	const URL_DEV = '/advanced/advanced?action=dev&t=advanced/dev&lang=zh_CN';

	private $username;
	private $password;

	//成功登录后获取的token
	private $token;
	//成功登录后获取的cookie
	private $cookie;

	private $imgpath = '.';

	//错误信息
	private $error = '';

	public function __construct($username, $password) {
		$this->username = $username;
		$this->password = $password;
	}

	public function setImgPath($imgpath) {
		if (!file_exists($imgpath)) {
			mkdir($imgpath,0777,true);
		}
		$this->imgpath = $imgpath;
	}

	private function getToken() {
		//token为空，重新获取
		$token = $this->getCache('token_'.$this->username);
		if (!$token) {
			$curl = new Curl();
			$curl->referer(self::HOST);
			$data['username'] = $this->username;
			$data['pwd'] = md5($this->password);
			$data['imgcode'] = '';
			$data['f'] = 'json';
			$content = $curl->post(self::HOST.self::URL_LOGIN,$data);
			$result = json_decode($content,true);
			//成功
			if ($result['base_resp']['err_msg']=='ok') {
				//匹配出成功的token
				preg_match('/token=(\d+)&?/', $result['redirect_url'], $match);
				$this->setCache('token_'.$this->username, $match[1], 300);
				$this->setCache('cookie_'.$this->username, $curl->getCookies(), 300);
				$token = $match[1];
			}
			else {
				$this->error = $result['base_resp']['err_msg'];
				return false;
			}
		}
		return $token;
	}

	public function getError() {
		return $this->error;
	}
	
	public function getMpInfo() {
		$curl = new Curl();
		$vefify_token = $this->getToken();
		if (!$vefify_token) {
			return false;
		}
		$url = self::HOST.self::URL_SETTING.'&token='.$vefify_token;
		$curl->setCookies($this->getCache('cookie_'.$this->username));
		$content = $curl->get($url);

		$html = str_get_html($content);
		$items = $html->find('.account_setting_area ul li');
		$temp = array();
		foreach ($items as $item) {
			if ($item->class=='account_setting_item wrp_pic_item_spe1') {
				$src = self::HOST.$item->find('.meta_content img',0)->src;
				$temp[$item->find('h4',0)->plaintext] = trim($img);
				$img = $this->imgpath.'/qrcode_'.$this->username.'.jpg';
				file_put_contents($img, $curl->get($src));
				$info['qrcode'] = $img;
			}
			elseif ($item->class=='account_setting_item wrp_pic_item_spe2') {
				$src = self::HOST.$item->find('.meta_content img',0)->src;
				$temp[$item->find('h4',0)->plaintext] = trim($src);
				$img = $this->imgpath.'/headpic_'.$this->username.'.jpg';
				file_put_contents($img, $curl->get($src));
				$info['headpic'] = $img;
			}
			else {
				$temp[$item->find('h4',0)->plaintext] = trim($item->find('.meta_content',0)->plaintext);
			}
		}

		$html->clear();

		if (array_key_exists('名称', $temp)) {
			$info['name'] = $temp['名称'];
		}
		if (array_key_exists('微信号', $temp)) {
			$info['mp_number'] = $temp['微信号'];
		}
		if (array_key_exists('类型', $temp)) {
			$info['type_name'] = trim(str_replace('类型不可变更', '', $temp['类型']));
		}
		if (array_key_exists('介绍', $temp)) {
			$info['description'] = $temp['介绍'];
		}
		if (array_key_exists('认证情况', $temp)) {
			$info['is_varify'] = $temp['认证情况'];
		}
		if (array_key_exists('所在地址', $temp)) {
			$info['address'] = $temp['所在地址'];
		}
		if (array_key_exists('主体信息', $temp)) {
			$info['owner'] = $temp['主体信息'];
		}
		if (array_key_exists('登录邮箱', $temp)) {
			$info['email'] = $temp['登录邮箱'];
		}
		if (array_key_exists('原始ID', $temp)) {
			$info['origin_id'] = $temp['原始ID'];
		}

		switch ($info['is_varify'].$info['type_name']) {
			case '未认证订阅号':
				$info['type'] = 0;
				break;
			case '微信认证订阅号':
				$info['type'] = 1;
				break;
			case '未认证服务号':
				$info['type'] = 2;
				break;
			case '微信认证服务号':
				$info['type'] = 3;
				break;
			default:
				break;
		}

		$content = $curl->get(self::HOST.self::URL_DEV.'&token='.$vefify_token);
		$html = str_get_html($content);
		$info['appid'] = $html->find('div[class=developer_info_item rel] div[class=frm_controls frm_vertical_pt]',0)->plaintext;
		$info['encoding_aeskey'] = trim($html->find('#js_symmetrikey',0)->next_sibling()->plaintext);
		return $info;
	}

	public function bind($api, $token, $encoding_aeskey = '') {
		$vefify_token = $this->getToken();
		if (!$vefify_token) {
			return false;
		}
		$referer = self::HOST.self::URL_INTERFACE.'&token='.$vefify_token;
		$curl = new Curl();
		$curl->setCookies($this->getCache('cookie_'.$this->username));
		$content = $curl->get($referer);
		preg_match('/operation_seq:.*"(\d+)"/', trim($content), $match);
		$seq = $match[1];

		$post['url'] = $api;
		$post['callback_token'] = $token;
		//安全模式
		if (!empty($encoding_aeskey)) {
			$post['callback_encrypt_mode'] = 2;
		}
		//明文模式
		else {
			$post['callback_encrypt_mode'] = 0;
		}
		$post['encoding_aeskey'] = 'bc0adf7e6895eb76a22cbac1f2cb776d7dd7cb7ae1c';
		$post['operation_seq'] = $seq;

		$url = self::HOST.self::URL_BIND.'&token='.$vefify_token;
		$curl->referer($referer);
		$content = $curl->post($url,$post);
		preg_match('/"err_msg":"(.*)"/',$content,$match);
		return $match[1]=='ok';
	}

	protected function setCache($cachename, $value, $expired) {
		//TODO
		return false;
	}

	protected function getCache($cachename){
		//TODO
		return false;
	}
}