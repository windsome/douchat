<?php

namespace Addons\YouaskService;
use Common\Controller\Addon;

/**
 * 你问我答客服系统插件
 * @author 陌路生人
 */

    class YouaskServiceAddon extends Addon{
        public $custom_config = 'config.html';
        public $info = array(
            'name'=>'YouaskService',
            'title'=>'多客服',
            'description'=>'微信多客服管理，智能化控制',
            'status'=>1,
            'author'=>'梦醒',
            'version'=>'0.1',
            'has_adminlist'=>1,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/YouaskService/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/YouaskService/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }