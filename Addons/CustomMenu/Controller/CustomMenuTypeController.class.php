<?php

namespace Addons\CustomMenu\Controller;

use Addons\CustomMenu\Controller\BaseController;

class CustomMenuTypeController extends BaseController {
	var $model_name = 'custom_menu_type';
	function _initialize() {
		parent::_initialize();					
	}

	function json_encode_cn($data) {
		$data = json_encode ( $data );
		return preg_replace ( "/\\\u([0-9a-f]{4})/ie", "iconv('UCS-2BE', 'UTF-8', pack('H*', '$1'));", $data );
	}

	public function menu_now_lists() {
		$normal_tips = '微信端菜单管理<br/>
		   注意:<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;1、点击删除微信端所有菜单按钮，将会删除微信端默认菜单和所有个性化菜单。<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;2、点击个性菜单对应删除按钮，则会删除相应微信端个性化菜单。<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;3、从微信端删除菜单后，会更新本地数据库菜单信息状态，如果本地不存在则会报：数据更新失败。';		

		$this->assign ( 'normal_tips', $normal_tips );

		$access_token = get_access_token ();
			
		$url_post = 'https://api.weixin.qq.com/cgi-bin/menu/get?access_token=' . $access_token;
		//$header [] = "content-type: application/x-www-form-urlencoded; charset=UTF-8";
     
        $res = D ( 'CustomMenu' )->curlGet($url_post);
		$res = json_decode ( $res, true );
		if ($res ['errcode'] == 0) {
            $menu_lists[] = array();
            $res = $res['conditionalmenu'];
            foreach($res as $aitem){
              $menu_lists[] = $aitem['menuid'];
            }
            unset($menu_lists[0]);
            //dump($menu_lists  );
            $this->assign('menu_lists',$menu_lists);

		} elseif ($res ['errcode'] == 46003) {
			exit();
		} else{
			$this->error ( error_msg ( $res ) );
		}

		$this->display();

	}

    //删除个性化菜单
	public function del_special_menu() {
		$id = $_GET['id'];
		$menuid = array();
		$menuid['menuid'] = $id;
        $menuid = json_encode_cn($menuid);
        //dump($menuid);die();
		$access_token = get_access_token ();		
		
		$url_post = 'https://api.weixin.qq.com/cgi-bin/menu/delconditional?access_token=' . $access_token;
		//$header [] = "content-type: application/x-www-form-urlencoded; charset=UTF-8";
     
        $res = D ( 'CustomMenu' )->curlGet($url_post, $method = 'post', $data = $menuid);
		$res = json_decode ( $res, true );
		if ($res ['errcode'] == 0) {
			 $result = D ( 'CustomMenuType' )->set_menu_local(2,$id);
             if ($result) {
             	$this->success ( '菜单删除成功,数据更新成功！' );
             }else{
             	$this->error ( '菜单删除成功,数据更新失败！' );
             }	 

		} else {
			$this->error ( error_msg ( $res ) );
		}

	}

