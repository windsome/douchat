<?php
// +----------------------------------------------------------------------
// | OneThink [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2013 http://www.onethink.cn All rights reserved.
// +----------------------------------------------------------------------
// | Author: 麦当苗儿 <zuojiazi@vip.qq.com> <http://www.zjzit.cn>
// +----------------------------------------------------------------------

namespace Apis\Controller;
use Think\Controller;

/**
 * 前台公共控制器
 * 为防止多分组Controller名称冲突，公共Controller名称统一使用分组名称
 */
class DeviceController extends Controller {
	protected $post = null;    
	public function __construct() {
    }

	public function index(){
	}
    
	public function get_bind_device () {
        $param ['openid'] = I ('openid');        
        $param ['access_token'] = I ('access_token');
        $url = 'https://api.weixin.qq.com/device/get_bind_device?' . http_build_query ( $param );
  		
        $content = file_get_contents ( $url );
		$content = json_decode ( $content, true );
        $devices = $content ['device_list'];
        $Model = M('wxdevice_devices');
        
        $arr = array();
        $data ['openid'] = I ('openid');
        foreach ( $devices as $device ) {
            $cond1['deviceid'] = $device ['device_id'];
            $exist_device = $Model->where($cond1)->find();
            if ($exist_device != null) {
                //$device ['mac'] = $exist_device ['mac'];
                //$device ['uid'] = $exist_device ['uuid'];
                //var_dump ($device);
                $arr[] = $exist_device;
            }
		}
        
        $content ['device_list'] = $arr;
        //var_dump ($content);
        $this->ajaxReturn($content);
    }

	public function accesstoken () {
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);

        $user_token = $post['user_token'];
        $user_name = $post['user_name'];
        
        $access_token = get_access_token($user_token);

        $data['token'] = $user_token;
        $data['name'] = $user_name;
        $data['access_token'] = $access_token;

        $this->ajaxReturn($data);        
	}

    //https://api.weixin.qq.com/device/authorize_device?access_token=
	public function register () {
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        
        $device_type = $post['device_type'];
        $device_uuid = $post['device_uuid'];
        $device_mac  = $post['device_mac'];
        $product_id  = $post['product_id'];        
        
        /*
        $device_type = 'gh_9e62dd855eff';
        $device_uuid = '123123123123';
        $device_mac  = '112233445566';
        $product_id  = '1550';        
        */

        $access_token = get_access_token($device_type);
        $data['access_token'] = $access_token;

        $Model = M('wxdevice_devices');
        $cond1['productid'] = $product_id;
        $cond1['uuid'] = $device_uuid;
        $exist_device = $Model->where($cond1)->find();
        if ($exist_device == null) {
            error_log("\nwindsome ". __METHOD__. ", no device", 3, PHP_LOG_PATH);
            $cond['productid'] = $product_id;
            $cond['uuid'] = '';
            $new_device = $Model->where($cond)->find();
            //var_dump ($Model);            
            
            $cond['id'] = $new_device['id'];
            $Model->uuid = $device_uuid;
            $Model->mac = $device_mac;
            $Model->where($cond)->save();
            
            unset ($cond);
            $cond['uuid'] = $device_uuid;
            $new_device = $Model->where($cond)->find();
            $data['device_id'] = $new_device['deviceid'];            
            $data['device_qrcode'] = $new_device['qrcode'];
            //var_dump ($new_device);            
        } else {
            error_log("\nwindsome ". __METHOD__. ", get device", 3, PHP_LOG_PATH);
            $data['device_id'] = $exist_device['deviceid'];
            $data['device_qrcode'] = $exist_device['qrcode'];
            //var_dump ($exist_device);     
        }

        $this->ajaxReturn($data);        
	}

	public function get_device_list ( $openid = '') {
        
    }

	/* 空操作，用于输出404页面 */
	public function _empty(){
		$this->redirect('Index/index');
	}
	//初始化操作
	function _initialize() {
		
	}

	/* 用户登录检测 */
	protected function login(){
		/* 用户登录检测 */
		is_login() || $this->error('您还没有登录，请先登录！', U('User/login'));
	}

}
