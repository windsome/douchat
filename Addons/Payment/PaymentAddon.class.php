<?php

namespace Addons\Payment;
use Common\Controller\Addon;

/**
 * 支付设置插件
 * @author 艾逗笔
 */

    class PaymentAddon extends Addon{

        public $info = array(
            'name'=>'Payment',
            'title'=>'支付设置',
            'description'=>'微信支付,财富通,支付宝',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>1,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/Payment/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Payment/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }