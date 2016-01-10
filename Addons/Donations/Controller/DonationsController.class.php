<?php

namespace Addons\Donations\Controller;
use Home\Controller\AddonsController;

class DonationsController extends AddonsController{

    public function _initialize(){

        parent::_initialize();

        $controller = strtolower(_CONTROLLER);
        $action = strtolower(_ACTION);

        $res['title'] = '插件配置';
        $res['url'] = addons_url('Donations://Donations/config');
        $res['class'] = $controller == 'donations' ? 'current' : '';
        $nav[] = $res;

        $res['title'] = '捐赠额设置';
        $res['url'] = addons_url('Donations://Money/lists');
        $res['class'] = $controller == 'money' ? 'current' : '';
        $nav[] = $res;

        $res['title'] = '捐赠列表';
        $res['url'] = addons_url('Donations://List/lists');
        $res['class'] = $controller == 'list' ? 'current' : '';
        $nav[] = $res;

        $this->assign('nav', $nav);

    } 
	 //首页
    public function index(){   	

    	if(IS_POST){
          
          $data['token'] = get_token();
          $data['openid'] = get_openid();
          $data['ctime'] = time();
          $data['money'] = I('money1');
          $data['email'] = I('email');
          $data['content'] = I('content');
          $data['is_anonymous'] = intval(I('is_anonymous'));
          $myInfo = getUserInfo(get_openid());
          $data['nickname'] = $myInfo['nickname'] ? $myInfo['nickname'] : '匿名';

          if($_SESSION['support_info'] !="")
          {
            unset($_SESSION['support_info']);
          }
          
          session_start();
          $_SESSION['support_info'] = $data;        

          $param['orderid']=time();
          $param['price']= floatval($data['money']);
          $param['from']=urlencode(addons_url('Donations://Donations/payok'));
          $payurl=addons_url('WechatPay://WechatPay/pay',$param);        
          redirect($payurl);  

      } else {
          $config = getAddonConfig('Donations');
          $this->assign('config',$config);

          $money = M('donations_money')->where(array('token'=>get_token()))->order('money asc')->select();
          // dump($money);
          $this->assign('money', $money);       // 捐赠额设置
      
          $this->display();
      }    
    }

    public function payok(){        
        
        $data['token'] = get_token();
        $data['openid'] = get_openid();
        $data['money'] = I('price');
        $data['ctime'] = time();
        $data['email'] = I('email');
        $data['content'] = I('content');
        $data['is_anonymous'] = intval(I('is_anonymous'));
        $wexinUserInfo = getWeixinUserInfo(get_openid(),get_token());
        $data['nickname'] = $wexinUserInfo['nickname'] ? $wexinUserInfo['nickname'] : '匿名';
        
        $res = M('donations_list')->add($data);
        if($res){

            // 给管理员发送通知
            $config = getAddonConfig('Donations');
            foreach ($config['admins'] as $k => $v) {
                $kf_data['touser'] = getOpenidByUid($v);
                $kf_data['msgtype'] = 'text';
                $kf_data['text']['content'] = '用户'.$data['nickname'].'捐赠了'.$data['money'].'元并附言：'.$data['content'];
                sendCustomMessage($kf_data);
            }
            
            echo json_encode($data);
        }
    }

    // 支付成功通知页面
    public function pay_ok_info(){
      $this->display();
    }

    public function donations_list(){
      $list = M('donations_list')->where(array('token'=>get_token()))->order('ctime desc')->select();
      foreach ($list as $k => &$v) {
          
          $weixinUserInfo = getUserInfo($v['openid']);
  
          $v['nickname'] = $weixinUserInfo['nickname'] && $v['is_anonymous'] == 0 ? $weixinUserInfo['nickname'] : '匿名';
          $v['headimgurl'] = $weixinUserInfo['headimgurl'] && $v['is_anonymous'] == 0 ? $weixinUserInfo['headimgurl'] : __ROOT__ . '/Public/Home/images/noheadimg.png';
      }
      $this->assign('list',$list);
      $this->display();
    }
}
