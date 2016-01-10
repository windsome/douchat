<?php

namespace Addons\Idioms;
use Common\Controller\Addon;

/**
 * 成语接龙插件
 * @author 艾逗笔
 */

    class IdiomsAddon extends Addon{

        public $info = array(
            'name'=>'Idioms',
            'title'=>'成语接龙',
            'description'=>'weiphp成语接龙插件，当用户在微信中回复“成语接龙”时开始成语接龙游戏',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>0,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/Idioms/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Idioms/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }