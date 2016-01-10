<?php

namespace Addons\Dg\Controller;
use Home\Controller\AddonsController;

class DgController extends AddonsController{
	public function lists() {
		$this->assign ( 'add_button', false );
		$this->assign ( 'del_button', false );
		$this->assign ( 'search_button', false );
		$this->assign ( 'check_all', false );
		$model = $this->getModel ( 'dg' );
		parent::common_lists ( $model );
	}
}
