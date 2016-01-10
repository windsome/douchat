<?php

namespace Addons\SceneQrcode\Controller;
use Home\Controller\AddonsController;

class StatisticsController extends AddonsController{

	public function _initialize() {
		$this->model = $this->getModel('scene_qrcode_statistics');

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

	public function lists() {
		$this->assign('add_button', false);
		$this->assign('del_button', false);
		if (I('qrcode_id')) {
			
			$data = M('scene_qrcode_statistics')->where(array('token'=>get_token(),'qrcode_id'=>I('qrcode_id')))->order('id desc')->select();
			
			// 解析列表规则
			$list_data = $this->_list_grid ( $this->model );
			$list_data ['list_data'] = $data;
			
			//$this->assign ( 'list_grids', $grids );
			$this->assign ( $list_data );
			
			$templateFile || $templateFile = $model ['template_list'] ? $model ['template_list'] : '';
			$this->display ( $templateFile );
		} else {
			parent::common_lists($this->model);
		}
		
	}

}

?>
