<div class="sidebar-row">
<h6>{__("admin_search_title")}</h6>
<form name="document_search_form" action="{""|fn_url}" method="get" class="{$form_meta}">
    {if $smarty.request.redirect_url}
        <input type="hidden" name="redirect_url" value="{$smarty.request.redirect_url}" />
    {/if}

    {if $selected_section != ""}
        <input type="hidden" id="selected_section" name="selected_section" value="{$selected_section}" />
    {/if}

    {if $put_request_vars}
        {array_to_fields data=$smarty.request skip=["callback"]}
    {/if}

    {$extra nofilter}

    {capture name="simple_search"}
    <div class="sidebar-field">
        <label for="elm_name">{__("document")}</label>
        <input type="text" id="elm_name" name="name" size="20" value="{$search.name}" onfocus="this.select();" class="input-text" />
    </div>

        <div class="sidebar-field">
            <label for="elm_type">{__("type")}</label>
            <div class="controls">
                <select name="type" id="elm_type">
                    <option value="">{__("all")}</option>
                    <option {if $search.type == "I"}selected="selected"{/if} value="I">{__("inside_type")}</option>
                    <option {if $search.type == "O"}selected="selected"{/if} value="O">{__("outside_type")}</option>
                </select>
            </div>
        </div>


    <div class="sidebar-field">
        <label for="elm_type">{__("status")}</label>
        {assign var="items_status" value=""|fn_get_default_statuses:true}
        <div class="controls">
            <select name="status" id="elm_type">
                <option value="">{__("all")}</option>
                {foreach from=$items_status key=key item=status}
                    <option value="{$key}" {if $search.status == $key}selected="selected"{/if}>{$status}</option>
                {/foreach}
            </select>
        </div>
    </div>
    {/capture}

    {capture name="advanced_search"}
    <div class="group form-horizontal">
        <div class="control-group">
            <label class="control-label">{__("period")}</label>
            <div class="controls">
                {include file="common/period_selector.tpl" period=$search.period form_name="handle_documents_search_form"}
            </div>
        </div>
    </div>

    {/capture}

    {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="tags"}

    </form>
</div>