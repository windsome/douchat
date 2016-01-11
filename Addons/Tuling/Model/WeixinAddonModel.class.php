<?php

namespace Addons\Tuling\Model;

use Home\Model\WeixinModel;

class WeixinAddonModel extends WeixinModel {
	var $config = array ();
	function reply($dataArr, $keywordArr = array()) {
		$this->config = getAddonConfig ( 'Tuling' ); // 获取后台插件的配置参数
		
		$content = $this -> turingAPI($dataArr['Content']);
		if ($content) {
			exit ();
		}		
		
		// 最后只能随机回复了
		if (empty ( $content )) {
			$content = $this -> _rand ();
		}
		
		// 增加积分,每隔5分钟才加一次，5分钟内只记一次积分
		add_credit ( 'chat', 300 );
		
		$res = $this -> replyText($content);
		return $res;
	}
	
	// 随机回复
	private function _rand() {
		$this->config ['rand_reply'] = array_map ( 'trim', explode ( "\n", $this->config ['rand_reply'] ) );
		$key = array_rand ( $this->config ['rand_reply'] );
		
		return $this->config ['rand_reply'] [$key];
	}
	
	// 图灵机器人
	private function turingAPI($keyword) {
		$api_url = $this->config ['tuling_url'] . "?key=" . $this->config ['tuling_key'] . "&info=" . $keyword;
		
		$result = file_get_contents ( $api_url );
		$result = json_decode ( $result, true );
		if ($_GET ['format'] == 'test') {
			dump ( '图灵机器人结果：' );
			dump ( $result );
		}
		if ($result ['code']>40000 && $result['code']<40008) {
			if ($result ['code'] < 40008 && ! empty ( $result ['text'] )) {
				$this->replyText ( '图灵机器人请你注意：' . $result ['text'] );
			} else {
				return false;
			}
		}
		switch ($result ['code']) {
			case '100000' :
				$this -> replyText($result['text']);
				break;
			case '200000' :
				$text = $result ['text'] . ',<a href="' . $result ['url'] . '">点击进入</a>';
				$this->replyText ( $text );
				break;
			case '301000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['author'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '302000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['article'],
							'Description' => $info ['source'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '304000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['count'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '305000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['start'] . '--' . $info ['terminal'],
							'Description' => $info ['starttime'] . '--' . $info ['endtime'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '306000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['flight'] . '--' . $info ['route'],
							'Description' => $info ['starttime'] . '--' . $info ['endtime'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '307000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '308000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '309000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'] . ' 满意度 : ' . $info ['satisfaction'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '310000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['number'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '311000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '312000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			default :
				if (empty ( $result ['text'] )) {
					return false;
				} else {
					$this->replyText ( $result ['text'] );
				}
		}
		return true;
	}

	// 语音智能识别
	public function voice($data) {
		$keyword = substr($data['Recognition'],0,strlen($data['Recognition'])-3); 
		$this->config = getAddonConfig ( 'Tuling' ); // 获取后台插件的配置参数
		
		$content = $this -> turingAPI($keyword);
		if ($content) {
			exit ();
		}		
		
		// 最后只能随机回复了
		if (empty ( $content )) {
			$content = $this -> _rand ();
		}
		
		// 增加积分,每隔5分钟才加一次，5分钟内只记一次积分
		add_credit ( 'chat', 300 );
		
		$res = $this -> replyText($content);
		return $res;
	}
}
