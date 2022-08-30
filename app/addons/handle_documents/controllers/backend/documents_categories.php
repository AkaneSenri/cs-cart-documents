<?php 

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode === 'manage') {
    $categories = fn_get_document_categories();

    Tygh::$app['view']->assign('categories', $categories);
}

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

    fn_trusted_vars('documents_categories', 'category_data');
    $suffix = '';

    if ($mode == 'm_delete') {
        foreach ($_REQUEST['category_ids'] as $v) {
            fn_delete_document_category_by_id($v);
        }

        $suffix = '.manage';
    }

    if (
        $mode === 'm_update_statuses'
        && !empty($_REQUEST['category_ids'])
        && is_array($_REQUEST['category_ids'])
        && !empty($_REQUEST['status'])
    ) {
        $status_to = (string) $_REQUEST['status'];

        if (defined('AJAX_REQUEST')) {
            $redirect_url = fn_url('documents_categories.manage');
            if (isset($_REQUEST['redirect_url'])) {
                $redirect_url = $_REQUEST['redirect_url'];
            }
            Tygh::$app['ajax']->assign('force_redirection', $redirect_url);
            Tygh::$app['ajax']->assign('non_ajax_notifications', true);
            return [CONTROLLER_STATUS_NO_CONTENT];
        }
    }

if ($mode == 'update') {
    $category_id = fn_documents_categories_update_category($_REQUEST['category_data'], $_REQUEST['category_id'], DESCR_SL);

    $suffix = ".manage";
}

if ($mode == 'delete') {
    if (!empty($_REQUEST['category_id'])) {
        fn_delete_document_category_by_id($_REQUEST['category_id']);
    }

    $suffix = '.manage';
}

return array(CONTROLLER_STATUS_OK, 'documents_categories' . $suffix);
}

if ($mode == 'update') {
    $category = fn_get_document_category_data($_REQUEST['category_id'], DESCR_SL);

    if (empty($category)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    Registry::set('navigation.tabs', array (
        'general' => array (
            'title' => __('general'),
            'js' => true
        ),
    ));

    Tygh::$app['view']->assign('category', $category);
}