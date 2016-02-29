<?php

namespace Addons\SceneQrcode;
use Common\Controller\Addon;

/**
 * 二维码管理插件
 * @author 艾逗笔
 */

    class SceneQrcodeAddon extends Addon{

        public $info = array(
            'name'=>'SceneQrcode',
            'title'=>'二维码管理',
            'description'=>'设置不同的场景生成对应的二维码，用于营销推广、用户绑定、数据统计等场景。',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'0.1',
            'has_adminlist'=>1
        );

	public function install() {
		$install_sql = './Addons/SceneQrcode/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/SceneQrcode/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }