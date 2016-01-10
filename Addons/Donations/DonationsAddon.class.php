<?php

namespace Addons\Donations;
use Common\Controller\Addon;

/**
 * 捐款插件
 * @author 洛杉矶豪哥
 */

    class DonationsAddon extends Addon{

        public $info = array(
            'name'=>'Donations',
            'title'=>'微捐赠',
            'description'=>'在线捐赠功能，用户可以在微信端捐赠',
            'status'=>1,
            'author'=>'洛杉矶豪哥',
            'version'=>'1.0',
            'has_adminlist'=>0,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/Donations/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Donations/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }