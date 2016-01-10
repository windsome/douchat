<?php
        	
namespace Addons\Idioms\Model;
use Home\Model\WeixinModel;
        	
/**
 * Idioms的微信模型
 */
class WeixinAddonModel extends WeixinModel{
	function reply($dataArr, $keywordArr = array()) {
		$config = getAddonConfig ( 'Idioms' );                 // 获取后台插件的配置参数	
		$api='http://i.itpk.cn/api.php?question=@cy';			// 成语接龙接口地址
		// 当用户触发成语接龙插件时
		if($dataArr['Content']=='成语接龙' || $dataArr['Content']=='Idioms'){
			$keywordArr['step']='input';		// 定义消息上下文的判断标识
			beginContext('Idioms',$keywordArr);			// 设置消息上下文
			replyText('请输入一个成语，比如：一马当先');		// 进行第一次响应
		}
		// 用户的下一次输入处于消息上下文中
		if($keywordArr['step']=='input'){
			if($dataArr['Content']=='退出'){
				// 不设置消息上下文，则用户的下一次输入不再处于消息上下文中
				replyText('你已退出成语接龙模式，再次回复【成语接龙】即可进入~');
				return false;
			}
			// 将用户输入关键词提交到成语接龙接口，获得接口返回内容
			$reply=file_get_contents($api.$dataArr['Content']);
			// 如果用户输入的成语不符合规则
			if($reply=='别来骗人家，不是随便打4个字就是成语哒！' || $reply=='成语必须为4个汉字'){
				$keywordArr['step']='input';		// 定义消息上下文的判断标识
				beginContext('Idioms',$keywordArr);		// 继续设置消息上下文
				replyText($reply."\n".'重新输入一个成语开始接龙,输入【退出】退出成语接龙');
			}else{		// 用户输入的成语是标准成语
				$keywordArr['step']='input';		// 定义消息上下文的判断标识
				beginContext('Idioms',$keywordArr);		// 继续设置消息上下文
				replyText($reply);
			}
		}
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
}
        	