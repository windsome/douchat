<?php

namespace Common\Model;

use Think\Model;

/**
 * 插件配置操作集成
 */
class CustomMenuTypeModel extends Model {
	protected $tableName = 'custom_menu_type';
	/**
	 * 获取菜单详细列表信息
	 */
	function get_menu_info($id) {
		$map ['token'] = get_token ();
		$map ['id'] = $id;
		if (empty ( $map ['token'] )) {
			return false;
		}

        $info = $this->where($map)->find();
		return $info;
	}

	/**
	 * 判断是否存在菜单
	 */
	function is_have_menu($type) {
		$map ['token'] = get_token ();
		$map ['type'] = $type;
		if (empty ( $map ['token'] )) {
			return false;
		}
        $result = $this->where($map)->select();
		if ($result) {
			return 1;
		}else{
			return 0;
		}
	}

	/**
	 * 获取使用中的默认菜单
	 */
	function get_now_menu() {
		$map ['token'] = get_token ();
		$map ['type'] = 0;
		$map ['show'] = 1;
		if (empty ( $map ['token'] )) {
			return false;
		}
        $id = $this->where($map)->getField('id');
		return $id;
	}

	/**
	 * 获取微信分组信息
	 */
	function get_group_lists(){
	    //用户分组列表
		$map ['token'] = get_token ();
		$map ['manager_id'] = $this->mid;
		$auth_group = M ( 'auth_group' )->where ( $gmap )->select ();
		
		return $auth_group;
	}

	/**
	 * 更新菜单信息
	 */
	function update_menu($data,$id) {
		$map ['token'] = get_token ();
		$map ['id'] = $id;
		if (empty ( $map ['token'] )) {
			return false;
		}

        $result = $this->where($map)->save($data);
		return $result;
	}

	/**
	 * 获取个性菜单已发布列表,或者最新发布菜单的ID
	 */
	function get_menu_show($type){
	    //用户分组列表
		$map ['token'] = get_token ();
		$map ['type'] = 1;
		$field = 'title,id,show';
		//返回列表
		if ($type == 1) {
		   $menulists = $this->field($field)->order(array( 'show' => 'desc' , 'cTime' => 'desc'))->where ( $map )->select ();
		   return $menulists;
		}
		//返回最新ID
		if ($type == 2) {
		   $menu_id = $this->field($field)->order('cTime desc')->limit(1)->where ( $map )->find ();
		   return $menu_id['id'];
		}
	}

	/**
	 * 菜单发布成功后的数据处理
	 */
	function set_menu_status($type,$id,$menuid=null){
	    //用户分组列表
		$map ['token'] = get_token ();

        $data ['cTime'] = NOW_TIME;
        $data ['show'] = 1;
		//更新默认菜单数据状态
		if ($type == 1) {
		   $map ['type'] = 0;
           $map ['show'] = 1;
           $datab ['show'] = 0;
           $datab ['cTime'] = '';
		   $result = $this->where($map)->save($datab);

		   $mapb ['id'] = $id;
		   $data ['show'] = 1;
		   $result = $this->where($mapb)->save($data);

		   return $result;
		}
		//更新个性菜单数据状态
		if ($type == 2) {
		   $map ['id'] = $id;
		   $map ['type'] = 1;
		   $data ['menuid'] = $menuid;
		   $result = $this->where($map)->save($data);

           return $result;
		}
	}

 	/**
	 * 组装个性菜单，匹配条件数组
	 */
	function set_menu_matchrule($id){
	    //用户分组列表
		$map ['token'] = get_token ();
		$map ['id'] = $id;
		$field = 'group_id,sex,country,province,city,client_platform_type';
		$matchrule = $this->field($field)->where ( $map )->find ();
        
		return $matchrule;
	}

 	/**
	 * 删除微信端菜单之后，对本地数据处理
	 */
	function set_menu_local($type,$id){
	    //用户分组列表
		$map ['token'] = get_token ();
		$data ['cTime'] = '';
		$data ['show'] = 0;
		//删除默认菜单，则删除所有个性菜单
        if ($type == 1) {
        	$map ['show'] = 1;
        	$result = $this->where($map)->save($data);
        	return $result;
        }
        //删除个性菜单
        if ($type == 2) {
		    $map ['menuid'] = $id;
        	$result = $this->where($map)->save($data);
        	return $result;
        }
		
	}
    //数组转换
	function json_encode_cn($data) {
		$data = json_encode ( $data );
		return preg_replace ( "/\\\u([0-9a-f]{4})/ie", "iconv('UCS-2BE', 'UTF-8', pack('H*', '$1'));", $data );
	}

 	/**
	 * 判断如果是已经发布的菜单，重新编辑发布的话，先删除微信端以前发布过的菜单
	 */
	function del_wweixinmenu_now($id){
	    //用户分组列表
		$map ['token'] = get_token ();
		$map ['show'] = 1;
		$map ['id'] = $id;

        $result = $this->where($map)->getField('menuid');

        if ($result) {
        	
		    $id = $result;
		    $menuid = array();
		    $menuid['menuid'] = $id;
            $menuid = json_encode_cn($menuid);
            //dump($menuid);die();
		    $access_token = get_access_token ();		
		    
		    $url_post = 'https://api.weixin.qq.com/cgi-bin/menu/delconditional?access_token=' . $access_token;
		    //$header [] = "content-type: application/x-www-form-urlencoded; charset=UTF-8";

            $res = D ( 'CustomMenu' )->curlGet($url_post, $method = 'post', $data = $menuid);

        }
	}   







}