    //删除所有菜单
	public function del_menu() {
        //dump($menuid);die();
		$access_token = get_access_token ();		
		
		$url_post = 'https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=' . $access_token;
		//$header [] = "content-type: application/x-www-form-urlencoded; charset=UTF-8";
     
        $res = D ( 'CustomMenu' )->curlGet($url_post);
		$res = json_decode ( $res, true );
		if ($res ['errcode'] == 0) {
			 $result = D ( 'CustomMenuType' )->set_menu_local(1,$id=null);
             if ($result) {
             	$this->success ( '全部菜单删除成功,数据更新成功！' );
             }else{
             	$this->error ( '全部菜单删除成功,数据更新失败！' );
             }
			 

		} else {
			$this->error ( error_msg ( $res ) );
		}

	}
    //菜单管理页面
	public function menu_lists($page = 0) {
		// 子导航
		$action = strtolower ( _ACTION );
		$controller = strtolower ( _CONTROLLER );
		
		$res ['title'] = '默认菜单';
		$res ['url'] = addons_url (  'CustomMenu://CustomMenuType/menu_lists' , array('type'=>0) );
		$nav [] = $res;	

		$res ['title'] = '个性菜单';
		$res ['url'] = addons_url (  'CustomMenu://CustomMenuType/menu_lists' , array('type'=>1)  );
		$nav [] = $res;							
				
		$this->assign ( 'sub_nav', $nav );

		$type = I ( 'type' );
		// 使用提示		
		if ($type == 1) {
		   $normal_tips = '发布个性菜单。<br/>
		   注意:<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;1、可以同时发布多个个性化菜单，匹配规则是从最新发布的菜单开始往后匹配。<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;2、直接打开"个性菜单"，显示的是最新已发布的个性菜单和已发布个性菜单列表,否则不存在的话跳转至菜单管理页面。<br/>';	
		}
		if ($type == 0) {
		   $normal_tips = '发布默认菜单。<br/>
		   注意:<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;1、没发布任何菜单时，打开默认菜单，直接跳转到菜单管理页面。否则显示当前使用中菜单。<br/>
		   &nbsp;&nbsp;&nbsp;&nbsp;2、每次只能发布一个默认菜单，发布当前的菜单会替换掉之前发布的。<br/>';		
		}
		$this->assign ( 'normal_tips', $normal_tips );

		if (IS_POST) {
			$data['token'] = get_token ();
			$data['title'] = $_POST['title'];
			$data['sex'] = $_POST['sex'];
			$data['group_id'] = $_POST['group_id'];

            empty($_POST['title']) && $this->error ( '菜单标题不能为空' );

			$province = $_POST['province'];
			$city = $_POST['city'];
		
			if ($province == '省份') {
				$data['province'] = '';
			}else{
				$data['province'] = $province;
			}
			if ($city == '城市') {
				$data['city'] = '';
			}else{
				$data['city'] = $city;
			}
			$data['show'] = 0;
			$data['type'] = $_POST['type'];
            $data['country'] = $_POST['country'];
			$data['client_platform_type'] = $_POST['client_platform_type'];
            
            if ($type == 1) {
               empty($data['sex']) &&  empty($data['group_id']) &&  
               empty($data['country']) &&  empty($data['province']) && 
               empty($data['city']) &&  empty($data['client_platform_type']) &&$this->error ( '匹配条件不能全部为空！' );
            }
			$result =  M ( 'custom_menu_type' )->add($data);
            if ($result) {
            	$this->success ( '菜单添加成功！' );
            }else{
            	$this->error ( '菜单添加失败！' );
            }
            
		}

		$page = I ( 'p', 1, 'intval' ); // 默认显示第一页数据

		$map ['token'] = get_token ();
		//筛选个性菜单
		$map ['type'] = $type ;
		$title = I ( 'title' );
		if (! empty ( $title )) {
			$map ['title'] = array (
					'like',
					"%$title%" 
			);
		}
		$row = '10';

		$list_data = M ( 'custom_menu_type' )->where ( $map )->order (array( 'show' => 'desc' , 'cTime' => 'desc') )->page ( $page, $row )->select ();		

		/* 查询记录总数 */
		$count = M ( 'custom_menu_type' )->where ( $map )->count();
		
		// 分页
		if ($count > $row) {
			$page = new \Think\Page ( $count, $row );
			$page->setConfig ( 'theme', '%FIRST% %UP_PAGE% %LINK_PAGE% %DOWN_PAGE% %END% %HEADER%' );
			$list['_page'] = $page->show ();
		}
		
        $auth_group = D ( 'CustomMenuType' )->get_group_lists ();
		$this->assign('auth_group',$auth_group);
		$this->type = $type;
		$this->assign ( $list  );
        $this->assign ('lists', $list_data  );
        $this->display ();
	}
    //删除本地数据
	public function del() {
		$ids = I ( 'id', 0 );
		if (empty ( $ids )) {
			$ids = array_unique ( ( array ) I ( 'ids', 0 ) );
		}
		if (empty ( $ids )) {
			$this->error ( '请选择要操作的数据!' );
		}
		
		$custom_menu_type = M ('custom_menu_type');
		$map = array (
				'id' => array (
						'in',
						$ids 
				) 
		);

		$custom_menu = M ('custom_menu');
		$mapa = array (
				'menu_id' => array (
						'in',
						$ids 
				) 
		);

		$map ['token'] = get_token ();
		$map['show'] = 0;
		$mapa ['token'] = get_token ();
        
        $result = $custom_menu_type->where ( $map )->delete ();
		if ($result) {
		    $custom_menu->where ( $mapa )->delete ();
		    $this->success ( '删除成功' );
		} else {
			$this->error ( '已发布菜单不能删除！请确保所删除菜单【未被发布使用中】！' );
		}
	}
   



}