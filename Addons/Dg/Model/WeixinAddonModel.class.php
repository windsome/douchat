<?php
        	
namespace Addons\Dg\Model;
use Home\Model\WeixinModel;
        	
/**
 * Dg的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'Dg' ); // 获取后台插件的配置参数
		// 其中token和openid这两个参数一定要传，否则程序不知道是哪个微信用户进入了系统
		$param ['token'] = get_token ();
		$param ['openid'] = get_openid ();
		$keyword=$keywordArr ['keyword'];//设置的关键词
		$myword=trim($dataArr ['Content']);//用户输入的内容
		$myword=str_replace($keyword,'',$myword);//过滤匹配词
		if(empty($myword) || empty($keyword)){
			$randgqinfoarr = $this->getBaiDurand();//随机歌曲
		 	$songName = $randgqinfoarr['songName'];
		 	$artistName = $randgqinfoarr['artistName'];
		 	$songLink = $this->getBaiDugqurl($randgqinfoarr['songLink']);
			$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
		}elseif($keyword=='点歌'){
            $arr = $this->getBaiDugqlist($myword);
            $mygqinfoarr=$this->getBaiDugqinfo($arr['0']['song_id']);
		 	$songName = $mygqinfoarr['songName'];
		 	$artistName = $mygqinfoarr['artistName'];
		 	$songLink = $this->getBaiDugqurl($mygqinfoarr['songLink']);
			$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
        	$this->replyText ( $msg );
		}else{
			$this->replyText("系统指令出错\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
		}
	} 
	//获取搜索歌名
	function getBaiDugqlist($gq) {
		$param ['from'] = 'qianqian';
		$param ['version'] = '2.1.0';
		$param ['method'] = 'baidu.ting.search.common';
		$param ['format'] = 'json';
		$param ['query'] = $gq;
		$param ['page_no'] = '1';
		$param ['page_size'] = '200';
		$url = 'http://tingapi.ting.baidu.com/v1/restserver/ting?'. http_build_query ( $param );
		$content = file_get_contents ( $url );
		$content = json_decode ( $content, true );
		if (!empty($content['song_list'])) {
			return $content['song_list'];
		}else{
			$this->replyText("系统没有找到相关歌曲\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
		}

	}
	//获取ID歌曲信息
	function getBaiDugqinfo($songIds) {
		$param ['songIds'] = $songIds;
		$url = 'http://ting.baidu.com/data/music/links?'. http_build_query ( $param );
		$content = file_get_contents ( $url );
		$content = json_decode ( $content, true );
		if ($content['errorCode'] == 22000) {
			return $content['data']['songList']['0'];
		}else{
			$this->replyText("系统没有找到相关歌曲\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
		}
	}

	//随机音乐
	function getBaiDurand() {
		$gqlist=$this->getBaiDudt('public_tuijian_suibiantingting');
		shuffle($gqlist);//调用现成的数组随机排列函数
		$gqlist = array_slice($gqlist,0,1);//截取前$limit个
		$gqinfo = $this->getBaiDugqinfo($gqlist['0']['songid']);
		return $gqinfo;
	}
	//随机音乐列表
	function getBaiDudt($dt) {
		$param ['from'] = 'qianqian';
		$param ['version'] = '2.1.0';
		$param ['method'] = 'baidu.ting.radio.getChannelSong';
		$param ['format'] = 'json';
		$param ['pn'] = '0';
		$param ['rn'] = '100';
		$param ['channelname'] = 'public_tuijian_rege';
		$url = 'http://tingapi.ting.baidu.com/v1/restserver/ting?'. http_build_query ( $param );
		$content = file_get_contents ( $url );
		$content = json_decode ( $content, true );
		if ($content['error_code'] == 22000) {
			return($content['result']['songlist']);
		}else{
			$this->replyText("系统没有找到相关音乐\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
		}
	}

	//歌曲URL处理
	function getBaiDugqurl($songurl) {
		if(strrpos($songurl,'&')){
			$songurl = substr($songurl,0,strrpos($songurl,'&'));
		}
		return $songurl;
	}

	// 关注公众号事件
	public function subscribe() {
		return true;
	}
	
	// 取消关注公众号事件
	public function unsubscribe() {
		return true;
	}
	
	// 扫描带参数二维码事件
	public function scan() {
		return true;
	}
	
	// 上报地理位置事件
	public function location() {
		return true;
	}
	
	// 自定义菜单事件
	public function click() {
		return true;
	}	

	// 关键词处理
	public function text( $data ){

		$config = getAddonConfig('Dg');
		// replyText($config['keyword']);

		if ( $this->chstr($data['Content'], $config['keyword']) ){


			if ( $config['keyword'] ) {
				$keyword = $config['keyword'];
			} else {
				$keyword = '点歌';
			}

			$myword=trim($data ['Content']);//用户输入的内容
			$myword=str_replace($keyword,'',$myword);//过滤匹配词
			if(empty($myword) || empty($keyword)){
				$randgqinfoarr = $this->getBaiDurand();//随机歌曲
			 	$songName = $randgqinfoarr['songName'];
			 	$artistName = $randgqinfoarr['artistName'];
			 	$songLink = $this->getBaiDugqurl($randgqinfoarr['songLink']);
				$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
			}elseif($keyword==$config['keyword']){
	            $arr = $this->getBaiDugqlist($myword);
	            $mygqinfoarr=$this->getBaiDugqinfo($arr['0']['song_id']);
			 	$songName = $mygqinfoarr['songName'];
			 	$artistName = $mygqinfoarr['artistName'];
			 	$songLink = $this->getBaiDugqurl($mygqinfoarr['songLink']);
				$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
	        	$this->replyText ( $msg );
			}else{
				 $this->replyText("系统指令出错\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
			}

		}
	}

	public function voice($data) {
		//点个插件voice 接收语音时，不要加上“点歌”，否者语音的话，后面的插件无法再识别语言（多客服）
		$data['Content'] = substr($data['Recognition'],0,strlen($data['Recognition'])-3); 
		
		$config = getAddonConfig('Dg');
		// replyText($config['keyword']);

		if ( $this->chstr($data['Content'], $config['keyword']) ){


			if ( $config['keyword'] ) {
				$keyword = $config['keyword'];
			} else {
				$keyword = '点歌';
			}

			$myword=trim($data ['Content']);//用户输入的内容
			$myword=str_replace($keyword,'',$myword);//过滤匹配词
			if(empty($myword) || empty($keyword)){
				$randgqinfoarr = $this->getBaiDurand();//随机歌曲
			 	$songName = $randgqinfoarr['songName'];
			 	$artistName = $randgqinfoarr['artistName'];
			 	$songLink = $this->getBaiDugqurl($randgqinfoarr['songLink']);
				$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
			}elseif($keyword==$config['keyword']){
	            $arr = $this->getBaiDugqlist($myword);
	            $mygqinfoarr=$this->getBaiDugqinfo($arr['0']['song_id']);
			 	$songName = $mygqinfoarr['songName'];
			 	$artistName = $mygqinfoarr['artistName'];
			 	$songLink = $this->getBaiDugqurl($mygqinfoarr['songLink']);
				$this->replyMusicnothumb($songName, $artistName, $songLink, $songLink);
	        	$this->replyText ( $msg );
			}else{
				 $this->replyText("系统指令出错\n发送【点歌】随机听歌，\n发送【点歌+歌曲名】点歌");
			}

		}
	}

	function chstr($str,$in){

	    $tmparr = explode($in,$str);

	    if(count($tmparr)>1){

	        return true;

	    }else{

	        return false;

	    }

	}
}
        	