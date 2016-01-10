<?php

namespace Addons\AutoReply\Controller;

use Home\Controller\AddonsController;

class AutoReplyController extends AddonsController {
	function _initialize() {
		parent::_initialize();
		
		$act = strtolower ( _ACTION );
		// $type = I ( 'type' );
		
		$res ['title'] = '被添加自动回复';
		$res ['url'] = addons_url ( 'AutoReply://AutoReply/subscribe' );
		$res ['class'] = $act == 'subscribe' ? 'current' : '';
		$nav [] = $res;
		
		$res ['title'] = '消息自动回复';
		$res ['url'] = addons_url ( 'AutoReply://AutoReply/message' );
		$res ['class'] = $act == 'message' ? 'current' : '';
		$nav [] = $res;
		
		$res ['title'] = '关键词自动回复';
		$res ['url'] = addons_url ( 'AutoReply://AutoReply/lists' );
		$res ['class'] = $act == 'lists' || $act == 'add' || $act == 'edit' ? 'current' : '';
		$nav [] = $res;
		
		$this->assign ( 'nav', $nav );
	}

	// 被关注自动回复
	function subscribe() {

		$replyInfo = M('auto_reply')->where(array('token'=>get_token(),'reply_scene'=>0))->find();
		$this->assign('data', $replyInfo);

		$this->assign ( 'normal_tips', '用户关注公众号时回复的消息，如果添加了多种类型的消息，只回复第一种类型' );
		$this->assign('reply_scene', 0);		// 回复场景：用户关注
		$this->display('reply');
	}

	// 消息自动回复
	function message() {

		$replyInfo = M('auto_reply')->where(array('token'=>get_token(),'reply_scene'=>1))->find();
		$this->assign('data', $replyInfo);

		$this->assign ( 'normal_tips', '用户发送消息没有触发任何回复规则时回复的消息，如果添加了多种类型的消息，只回复第一种类型' );
		$this->assign('reply_scene', 1);		// 回复场景：用户发送消息未触发其他回复规则
		$this->display('reply');
	}

	function lists() {
		// 获取模型信息
		$model = $this->getModel('auto_reply');
		
		$list_data = $this->_get_model_list ( $model, $page, $order );

		foreach ($list_data['list_data'] as $k => &$v) {

			if ($v['keyword'] == '') {
				unset($list_data['list_data'][$k]);
			}

			switch ($v['msg_type']) {
				case 'text':
					$v['msg_type'] = '文本';
					break;
				case 'image':
					$v['msg_type'] = '图片';
					break;
				case 'news':
					$v['msg_type'] = '图文';
					break;
				case 'voice':
					$v['msg_type'] = '语音';
					break;
				case 'video':
					$v['msg_type'] = '视频';
					break;
				default:
					break;
			}

			// $v['short_url'] = '<a href="'.$v['short_url'].'" target="_blank">' . url_img_html($v['short_url']) . '</a>';

			// $v['expire'] = $v['expire'] ? $v['expire'] . '(秒)' : '永不过期';
		}

		$this->assign ( $list_data );
		// dump($list_data);
		
		$templateFile || $templateFile = $model ['template_list'] ? $model ['template_list'] : '';
		$this->display ( $templateFile );
	}
	function news() {
		$list_data = $this->_get_data ( 'news' );
		$this->assign ( 'normal_tips', '请不设置相同的关键词，相同的关键词只回复最新的设置' );
		unset ( $list_data ['list_grids'] ['content'], $list_data ['list_grids'] ['image_id'] );
		
		foreach ( $list_data ['list_data'] as &$d ) {
			$map2 ['group_id'] = $d ['group_id'];
			$titles = M ( 'material_news' )->where ( $map2 )->getFields ( 'title' );
			$d ['group_id'] = implode ( '<br/>', $titles );
		}
		
		$this->assign ( $list_data );
		// dump ( $list_data );
		
		$this->display ('lists');
	}
	function image() {
		$list_data = $this->_get_data ( 'image' );
		$this->assign ( 'normal_tips', '请不设置相同的关键词，相同的关键词只回复最新的设置' );
		unset ( $list_data ['list_grids'] ['group_id'], $list_data ['list_grids'] ['content'] );
		
		foreach ( $list_data ['list_data'] as &$d ) {
            if ($d['image_id']){
                $d['image_id']=url_img_html(get_cover_url($d['image_id']));
            }else if($d['image_material']){
    			$map2 ['id'] = $d ['image_material'];
    			$url = M ( 'material_image' )->where ( $map2 )->getField ( 'cover_url' );
    			$d['image_id'] = url_img_html ( $url );
            }
		}
		
		$this->assign ( $list_data );
		//dump($list_data);
		
		$this->display ('lists');
	}
	function _get_data($type) {
		$model = $this->getModel ( 'AutoReply' );
		
		$page = I ( 'p', 1, 'intval' ); // 默认显示第一页数据
		                                
		// 解析列表规则
		$list_data = $this->_list_grid ( $model );
		
		// 搜索条件
		$map = $this->_search_map ( $model, $fields );
		$map ['msg_type'] = $type;
		
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
		
		$this->assign ( 'add_url', U ( 'add?type=' . $type ) );
		
		return $list_data;
	}
	// 通用插件的编辑模型
	public function edit() {
		$this->assign ( 'normal_tips', '请不设置相同的关键词，相同的关键词只回复最新的设置' );

		$model = $this->getModel ( 'AutoReply' );
		$id = I ( 'id' );
		
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
			if ($Model->create () && $Model->save ()) {
				$this->_saveKeyword ( $model, $id );
				
				$url = U ( 'lists' );
				if ($data ['msg_type'] == 'news') {
					$url = U ( 'news' );
				} elseif ($data ['msg_type'] == 'image') {
					$url = U ( 'image' );
				}
				$this->success ( '保存' . $model ['title'] . '成功！', $url );
			} else {
				$this->error ( $Model->getError () );
			}
		} else {
			$fields = get_model_attribute ( $model ['id'] );
			$fields = $this->_deal_fields ( $fields, $data ['msg_type'] );
			$this->assign ( 'fields', $fields );
			if($data['image_material']){
			    $map2 ['id'] = $data ['image_material'];
			    $url = M ( 'material_image' )->where ( $map2 )->getField ( 'cover_url' );
			    $data ['cover_url'] =  $url ;
			}
			$this->assign ( 'data', $data );
// 			dump($fields);
			$this->assign('reply_scene', 2);		// 回复场景：关键词回复
			$this->display ('reply');
		}
	}
	
	// 通用插件的增加模型
	public function add() {

		$this->assign ( 'normal_tips', '请不设置相同的关键词，相同的关键词只回复最新的设置' );

		$replyInfo = M('auto_reply')->where(array('id'=>I('id')))->find();
		$this->assign('data', $replyInfo);
		
		$model = $this->getModel ( 'AutoReply' );
		if (IS_POST) {

			if ($_POST['reply_scene'] == 2 && $_POST['keyword'] == '') {
				$this->error('请填写关键词');
			}
			// dump($_POST);die;

			if (I('video_id')) {
				$data['msg_type'] = 'video';
			}

			if (I('voice_id')) {
				$data['msg_type'] = 'voice';
			}

			if (I('image_material') || I('image')) {
				$data['msg_type'] = 'image';
			}

			if (I('appmsg_id')) {
				$data['msg_type'] = 'news';
			}

			if (I('content')) {
				$data['msg_type'] = 'text';
			}

			$data['keyword'] = I('keyword');
			$data['reply_scene'] = I('reply_scene');
			$data['content'] = I('content');
			$data['group_id'] = intval(I('appmsg_id'));
			$data['image_id'] = intval(I('image'));
			$data['voice_id'] = intval(I('voice_id'));
			$data['video_id'] = intval(I('video_id'));
			$data['manage_id'] = intval(get_mid());
			$data['token'] = get_token();
			$data['image_material'] = intval(I('image_material'));

			// dump($data);die;

			$Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );
			// 获取模型的字段信息
			if ($_POST['reply_scene'] == 2) {
				$Model = $this->checkAttr ( $Model, $model ['id'] );
			}
			
			if ($Model->create ()) {

				if (I('reply_scene') == 0) {
					$url = U('subscribe');
				} elseif (I('reply_scene') == 1) {
					$url = U('message');
				} else {
					$url = U ( 'lists' );
				}

				if (I('id')) {		// 更新
					$result = M('auto_reply')->where(array('id'=>I('id')))->save($data);
					if ($result || $result === 0) {
						$this->success ( '更新' . $model ['title'] . '成功！', $url );
					}
				} else {			// 新增
					$id = $Model->add ($data);
					$this->_saveKeyword ( $model, $id );
					$this->success ( '添加' . $model ['title'] . '成功！', $url );
				}
				
			} else {
				$this->error ( $Model->getError () );
			}
		} else {
			$fields = get_model_attribute ( $model ['id'] );
			$fields = $this->_deal_fields ( $fields, $type );
			$this->assign ( 'fields', $fields );
			$postUrl=U('add',array('model'=>$model['id']));
			$this->assign('post_url',$postUrl);

			$this->assign('reply_scene', 2);		// 回复场景：关键词回复
			$this->display ('reply');
		}
	}
	function _deal_fields($fields, $type) {
		// dump ( $type );
		switch ($type) {
			case 'news' :
				unset ( $fields ['content'], $fields ['image_id'] );
				break;
			case 'image' :
				unset ( $fields ['group_id'], $fields ['content'] );
				break;
			
			default :
				unset ( $fields ['group_id'], $fields ['image_id'] );
		}
		// dump ( $fields );
		return $fields;
	}
}
