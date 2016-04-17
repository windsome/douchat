<?php
// +----------------------------------------------------------------------
// | OneThink [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2013 http://www.onethink.cn All rights reserved.
// +----------------------------------------------------------------------
// | Author: 麦当苗儿 <zuojiazi@vip.qq.com> <http://www.zjzit.cn>
// +----------------------------------------------------------------------

namespace Home\Controller;
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
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", url:".$url.",\ncontent=".$content, 3, PHP_LOG_PATH);
		$content = json_decode ( $content, true );
        $devices = $content ['device_list'];
        $Model = M('wxdevice_devices');
        
        $arr = array();
        $data ['openid'] = I ('openid');
        foreach ( $devices as $device ) {
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", device=".json_encode($device), 3, PHP_LOG_PATH);
            $cond1['deviceid'] = $device ['device_id'];
            $exist_device = $Model->where($cond1)->find();
            if ($exist_device != null) {
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", exist_device=".json_encode($exist_device), 3, PHP_LOG_PATH);
                //$device ['mac'] = $exist_device ['mac'];
                //$device ['uid'] = $exist_device ['uuid'];
                //var_dump ($device);
                $arr[] = $exist_device;
            }
		}
        
        $content ['response'] = 'sucess';
        $content ['device_list'] = $arr;
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", device_list:".json_encode($content), 3, PHP_LOG_PATH);
        
        //var_dump ($content);
        $this->ajaxReturn($content, 'json');
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

	public function bindToUser () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        $openid = get_openid ();
        $access_token = get_access_token ();
        //error_log("\nwindsome ".__METHOD__." ".__LINE__.", openid:".$openid.",access_token=".$access_token, 3, PHP_LOG_PATH);

        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        
        $device_qrcode = $post['qrcode'];
        $device_info['name'] = $post['name'];
        $device_info['latitude'] = $post['latitude'];
        $device_info['longitude'] = $post['longitude'];
        $device_ticket = $post ['ticket'];

        //$openid = $post ['openid'];
        //$access_token = $post ['access_token'];

        $Model = M('wxdevice_devices');
        $cond1['qrcode'] = $device_qrcode;
        $exist_device = $Model->where($cond1)->find();
        if ($exist_device != null) {
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", find device:".print_r($exist_device,true), 3, PHP_LOG_PATH);

            $cond['id'] = $exist_device['id'];
            $Model->openid=$openid;
            //$Model->uuid='123123123';
            //$Model->mac='112233445566';
            $Model->info=json_encode($device_info);
            //error_log("\nwindsome ".__METHOD__." ".__LINE__.", Model:".print_r($Model,true), 3, PHP_LOG_PATH);
            $Model->where($cond)->save();

            // post to weixin.
            $url = "https://api.weixin.qq.com/device/bind?access_token=".$access_token;
            $postOb['ticket'] = $device_ticket;
            $postOb['device_id'] = $exist_device['deviceid'];
            $postOb['openid'] = $openid;
            //error_log("\nwindsome ". __METHOD__." ".__LINE__.", url=".$url.", postOb=".json_encode($postOb), 3, PHP_LOG_PATH);
            list($retcode, $content) = $this->http_post_json ($url, json_encode($postOb));
            
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", url=".$url.", postOb=".json_encode($postOb).", \nretcode=".$retcode.",content=".$content, 3, PHP_LOG_PATH);
            
            $content = json_decode ( $content, true );

            $result['errcode'] = 0;
            $result['msg'] = 'no error';
        } else {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", no such qrcode", 3, PHP_LOG_PATH);
            $result['errcode'] = 10001;
            $result['msg'] = 'no such qrcode in wxdevice_devices';
        }

        $this->ajaxReturn($result);        
	}

	public function getDeviceByQrcode () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        //$openid = get_openid ();
        //error_log("\nwindsome ". __METHOD__." ".__LINE__.", openid=".$openid, 3, PHP_LOG_PATH);

        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        
        $device_qrcode = $post['qrcode'];

        $Model = M('wxdevice_devices');
        $cond1['qrcode'] = $device_qrcode;
        $exist_device = $Model->where($cond1)->find();
        if ($exist_device != null) {
            $result['devices'] = array($exist_device);
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", find device:".print_r($exist_device,true), 3, PHP_LOG_PATH);
            $result['errcode'] = 0;
            $result['msg'] = 'no error';
        } else {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", no such qrcode", 3, PHP_LOG_PATH);
            $result['errcode'] = 10001;
            $result['msg'] = 'no such qrcode in wxdevice_devices';
        }

        $this->ajaxReturn($result);
	}

	public function get_bind_device_1 ($openid = '', $access_token = '') {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        if ($openid == '')
            $openid = get_openid ();
        if ($access_token == '')
            $access_token = get_access_token ();
        //error_log("\nwindsome ".__METHOD__." ".__LINE__.", openid:".$openid.",access_token=".$access_token, 3, PHP_LOG_PATH);

        $param ['openid'] = $openid;        
        $param ['access_token'] = $access_token;
        $url = 'https://api.weixin.qq.com/device/get_bind_device?' . http_build_query ( $param );
  		
        $content = file_get_contents ( $url );
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", url:".$url.",\ncontent=".$content, 3, PHP_LOG_PATH);
		$content = json_decode ( $content, true );
        $devices = $content ['device_list'];
        return $devices;
    }

	public function get_device_list () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        $openid = get_openid ();
        if ($openid == '-1' || $openid == '-2' || $openid == '')
            $openid = "ornMov9SNy74EZxq-UL5ZPTXQrhc"; //I('openid');
        $access_token = get_access_token ();
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", openid:".$openid.",access_token=".$access_token, 3, PHP_LOG_PATH);

        $devices = $this->get_bind_device_1 ($openid, $access_token); 

        $Model = M('wxdevice_devices');
        
        $arr = array();
        foreach ( $devices as $device ) {
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", device=".json_encode($device), 3, PHP_LOG_PATH);
            $cond1['deviceid'] = $device ['device_id'];
            //$cond1['type'] = $device ['type'];
            $exist_device = $Model->where($cond1)->find();
            // check device type, return device tree.
            if ($exist_device != null) {
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", exist_device=".json_encode($exist_device), 3, PHP_LOG_PATH);
                //$device ['mac'] = $exist_device ['mac'];
                //$device ['uid'] = $exist_device ['uuid'];
                //var_dump ($device);
                $arr[] = $exist_device;
            }
		}
        
        $content ['response'] = 'success';
        $content ['device_list'] = $arr;
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", device_list:".json_encode($content), 3, PHP_LOG_PATH);
        
        //var_dump ($content);
        $this->ajaxReturn($content, 'json');
    }

	public function datax () {
        /*
          {"deviceid":"12345678901234567890123456789032", "sensors":[{"subid":"1","type":"temp","val":21.0},{"subid":"2","type":"humi","val":24.0},{"subid":"3","type":"co2","val":23224.0},{"subid":"4","type":"lm","val":11224.0}]}
         */
        $post = wp_file_get_contents ( 'php://input' );        
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", post:".$post, 3, PHP_LOG_PATH);
        //$post1 = '{"deviceid":"12345678901234567890123456789032", "sensors":[{"subid":"1","type":"temp","val":21.0},{"subid":"2","type":"humi","val":24.0},{"subid":"3","type":"co2","val":23224.0},{"subid":"4","type":"lm","val":11224.0}]}';
        $post = json_decode ($post, true);
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", post after decode:".json_encode($post), 3, PHP_LOG_PATH);
        
        $Model = M('wxdevice_datax');

        $count = 0;
        $deviceid = $post['deviceid'];
        $sensors = $post['sensors'];
        foreach ($sensors as $sensor) {
            //$subid = $sensor['subid'];
            //$type = $sensor['type'];
            //$val = $sensor['val'];
            $data = $sensor;
            $data['deviceid'] = $deviceid;
            $data['time']=time();
            $data = $Model->create($data);
            if ($data) {
                $Model->add();
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", create:".json_encode($data), 3, PHP_LOG_PATH);
                $count++;
            }
        }

        $content ['response'] = 'success';
        $content ['datax_count'] = $count;
        $this->ajaxReturn($content);
	}

	public function getDataxHistory () {
        /*
          params: 
          $deviceid: device's id.
          $begintime: data's begin time.
          $endtime: data's end time.
          {"deviceid":"12345678901234567890123456789032", "sensors":[{"subid":"1","type":"temp","data":[[1460707899000,20.33],[1460707945000,21.0]]},{"subid":"2","type":"humi","data":[[1460707899000,20.33],[1460707945000,21.0]]},{"subid":"3","type":"co2","data":[[1460707899000,20.33],[1460707945000,21.0]]},{"subid":"4","type":"lm","data":[[1460707899000,20.33],[1460707945000,21.0]]}]}
         */
        $deviceid = I ('deviceid', '');        
        $begintime = I ('begintime', -1);
        $endtime = I ('endtime', -1);
        $current_time = time();

        if ($deviceid == '' || $begintime < 0) {
            $content ['response'] = 'fail';
            $content ['msg'] = 'parameter error! deviceid and begintime should not null! deviceid='.$deviceid.',begintime='.$begintime;
            $this->ajaxReturn($content);
            return;
        }
        if ($endtime >= 0 && (($endtime-$begintime)>60*60*24*366)) {
            $content ['response'] = 'fail';
            $content ['msg'] = 'parameter error! time should not across one year! begintime='.$begintime.',endtime='.$endtime;
            $this->ajaxReturn($content);
            return;
        }
        if ($endtime < 0 && (($current_time-$begintime)>60*60*24*366)) {
            $content ['response'] = 'fail';
            $content ['msg'] = 'parameter error! time should not across one year! begintime='.$begintime.',current_time='.$current_time;
            $this->ajaxReturn($content);
            return;
        }

        $condition['deviceid'] = $deviceid;
        $condition['time'] = array('gt',$begintime);
        if ($endtime > 0) {
            $condition['time'] = array('lt',$endtime);
        }

        $sensors = array();
        $Model = M('wxdevice_datax');
        //$total = $Model->where($condition)->order(array('subid','time'=>'asc'))->count();
        $datas = $Model->where($condition)->order(array('subid','time'=>'asc'))->select();
        if ($datas) {
            $sensor = null;
            foreach ($datas as $data) {
                if ($sensor == null || $data['subid'] != $sensor['subid']) {
                    if ($sensor != null)
                        $sensors[] = $sensor;
                    $sensor =  array();
                    $sensor['subid'] = $data['subid'];
                    $sensor['type'] = $data['type'];
                    $sensor['name'] = $data['type'].$data['subid'];
                    $sensor['data'] = array();
                }
                $sensor['data'][] = array($data['time']*1000, $data['val']);
            }
            if ($sensor != null)
                $sensors[] = $sensor;
        }

        $content['deviceid'] = $deviceid;
        $content['sensors'] = $sensors;

        $content ['response'] = 'success';
        $content ['datax_count'] = count($datas);
        $this->ajaxReturn($content);
	}

	public function getDataxLatest () {
        /*
          params: 
          $deviceid: device's id.
          $begintime: data's begin time.
          {"deviceid":"12345678901234567890123456789032", "sensors":[{"subid":"1","type":"temp","data":[[1460707899000,20.33]]},{"subid":"2","type":"humi","data":[[1460707899000,20.33]]},{"subid":"3","type":"co2","data":[[1460707899000,20.33]]},{"subid":"4","type":"lm","data":[[1460707899000,20.33]]}]}
         */
        $deviceid = I ('deviceid', '');        
        $begintime = I ('begintime', -1);
        $current_time = time();

        if ($deviceid == '') {
            $content ['response'] = 'fail';
            $content ['msg'] = 'parameter error! deviceid should not null! deviceid='.$deviceid;
            $this->ajaxReturn($content);
            return;
        }

        $sensors = array();

        $condition['deviceid'] = $deviceid;
        if ($begintime >= 0) {
            $condition['time'] = array('gt',$begintime);
        }

        $Model = M('wxdevice_datax');
        $sensor_subids = $Model->distinct(true)->field('subid')->where($condition)->select();
        if ($sensor_subids) {
            foreach ($sensor_subids as $subid) {
                $condition['subid'] = $subid['subid'];
                $data = $Model->where($condition)->order(array('time'=>'desc'))->find();
                if ($data) {
                    $sensor =  array();
                    $sensor['subid'] = $data['subid'];
                    $sensor['type'] = $data['type'];
                    $sensor['name'] = $data['type'].$data['subid'];
                    $sensor['data'] = array();
                    $sensor['data'][] = array($data['time']*1000, $data['val']);
                    $sensors[] = $sensor;
                }
            }
        }

        $content['deviceid'] = $deviceid;
        $content['sensors'] = $sensors;

        $content ['response'] = 'success';
        $content ['datax_count'] = count($sensors);
        $this->ajaxReturn($content);
	}

    function http_post_json($url, $jsonStr) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonStr);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                        'Content-Type: application/json; charset=utf-8',
                        'Content-Length: ' . strlen($jsonStr)
                        )
            );
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        return array($httpCode, $response);
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