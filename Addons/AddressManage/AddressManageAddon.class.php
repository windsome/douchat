<?php

namespace Addons\AddressManage;
use Common\Controller\Addon;

/**
 * 地址管理插件
 * @author 艾逗笔
 */

    class AddressManageAddon extends Addon{

        public $info = array(
            'name'=>'AddressManage',
            'title'=>'地址管理',
            'description'=>'通用地址管理插件',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>1,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/AddressManage/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/AddressManage/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }