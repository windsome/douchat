<?php

namespace Addons\IdouExample\Controller;
use Home\Controller\AddonsController;

class IdouExampleController extends AddonsController{
    function lists () {
		$model = $this->getModel ( 'iot_device' );
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
		
		// 查询记录总数 
		$count = M ( $name )->where ( $map )->count ();

        error_log("\nwindsome ". __METHOD__. ": table=".$name, 3, PHP_LOG_PATH);
		$list_data ['list_data'] = $data;
		
		// 分页
		if ($count > $row) {
			$page = new \Think\Page ( $count, $row );
			$page->setConfig ( 'theme', '%FIRST% %UP_PAGE% %LINK_PAGE% %DOWN_PAGE% %END% %HEADER%' );
			$list_data ['_page'] = $page->show ();
		}
		
		$this->assign ( $list_data );	
		$this->display ();
    }

}
