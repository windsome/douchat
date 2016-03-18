<?php

namespace Addons\Farm\Controller;
use Home\Controller\AddonsController;

class FarmController extends AddonsController{
    function _initialize() {
        define ('FARM_TEMPLETE_PATH', ONETHINK_ADDON_PATH . 'Farm/View/default/Farm');
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

    function buyer () {
    }

    function seller () {
    }

    function deviceScan () {
    }

    function deviceList () {
        $this->display ();
    }

    function deviceAlert () {
    }
}
