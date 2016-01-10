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
		//判断微信用户发送的消息中的关键词
		$token = get_token();	
       		
        //location 是屏蔽用户上送地理位置信息
		if ($config["state"] == 1 && $content!='location') {
             if ($config["cxkey"] == $content) {
			  $this->getzxkflist($config,$token);
             }
          //先判断用户是否指定客服，否则发出自定义回复
		  $connectkf = $this->connectkf($content,$token,$config,$keywordArr,$dataArr);

		  //开启智能客服
		  if ($config ['model3'] == 1) {
		      $content = $this->_tuling($content,$config);
		      if ($content) {
			      exit ();
		      }
		  }

		  //开启多客服时的未识别自动回复
		  switch ($config ['type2']) {
			case '3' :
				$articles [0] = array (
						'Title' => $config ['title2'],
						'Description' => $config ['description2'],
						'PicUrl' => get_cover_url ( $config ['pic_url2'] ),
						'Url' => str_replace ( $sreach, $replace, $config ['url2'] ) 
				);
				$res = $this->replyNews ( $articles );
				break;
			 case '1' :
				$res = $this->replyText ( $config ['description2'] );
				break;
		   }
		}elseif ($config["state"] == 0 && $content!='location') {
          //开启智能客服
		  if ($config ['model3'] == 1) {
		      $content = $this->_tuling($content,$config);
		      if ($content) {
			      exit ();
		      }
		  }
		  //关闭多客服，关闭智能聊天时的自动回复
		  switch ($config ['type']) {
			case '3' :
				$articles [0] = array (
						'Title' => $config ['title'],
						'Description' => $config ['description'],
						'PicUrl' => get_cover_url ( $config ['pic_url'] ),
						'Url' => str_replace ( $sreach, $replace, $config ['url'] ) 
				);
				$res = $this->replyNews ( $articles );
				break;
			 case '1' :
				$res = $this->replyText ( $config ['description'] );
				break;
		   }


		}

	} 
	
	//转接人工客服
	public function connectkf($content,$token,$config,$keywordArr,$dataArr){
		//直接进入人工操作
		if($config["zrg"] == $content){			
		
			//判断是否有在线的客服,电脑优先，只有手机在线的被屏蔽掉
			$zxlists = $this->kfzxstate($config['model2']);

			$len = sizeof($zxlists);
			//$res = $this->replyText ($zxlists[0].'+'.$zxlists[1].'+'.$zxlists[2].'+'.$zxlists[3]);
			if($len !=0){
				//随机生成一个在线客服，再指定
				$kfaccount = $zxlists[rand(0,($len-1))];
				$this->transmitServiceZD($dataArr,$kfaccount);
                //系统随机分配在线客服（上面两句代码，可以用下面一句代替）
				$this->transmitService($dataArr);
			}else{
				$res = $this->replyText ($config ['kfbz']);
			}
			exit();
		}	   
	 
        $keywords=M('youaskservice_keyword');
		$keywordsValue = $keywords->where(" token='".$token."' and instr('".$content."',msgkeyword) >0 ")->order("id desc")->select();           
              
		//查询匹配方式
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
				if($v["zdtype"] == 0){
					$zxlists = $this->kfzxstate($config['model2']);
					//判断指定客服是否在线，否则返回提示
					if (in_array($v["msgkfaccount"], $zxlists)) {
                         $this->transmitServiceZD($dataArr,$v["msgkfaccount"]);
                     }else{
                     	$res = $this->replyText ($config ['zdkfbz']);
                     }
					
					exit();
				}else{
					//查询组
					$group =  M("youaskservice_group")->where(array("token"=>$token,"id"=>$v["kfgroupid"]))->find();
					if($group){ 
						$zxlists = $this->kfzxstate($config['model2']);
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
	//客服在线状态
	public function kfzxstate($model){
		//$res = $this->replyText ($model);
		header("Content-type: text/html; charset=utf-8"); 
				
		$access_token = $this->getaccess_token();	
		$url_get = 'https://api.weixin.qq.com/cgi-bin/customservice/getonlinekflist?access_token='.$access_token;				
		$json = $this->curlGet($url_get);			
		$json =json_decode($json);
		
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
    	$zxlists = $this->kfzxstate($config['model2']);
        $keywords=M('youaskservice_keyword');
        $map['token'] = $token;
        $map['msgstate'] = 1;
		$keywordsValue = $keywords->where($map)->order("id desc")->select();
         //$res = $this->replyText ('测试');
        foreach($keywordsValue as $v){

				if($v["zdtype"] == 0){
					//判断客服是否在线
					if (in_array($v["msgkfaccount"], $zxlists)) {
                         $zxkglist[] = $v["msgkeyword"]." ----> ".$v["kf_explain"];
                     }
                   
				}else{
					//查询组，判断组内客服是否在线
					$group =  M("youaskservice_group")->where(array("token"=>$token,"id"=>$v["kfgroupid"]))->find();
					if($group){ 
						$zxlists = $this->kfzxstate($config['model2']);
						$kfgroup = unserialize($group["groupdata"]);
						$zxkfgroup = array_intersect($zxlists,$kfgroup);
						$len = sizeof($zxkfgroup);
						if($len !=0){
						  $zxkglist[] = $v["msgkeyword"]." ----> ".$v["kf_explain"];
						}
						
					}
				}

        }
        $len = sizeof($zxkglist);
        if ($len == 0) {
        	$res = $this->replyText ($config ['kfbz']);
        	exit();
        }
        //$res = $this->replyText ('测试');
        //重建索引0，1，2...
        array_splice($zxkglist,0,0); 

        $zxkf_array = implode("\n        ",$zxkglist);
        //$res = $this->replyText ($zxkf_array);
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

	
	// 图灵机器人
	private function _tuling($keyword,$config) {
		$api_url = $config ['tuling_url'] . "?key=" . $config ['tuling_key'] . "&info=" . $keyword;
		//$this->replyText ( $api_url );
		$result = file_get_contents ( $api_url );
		$result = json_decode ( $result, true );
		if ($_GET ['format'] == 'test') {
			dump ( '图灵机器人结果：' );
			dump ( $result );
		}
		if ($result ['code'] > 40000) {
			if ($result ['code'] < 40008 && ! empty ( $result ['text'] )) {
				$this->replyText ( '图灵机器人请你注意：' . $result ['text'] );
			} elseif ($result ['code'] != 100000) {
				return false;
			}
		}
		switch ($result ['code']) {
			case '200000' :
				$text = $result ['text'] . ',<a href="' . $result ['url'] . '">点击进入</a>';
				$this->replyText ( $text );
				break;
			case '200000' :
				$text = $result ['text'] . ',<a href="' . $result ['url'] . '">点击进入</a>';
				$this->replyText ( $text );
				break;
			case '301000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['author'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '302000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['article'],
							'Description' => $info ['source'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '304000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['count'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '305000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['start'] . '--' . $info ['terminal'],
							'Description' => $info ['starttime'] . '--' . $info ['endtime'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '306000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['flight'] . '--' . $info ['route'],
							'Description' => $info ['starttime'] . '--' . $info ['endtime'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '307000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '308000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '309000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'] . ' 满意度 : ' . $info ['satisfaction'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '310000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['number'],
							'Description' => $info ['info'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '311000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			case '312000' :
				foreach ( $result ['list'] as $info ) {
					$articles [] = array (
							'Title' => $info ['name'],
							'Description' => '价格 : ' . $info ['price'],
							'PicUrl' => $info ['icon'],
							'Url' => $info ['detailurl'] 
					);
				}
				$this->replyNews ( $articles );
				break;
			default :
				if (empty ( $result ['text'] )) {
					return false;
				} else {
					$this->replyText ( $result ['text'] );
				}
		}
		
		return true;
	}


	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
}
        	