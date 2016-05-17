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
            list($retcode, $content) = $this->_http_post_json ($url, json_encode($postOb));
            
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

	public function bindToUser2 () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);

        $device = $post['device'];
        $device_ticket = $post['ticket'];

        $openid = get_openid();
        $access_token = get_access_token();

        $retcode = 0;
        if ($device == null) {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! device=".$device, 3, PHP_LOG_PATH);
            $retcode = -1;
        } else if ($openid == '-1' || $openid == '-2' || $openid == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! openid=".$openid, 3, PHP_LOG_PATH);
            $retcode = -2;
        } else if ($device_ticket == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! device_ticket=".$device_ticket, 3, PHP_LOG_PATH);
            $retcode = -3;
        } else if ($access_token == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! access_token=".$access_token, 3, PHP_LOG_PATH);
            $retcode = -4;
        }

        if ($retcode == 0) {
            // post to weixin.
            $url = "https://api.weixin.qq.com/device/bind?access_token=".$access_token;
            $postOb['ticket'] = $device_ticket;
            $postOb['device_id'] = $device['deviceid'];
            $postOb['openid'] = $openid;
            $retcode = $this->_wx_post_json ($url, json_encode($postOb));
            if ($retcode == 0) {
                // bind user success! then save device info to database.
                $device['info'] = json_encode($device['info']);
                $Model = M('wxdevice_devices');
                $count = $Model->save ($device);
                $cond1['id']=$device['id'];
                //$count = $Model->where($cond1)->save ($device);
                //$count = $Model->where($cond1)->data($device)->save();
                if ($count) {
                    error_log("\nwindsome ". __METHOD__." ".__LINE__.", success! update ".$count." records", 3, PHP_LOG_PATH);
                } else {
                    error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! update device fail!", 3, PHP_LOG_PATH);
                    $retcode = 1000;
                }
            } else {
                error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! bind device to user fail!", 3, PHP_LOG_PATH);
            }
        }

        $result['errcode'] = $retcode;
        $this->ajaxReturn($result);        
	}

	public function unbindToUser2 () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);

        $device = $post['device'];
        $device_ticket = $post['ticket'];

        $openid = get_openid();
        $access_token = get_access_token();

        $retcode = 0;
        if ($device == null) {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! device=".$device, 3, PHP_LOG_PATH);
            $retcode = -1;
        } else if ($openid == '-1' || $openid == '-2' || $openid == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! openid=".$openid, 3, PHP_LOG_PATH);
            $retcode = -2;
        } else if ($device_ticket == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! device_ticket=".$device_ticket, 3, PHP_LOG_PATH);
            $retcode = -3;
        } else if ($access_token == '') {
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! access_token=".$access_token, 3, PHP_LOG_PATH);
            $retcode = -4;
        }

        if ($retcode == 0) {
            // post to weixin.
            $url = "https://api.weixin.qq.com/device/unbind?access_token=".$access_token;
            $postOb['ticket'] = $device_ticket;
            $postOb['device_id'] = $device['deviceid'];
            $postOb['openid'] = $openid;
            $retcode = $this->_wx_post_json ($url, json_encode($postOb));
            if ($retcode == 0) {
                // unbind user success! then save device info to database.
                /*
                $device['info'] = json_encode($device['info']);
                $Model = M('wxdevice_devices');
                $count = $Model->save ($device);
                $cond1['id']=$device['id'];
                if ($count) {
                    error_log("\nwindsome ". __METHOD__." ".__LINE__.", success! update ".$count." records", 3, PHP_LOG_PATH);
                } else {
                    error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! update device fail!", 3, PHP_LOG_PATH);
                    $retcode = 1000;
                }
                */
            } else {
                error_log("\nwindsome ". __METHOD__." ".__LINE__.", error! bind device to user fail!", 3, PHP_LOG_PATH);
            }
        }

        $result['errcode'] = $retcode;
        $this->ajaxReturn($result);        
	}

	public function getDeviceByQrcode () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        //$openid = get_openid ();
        error_log("\nwindsome ". __METHOD__." ".__LINE__, 3, PHP_LOG_PATH);

        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        
        $device_qrcode = $post['qrcode'];

        $Model = M('wxdevice_devices');
        $cond1['qrcode'] = $device_qrcode;
        $exist_device = $Model->where($cond1)->find();
        if ($exist_device != null) {
            /*error_log("\nwindsome ". __METHOD__." ".__LINE__." size=".sizeof($exist_device), 3, PHP_LOG_PATH);
            $count=sizeof($exist_device);
            for ($i = 0; $i < $count; $i++) {
                error_log("\nwindsome ". __METHOD__." ".__LINE__." $i=".$i." ".print_r($exist_device[$i],true), 3, PHP_LOG_PATH);
                $exist_device[$i]['info'] = json_decode($exist_device[$i]['info']);
                }*/
            $exist_device['info'] = json_decode($exist_device['info'],true);
            
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

	public function get_device_list () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        $retcode = 0;

        $openid = get_openid ();
        if ($openid == '-1' || $openid == '-2' || $openid == '')
            $openid = "ornMov9SNy74EZxq-UL5ZPTXQrhc"; //I('openid');
        $access_token = get_access_token ();
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", openid:".$openid.",access_token=".$access_token, 3, PHP_LOG_PATH);

        $param ['openid'] = $openid;
        $param ['access_token'] = $access_token;
        $url = 'https://api.weixin.qq.com/device/get_bind_device?' . http_build_query ( $param );
        $content = file_get_contents ( $url );
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", url:".$url.",\ncontent=".$content, 3, PHP_LOG_PATH);
		$content = json_decode ( $content, true );
        if ($content['errcode']) $retcode = (int)$content['errcode'];
        if ($retcode == 0) {
            $resp_msg = $content ['resp_msg'];
            if ($resp_msg) {
                $retcode = (int) $resp_msg['ret_code'];
                if ($retcode != 0) {
                    $retdata ['retcode'] = $retcode;
                    $retdata ['response_str'] = $resp_msg['error_info'];
                }
            }
        } else {
            $retdata ['retcode'] = $retcode;
            $retdata ['response_str'] = $content['errmsg'];
        }
        if ($retcode == 0) {
            $devices = $content ['device_list'];

            $Model = M('wxdevice_devices');
            $arr = array();
            foreach ( $devices as $device ) {
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", try to find device=".json_encode($device), 3, PHP_LOG_PATH);
                $cond1['deviceid'] = $device ['device_id'];
                //$original_id = $device ['device_type']; //gh_9e62dd855eff
                $exist_device = $Model->where($cond1)->find();
                // check device type, return device tree.
                if ($exist_device) {
                    //error_log("\nwindsome ".__METHOD__." ".__LINE__.", ok! find device=".json_encode($exist_device), 3, PHP_LOG_PATH);
                    $exist_device['info'] = json_decode ($exist_device['info'], true);
                    $arr[] = $exist_device;
                } else if ($exist_device == null) {
                    // no device.
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", warning! not find device: ".json_encode($device), 3, PHP_LOG_PATH);
                } else {
                    // false. sql query fail.
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", error! sql fail!  ".json_encode($device), 3, PHP_LOG_PATH);
                }
            }
        
            $retdata ['response'] = 'success';
            $retdata ['device_list'] = $arr;
        } else {
            $retdata ['response'] = 'fail';
        }
        
        //var_dump ($retdata);
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", device_list:".json_encode($retdata), 3, PHP_LOG_PATH);
        $this->ajaxReturn($retdata, 'json');
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
            $data['time']=NOW_TIME;
            $data = $Model->create($data);
            if ($data) {
                $Model->add();
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", create:".json_encode($data), 3, PHP_LOG_PATH);
                $count++;
            }
        }

        $Model2 = M('wxdevice_cmd');
        $cond1['deviceid']=$deviceid;
        $cond1['_string'] = 'pTime is null OR pTime=""';
        $exist = $Model2->where($cond1)->find();
        if ($exist) {
            $content = json_decode($exist['cmd']);
            //error_log("\nwindsome ".__METHOD__." ".__LINE__.", content=".print_r($content,true), 3, PHP_LOG_PATH);

            //$content = json_encode($content,JSON_UNESCAPED_SLASHES);
            $exist['pTime'] = NOW_TIME;
            $cond2['id'] = $exist['id'];
            $ret2 = $Model2->where($cond2)->save($exist);
            if ($ret2 === false) {
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql updated fail!", 3, PHP_LOG_PATH);
            } else if ($ret2 == 0) {
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", warning: sql updated none record! should not go here!", 3, PHP_LOG_PATH);
            }
        } else {
            $content ['response'] = 'success';
            $content ['datax_count'] = $count;
        }
        $content2 = stripslashes(json_encode($content));
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", content2=".$content2, 3, PHP_LOG_PATH);
        //$this->ajaxReturn($content, 'JSON', JSON_UNESCAPED_SLASHES);
        exit ($content2);
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
        $begintime = (int) I ('begintime', -1);
        $endtime = (int) I ('endtime', time());

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

        $condition['deviceid'] = $deviceid;
        //$condition['time'] = array('gt',$begintime);
        //$condition['time'] = array('lt',$endtime);
        $condition['time'] = array(array('gt',$begintime),array('lt',$endtime));

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
                $sensor['data'][] = array((int)$data['time'], (double)$data['val']);
                //$sensor['data'][] = array($data['time']*1000, $data['val']);
            }
            if ($sensor != null)
                $sensors[] = $sensor;
        }

        $content['deviceid'] = $deviceid;
        $content['sensors'] = $sensors;
        $content['begintime'] = $begintime;
        $content['endtime'] = $endtime;

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
        $begintime = (int)I ('begintime', -1);

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
                    //$sensor['data'][] = array($data['time']*1000, $data['val']);
                    $sensor['data'][] = array((int)$data['time'], (double)$data['val']);
                    $sensors[] = $sensor;
                }
            }
        }

        $content['deviceid'] = $deviceid;
        $content['sensors'] = $sensors;
        $content['begintime'] = $begintime;
        $content['endtime'] = time();

        $content ['response'] = 'success';
        $content ['datax_count'] = count($sensors);
        $this->ajaxReturn($content);
	}

	public function getDataxLatestList () {
        /*
          params: 
          $deviceid: device's id.
          $begintime: data's begin time.
          {"deviceid":"12345678901234567890123456789032", "sensors":[{"subid":"1","type":"temp","data":[[1460707899000,20.33]]},{"subid":"2","type":"humi","data":[[1460707899000,20.33]]},{"subid":"3","type":"co2","data":[[1460707899000,20.33]]},{"subid":"4","type":"lm","data":[[1460707899000,20.33]]}]}

          sql: select a.* from dc_wxdevice_datax a, (SELECT *,max(time) as mtime FROM `dc_wxdevice_datax` where time>1460690690 group by deviceid,subid) b where a.time=b.time and a.deviceid=b.deviceid and a.subid=b.subid;
         */
        $deviceid = I ('deviceid', '');
        if($begintime = (int)I ('begintime', -1) == -1) {
            $begintime = (int)I('get.begintime', -1);
        }
        $endtime = (int) I ('endtime', time());

        $post = wp_file_get_contents ( 'php://input' );        
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", post:".$post.",db_PREFIX=".C('__WXDEVICE_DEVICES__'), 3, PHP_LOG_PATH);
        $post = json_decode ($post, true);

        $cond = array();
        if ($begintime >= 0) {
            $cond[] = '(time>'.$begintime.')';
        }
        if ($endtime >= 0) {
            $cond[] = '(time<'.$endtime.')';
        }

        if ($deviceid != '') {
            $cond[] = "(deviceid=\'".$deviceid."\')";
        } else {
            if ($post && $post['devices'] && count($post['devices']) > 0) {
                $devices = "'".implode("','",$post['devices'])."'";
                $cond[] = "deviceid in (".$devices.")";
            }
        }

        $cond1 = implode(" and ", $cond);
        $str = "select a.* from __PREFIX__wxdevice_datax a, (SELECT *,max(time) as mtime FROM __PREFIX__wxdevice_datax where ".$cond1." group by deviceid,subid) b where a.time=b.mtime and a.deviceid=b.deviceid and a.subid=b.subid";
        $str = "select a.* from dc_wxdevice_datax a, (SELECT *,max(time) as mtime FROM dc_wxdevice_datax where ".$cond1." group by deviceid,subid) b where a.time=b.mtime and a.deviceid=b.deviceid and a.subid=b.subid";
        error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql: ".$str, 3, PHP_LOG_PATH);
        $Model = new \Think\Model(); // 实例化一个model对象 没有对应任何数据表
        $datax = $Model->query($str);
        if ($datax) {
            $content['datax'] = $datax;
            $content['begintime'] = $begintime;
            $content['endtime'] = $endtime;
            $content ['response'] = 'success';
            $content ['datax_count'] = count($datax);
        } else if ($datax == null){
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", get no record", 3, PHP_LOG_PATH);
            $content['datax'] = array();
            $content['begintime'] = $begintime;
            $content['endtime'] = $endtime;
            $content ['response'] = 'success';
            $content ['datax_count'] = 0;
        } else {
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", get datax fail", 3, PHP_LOG_PATH);
            $content ['response'] = 'fail';
        }
        $this->ajaxReturn($content);
	}

	public function _wx_post_json ($url, $body) {
        // post to weixin.
        list($retcode, $content) = $this->_http_post_json ($url, $body);
        error_log("\nwindsome ". __METHOD__." ".__LINE__.", url=".$url.", body=".$body.", \nretcode=".$retcode.",content=".$content, 3, PHP_LOG_PATH);
        if ($retcode == '200') {
            // curl request ok.
            $content = json_decode ( $content, true );
            $base_resp = $content['base_resp'];
            return (int)$base_resp['errcode']; 
        } else {
            // curl request fail.
            return -1;
        }
	}

    function _http_post_json($url, $jsonStr) {
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

    public function firmwareUpload() {
        error_log("\nwindsome ". __METHOD__." ".__LINE__, 3, PHP_LOG_PATH);
        $result['errcode'] = 0;
        $result['msg'] = 'no error';

        $upload = new \Think\Upload();// 实例化上传类
        $upload->maxSize   = 10*1024*1024;// 设置附件上传大小
        $upload->exts      = array('bin', 'BIN', 'hex', 'jpg', 'JPG', 'png', 'PNG', 'txt', 'TXT', 'doc', 'DOC', 'PDF' );// 设置附件上传类型
        $upload->rootPath  = './Uploads/'; // 设置附件上传根目录
        $upload->savePath  = 'Firmware/'; // 设置附件上传（子）目录
        $upload->saveName = time().'_'.mt_rand();
        // 上传文件 
        $info = $upload->upload();
        if (!$info) {// 上传错误提示错误信息
            $result['errcode'] = 10003;
            $result['msg'] = 'upload firmware fail: '.$upload->getError();
            //$this->error ($upload->getError());
        } else {// 上传成功
            $Model = M('wxdevice_firmware');
            $count = 0;
            foreach($info as $file){
                $count++;
                $data['cTime'] = NOW_TIME;
                $data['filepath'] = $file['savepath'].$file['savename'];
                $data['desc'] = $file['name'];
                $data['manager_id'] = $this->mid;
                $Model->add ($data);
            }

            $result['errcode'] = 0;
            $result['msg'] = 'upload firmware ok';
            $result['firmware_count'] = $count;
            //$this->success('上传成功！');
        }
        error_log("\nwindsome ". __METHOD__." ".__LINE__.":".json_encode($result), 3, PHP_LOG_PATH);
        
        $this->ajaxReturn($result);
    }

    public function firmwareDelete() {
        error_log("\nwindsome ". __METHOD__." ".__LINE__, 3, PHP_LOG_PATH);
        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        $firmware_id = $post['id'];

        $Model = M('wxdevice_firmware');
        $cond1['id'] = $firmware_id;
        $data = $Model->where($cond1)->find();
        if ($data) {
            $path = SITE_PATH . '/Uploads/' . $data['filepath'];
            $db_ret = $Model->delete($firmware_id);
            $res = unlink($path);//删除文件

            if($db_ret && $res){
                $result['errcode'] = 0;
                $result['msg'] = 'delete firmware ok!';
                //$this->success('文件成功删除！！',U('Upload/fileList'));
            } else if ($db_ret) {
                $result['errcode'] = 10005;
                $result['msg'] = 'delete firmware database record ok, but delete file fail! id='. $firmware_id.', file='.$path;
                //$this->error('文件删除失败或者文件不存在！！',U('Upload/fileList'));
            } else {
                $result['errcode'] = 10006;
                $result['msg'] = 'delete firmware database record fail, but delete file ok! id='. $firmware_id.', file='.$path;
            }
        } else {
            $result['errcode'] = 10004;
            $result['msg'] = 'not find firmware which id = '.$firmware_id;
        }
        $this->ajaxReturn($result);
    }

	public function firmwareList () {
        // 是否判断用户权限？得到用户openid，具有权限后才进行后续操作。
        //$openid = get_openid ();
        error_log("\nwindsome ". __METHOD__." ".__LINE__.",SITE_PATH=".SITE_PATH.",SITE_URL=".SITE_URL.", __ROOT__=".__ROOT__.",APP_PATH=".APP_PATH, 3, PHP_LOG_PATH);

        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);
        
        $name = $post['name'];

        $Model = M('wxdevice_firmware');
        if ($name)
            $cond1['desc'] = array('like','%'.$name.'%');
        else
            $cond1['1'] = '1';

        $datas = $Model->where($cond1)->order(array('cTime'=>'desc'))->select();
        if ($datas) {
            $datas2 = array();
            foreach ($datas as $data) {
                if ($data) {
                    $data['filepath'] = SITE_URL.'/Uploads/'.$data['filepath'];
                    //$data['filepath'] = __ROOT__.'/Uploads/'.$data['filepath'];
                    $datas2[] = $data;
                }
            }

            $result['datas'] = $datas2;
            $result['errcode'] = 0;
            $result['msg'] = 'no error';
            error_log("\nwindsome ".__METHOD__." ".__LINE__.", find firmware list:".json_encode($datas2), 3, PHP_LOG_PATH);
        } else {
            $result['errcode'] = 10002;
            $result['msg'] = 'no firmware';
            error_log("\nwindsome ". __METHOD__." ".__LINE__.", no firmware in db.", 3, PHP_LOG_PATH);
        }

        $this->ajaxReturn($result);
	}

    public function updateCmd() {
        /************************
         * { devices:['deviceid1', 'deviceid2'], 
         *   cmds:{update:"http://www.what.net/file/path.bin", setuuid:'uuid'}}
         ************************/
        error_log("\nwindsome ". __METHOD__." ".__LINE__, 3, PHP_LOG_PATH);
        $result['errcode'] = 0;
        $result['msg'] = 'no error';
        $post = wp_file_get_contents ( 'php://input' );        
        $post = json_decode ($post, true);

        $devices = $post['devices'];
        $cmds = $post['cmds'];

        $Model = M('wxdevice_cmd');
        $failcount = 0;

        foreach ( $devices as $deviceid ) {
            $cond1['deviceid'] = $deviceid;
            //$cond1['pTime']  = array('exp',' is NULL');
            $cond1['_string'] = 'pTime is null OR pTime=""';
            $exist = $Model->where($cond1)->find();
            if ($exist) {
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", exist=".print_r($exist, true), 3, PHP_LOG_PATH);
                $db_cmd = json_decode($exist['cmd']);
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", tttt1: db_cmd=".print_r($db_cmd,true), 3, PHP_LOG_PATH);
                //$db_cmd2 = json_encode($db_cmd, JSON_UNESCAPED_SLASHES);
                //$db_cmd3 = json_encode($db_cmd);
                //$db_cmd4 = str_replace('\\/', '/', json_encode($db_cmd));
                //$db_cmd5 = stripslashes(json_encode($db_cmd));
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", tttt2: db_cmd2=".$db_cmd2, 3, PHP_LOG_PATH);
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", tttt3: db_cmd3=".$db_cmd3, 3, PHP_LOG_PATH);
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", tttt4: db_cmd4=".$db_cmd4, 3, PHP_LOG_PATH);
                //error_log("\nwindsome ".__METHOD__." ".__LINE__.", tttt5: db_cmd5=".$db_cmd5, 3, PHP_LOG_PATH);

                foreach($cmds as $k=>$v){ 
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", k=".$k.",v=".$v, 3, PHP_LOG_PATH);
                    //echo $k."=>".$v."<br />"; 
                    //$db_cmd[$k+""] = $v;
                    $db_cmd->{$k} = $v;
                }
                $exist['cmd'] = json_encode($db_cmd);
                $exist['cTime'] = NOW_TIME;
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", updated=".$exist['cmd'], 3, PHP_LOG_PATH);
                $cond2['id'] = $exist['id'];
                $ret2 = $Model->where($cond2)->save($exist);
                if ($ret2 === false) {
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql updated fail!", 3, PHP_LOG_PATH);
                    $failcount++;
                    //fail
                } else if ($ret2 == 0) {
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", warning: sql updated none record! should not reach here!", 3, PHP_LOG_PATH);
                    $failcount++;
                }
            } else if ($exist == null) {
                // null cmd.
                $exist['cTime'] = NOW_TIME;
                $exist['deviceid'] = $deviceid;
                $exist['cmd'] = json_encode($cmds);
                $exist = $Model->create($exist);
                if ($exist) {
                    $ret2 = $Model->add();
                    if (!$ret2) {
                        error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql add fail!", 3, PHP_LOG_PATH);
                        $failcount++;
                    }
                } else {
                    error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql create fail!", 3, PHP_LOG_PATH);
                }
            } else {
                error_log("\nwindsome ".__METHOD__." ".__LINE__.", sql query fail!", 3, PHP_LOG_PATH);
                // fail
                $failcount++;
            }
		}

        if ($failcount > 0) {
            $result['errcode'] = 10007;
            $result['msg'] = 'there are some error, please lookup error log.';
        }

        $this->ajaxReturn($result);
    }

}
