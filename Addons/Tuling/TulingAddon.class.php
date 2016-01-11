<?php

namespace Addons\Tuling;
use Common\Controller\Addon;

/**
 * 图灵机器人
 * @author 艾逗笔
 */

    class TulingAddon extends Addon{

        public $info = array(
            'name'=>'Tuling',
            'title'=>'图灵机器人',
            'description'=>'使用图灵机器人接口实现微信端智能聊天，支持语音识别',
            'status'=>1,
            'author'=>'艾逗笔',
            'version'=>'2.0'
        );

        public $admin_list = array(
            'model'=>'Example',		//要查的表
			'fields'=>'*',			//要查的字段
			'map'=>'',				//查询条件, 如果需要可以再插件类的构造方法里动态重置这个属性
			'order'=>'id desc',		//排序,
			'listKey'=>array( 		//这里定义的是除了id序号外的表格里字段显示的表头名
				'字段名'=>'表头显示名'
			),
        );

        public function install(){
            return true;
        }

        public function uninstall(){
            return true;
        }

        //实现的weixin钩子方法
        public function weixin($param){

        }

    }