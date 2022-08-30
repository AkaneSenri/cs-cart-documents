<?php

use Tygh\Registry;
use Tygh\Languages\Languages;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_get_documents($params = array(), $items_per_page = 0)
{
    $default_params = array(
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    if (AREA == 'C') {
        $params['status'] = 'A';
    }

    $sortings = array(
        'timestamp' => '?:handle_documents.timestamp',
        'name' => '?:handle_documents.document',
        'type' => '?:handle_documents.type',
        'status' => '?:handle_documents.status',
        'description' => '?:handle_documents.description', 
        'user_login' => '?:users.user_login'
    );

    $condition = $limit = $join = '';

    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }

    $sorting = db_sort($params, $sortings, 'name', 'asc');

    if (!empty($params['item_ids'])) {
        $condition .= db_quote(' AND ?:handle_documents.document_id IN (?n)', explode(',', $params['item_ids']));
    }

    if (!empty($params['name'])) {
        $condition .= db_quote(' AND ?:handle_documents.document LIKE ?l', '%' . trim($params['name']) . '%');
    }

    if (!empty($params['type'])) {
        $condition .= db_quote(' AND ?:handle_documents.type = ?s', $params['type']);
    }

    if (!empty($params['status'])) {
        $condition .= db_quote(' AND ?:handle_documents.status = ?s', $params['status']);
    }

    if (!empty($params['user_login'])) {
        $condition .= db_quote(' AND ?:handle_documents.user_login = ?s', $params['user_login']);
    }
    
    if (!empty($params['period']) && $params['period'] != 'A') {
        list($params['time_from'], $params['time_to']) = fn_create_periods($params);
        $condition .= db_quote(' AND (?:handle_documents.timestamp >= ?i AND ?:handle_documents.timestamp <= ?i)', $params['time_from'], $params['time_to']);
    }

    if (!empty($params['description'])) {
        $condition .= db_quote(' AND ?:handle_documents.description = ?s', $params['description']);
    }

    $fields = array (
        '?:handle_documents.document_id',
        '?:handle_documents.document',
        '?:handle_documents.type',
        '?:handle_documents.status',
        '?:handle_documents.timestamp',
        '?:handle_documents.description',
        '?:users.user_login',
        '?:handle_documents.user_id'
    );

    $join .= db_quote(' LEFT JOIN ?:users ON ?:users.user_id = ?:handle_documents.user_id ');
 
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:handle_documents $join WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $handle_documents = db_get_hash_array(
        "SELECT ?p FROM ?:handle_documents" . 
        $join .
        "WHERE 1 ?p ?p ?p",
        'document_id', implode(', ', $fields), $condition, $sorting, $limit
    );

    if (!empty($params['item_ids'])) {
        $handle_documents = fn_sort_by_ids($handle_documents, explode(',', $params['item_ids']), 'document_id');
    }

    if (!empty($handle_documents)) {
        foreach ($handle_documents as &$document) {
            $document['category_id'] = db_get_fields("SELECT category_id FROM ?:handle_documents_categories_links
            WHERE document_id = ?i", $document['document_id']); 
            
            if (!empty($document['category_id'])) {
                foreach ($document['category_id'] as $category_id) {
                    $document['category_name'][] = db_get_field("SELECT name FROM ?:handle_documents_categories WHERE category_id = ?i", $category_id);
                }
            }
        }
    }
    
    return array($handle_documents, $params);
}

function fn_get_document_data($document_id)
{

    $fields = array();
    $condition = '';

    $fields = array (
        '?:handle_documents.document_id',
        '?:handle_documents.status',
        '?:handle_documents.document',
        '?:handle_documents.type',
        '?:handle_documents.description',
        '?:handle_documents.timestamp',
        '?:handle_documents.user_id'
    );

    $condition = db_quote("WHERE ?:handle_documents.document_id = ?i", $document_id);
    $condition .= (AREA == 'A') ? '' : " AND ?:handle_documents.status IN ('A', 'H') ";

    $document = db_get_row("SELECT " . implode(", ", $fields) . " FROM ?:handle_documents"." $condition"); 

    if (!empty($document)) { 
        $document['user_login'] = db_get_field("SELECT user_login FROM ?:users WHERE user_id = ?i", $document['user_id']);
        $document['categories_ids'] = db_get_fields("SELECT category_id FROM ?:handle_documents_categories_links WHERE document_id = ?i", $document_id);
    }

    return $document;
}

function fn_get_document_categories()
{
    $categories = db_get_array("SELECT * FROM ?:handle_documents_categories");

    return $categories;
}

function fn_get_document_category_data($category_id)
{

    $fields = array();
    $condition = '';

    $fields = array (
        '?:handle_documents_categories.category_id',
        '?:handle_documents_categories.status',
        '?:handle_documents_categories.name'
    );

    $condition = db_quote("WHERE ?:handle_documents_categories.category_id = ?i", $category_id);
    $condition .= (AREA == 'A') ? '' : " AND ?:handle_documents_categories.status IN ('A', 'H') ";

    $category = db_get_row("SELECT " . implode(", ", $fields) . " FROM ?:handle_documents_categories "." $condition");

    return $category;
}

function fn_delete_document_by_id($document_id)
{
    if (!empty($document_id)) {
        db_query("DELETE FROM ?:handle_documents WHERE document_id = ?i", $document_id);
    }
}

function fn_delete_document_category_by_id($category_id)
{
    if (!empty($category_id)) {
        db_query("DELETE FROM ?:handle_documents_categories WHERE category_id = ?i", $category_id);
    }
}

function fn_handle_documents_update_document(&$data, $document_id)
{

    if (!empty($document_id)) {

        db_query("DELETE FROM ?:handle_documents_categories_links WHERE document_id = ?i", $document_id);

        if (!empty($data['category_ids'])) {
            foreach ($data['category_ids'] as $category_id) {
                $insert_data = [
                    'document_id' => $document_id,
                    'category_id' => $category_id
                ];
                db_query("INSERT INTO ?:handle_documents_categories_links ?e", $insert_data);
            }
        }

        $data['files']['object_id'] = $document_id;
        $data['files']['object_type'] = "document";

        db_query("UPDATE ?:handle_documents SET ?u WHERE document_id = ?i", $data, $document_id);

    } else {

        $data['user_id'] = $_SESSION['auth']['user_id'];
        
        $data['timestamp'] = time();
        
        $document_id = db_query("INSERT INTO ?:handle_documents ?e", $data);

        foreach ($data['category_ids'] as $category_id) {
            $insert_data = [
                'document_id' => $document_id,
                'category_id' => $category_id
            ];
            db_query("INSERT INTO ?:handle_documents_categories_links ?e", $insert_data);
        }

    }

    fn_update_attachments($data['files'], $data['files']['attachment_id'], "document", $document_id, $type = 'M', $files = []);
    
    return $document_id;
}

function fn_documents_categories_update_category($data, $category_id)
{
    if (!empty($category_id)) {
        db_query("UPDATE ?:handle_documents_categories SET ?u WHERE category_id = ?i", $data, $category_id);
    } else {
        $category_id = db_query("REPLACE INTO ?:handle_documents_categories ?e", $data);
    }
    
    return $category_id;
}