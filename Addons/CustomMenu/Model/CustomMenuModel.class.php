<?php

namespace Addons\CustomMenu\Model;
use Think\Model;

/**
 * CustomMenu模型
 */
class CustomMenuModel extends Model{

    // 获取进行中的活动
    function getListData($addon,$model,$stime_col='',$etime_col='',$token_col='',$state_col='',$state_val=1) {
        if ($token_col){
            $map [$token_col] = get_token ();
        }
        if ($stime_col){
            $map[$stime_col]=array('elt',NOW_TIME);
        }
        if ($etime_col){
            $map[$etime_col]=array('gt',NOW_TIME);
        }
        if ($state_col){
            $map[$state_col]=$state_val;
        }
        $data_list = D("Addons://$addon/$model")->where ( $map )->field ( 'id,title' )->order ( 'id desc' )->select ();
        return $data_list;
    }

    function curlGet($url, $method = 'get', $data = '')
    {       
        $ch = curl_init();
        $headers = array('Accept-Charset: utf-8');
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, strtoupper($method));
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (compatible;MSIE 5.01;Windows NT 5.0)');
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $temp = curl_exec($ch);
        curl_close ( $ch );
        return $temp;
    }

    
}
