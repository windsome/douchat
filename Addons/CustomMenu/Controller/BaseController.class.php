<?php

namespace Addons\CustomMenu\Controller;

use Home\Controller\AddonsController;

class BaseController extends AddonsController{	

	function _initialize(){
		parent::_initialize();
		
		//$controller = strtolower ( _CONTROLLER );		
		$action = strtolower ( _ACTION );
		$res ['title'] = '菜单管理';
		$res ['url'] = addons_url ( 'CustomMenu://CustomMenuType/menu_lists' , array('type'=>0));
		$res ['class'] = $action == 'menu_lists'? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '微信端个性菜单管理';
		$res ['url'] = addons_url (  'CustomMenu://CustomMenuType/menu_now_lists');
		$res ['class'] = $action == 'menu_now_lists'? 'current' : '';
		$nav [] = $res;	

		$res ['title'] = '默认菜单';
		$res ['url'] = addons_url ( 'CustomMenu://CustomMenu/lists' );
		$res ['class'] = $action == 'lists'? 'current' : '';
		$nav [] = $res;
		
		$res ['title'] = '个性菜单';
		$res ['url'] = addons_url ( 'CustomMenu://CustomMenu/special_lists' );
		$res ['class'] = $action == 'special_lists'? 'current' : '';
		$nav [] = $res;

		$this->assign('nav',$nav);

	}


}
