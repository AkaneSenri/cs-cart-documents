<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'manage') {

    list($handle_documents, $params) = fn_get_documents($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign(array(
        'handle_documents'  => $handle_documents,
        'search' => $params
    ));
}

if ($mode == 'view') {
    $_REQUEST['object_type'] = "document";
    $attachments = fn_get_attachments($_REQUEST['object_type'], $_REQUEST['document_id'], 'M');

    Registry::set('navigation.tabs.attachments', array (
        'title' => __('attachments'),
        'js' => true
    ));

    Tygh::$app['view']->assign('attachments', $attachments);

        $document = fn_get_document_data($_REQUEST['document_id']);

    if (empty($document)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    Tygh::$app['view']->assign('document', $document);
}
