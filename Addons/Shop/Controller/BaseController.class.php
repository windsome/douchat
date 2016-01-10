<?php

namespace Addons\Shop\Controller;

use Home\Controller\AddonsController;

class BaseController extends AddonsController {
	var $shop_id;
	function _initialize() {
		parent::_initialize ();
		// 获取当前登录的用户的商城
		$map ['token'] = get_token ();
		$map ['manamger_id'] = $this->mid;
		$this->shop_id = 0;
		
		$currentShopInfo = M ( 'shop' )->where ( $map )->find ();
		if ($currentShopInfo) {
			$this->shop_id = $currentShopInfo ['id'];
		} elseif (_ACTION != 'summary' && _ACTION != 'add') {
			redirect ( addons_url ( 'Shop://Shop/summary' ) );
		}
		
		$controller = strtolower ( _CONTROLLER );
		
		// $res ['title'] = '商店管理';
		// $res ['url'] = addons_url ( 'Shop://Shop/lists' );
		// $res ['class'] = ($controller == 'shop' && _ACTION == "lists") ? 'current' : '';
		// $nav [] = $res;

		$res ['title'] = '店铺汇总';
		$res ['url'] = addons_url ( 'Shop://Shop/summary' );
		$res ['class'] = ($controller == 'shop' && _ACTION == "summary") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '基本信息';
		$res ['url'] = addons_url ( 'Shop://Shop/edit' );
		$res ['class'] = ($controller == 'shop' && _ACTION == "edit") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '幻灯片';
		$res ['url'] = addons_url ( 'Shop://Slideshow/lists' );
		$res ['class'] = ($controller == 'slideshow' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '商品分组';
		$res ['url'] = addons_url ( 'Shop://Category/lists' );
		$res ['class'] = ($controller == 'category' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '商品管理';
		$res ['url'] = addons_url ( 'Shop://Goods/lists' );
		$res ['class'] = ($controller == 'goods' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '订单管理';
		$res ['url'] = addons_url ( 'Shop://Order/lists' );
		$res ['class'] = ($controller == 'order' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '模板管理';
		$res ['url'] = addons_url ( 'Shop://Template/lists' );
		$res ['class'] = ($controller == 'template' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;

		$res ['title'] = '支付配置';
		$res ['url'] = addons_url ( 'Payment://Payment/lists' );
		$res ['class'] = ($controller == 'payment' && _ACTION == "lists") ? 'current' : '';
		$nav [] = $res;
		
		//$nav = array ();
		$this->assign ( 'nav', $nav );
		
		define ( 'CUSTOM_TEMPLATE_PATH', ONETHINK_ADDON_PATH . 'Shop/View/default/Wap/Template' );
	}
}
