<?php

namespace Addons\Tmplmsg;
use Common\Controller\Addon;

/**
 * 模板消息插件
 * @author 艾逗笔
 */

    class TmplmsgAddon extends Addon{

        public $info = array(
            'name'=>'Tmplmsg',
            'title'=>'模板消息',
            'description'=>'通用的模板消息发送插件',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'1.0',
            'has_adminlist'=>1,
            'type'=>1         
        );

	public function install() {
		$install_sql = './Addons/Tmplmsg/install.sql';
		if (file_exists ( $install_sql )) {
			execute_sql_file ( $install_sql );
		}
		return true;
	}
	public function uninstall() {
		$uninstall_sql = './Addons/Tmplmsg/uninstall.sql';
		if (file_exists ( $uninstall_sql )) {
			execute_sql_file ( $uninstall_sql );
		}
		return true;
	}

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }