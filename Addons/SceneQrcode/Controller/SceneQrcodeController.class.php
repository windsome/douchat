<?php

namespace Addons\SceneQrcode\Controller;
use Home\Controller\AddonsController;

class SceneQrcodeController extends AddonsController{

	public function _initialize() {

		parent::_initialize();
		
		$this->model = $this->getModel('scene_qrcode');

		$controller = strtolower(_CONTROLLER);

		$res['title'] = '二维码管理';
		$res['url'] = addons_url('SceneQrcode://SceneQrcode/lists');
		$res['class'] = $controller == 'sceneqrcode' ? 'current' : '';
		$nav[] = $res;

		$res['title'] = '扫描统计';
		$res['url'] = addons_url('SceneQrcode://Statistics/lists');
		$res['class'] = $controller == 'statistics' ? 'current' : '';
		$nav[] = $res;

		$this->assign('nav', $nav);
	}

	// 数据列表
	public function lists() {
		// 获取模型信息
		$model = $this->model;
		
		$list_data = $this->_get_model_list ( $model, $page, $order );

		foreach ($list_data['list_data'] as $k => &$v) {
			switch ($v['scene_type']) {
				case 0:
					$v['scene_type'] = '临时二维码';
					break;
				
				default:
					$v['scene_type'] = '永久二维码';
					break;
			}

			$v['short_url'] = '<a href="'.$v['short_url'].'" target="_blank">' . url_img_html($v['short_url']) . '</a>';

			$v['expire'] = $v['expire'] ? $v['expire'] . '(秒)' : '永不过期';
		}

		$this->assign ( $list_data );
		// dump($list_data);
		
		$templateFile || $templateFile = $model ['template_list'] ? $model ['template_list'] : '';
		$this->display ( $templateFile );
	}

	// 新增二维码
	public function add() {

		$model = $this->model;
		if (IS_POST) {
			$Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );
			// 获取模型的字段信息
			$Model = $this->checkAttr ( $Model, $model ['id'] );
			if ($Model->create ()) {

				$data['token'] = get_token();
				$data['ctime'] = time();
				$data['scene_name'] = $_POST['scene_name'];
				$data['keyword'] = $_POST['keyword'];
				if ($_POST['scene_type'] == 0) {
					$data['expire'] = $_POST['expire'] ? $_POST['expire'] : 1800;
					$qrCode = M('scene_qrcode')->where(array('token'=>get_token(),'scene_type'=>0))->order('scene_id desc')->find();
					if (!$qrCode['scene_id']) {
						$data['scene_id'] = 320001;
					} else {
						$data['scene_id'] = intval($qrCode['scene_id'])+1;
					}
					
					$data['scene_type'] =0;
					$qrCode = getQRCode($data['scene_id'], 0, $data['expire']);
					if (!$qrCode) {
						$this->error('未能成功创建二维码，请稍后再试~');
						exit();
					}
					$data['ticket'] = $qrCode['ticket'];
					$data['url'] = $qrCode['url'];
					$data['short_url'] = getShortUrl(getQRUrl($qrCode['ticket']));
				}

				if ($_POST['scene_type'] == 1) {
					if ($_POST['scene_str'] == '') {	// 如果没有填场景值字符串，则系统自动生成场景值ID
						$qrCode = M('scene_qrcode')->where(array('token'=>get_token(),'scene_type'=>1))->order('scene_id desc')->find();
						if (!$qrCode['scene_id']) {
							$data['scene_id'] = 100001;
						} else {
							$data['scene_id'] = intval($qrCode['scene_id'])+1;
						}
						
					} else {	// 如果填了场景值字符串，则使用场景值字符串
						$data['scene_str'] = $_POST['scene_str'];
					}
					
					$temp_scene_id = $data['scene_id'] ? $data['scene_id'] : $data['scene_str'];
					$data['scene_type'] = 1;
					$qrCode = getQRCode($temp_scene_id, $data['scene_type']);
					if (!$qrCode) {
						$this->error('未能成功创建二维码，请稍后再试~');
						exit();
					}
					$data['ticket'] = $qrCode['ticket'];
					$data['url'] = $qrCode['url'];
					$data['short_url'] = getShortUrl(getQRUrl($qrCode['ticket']));
				}



				$res = $Model->add($data);
				if ($res) {
					$this->_saveKeyword ( $model, $id );
				
					// 清空缓存
					method_exists ( $Model, 'clear' ) && $Model->clear ( $id, 'add' );
					
					$this->success ( '添加' . $model ['title'] . '成功！', U ( 'lists?model=' . $model ['name'], $this->get_param ) );
				
				}
			} else {
				$this->error ( $Model->getError () );
			}
		} else {
			$fields = get_model_attribute ( $model ['id'] );
			$this->assign ( 'fields', $fields );
			
			$templateFile || $templateFile = $model ['template_add'] ? $model ['template_add'] : '';
			$this->display ( $templateFile );
		}
	}

	// 编辑二维码
	public function edit() {
		$model = $this->model;
		$id || $id = I ( 'id' );
		
		// 获取数据
		$data = M ( get_table_name ( $model ['id'] ) )->find ( $id );
		$data || $this->error ( '数据不存在！' );
		
		$token = get_token ();
		if (isset ( $data ['token'] ) && $token != $data ['token'] && defined ( 'ADDON_PUBLIC_PATH' )) {
			$this->error ( '非法访问！' );
		}
		
		if (IS_POST) {
			$Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );
			// 获取模型的字段信息
			$Model = $this->checkAttr ( $Model, $model ['id'] );
			if ($Model->create ()) {

				$data['scene_name'] = $_POST['scene_name'];
				$data['keyword'] = $_POST['keyword'];
				$Model->save($data);

				$this->_saveKeyword ( $model, $id );
				
				// 清空缓存
				method_exists ( $Model, 'clear' ) && $Model->clear ( $id, 'edit' );
				
				$this->success ( '保存' . $model ['title'] . '成功！', U ( 'lists?model=' . $model ['name'], $this->get_param ) );
			} else {
				$this->error ( $Model->getError () );
			}
		} else {
			$fields = get_model_attribute ( $model ['id'] );
			//dump($fields);die;
			$temp_fields['scene_name'] = $fields['scene_name'];
			$temp_fields['keyword'] = $fields['keyword'];
			$this->assign ( 'fields', $temp_fields );
			$this->assign ( 'data', $data );
			
			$templateFile || $templateFile = $model ['template_edit'] ? $model ['template_edit'] : '';
			$this->display ( $templateFile );
		}
	}

	// 删除二维码
	public function del() {
		$model = $this->model;
		$model_r = $this->getModel('scene_qrcode_statistics');	// 获取扫描统计模型
		
		! empty ( $ids ) || $ids = I ( 'id' );
		! empty ( $ids ) || $ids = array_filter ( array_unique ( ( array ) I ( 'ids', 0 ) ) );
		! empty ( $ids ) || $this->error ( '请选择要操作的数据!' );
		
		$Model = M ( get_table_name ( $model ['id'] ) );
		$map ['id'] = array (
				'in',
				$ids 
		);

		$Model_r = M ( get_table_name ( $model_r ['id'] ) );
		$map_r['qrcode_id'] = array(
			'in',
			$ids
		);
		
		// 插件里的操作自动加上Token限制
		$token = get_token ();
		if (defined ( 'ADDON_PUBLIC_PATH' ) && ! empty ( $token )) {
			$map ['token'] = $token;
			$map_r['token'] = $token;
		}

		
		// 删除二维码及对应的统计数据
		if ($Model->where ( $map )->delete () && $Model_r->where ( $map_r )->delete ()) {
			// 清空缓存
			method_exists ( $Model, 'clear' ) && $Model->clear ( $ids, 'del' );
			method_exists ( $Model_r, 'clear' ) && $Model_r->clear ( $ids, 'del' );

			$this->success ( '删除成功' );
		} else {
			$this->error ( '删除失败！' );
		}
		// parent::common_del($this->model);
	}

	// 查看扫描统计
	public function viewScan() {
		$qrcode_id = I('id');
		$jump_url = addons_url('SceneQrcode://Statistics/lists',array('qrcode_id'=>$qrcode_id));
		redirect($jump_url);
	}

}
