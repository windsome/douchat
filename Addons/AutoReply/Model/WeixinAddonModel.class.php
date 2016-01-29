<?php

namespace Addons\AutoReply\Model;

use Home\Model\WeixinModel;

/**
 * AutoReply的微信模型
 */
class WeixinAddonModel extends WeixinModel {
	function reply($dataArr, $keywordArr = array()) {
		$map ['id'] = $keywordArr ['aim_id'];
		
		$info = M ( 'auto_reply' )->where ( $map )->find ();
		$this->replyMsg($info);
	}
	function _getNewsUrl($info, $param) {
		if (! empty ( $info ['link'] )) {
			$url = replace_url ( $info ['link'] );
		} else {
			$param ['id'] = $info ['id'];
			$url = U ( 'Home/Material/news_detail', $param );
		}
		return $url;
	}

	// 关注时自动处理
	public function subscribe($data) {
		//初始化用户数据存入数据库
		$uid = D ( 'Common/Follow' )->init_follow ( $data ['FromUserName'] );
		D ( 'Common/Follow' )->set_subscribe ( $data ['FromUserName'], 1 );
		// 增加积分
		session ( 'mid', $uid );
			
		add_credit ( 'subscribe' );
        // 关注时自动回复  欢迎语
		$info = M('auto_reply')->where(array('token'=>get_token(),'reply_scene'=>0))->find();
		$this->replyMsg($info);
	}

	// 取消关注时的自动处理
	public function unsubscribe($data) {
		// 直接删除用户
		//$map1 ['openid'] = $data ['FromUserName'];
		//$map1 ['token'] = get_token ();
		//$map2 ['uid'] = D ( 'public_follow' )->where ( $map1 )->getField ( 'uid' );
		//M ( 'public_follow' )->where ( $map1 )->delete ();
		//M ( 'user' )->where ( $map2 )->delete ();
		//M ( 'credit_data' )->where ( $map2 )->delete ();
		//取消专注改变用户状态
		D ( 'Common/Follow' )->set_subscribe ( $data ['FromUserName'], 0 );
		session ( 'mid', null );
		// 积分处理
		add_credit ( 'unsubscribe' );
	}

	function replyMsg($info) {
		if ($info ['msg_type'] == 'news') {
			$map_news ['group_id'] = $info ['group_id'];
			$list = M ( 'material_news' )->where ( $map_news )->select ();
			
			$param ['publicid'] = get_token_appinfo ( '', 'id' );
			
			foreach ( $list as $k => $vo ) {
				if ($k > 8)
					continue;

				if ( empty($vo ['url']) ) {
					$url = $this->_getNewsUrl ( $vo, $param ) ;
				}else{
					$url = $vo ['url'];
				}

				$articles [] = array (
						'Title' => $vo ['title'],
						'Description' => $vo ['intro'],
						'PicUrl' => get_cover_url ( $vo ['cover_id'] ),
						'Url' => $url
				);
			}
			
			$res = $this->replyNews ( $articles );
		} elseif ($info ['msg_type'] == 'image') {
			if ($info['image_id']){
// 				$d['image_id']=url_img_html(get_cover_url($d['image_id']));
				$media_id=D ( 'Common/Custom' )->get_image_media_id($info['image_id']);
			}else if($info['image_material']){
				$map2 ['id'] = $info ['image_material'];
				$media_img = M ( 'material_image' )->where ( $map2 )->find ( );
				$media_id=$media_img['image_id'];
				if (!$media_id){
					$media_id=D ( 'Common/Custom' )->get_image_media_id($media_img['cover_id']);
				}
			}
			$this->replyImage ( $media_id);
		} else {
			$contetn = replace_url ( htmlspecialchars_decode ( $info ['content'] ) );
			$this->replyText ( $contetn );
		}
	}
}
        	