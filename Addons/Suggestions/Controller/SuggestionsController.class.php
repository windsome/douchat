<?php

namespace Addons\Suggestions\Controller;

use Home\Controller\AddonsController;

class SuggestionsController extends AddonsController {

	function _initialize(){
		parent::_initialize();
		
		$controller = strtolower(_CONTROLLER);
		$action = strtolower(_ACTION);

		$res ['title'] = '插件配置';
		$res ['url'] = addons_url ( 'Suggestions://Suggestions/config' );
		$res ['class'] = $controller == 'suggestions' && $action == 'config' ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '用户反馈';
		$res ['url'] = addons_url ( 'Suggestions://Suggestions/lists' );
		$res ['class'] = $controller == 'suggestions' && $action == 'lists' ? 'current' : '';
		$nav [] = $res;

		$this->assign('nav',$nav);
	}

	function config() {
		$normal_tips = '在微信里回复“意见反馈”即可以查看效果，也可点击:<a target="_blank" href="' . U ( 'preview' ) . '">预览</a>,<a id="copyLink" data-clipboard-text="' . U ( 'suggest',array('token'=>get_token())) . '">复制链接</a><script type="application/javascript">$.WeiPHP.initCopyBtn("copyLink");</script>';
		$this->assign ( 'normal_tips', $normal_tips );
		parent::config();
	}

	function lists() {
		// 获取模型信息
		$model = $this->getModel ();
		
		$map ['token'] = get_token ();
		session ( 'common_condition', $map );
		
		// 获取模型列表数据
		$list_data = $this->_get_model_list ( $model );
		
		// 获取相关的用户信息
		$uids = getSubByKey ( $list_data ['list_data'], 'uid' );
		$uids = array_filter ( $uids );
		$uids = array_unique ( $uids );
		if (! empty ( $uids )) {
			$map ['id'] = array (
					'in',
					$uids 
			);
			$members = M ( 'follow' )->where ( $map )->field ( 'id,nickname,mobile' )->select ();
			foreach ( $members as $m ) {
				$user [$m ['id']] = $m;
			}
			
			foreach ( $list_data ['list_data'] as &$vo ) {
				empty ( $vo ['mobile'] ) || $vo ['mobile'] = $user [$vo ['uid']] ['mobile'];
				empty ( $vo ['nickname'] ) || $vo ['nickname'] = $user [$vo ['uid']] ['nickname'];
			}
		}
		
		$this->assign ( $list_data );
		$this->assign ( 'add_url', U ( 'suggest' ) );
		
		$this->display ( $model ['template_list'] );
	}

	public function suggest() {

		$config = getAddonConfig('Suggestions');
		
		if (IS_AJAX) {
			// 保存用户信息
			$nickname = I ( 'nickname' );
			if ($config ['need_nickname'] && ! empty ( $nickname )) {
				$data ['nickname'] = $nickname;
			}
			$mobile = I ( 'mobile' );
			if ($config ['need_mobile'] && ! empty ( $mobile )) {
				$data ['mobile'] = $mobile;
			}
			
			// 保存内容
			$data ['cTime'] = time ();
			$data ['content'] = I ( 'content' );
			$data ['token'] = get_token ();
			
			$res = M ( 'suggestions' )->add ( $data );
			if ($res) {
				// 增加积分
				add_credit ( 'suggestions' );
				$data['status'] = 1;
				$data['info']='反馈成功，感谢您的支持~';
				//$this->success ( '增加成功，谢谢您的反馈' );

				$openid = getOpenidByUid($config['admin_id']);
				$kf_data['touser'] = $openid;
				$kf_data['msgtype'] = 'text';
				$kf_data['text']['content'] = "新的反馈内容：" . $data['content'];
				//replyText(json_encode($kf_data));
				sendCustomMessage($kf_data);
			} else{
				$data['status'] = 0;
				$data['info']='反馈失败，请重新提交反馈内容~';
				//$this->error ( '增加失败，请稍后再试' );
			}

			$this->ajaxReturn($data);
				
		} else {

			
			$this->assign ( $config );
			// dump ( $config );
			
			$user = getUserInfo ( get_mid() );
			$this->assign ( 'user', $user );

		
			$this->display ();
		}
	}

	/* 预览 */
	function preview(){
		
	    $url = addons_url('Suggestions://Suggestions/suggest',array('token'=>get_token()));
	    parent::common_preview($url);

	}
}
