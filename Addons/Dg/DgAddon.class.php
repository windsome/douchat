<?php

namespace Addons\Dg;
use Common\Controller\Addon;

/**
 * 点歌插件
 * @author 艾逗笔
 */

    class DgAddon extends Addon{

        public $info = array(
            'name'=>'Dg',
            'title'=>'在线点歌',
            'description'=>'使用百度音乐api实现微信端在线点歌功能',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>0,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/Dg/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Dg/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }