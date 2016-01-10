<?php
/**
*	@类名 Curl
*	@功能 基于Curl的二次封装库
*	@author XueXingdong(306947352@qq.com)
*
*/

namespace WechatLogin;

class Curl {

	//代理
	private $proxy = array();
	//来源
	private $referer;
	//浏览器
	private $user_agent;
	//超时时间
	private $timeout = 0;
	//请求头
	private $req_headers = array();

	//是否允许重定向
	private $follow_redirects = false;
	//最大重定向次数
	private $max_redirects = 5;

	//请求cookie数组
	private $req_cookies = array();

	//返回cookie数组
	private $resp_cookies = array();

	//临时储存CURL状态信息
	private $status;

	//临时存储返回的原始HTTP头
	private $raw_headers;

	//返回的格式化http头数组
	private $resp_headers = array();

	//临时存储HTML内容
	private $content;

	/**
	 * @function 构造函数
	 * @param array 相关设置
	 * @return void
	 */
	public function __construct(array $options = array()) {
		$this->proxy = isset($options['proxy'])?$options['proxy']:'';
		$this->referer = isset($options['referer'])?$options['referer']:'';
		$this->user_agent = isset($options['user_agent'])?$options['user_agent']:'';
		$this->timeout = isset($options['timeout'])?$options['timeout']:0;
		$this->req_cookies = isset($options['cookie'])?self::_formatCookie($options['cookie']):'';
	}

	/**
	 * @function 伪造ip
	 * @param string client_ip
	 * @param string x_forwarded_for
	 * @return mixed
	 */
	public function ip($client_ip, $x_forwarded_for = '') {
		if (func_num_args()==0) {
			return array(
				'CLIENT-IP'=>$this->req_headers['CLIENT'],
				'X-FORWARDED-FOR'=>$this->req_headers['X-FORWARDED-FOR']
				);
		}
		$this->req_headers['CLIENT-IP'] = $client_ip;
		$this->req_headers['X-FORWARDED-FOR'] = $x_forwarded_for ? $x_forwarded_for : $client_ip;
		return $this;
	}

	/**
	 * @function 代理设置
	 * @param string ip
	 * @param string 端口
	 * @param string 登录用户名
	 * @param string 登录密码
	 * @param string 代理类型
	 * @return mixed
	 */
	public function proxy($ip = '127.0.0.1', $port = 80, $username = '', $password = '' , $type = CURLPROXY_HTTP){
		if (func_num_args()==0) {
			return $this->proxy;
		}
		$this->proxy['ip'] = $ip;
		$this->proxy['port'] = $port;
		if ($username) {
			$this->proxy['username'] = $username;
			$this->proxy['password'] = $password;
		}
		if ($type != CURLPROXY_HTTP) {
			$type = CURLPROXY_SOCKS5;
		}
		$this->proxy['type'] = $type;
		return $this;
	}

	/**
	 * @function 设置/获取referer
	 * @param string referer地址
	 * @return mixed
	 */
	public function referer($referer = '') {
		if (func_num_args()==0) 
			return $this->referer;
		else {
			$this->referer = $referer;
			return $this;
		}
	}

	/**
	 * @function 设置/获取浏览器标识
	 * @param string 浏览器标识
	 * @return mixed
	 */
	public function userAgent($user_agent = '') {
		if (func_num_args()==0) 
			return $this->user_agent;
		else {
			$this->user_agent = $user_agent;
			return $this;
		}
	}

	/**
	 * @function 设置/获取超时时间
	 * @param float/int 超时时间
	 * @return mixed
	 */
	public function timeout($timeout = '') {
		if (func_num_args()==0)
			return $this->timeout;
		else {
			$this->timeout = $timeout;
			return $this;
		}
	}

	/**
	 * @function 设置自动跟随重定向次数
	 * @param int 自动跟随重定向次数
	 * @return this
	 */
	public function followLocation($follow = true) {
		$this->max_redirects = $follow === true ? : max(1, $follow);
		$this->follow_redirects = (bool) $follow;
		return $this;
	}

	/**
	 * @function 人工设置请求cookie
	 * @param string/array cookie值，字符串或数组形式
	 * @return this
	 */
	public function setCookies($cookies) {
		$this->req_cookies = self::_formatCookie($cookies);
		return $this;
	}

	/**
	 * @function 解析上一次http请求的头部，截取其中的cookie信息
	 * @param array cookieNameArray 所需要的cookie名字数组，默认返回所有cookie
	 * @example ('cookiename1','cookiename2');
	 *
	 * @return array cookies 返回的cookie数组
	 * @example ('cookiename1'=>'cookievalue1','cookiename2'=>'cookievalue2');
	 */

	public function getCookies($cookieNameArray = '') {
		$cookies = array();
		if (is_array($cookieNameArray) && !empty($cookieNameArray)) {
			foreach ($cookieNameArray as $cookieName) {
				if (array_key_exists($cookieName, $this->resp_cookies)) {
					$cookies[$cookieName] = $this->resp_cookies[$cookieName];
				}
			}
		}
		else {
			$cookies = $this->resp_cookies;
		}
		return $cookies;

	}

	/**
	 * @function 获取单个cookie
	 * @param string cookie名
	 * @return array cookie值
	 */
	public function getCookie($cookieName) {
		return $this->resp_cookies[$cookieName];
	}

	public function getContent() {
		return $this->content;
	}

	public function getStatus() {
		return $this->status;
	}

	public function getHeaders() {
		return $this->resp_headers;
	}

	public function getHeader($headerName) {
		return $this->resp_headers[$headerName];
	}

	/**
	 * GET 请求
	 * @param string url 请求链接
	 * @param string/array cookie 请求所带的cookie
	 * @return string content 结果界面的body值
	 */

	public function get($url) {
		$curl = curl_init();
		//判断是否是https请求，若是则跳过SSL验证
		if(stripos($url,"https://")!==false) {
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		}
		//代理设置
		if ($this->proxy) {
			curl_setopt($curl, CURLOPT_PROXY, $this->proxy['ip']);
			curl_setopt($curl, CURLOPT_PROXYPORT, $this->proxy['port']);
			curl_setopt($curl, CURLOPT_PROXYTYPE, $this->proxy['type']);
			curl_setopt($curl, CURLOPT_PROXYAUTH, CURLAUTH_BASIC);
			curl_setopt($curl, CURLOPT_HTTPPROXYTUNNEL, 1);
			if (isset($this->proxy['username'])) {
				curl_setopt($curl, CURLOPT_PROXYUSERPWD, $this->proxy['username'].':'.$this->proxy['password']);
			}
		}
		//超时设置
		if ($this->timeout) {
			curl_setopt($curl, CURLOPT_TIMEOUT, $this->timeout);
		}
		//重定向
		if ($this->follow_redirects) {
			curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
			curl_setopt($curl, CURLOPT_MAXREDIRS, $this->max_redirects);
		}
		if ($this->user_agent) {
			curl_setopt($curl, CURLOPT_USERAGENT, $this->user_agent);
		}
		if ($this->referer) {
			curl_setopt($curl, CURLOPT_REFERER, $this->referer);
		}
		//如果没有设置referer，则自动设置referer
		else {
			curl_setopt($curl, CURLOPT_AUTOREFERER, 1);
		}
		//设置cookie
		if ($this->req_cookies) {
			curl_setopt($curl, CURLOPT_COOKIE, $this->req_cookies);
		}
		$req_headers = $this->req_headers;
		foreach ($req_headers as $key => $value) {
			$req_headers[] = $key.':'.$value;
		}
		curl_setopt($curl, CURLOPT_HTTPHEADER , $req_headers);
		curl_setopt($curl, CURLOPT_HEADER, 1);
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		$response = curl_exec($curl);
		//自动检测把GB2312转换为UTF-8
		if(mb_detect_encoding($response,array('UTF-8','GB2312'))=='EUC-CN')
			$response = mb_convert_encoding($response,'UTF-8','GB2312');
		$header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
		$resp_headers = substr($response, 0, $header_size);
		$content = substr($response, $header_size);
		$status = curl_getinfo($curl);
		curl_close($curl);
		$this->status = $status;
		$this->raw_headers = $resp_headers;
		$this->resp_headers = $this->_parseHearders($this->raw_headers);
		$this->content = $content;
		return $content;
	}

	/**
	 * POST 请求
	 * @param string url 请求链接
	 * @param string/array param 请求参数
	 * @param string/array cookie 请求所带的cookie
	 * @return string content 结果界面的body值
	 */
	public function post($url, $param = '') {
		$curl = curl_init();
		//判断是否是https请求，若是则跳过SSL验证
		if(stripos($url,"https://")!==false) {
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		}
		//代理设置
		if ($this->proxy) {
			curl_setopt($curl, CURLOPT_PROXY, $this->proxy['ip']);
			curl_setopt($curl, CURLOPT_PROXYPORT, $this->proxy['port']);
			curl_setopt($curl, CURLOPT_PROXYTYPE, $this->proxy['type']);
			curl_setopt($curl, CURLOPT_PROXYAUTH, CURLAUTH_BASIC);
			curl_setopt($curl, CURLOPT_HTTPPROXYTUNNEL, 1);
			if (isset($this->proxy['username'])) {
				curl_setopt($curl, CURLOPT_PROXYUSERPWD, $this->proxy['username'].':'.$this->proxy['password']);
			}
		}
		//超时设置
		if ($this->timeout) {
			curl_setopt($curl, CURLOPT_TIMEOUT, $this->timeout);
		}
		//重定向
		if ($this->follow_redirects) {
			curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
			curl_setopt($curl, CURLOPT_MAXREDIRS, $this->max_redirects);
		}
		if ($this->user_agent) {
			curl_setopt($curl, CURLOPT_USERAGENT, $this->user_agent);
		}
		if ($this->referer) {
			curl_setopt($curl, CURLOPT_REFERER, $this->referer);
		}
		//如果没有设置referer，则自动设置referer
		else {
			curl_setopt($curl, CURLOPT_AUTOREFERER, 1);
		}
		//设置cookie
		if ($this->req_cookies) {
			curl_setopt($curl, CURLOPT_COOKIE, $this->req_cookies);
		}

		//post参数设置
		curl_setopt($curl, CURLOPT_POST, 1);
		if (!empty($param)) {
			if (is_array($param)) {
				$param = http_build_query($param);
			}
			curl_setopt($curl, CURLOPT_POSTFIELDS, $param);
		}

		$req_headers = $this->req_headers;
		foreach ($req_headers as $key => $value) {
			$req_headers[] = $key.':'.$value;
		}
		curl_setopt($curl, CURLOPT_HTTPHEADER , $req_headers);
		curl_setopt($curl, CURLOPT_HEADER, 1);
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		$response = curl_exec($curl);
		//自动检测把GB2312转换为UTF-8
		if(mb_detect_encoding($response,array('UTF-8','GB2312'))=='EUC-CN')
			$response = mb_convert_encoding($response,'UTF-8','GB2312');
		$header_size = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
		$resp_headers = substr($response, 0, $header_size);
		$content = substr($response, $header_size);
		$status = curl_getinfo($curl);
		curl_close($curl);
		$this->status = $status;
		$this->raw_headers = $resp_headers;
		$this->resp_headers = $this->_parseHearders($this->raw_headers);
		$this->content = $content;
		return $content;
	}
	
	/**
	 * @function 解析头部为数组，并提取出cookie放入数组
	 * @param string 原始头部字符串
	 * @return array 转换后的头部
	 */
	private function _parseHearders($headers) {
		$headers = preg_split("/(\r|\n)+/", $headers, -1, \PREG_SPLIT_NO_EMPTY);
		$parse_headers = array();
		$count = count($headers);
		for ($i = 1; $i < $count; $i++) {
			//匹配到cookie时，不放入头部，直接填充入cookie数组
			if(preg_match('/set-cookie:[\s]+([^=]+)=([^;]+)/i', $headers[$i],$match)) {
				$this->resp_cookies[$match[1]] = $match[2];
				continue;
			}

			//先在headers[$i]中找':'，找到了再对其进行explode，避免出现notice级别的警告
			if (false!=strpos($headers[$i], ':')) {
				list($key, $raw_value) = explode(':', $headers[$i], 2);
				$key = trim($key);
				$value = trim($raw_value);
				if (array_key_exists($key, $parse_headers)) {
					$parse_headers[$key] .= ',' . $value;
				} else {
					$parse_headers[$key] = $value;
				}
			}
		}
		return $parse_headers;
	}

	/**
	 * @function 格式化cookie为字符串形式
	 * @param string/array cookie
	 * @example 'cookiename1=cookievalue1;cookiename2=cookievalue2'
	 * @example array('cookiename1'=>'cookievalue1','cookiename2'=>'cookievalue2')
	 *
	 * @return string cookie字符串形式
	 * @example 'cookiename1=cookievalue1;cookiename2=cookievalue2'
	 */
	public static function _formatCookie($cookies) {
		$cookie_string = '';
		if (is_array($cookies)) {
			$tempArr = array();
			foreach($cookies as $key => $value) {
				$tempArr[] = $key.'='.$value;
			}
			$cookie_string = implode(';', $tempArr);
		}
		else {
			$cookie_string = (string)$cookies;
		}
		return $cookie_string;
	}

	/**
	 * @function 释放资源，重置变量
	 * @param void
	 * @return void
	 */
	public function clear() {
		$this->proxy = array();
		$this->referer = '';
		$this->user_agent = '';
		$this->timeout = 0;
		$this->req_headers = array();
		$this->follow_redirects = false;
		$this->max_redirects = 5;
		$this->req_cookies = array();
		$this->resp_cookies = array();
		$this->status = '';
		$this->raw_headers = '';
		$this->resp_headers = array();
		$this->content = '';
	}
}