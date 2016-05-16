<?php

namespace Addons\Farm\Controller;
use Home\Controller\AddonsController;

class FarmController extends AddonsController{
    function _initialize() {
        define ('FARM_TEMPLETE_PATH', ONETHINK_ADDON_PATH . 'Farm/View/default/Farm');
        
        $url_detail = U('addon/Farm/Farm/detail', array('token'=>get_token()), '');
        error_log("\nwindsome ".__METHOD__.' '.__LINE__.' ,url='.$url_detail, 3, PHP_LOG_PATH);
        $this->assign ('FARM_URL_DETAIL1', $url_detail);
    }

    function latestNews () {
        $this->display ( FARM_TEMPLETE_PATH . 'wx/latestNews.html' );
    }

    function demo () {
        $this->display ();
    }

    function react () {
        $this->display ();
    }

    function charts () {
        $this->display ();
    }

    function deviceScan () {
        $this->display ();
    }

    function deviceList () {
        $this->display ();
    }

    function detail () {
        $this->display ();
    }

    function iotPage () {
        $this->display ();
    }

    function iotPage2 () {
        $this->display ();
    }

    function iotPage3 () {
        $this->display ();
    }

    function testPage () {
        $this->display ();
    }

    function testPage2 () {
        $this->display ();
    }

}
