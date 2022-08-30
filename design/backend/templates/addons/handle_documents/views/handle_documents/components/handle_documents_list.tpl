{include file="common/pagination.tpl" div_id="pagination_`$smarty.request.data_id`"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{assign var="rev" value="pagination_`$smarty.request.data_id`"|default:"pagination_contents"}

{include_ext file="common/icon.tpl" class="icon-`$search.sort_order_rev`" assign=c_icon}
{include_ext file="common/icon.tpl" class="icon-dummy" assign=c_dummy}

{if $handle_documents}
<input type="hidden" id="add_document_id" name="document_id" value=""/>

<div class="table-responsive-wrapper">
    <table width="100%" class="table table-middle table--relative table-responsive">
    <thead>
    <tr>
        {hook name="handle_documents_list:table_head"}
        <th class="center" width="1%">
            {include file="common/check_items.tpl"}
        </th>
        <th width="70%"><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("document")}{if $search.sort_by === "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("creation_date")}{if $search.sort_by === "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        {/hook}
    </tr>
    </thead>
    {foreach from=$handle_documents item=document}
    <tr>
        {hook name="handle_documents_list:table_body"}
        <td>
            <input type="checkbox" name="{$smarty.request.checkbox_name|default:"handle_documents_ids"}[]" value="{$document.document_id}" class="cm-item mrg-check" /></td>
        <td id="document_{$document.document_id}" width="80%" data-th="{__("document")}">{$document.document}</td>
        <td width="20%" data-th="{__("creation_date")}">
            {$document.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
        </td>
        {/hook}
    </tr>
    {/foreach}
    </table>
</div>

{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_`$smarty.request.data_id`"}
