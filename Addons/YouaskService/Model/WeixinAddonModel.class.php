<?php
        	
namespace Addons\YouaskService\Model;
use Home\Model\WeixinModel;
        	
/**
 * YouaskService的微信模型
 */
class WeixinAddonModel extends WeixinModel{

	function reply($dataArr, $keywordArr = array()) {

		$config = getAddonConfig ( 'YouaskService' ); // 获取后台插件的配置参数	

		$content = $dataArr["Content"];
        			
		//处理用户发送语音事件
		if ($dataArr ['MsgType'] == 'voice') {
			
            $content = substr($dataArr['Recognition'],0,strlen($dataArr['Recognition'])-3); 

        }


        //处理客服会话通知事件
        if ($dataArr ['MsgType'] == 'event') {
        	$event = strtolower ( $dataArr ['Event'] );

			$map ['token'] = $dataArr ['ToUserName'];
			$map ['openid'] = $dataArr ['FromUserName'];

			$KfAccount = $this -> get_kfname( $dataArr ['KfAccount'] );
			$ToKfAccount = $this -> get_kfname( $dataArr ['ToKfAccount'] );

			$u_id = M ( 'public_follow' )->where ( $map )->getField ( 'uid' );

            $sreach = array (
					'[name]'
			);

			if ( $event == 'kf_create_session' ) {
				$replace = array (
					$KfAccount 
			    );
                $config ['jrkf'] = str_replace ( $sreach, $replace, $config ['jrkf'] );
				D ( 'Common/Custom' )-> replyText ( $u_id, $config ['jrkf'] );
				die('');
			}
			if ( $event == 'kf_close_session' ) {
				D ( 'Common/Custom' ) -> replyText ( $u_id, $config ['gbkf'] );
				die('');
			}
			if ( $event == 'kf_switch_session' ) {
				$replace = array (
					$ToKfAccount
			    );
                $config ['zjkf'] = str_replace ( $sreach, $replace, $config ['zjkf'] );
				D ( 'Common/Custom' ) -> replyText ( $u_id, $config ['zjkf'] );
				die('');
			}

		}


		$token = get_token();	

		//用户主动关闭人工客服
		if($config["tcrg"] == $content){			
			$gbkf = $this->gbkf();	
		}	

		//支持多个关键词查询在线客服
	    $cxkey = explode('|',$config["cxkey"].'|',-1);
		$cxkeykf = in_array($content,$cxkey);

        //查询在线客服列表
        if ( $cxkeykf ) {
            $this->getzxkflist($config,$token);
        }

        //转人工客服，先判断用户是否指定客服
		$connectkf = $this->connectkf($content,$token,$config,$keywordArr,$dataArr);

        //未识别之后，调用图灵机器人
		$this->zjtuling($dataArr, $keywordArr = array());

	} 

	//转接人工客服
	public function connectkf($content,$token,$config,$keywordArr,$dataArr){

		//支持多个关键词转人工客服
		$zrg = explode('|',$config["zrg"].'|',-1);
		$zrgkf = in_array($content,$zrg);

		if( $zrgkf ){		
                //判断是否已经接入客服
			    $kf_account = $this->cxkfstate();
			    $kfname = $this->get_kfname($kf_account);

			    if ($kfname!=null) {
			    	$res = $this->replyText ('您正在被客服【'.$kfname.'】接入中，无法接入其他客服');
			    }
			    //判断是否有在线的客服,电脑优先，只有手机在线的被屏蔽掉
			    $zxlists = $this->kfzxstate($config["state"],$config['model2']);

			    $len = sizeof($zxlists);

			    if($len !=0){

				    //随机生成一个在线客服，再指定
				    $kfaccount = $zxlists[rand(0,($len-1))];
				    $this->transmitServiceZD($dataArr,$kfaccount);
                    //系统随机分配在线客服（上面两句代码，可以用下面一句代替）
				    //$this->transmitService($dataArr);
			    }else{
				    $res = $this->replyText ($config ['kfbz']);
			    }	
		
			exit();

		}	
 
	    //查询匹配方式
        $keywords=M('youaskservice_keyword');
		$keywordsValue = $keywords->where(" token='".$token."' and instr('".$content."',msgkeyword) >0 ")->order("id desc")->select();           
              
		foreach($keywordsValue as $v){
			
			$ispass  =false;
			//多项匹配,只取第一项
			switch($v["msgkeyword_type"]){				
				case "0":
					if($v["msgkeyword"] == $content){
						$ispass  =true;
					}
					break;
				case "1":
					if($v["msgkeyword"] == substr($content,strlen($v["msgkeyword"]))){
						$ispass  =true;
					}
					break;
				case "2":
					if($v["msgkeyword"] == substr($content,-strlen($v["msgkeyword"]))){
						$ispass  =true;
					}
					break;
				case "3":					
					//发送到客服0:指定人员 1:指定客服组					
					$ispass  =true;					
					break;				
			}
			
			if($ispass){

				//判断用户是否已经接入客服，返回提醒
			    $kf_account = $this->cxkfstate();
			    $kfname = $this->get_kfname($kf_account);

			    if ($kfname!=null) {
			    	$res = $this->replyText ('您正在被客服【'.$kfname.'】接入中，无法接入其他客服');
			    }

				if($v["zdtype"] == 0){
					$zxlists = $this->kfzxstate($config["state"],$config['model2']);

					//判断指定客服是否在线，否则返回提示
					if (in_array($v["msgkfaccount"], $zxlists)) {
                         $this->transmitServiceZD($dataArr,$v["msgkfaccount"]);
                     }else{
                     	$res = $this->replyText ($config ['zdkfbz']);
                     }
					
					exit();
				}else{

					//查询客服分组
					$group =  M("youaskservice_group")->where(array("token"=>$token,"id"=>$v["kfgroupid"]))->find();
					if($group){ 
						$zxlists = $this->kfzxstate($config["state"],$config['model2']);
						$kfgroup = unserialize($group["groupdata"]);
						$zxkfgroup = array_intersect($zxlists,$kfgroup);
						$len = sizeof($zxkfgroup);
						if($len !=0){
							$kfaccount = $zxkfgroup[rand(0,($len-1))];
						    $this->transmitServiceZD($dataArr,$kfaccount);
						}else{
                            $res = $this->replyText ($config ['zdkfbz']);
						}
						
						exit();
					}
				}	
			}	
				
		}			

	}

	//判断客服在线状态
	public function kfzxstate($config,$model){

		if ($config["state"] == 0 ) {
		    $this->replyText ('未开启人工客服！');
		    exit();
		}

		//$res = $this->replyText ($model);
		header("Content-type: text/html; charset=utf-8"); 
				
		// $access_token = $this->getaccess_token();	
		// $url_get = 'https://api.weixin.qq.com/cgi-bin/customservice/getonlinekflist?access_token='.$access_token;				
		// $json = $this->curlGet($url_get);			
		// $json =json_decode($json);
		$json =json_decode(json_encode(getCustomServiceOnlineKFlist()));
		
		$kf_onlinelists = $json->kf_online_list;

		$kflist =array();
		$status =array();

		//补充昵称		
		foreach	($kf_onlinelists as $value ) {
			$status[] = $value->status;	
			$kflist[] = $value->kf_account;		
		}

		$t = count($status);
         for ($i=0; $i <$t ; $i++) { 

         	//开启和关闭多客服助手接待
         	if ($status[$i] == $model) {
         		unset($kflist[$i]);
         	}  	 	
         }

        //删除后的数组重建索引0，1，2...
        array_splice($kflist,0,0);  
		return $kflist;
	}

    //获取在线客服，跟设定关键词匹配，筛选出关键词指定有客服在线的，回复列表
    function getzxkflist($config,$token){
    	$zxkglist = array();
    	$zxlists = $this->kfzxstate($config["state"],$config['model2']);
        $keywords=M('youaskservice_keyword');
        $map['token'] = $token;
        $map['msgstate'] = 1;
		$keywordsValue = $keywords->where($map)->order("id desc")->select();

        foreach($keywordsValue as $v){

				if($v["zdtype"] == 0){
					//判断客服是否在线
					if (in_array($v["msgkfaccount"], $zxlists)) {
                         $zxkglist[] = $v["msgkeyword"].' '.$v["kf_explain"];
                     }
                   
				}else{
					//查询组，判断组内客服是否在线
					$group =  M("youaskservice_group")->where(array("token"=>$token,"id"=>$v["kfgroupid"]))->find();
					if($group){ 
						$zxlists = $this->kfzxstate($config["state"],$config['model2']);
						$kfgroup = unserialize($group["groupdata"]);
						$zxkfgroup = array_intersect($zxlists,$kfgroup);
						$len = sizeof($zxkfgroup);
						if($len !=0){
						  $zxkglist[] = $v["msgkeyword"].' '.$v["kf_explain"];
						}
						
					}
				}

        }
        $len = sizeof($zxkglist);
        if ($len == 0) {
        	$res = $this->replyText ($config ['kfbz']);
        	exit();
        }

        //重建索引0，1，2...
        array_splice($zxkglist,0,0); 
        $zxkf_array = implode("\n        ",$zxkglist);

        $description = $config ['description_head']."\n"."\n        ".$zxkf_array."\n"."\n".$config ['description_foot'];
		  switch ($config ['type3']) {
			case '3' :
				$articles [0] = array (
						'Title' => $config ['title3'],
						'Description' => $description,
						'PicUrl' => get_cover_url ( $config ['pic_url3'] ),
						'Url' => str_replace ( $sreach, $replace, $config ['url2'] ) 
				);
				$res = $this->replyNews ( $articles );
				break;
			 case '1' :
				$res = $this->replyText ( $description );
				break;
		   }

    }

    //获取客服昵称
    private function get_kfname($kf_account){
    	$map['userName'] = $kf_account;
    	$name = M ( 'youaskservice_user' )->where ( $map )->getField ( 'name' );
        return $name;
    }

    //查询用户会话状态
	public function cxkfstate(){
		header("Content-type: text/html; charset=utf-8"); 
				
		// $access_token = $this->getaccess_token();	
		$openid = get_openid();
        
		// $url_get = 'https://api.weixin.qq.com/customservice/kfsession/getsession?access_token='.$access_token.'&openid='.$openid;				
		// $json = $this->curlGet($url_get);	
		// $json = json_decode($json,true);
		$json = getKFSession($openid);
		$kf_account = $json['kf_account'];

		return $kf_account;
	}

    //关闭人工客服
	public function gbkf(){
		header("Content-type: text/html; charset=utf-8"); 		
		$openid = get_openid();
		$kf_account = $this->cxkfstate();

		if ($kf_account  == null) {
			$res = $this->replyText ('您未接入任何客服！');	
			exit();
		}

		$postdata = array(
	    	"kf_account" => $kf_account ,
	    	"openid" => $openid,
	    	"text" => '用户主动关闭会话！'
	    	);

	 //    $postdata = json_encode($postdata);
		// $access_token = $this->getaccess_token();
		// $url_post = 'https://api.weixin.qq.com/customservice/kfsession/close?access_token='.$access_token;				
		// $json = $this->curlGet($url_post, $method = 'post', $data = $postdata);	
		$json = json_decode(json_encode(closeKFSession($postdata['openid'],$postdata['kf_account'],$postdata['text'])));

		if (!$json->errmsg) {
			exit();
        }	

	}


	//获取微信认证
	function getaccess_token(){
		return get_access_token();
	}
	
	function curlGet($url, $method = 'get', $data = '')
    {		
        $ch = curl_init();
        $headers = array('Accept-Charset: utf-8');
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, strtoupper($method));
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (compatible;MSIE 5.01;Windows NT 5.0)');
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $temp = curl_exec($ch);
        return $temp;
    }
	
	//回复多客服消息,自动分配一个在线客服
    private function transmitService($object)
    {
		if($config["model"] == 1){
			$xmlTpl = "<xml>
	<ToUserName><![CDATA[%s]]></ToUserName>
	<FromUserName><![CDATA[%s]]></FromUserName>
	<CreateTime>%s</CreateTime>
	<MsgType><![CDATA[transfer_customer_service]]></MsgType>
	</xml>";
			$result = sprintf($xmlTpl, $object["FromUserName"], $object["ToUserName"], time());
			echo $result;
		}
    }
	 
	
	//回复多客服消息(指定客服)
    private function transmitServiceZD($object,$kf)
    {
		$config = getAddonConfig ( 'YouaskService' ); // 获取后台插件的配置参数	
		if($config["model"] == 1){	
			$xmlTpl = "<xml>
	<ToUserName><![CDATA[%s]]></ToUserName>
	<FromUserName><![CDATA[%s]]></FromUserName>
	<CreateTime>%s</CreateTime>
	<MsgType><![CDATA[transfer_customer_service]]></MsgType>
	<TransInfo>
			<KfAccount>%s</KfAccount>
	</TransInfo>
	</xml>";
			$result = sprintf($xmlTpl, $object["FromUserName"], $object["ToUserName"], time(),$kf);
			echo $result;
		}
    }

    //多客服关闭或者没有反应的时候转到图灵机器人
	public function zjtuling($dataArr, $keywordArr = array()){

	    // 以上插件未识别之后，则默认使用图灵机器人插件
        $config = getAddonConfig ( 'Tuling' ); // 获取后台插件的配置参数	

        //未开启图灵机器人的时候，转到未识别回复
        if ($config["state"] == 0 && $dataArr['Content'] != 'reportLocation') {
		   	$info = M('auto_reply')->where(array('token'=>get_token(),'reply_scene'=>1))->find();

		     if (empty($info['content']) && $info['group_id'] ==0
		      && $info['image_id'] ==0 && $info['image_material'] ==0 
		      && $info['voice_id'] ==0 && $info['video_id'] ==0) {
		     	$res = $this->replyText ( "所有插件无触发，请设置自定义回复中的消息自动回复内容(未识别回复)！" );
		     }

		     // 加载自动回复处理并反馈信息
		     require_once ONETHINK_ADDON_PATH . 'AutoReply' . '/Model/WeixinAddonModel.class.php';
		     $model = D ( 'Addons://' . 'AutoReply' . '/WeixinAddon' );
		     $model->replyMsg($info);
		     exit();
		}
		// 加载图灵机器人处理并反馈信息
		require_once ONETHINK_ADDON_PATH . 'Tuling' . '/Model/WeixinAddonModel.class.php';

		$model = D ( 'Addons://' . 'Tuling' . '/WeixinAddon' );

		$model->reply ( $dataArr, $keywordArr );

	}

    //处理语音钩子
	public function voice($data) {
		$this->reply ($data, $keywordArr = array());
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
}
