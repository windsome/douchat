<?php

namespace Addons\HelloWorld\Controller;
use Home\Controller\AddonsController;

class HelloWorldController extends AddonsController{
	function _initialize() {
        define ( 'CUSTOM_TEMPLATE_PATH', ONETHINK_ADDON_PATH . 'HelloWorld/View/WAP/' );
	}

	// 首页
	function index1() {
		//add_credit ( 'wxdevice', 86400 );
        //$token = get_token ();
        //$this->assign ( 'token', $token );
        $this->display ( ONETHINK_ADDON_PATH . 'HelloWorld/View/WAP/mydevice/qm/page-d.html' );
    }

	function index() {
		//add_credit ( 'wxdevice', 86400 );
        //$token = get_token ();
        //$this->assign ( 'token', $token );
        $this->display ( ONETHINK_ADDON_PATH . 'HelloWorld/View/WAP/mydevice/qm/page-c.html' );
		
        /*
		if (file_exists ( ONETHINK_ADDON_PATH . 'WeiSite/View/default/pigcms/Index_' . $this->config ['template_index'] . '.html' )) {
			$this->pigcms_index ();
			$this->display ( ONETHINK_ADDON_PATH . 'WeiSite/View/default/pigcms/Index_' . $this->config ['template_index'] . '.html' );
		} else {
			$map ['token'] = get_token ();
			$map ['is_show'] = 1;
			$map ['pid'] = 0; // 获取一级分类
			                  
			// 幻灯片
			$slideshow = M ( 'weisite_slideshow' )->where ( $map )->order ( 'sort asc, id desc' )->select ();
			foreach ( $slideshow as &$vo ) {
				$vo ['img'] = get_cover_url ( $vo ['img'] );
			}
			$this->assign ( 'slideshow', $slideshow );
			// dump($slideshow);
			
			// 分类
			$category = M ( 'weisite_category' )->where ( $map )->order ( 'sort asc, id desc' )->select ();
			foreach ( $category as &$vo ) {
				$vo ['icon'] = get_cover_url ( $vo ['icon'] );
				empty ( $vo ['url'] ) && $vo ['url'] = addons_url ( 'WeiSite://WeiSite/lists', array (
						'cate_id' => $vo ['id'] 
				) );
			}
			$this->assign ( 'category', $category );
			
			$map2 ['token'] = $map ['token'];
			$public_info = get_token_appinfo ( $map2 ['token'] );
			$this->assign ( 'publicid', $public_info ['id'] );
			
			$this->assign ( 'manager_id', $this->mid );
			
			$this->_footer ();
			
			$this->display ( ONETHINK_ADDON_PATH . 'WeiSite/View/default/TemplateIndex/' . $this->config ['template_index'] . '/index.html' );
		}
        */
	}

	function list_device() {
        $pid = I('pid');

        $list_data = $this->_get_device_data ($pid);
		$this->assign ( $list_data );        
		$this->display ( 'devices' );
    }

    function add_device() {
        $cnt = 0;
        $pid = I('pid');
		$url = 'https://api.weixin.qq.com/device/getqrcode?access_token=' . get_access_token () . '&product_id=' . I ( 'pid' );
        do {
            $data = stripslashes (wp_file_get_contents ( $url ));
            $data = json_decode ( $data, true );
            if (!empty ($data ['deviceid']) && !empty ($data ['qrticket'])) {        
                $data1 ['productid'] = $pid;
                $data1 ['deviceid'] = $data ['deviceid'];
                $data1 ['qrcode'] = $data ['qrticket'];
        
                /// Add device_id % device_qrcode to wp_wxdevice_devices table
                $model = $this->getModel ( 'wxdevice_devices' );
                $Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );

                // 获取模型的字段信息
                $Model = $this->checkAttr ( $Model, $model ['id'] );
                $Model->create ($data1);
                $Model->add ();
                $cnt++;                
            }
        } while (!empty ($data ['deviceid']) && !empty ($data ['qrticket']));

        if ($cnt > 0) {
            $this->success ( '添加成功'.$cnt.'个设备！', U ( 'lists' ) );
        } else {
            $resp = $data ['base_resp'];
            $this->error ( 'No device was added! Resp: '. $resp ['errmsg']);
        }
    }

	function lists () {
		$list_data = $this->_get_product_data ();

        foreach ( $list_data ['list_data'] as &$d ) {
			$map2 ['id'] = $d ['qrimage_id'];
			$url = M ( 'picture' )->where ( $map2 )->getField ( 'path' );
			$d ['qrimage_id'] = url_img_html ( SITE_URL .$url );           
            $d ['product_number'] = $this->_get_device_number ($d ['productid']);
            $d ['product_bind'] = $this->_get_device_number ($d ['productid']);
            $d ['product_online'] = $this->_get_device_number ($d ['productid']);
		}
        
		//$model = $this->getModel ( 'wxdevice_products' );

		$this->assign ( $list_data );	
		$this->display ( 'lists' );
		//$this->display ();
	}
    
	function _get_product_data() {
		$model = $this->getModel ( 'wxdevice_products' );
		$token = get_token ();

		$page = I ( 'p', 1, 'intval' ); // 默认显示第一页数据
		                                
		// 解析列表规则
		$list_data = $this->_list_grid ( $model );
		
		// 搜索条件
		$map = $this->_search_map ( $model, $fields );
		$map ['token'] = $token;
		
		$row = empty ( $model ['list_row'] ) ? 20 : $model ['list_row'];
		
		// 读取模型数据列表		
		$name = parse_name ( get_table_name ( $model ['id'] ), true );
		$data = M ( $name )->field ( true )->where ( $map )->order ( $order )->page ( $page, $row )->select ();
		
		/* 查询记录总数 */
		$count = M ( $name )->where ( $map )->count ();
		
		$list_data ['list_data'] = $data;
		
		// 分页
		if ($count > $row) {
			$page = new \Think\Page ( $count, $row );
			$page->setConfig ( 'theme', '%FIRST% %UP_PAGE% %LINK_PAGE% %DOWN_PAGE% %END% %HEADER%' );
			$list_data ['_page'] = $page->show ();
		}
		
		//$this->assign ( 'add_url', U ( 'add?type=' . $type ) );
		
		return $list_data;
	}

	function _get_device_data($product_id) {
		$model = $this->getModel ( 'wxdevice_devices' );

		$page = I ( 'p', 1, 'intval' ); // 默认显示第一页数据
		                                
		// 解析列表规则
		$list_data = $this->_list_grid ( $model );
		
		// 搜索条件
		$map = $this->_search_map ( $model, $fields );
		$map ['productid'] = $product_id;
		
		$row = empty ( $model ['list_row'] ) ? 20 : $model ['list_row'];
		
		// 读取模型数据列表		
		$name = parse_name ( get_table_name ( $model ['id'] ), true );
		$data = M ( $name )->field ( true )->where ( $map )->order ( $order )->page ( $page, $row )->select ();
		
		/* 查询记录总数 */
		$count = M ( $name )->where ( $map )->count ();
		
		$list_data ['list_data'] = $data;
		
		// 分页
		if ($count > $row) {
			$page = new \Think\Page ( $count, $row );
			$page->setConfig ( 'theme', '%FIRST% %UP_PAGE% %LINK_PAGE% %DOWN_PAGE% %END% %HEADER%' );
			$list_data ['_page'] = $page->show ();
		}
		
		//$this->assign ( 'add_url', U ( 'add?type=' . $type ) );
		
		return $list_data;
	}

	function _get_device_number ($product_id) {
		$model = $this->getModel ( 'wxdevice_devices' );

		// 搜索条件
		$map = $this->_search_map ( $model, $fields );
		$map ['productid'] = $product_id;

		$name = parse_name ( get_table_name ( $model ['id'] ), true );
		
		/* 查询记录总数 */
		$count = M ( $name )->where ( $map )->count ();
		
		return $count;
	}
}
