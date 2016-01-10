<?php

namespace Addons\AddressManage\Controller;
use Home\Controller\AddonsController;

class AddressManageController extends AddonsController{

	public function _initialize(){
		parent::_initialize();
		
		$this->model = $this->getModel('address');

		$res['title'] = '用户地址管理';
		$res['url'] = U('lists');
		$res['class'] = 'current';
		$nav[] = $res;
		$this->assign('nav', $nav);
		
	}

	// 地址列表
	public function lists(){
		$this->assign('add_button',false);
		//$this->assign('del_button',false);
		parent::common_lists($this->model);
	}

	public function del(){
		parent::common_del($this->model);
	}

	public function addList(){

		$this->assign('return_url', $_SESSION['return_url']);

		$addList = M('address')->where(array('openid'=>get_openid()))->select();
		$this->assign('addList',$addList);

		$this->display('addList');
	}

	public function add(){
		if ( IS_AJAX ){
			$data['country'] = I('country') ? I('country') : '中国';
			$data['province'] = I('province');
			$data['city'] = I('city');
			$data['area'] = I('area');
			$data['address'] = I('address');
			$data['name'] = I('name');
			$data['sex'] = I('sex');
			$data['mobile'] = I('mobile');
			$data['is_default'] = 0;
			$data['postcode'] = I('postcode');
			$data['openid'] = get_openid();
			$data['token'] = get_token();

			if (I('id')){
				$res = M('address')->where(array('id'=>I('id')))->save($data);
			}else{
				$res = M('address')->add($data);
			}

			
			if ($res || $res === 0){
				$data['status'] = 1;
				$data['info'] = '保存地址成功';
			} else {
				$data['status'] = 0;
				$data['info'] = '保存地址失败';
			}

			$this->ajaxReturn($data);

		}else{
			$addressInfo = M('address')->where(array('id'=>I('id')))->find();
			$this->assign('addInfo',$addressInfo);
			$this->assign('id',I('id'));
			$this->display();
		}
	}

	// 设置默认地址
	public function setDefaultAddress(){
		if (IS_AJAX) {
			M('address')->where(array('openid'=>get_openid(),'is_default'=>1))->setDec('is_default');
			$res = M('address')->where(array('openid'=>get_openid(),'id'=>I('id')))->setInc('is_default');
			if ($res) {
				$data['status'] = 1;
				$data['info'] = '设置默认地址成功';
				$data['return_url'] = $_SESSION['return_url'];
			} else {
				$data['status'] = 0;
				$data['info'] = '设置默认地址失败';
			}

			$this->ajaxReturn($data);
		}
		
	}

	// 获取json格式的地址数据
	public function getDefaultAddress(){
		$map['openid'] = I('openid');
		$map['is_default'] = 1;
		$addInfo = M('address')->where($map)->find();
		if ($addInfo){
			$this->ajaxReturn($addInfo);
		}
	}

}
