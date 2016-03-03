<?php
        	
namespace Addons\SceneQrcode\Model;
use Home\Model\WeixinModel;
        	
/**
 * SceneQrcode的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'SceneQrcode' ); // 获取后台插件的配置参数	
		//dump($config);
	}

	// 扫码统计
	public function scan($data){
		//replyText('Ticket:' . getRevTicket() . "\n" . 'Scene_id:' . getRevSceneId());
		$scene_qrcode = M('scene_qrcode')->where(array('token'=>get_token(),'ticket'=>getRevTicket()))->find();
		$data['token'] = get_token();
		$data['openid'] = get_openid();
		$data['qrcode_id'] = $scene_qrcode['id'];
		$data['scene_name'] = $scene_qrcode['scene_name'];
		$data['keyword'] = $scene_qrcode['keyword'];
		$data['scene_id'] = getRevSceneId();
		$data['scan_type'] = 'scan';
		$data['ctime'] = $data['CreateTime'];
		$res = M('scene_qrcode_statistics')->add($data);

		if ($res) {
			
			$map['title'] = $scene_qrcode['keyword'];
			$map['name'] = $scene_qrcode['scene_str'];
			$map['_logic'] = 'or';

			$where['_complex'] = $map; 
			$where['status'] = 1;

			$addonInfo = M('addons')->where($map)->find();

			// 调用插件的关键词回复
			if ($addonInfo) {
				require_once ONETHINK_ADDON_PATH . $addonInfo['name'] . '/Model/WeixinAddonModel.class.php';
				$model = D ( 'Addons://' . $addonInfo['name'] . '/WeixinAddon' );
				! method_exists ( $model, 'reply' ) || $model->reply ( $data, $keywordArr );
			} 

			// 调用自定义回复插件的回复规则
			$map_r['keyword'] = $scene_qrcode['keyword'];
			$map_r['token'] = get_token();
			$info = M('auto_reply')->where($map_r)->find();
			// replyText(json_encode($info));

			if (!$info) {
				//$this->replyText("根据你发送的语音识别到的关键词是：".$keyword."，系统没有匹配到对应的回复内容，请重新发送");
			} else {
				if ($info ['msg_type'] == 'news') {
					// replyText(json_encode($info));
					$map_news ['group_id'] = $info ['group_id'];
					$list = M ( 'material_news' )->where ( $map_news )->select ();
					
					$param ['publicid'] = get_token_appinfo ( '', 'id' );
					
					foreach ( $list as $k => $vo ) {
						if ($k > 8)
							continue;
						
						$articles [] = array (
								'Title' => $vo ['title'],
								'Description' => $vo ['intro'],
								'PicUrl' => get_cover_url ( $vo ['cover_id'] ),
								'Url' => $this->_getNewsUrl ( $vo, $param ) 
						);
					}
					
					
					$res = $this->replyNews ( $articles );
				} elseif ($info ['msg_type'] == 'image') {
					$this->replyText ( 'image' );
				} else {
					$contetn = replace_url ( htmlspecialchars_decode ( $info ['content'] ) );
					$this->replyText ( $contetn );
				}
			}
		}
	}

	// 未关注扫码统计
	public function subscribe($data) {
		$scene_qrcode = M('scene_qrcode')->where(array('token'=>get_token(),'ticket'=>getRevTicket()))->find();
		$data['token'] = get_token();
		$data['openid'] = get_openid();
		$data['qrcode_id'] = $scene_qrcode['id'];
		$data['scene_name'] = $scene_qrcode['scene_name'];
		$data['keyword'] = $scene_qrcode['keyword'];
		$data['scene_id'] = getRevSceneId();
		$data['scan_type'] = 'subscribe';
		$data['ctime'] = $data['CreateTime'];
		$res = M('scene_qrcode_statistics')->add($data);

		if ($res) {
			
			$map['title'] = $scene_qrcode['keyword'];
			$map['name'] = $scene_qrcode['scene_str'];
			$map['_logic'] = 'or';

			$where['_complex'] = $map; 
			$where['status'] = 1;

			$addonInfo = M('addons')->where($map)->find();

			// 调用插件的关键词回复
			if ($addonInfo) {
				require_once ONETHINK_ADDON_PATH . $addonInfo['name'] . '/Model/WeixinAddonModel.class.php';
				$model = D ( 'Addons://' . $addonInfo['name'] . '/WeixinAddon' );
				! method_exists ( $model, 'reply' ) || $model->reply ( $data, $keywordArr );
			} 

			// 调用自定义回复插件的回复规则
			$map_r['keyword'] = $scene_qrcode['keyword'];
			$map_r['token'] = get_token();
			$info = M('auto_reply')->where($map_r)->find();
			// replyText(json_encode($info));

			if (!$info) {
				//$this->replyText("根据你发送的语音识别到的关键词是：".$keyword."，系统没有匹配到对应的回复内容，请重新发送");
			} else {
				if ($info ['msg_type'] == 'news') {
					// replyText(json_encode($info));
					$map_news ['group_id'] = $info ['group_id'];
					$list = M ( 'material_news' )->where ( $map_news )->select ();
					
					$param ['publicid'] = get_token_appinfo ( '', 'id' );
					
					foreach ( $list as $k => $vo ) {
						if ($k > 8)
							continue;
						
						$articles [] = array (
								'Title' => $vo ['title'],
								'Description' => $vo ['intro'],
								'PicUrl' => get_cover_url ( $vo ['cover_id'] ),
								'Url' => $this->_getNewsUrl ( $vo, $param ) 
						);
					}
					
					
					$res = $this->replyNews ( $articles );
				} elseif ($info ['msg_type'] == 'image') {
					$this->replyText ( 'image' );
				} else {
					$contetn = replace_url ( htmlspecialchars_decode ( $info ['content'] ) );
					$this->replyText ( $contetn );
				}
			}
		}
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

}
        	