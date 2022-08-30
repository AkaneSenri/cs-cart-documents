<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

    if ($mode == 'm_delete') {
        foreach ($_REQUEST['document_ids'] as $document_id) {
            fn_delete_document_by_id($document_id);
        }

        $suffix = '.manage';
    }

    if ($mode == 'update') {
        $document_id = fn_handle_documents_update_document($_REQUEST['document_data'], $_REQUEST['document_id']);

        $suffix = ".update?document_id=" . $document_id;
    }

    if ($mode == 'delete') {
        if (!empty($_REQUEST['document_id'])) {
            fn_delete_document_by_id($_REQUEST['document_id']);
        }

        $suffix = '.manage';
    }

    return array(CONTROLLER_STATUS_OK, 'handle_documents' . $suffix);
}

if ($mode == 'update') {
    $document = fn_get_document_data($_REQUEST['document_id'], DESCR_SL);

    if (empty($document)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    Tygh::$app['view']->assign('document', $document);
}

if ($mode == 'manage') {

    list($handle_documents, $params) = fn_get_documents($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign(array(
        'handle_documents'  => $handle_documents,
        'search' => $params
    ));
}

if ($mode === 'update') {

    if (!empty($_REQUEST['document_id'])) {
        $document_id = $_REQUEST['document_id'];

        $document = fn_get_document_data($document_id);
        if (!empty($document['category_ids']) && !is_array($document['category_ids'])) {
            $document['category_ids'] = explode(',', $document['category_ids']);
        }

    } else {
        return [CONTROLLER_STATUS_REDIRECT, 'documents.add'];
    }

    Tygh::$app['view']->assign('document_id', $document_id);
}

if ($mode == 'update') {
    if (!empty($_REQUEST['document_id'])) {
        $attachments = fn_get_attachments("document", $_REQUEST['document_id'], 'M');

        Registry::set('navigation.tabs.attachments', array (
            'title' => __('attachments'),
            'js' => true
        ));

        Tygh::$app['view']->assign('attachments', $attachments);
    }
}

