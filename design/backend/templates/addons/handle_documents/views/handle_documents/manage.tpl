{capture name="mainbox"}

<form action="{""|fn_url}" method="post" id="handle_documents_form" name="handle_documents_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_contents_handle_documents"}

{$c_url=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

{$rev=$smarty.request.content_id|default:"pagination_contents_handle_documents"}
{include_ext file="common/icon.tpl" class="icon-`$search.sort_order_rev`" assign=c_icon}
{include_ext file="common/icon.tpl" class="icon-dummy" assign=c_dummy}
{$document_statuses=""|fn_get_default_statuses:true}
{$has_permission = fn_check_permissions("handle_documents", "update_status", "admin", "POST")}

{if $handle_documents}
    {capture name="handle_documents_table"}
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-middle table--relative table-responsive">
            <thead
                data-ca-bulkedit-default-object="true"
                data-ca-bulkedit-component="defaultObject"
            >
            <tr>
                <th width="6%" class="left mobile-hide">
                    {include file="common/check_items.tpl" is_check_disabled=!$has_permission check_statuses=($has_permission) ? $document_statuses : '' }

                    <input type="checkbox"
                        class="bulkedit-toggler hide"
                        data-ca-bulkedit-disable="[data-ca-bulkedit-default-object=true]"
                        data-ca-bulkedit-enable="[data-ca-bulkedit-expanded-object=true]"
                    />
                </th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("document")}{if $search.sort_by === "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=user_login&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("user_login")}{if $search.sort_by === "user_login"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=category&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("category")}{if $search.sort_by === "category"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=description&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("description")}{if $search.sort_by === "description"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="10%" class="mobile-hide"><a class="cm-ajax" href="{"`$c_url`&sort_by=type&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("type")}{if $search.sort_by === "type"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("creation_date")}{if $search.sort_by === "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>

                <th width="6%" class="mobile-hide">&nbsp;</th>
                <th width="10%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status")}{if $search.sort_by === "status"}{$c_icon nofilter}{/if}</a></th>
            </tr>
            </thead>
            {foreach from=$handle_documents item=document}
            <tr class="cm-row-status-{$document.status|lower} cm-longtap-target"
                {if $has_permission}
                    data-ca-longtap-action="setCheckBox"
                    data-ca-longtap-target="input.cm-item"
                    data-ca-id="{$document.document_id}"
                {/if}
            >
                {$allow_save=$document|fn_allow_save_object:"handle_documents"}

                {if $allow_save}
                    {$no_hide_input="cm-no-hide-input"}
                {else}
                    {$no_hide_input=""}
                {/if}
                <td width="6%" class="left mobile-hide">
                    <input type="checkbox" name="document_ids[]" value="{$document.document_id}" class="cm-item {$no_hide_input} cm-item-status-{$document.status|lower} hide" /></td>
                <td class="{$no_hide_input}" data-th="{__("document")}">
                    <a class="row-status" href="{"handle_documents.update?document_id=`$document.document_id`"|fn_url}">{$document.document}</a>
                    {include file="views/companies/components/company_name.tpl" object=$document}
                </td>
                <td class="{$no_hide_input}" data-th="{__("user_login")}">
                    <a class="row-status" href="{"handle_documents.update?document_id=`$document.document_id`"|fn_url}">{$document.user_login}</a>
                </td>
                <td class="{$no_hide_input}" data-th="{__("category")}">
                {foreach $document.category_name as $category}
                    <a class="row-status" href="{"handle_documents.update?document_id=`$document.document_id`"|fn_url}">{$category}</a>
                {/foreach}
                </td>

                <td class="{$no_hide_input}" data-th="{__("description")}">
                    <a class="row-status" style="white-space:pre" href="{"handle_documents.update?document_id=`$document.document_id`"|fn_url}">{$document.description}</a>
                </td>
                <td width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">
                    {if $document.type == "I"}{__("inside_type")}{else}{__("outside_type")}{/if}
                </td>
                <td width="15%" data-th="{__("creation_date")}">
                    {$document.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
                </td>

                <td width="6%" class="mobile-hide">
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("edit") href="handle_documents.update?document_id=`$document.document_id`"}</li>
                    {if $allow_save}
                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="handle_documents.delete?document_id=`$document.document_id`" method="POST"}</li>
                    {/if}
                    {/capture}
                    <div class="hidden-tools">
                        {dropdown content=$smarty.capture.tools_list}
                    </div>
                </td>
                <td width="10%" class="right" data-th="{__("status")}">
                    {include file="common/select_popup.tpl" id=$document.document_id status=$document.status hidden=true object_id_name="document_id" table="handle_documents" popup_additional_class="`$no_hide_input` dropleft"}
                </td>
            </tr>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="handle_documents_form"
        object="handle_documents"
        items=$smarty.capture.handle_documents_table
        has_permissions=$has_permission
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_contents_handle_documents"}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="handle_documents.add" prefix="top" hide_tools="true" title=__("add_document") icon="icon-plus"}
{/capture}

</form>

{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" dispatch="handle_documents.manage" view_type="handle_documents"}
    {include file="addons/handle_documents/views/handle_documents/components/handle_documents_search_form.tpl" dispatch="handle_documents.manage"}
{/capture}

{$page_title = __("handle_documents")}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}