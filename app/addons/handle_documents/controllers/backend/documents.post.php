<?php 


use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode == 'update') {
    // Assign attachments files for products
    $attachments = fn_get_documents_attachments('document', $_REQUEST['document_id'], 'M', DESCR_SL);

    Registry::set('navigation.tabs.attachments', array (
        'title' => __('attachments'),
        'js' => true
    ));

    Tygh::$app['view']->assign('attachments', $attachments);
}
