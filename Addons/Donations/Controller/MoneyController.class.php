<?php 

namespace Addons\Donations\Controller;
use Addons\Donations\Controller\DonationsController;

class MoneyController extends DonationsController{

    public function _initialize(){
        parent::_initialize();
        $this->model = $this->getModel('donations_money');
    }

    public function lists(){
        parent::common_lists($this->model);
    }

    public function add(){
        parent::common_add($this->model);
    }

    public function edit(){
        parent::common_edit($this->model);
    }

    public function del(){
        parent::common_del($this->model);
    }

}


?>