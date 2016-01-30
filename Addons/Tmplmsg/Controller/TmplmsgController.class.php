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
}
