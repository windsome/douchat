<?php

namespace Addons\Example;
use Common\Controller\Addon;

/**
 * 功能演示插件
 * @author 艾逗笔
 */

    class ExampleAddon extends Addon{

        public $info = array(
            'name'=>'Example',
            'title'=>'功能演示',
            'description'=>'对豆信框架的功能进行演示',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>0
        );

	public function install() {
		$install_sql = './Addons/Example/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Example/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }