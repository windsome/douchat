<?php

namespace Home\Controller;

/**
 * 主题皮肤完美切换解决方案
 *
 * @author 梦醒 <1248202785@qq.com>
 */
class TemplateController extends HomeController {

    //模板列表页
    public function main()
    {
        $temp = array();
        //路径可以用常量代替
        $dirs = $this->dirtree('./Application/Home/View');
        //dump($dirs );
        foreach ($dirs as $value) {
            $xml ='./Application/Home/View/'.$value . '/config.xml';
            //dump($xml);
            $sty = file_get_contents($xml);
            $style = $this -> toArray($sty);
            //dump($style['name']);
            $data['name'] = $style['name'][0];
            $data['author'] = $style['author'][0];
            $data['image'] = $style['image'][0];
            $data['email'] = $style['email'][0];
            $data['url'] = './Application/Home/View/'.$value;
            $data['current'] = $value;
            $temp[] = $data;
        }    
        
        $this->assign('data', $temp);
        $this->assign('temp', session ( 'DEFAULT_THEME' ));
        $this->display();
    }

/**
 * 选择模板
 * @author 梦醒 
 * @param  [string] $path [目录路径]
 * @return [array]       [目录结构数组]
 */

    public function selectStyle(){
        $data['temp'] = $_POST['temp'];
        $map['uid'] = session('mid');
        $result = M('user')->where($map)->save($data);
        if ($result) {
            session( 'DEFAULT_THEME' , null );
            session( 'DEFAULT_THEME' , $_POST['temp'] );
        }
        
    }

/**
 * 获取目录的结构
 * @author 梦醒 
 * @param  [string] $path [目录路径]
 * @return [array]       [目录结构数组]
 */

 function dirtree($path) {
    $handle = opendir($path);
    $itemArray=array();
    while (false !== ($file = readdir($handle))) {
        if (($file=='.')||($file=='..')){
        }elseif (is_dir($path.$file)) {
                try {
                    $dirtmparr=dirtree($path.$file.'/');
                } catch (Exception $e) {
                    $dirtmparr=null;
                };
                $itemArray[$file]=$dirtmparr;
            }else{
                array_push($itemArray, $file);
            }
        }
    return $itemArray;
 }

 
/**
 * 解析XML文件
 * @author 梦醒 
 * @param  type $xml
 * @return type
 */

    static private function compile($xml)
    {
        $xmlRes = xml_parser_create('utf-8');
        xml_parser_set_option($xmlRes, XML_OPTION_SKIP_WHITE, 1);
        xml_parser_set_option($xmlRes, XML_OPTION_CASE_FOLDING, 0);
        xml_parse_into_struct($xmlRes, $xml, $arr, $index);
        xml_parser_free($xmlRes);
        return $arr;
    }


/**
 * 将XML字符串或文件转为数组
 * @author 梦醒 
 * @param  string $xml XML字符串或XML文件
 * @return array        解析后的数组
 */

    static public function toArray($xml)
    {
        $arrData = self::compile($xml);
        $k = 1;
        return $arrData ? self::getData($arrData, $k) : false;
    }


/**
 * 解析编译后的内容为数组
 * @author 梦醒 
 * @param  array $arrData 数组数据
 * @param int $i 层级
 * @return array    数组
 */

    static private function getData($arrData, &$i)
    {
        $data = array();
        for ($i = $i; $i < count($arrData); $i++) {
            $name = $arrData[$i]['tag'];
            $type = $arrData[$i]['type'];
            switch ($type) {
                case "attributes":
                    $data[$name]['att'][] = $arrData[$i]['attributes'];
                    break;
                case "complete": //内容标签
                    $data[$name][] = isset($arrData[$i]['value']) ? $arrData[$i]['value'] : '';
                    break;
                case "open": //块标签
                    $k = isset($data[$name]) ? count($data[$name]) : 0;
                    $data[$name][$k] = self::getData($arrData, ++$i);
                    break;
                case "close":
                    return $data;
            }
        }
        return $data;
    }


























}