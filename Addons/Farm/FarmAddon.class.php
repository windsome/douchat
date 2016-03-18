<?php

namespace Addons\Farm;
use Common\Controller\Addon;

/**
 * 中农物联插件
 * @author 无名
 */

    class FarmAddon extends Addon{

        public $info = array(
            'name'=>'Farm',
            'title'=>'中农物联',
            'description'=>'中农物联农场平台',
            'status'=>1,
            'author'=>'无名',
            'version'=>'0.1',
            'has_adminlist'=>0
        );

	public function install() {
		$install_sql = './Addons/Farm/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Farm/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }