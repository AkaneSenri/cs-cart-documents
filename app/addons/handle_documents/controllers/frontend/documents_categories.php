<?php 

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode === 'manage') {
    $categories = fn_get_document_categories();

    Tygh::$app['view']->assign('categories', $categories);
}
