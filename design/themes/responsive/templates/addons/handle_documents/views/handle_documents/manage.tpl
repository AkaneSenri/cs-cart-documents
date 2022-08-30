{if $handle_documents}

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

    {if !$no_sorting}
        {include file="views/products/components/sorting.tpl"}
    {/if}

    {if !$show_empty}
        {split data=$handle_documents size=$columns|default:"2" assign="splitted_documents"}
    {else}
        {split data=$handle_documents size=$columns|default:"2" assign="splitted_documents" skip_complete=true}
    {/if}

    {math equation="100 / x" x=$columns|default:"2" assign="cell_width"}
    {if $item_number == "Y"}
        {assign var="cur_number" value=1}
    {/if}

    {if $settings.Appearance.enable_quick_view == 'Y'}
        {$quick_nav_ids = $handle_documents|fn_fields_from_multi_level:"document_id":"document_id"}
    {/if}
    <div class="grid-list">
        {strip}
            {foreach from=$splitted_documents item="sdocuments" name="sprod"}
                {foreach from=$sdocuments item="document" name="sdocuments"}
                    <div class="ty-column{$columns}">
                        {if $document}
                            {assign var="obj_id" value=$document.document_id}
                            {include file="common/product_data.tpl" document=$document}
                            {if $document.type == "O"}
                            <div class="table-responsive-wrapper longtap-selection">
                                <table class="table table-middle table--relative table-responsive">
                                <thead data-ca-bulkedit-default-object="true" data-ca-bulkedit-component="defaultObject">
                                    <tr>
                                        <th>{__("name")}</th>
                                        <th>{__("user_login")}</th>
                                        <th>{__("category")}</th>
                                        <th>{__("description")}</th>
                                        <th>{__("type")}</th>
                                        <th>{__("creation_date")}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">
                                            <a class="row-status" href="{"handle_documents.view?document_id=`$document.document_id`"|fn_url}">{$document.document}</a>
                                        </td>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">{$document.user_login}</td>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">
                                        {foreach $document.category_name as $category}
                                            {$category}</br>
                                        {/foreach}
                                        </td>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">{$document.description}</td>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">{$document.type}</td>
                                        <td style="text-align:center" width="10%" class="nowrap row-status {$no_hide_input} mobile-hide">{$document.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                {/foreach}
            {/foreach}
    {/strip}
    </div>
{if !$no_pagination}
    {include file="common/pagination.tpl"}
{/if}
    
{/if}
