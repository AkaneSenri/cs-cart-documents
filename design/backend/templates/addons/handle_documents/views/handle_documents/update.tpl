{script src="js/tygh/tabs.js"}

{if $document}
    {assign var="id" value=$document.document_id}
{else}
    {assign var="id" value=0}
{/if}

{$allow_save = $document|fn_allow_save_object:"documents"}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit{if !$allow_save || $hide_inputs} cm-hide-inputs{/if}" name="handle_documents_form" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
<input type="hidden" class="cm-no-hide-input" name="document_id" value="{$id}" />

<div class="tabs cm-j-tabs cm-track">
    <ul class="nav nav-tabs">
        <li class="active"><a>{__("general")}</a></li>
    </ul>
</div>

<div id="content_general">
    <div class="control-group">
        <label for="elm_document_name" class="control-label cm-required">{__("name")}</label>
        <div class="controls">
        <input type="text" name="document_data[document]" id="elm_document_name" value="{$document.document}" size="25" class="input-large" /></div>
    </div>

    <div class="control-group">
        <label for="elm_category_name" class="control-label">{__("category")}</label>
        <div class="controls">
        {$categories = fn_get_document_categories()}
        <select name="document_data[category_ids][]" id="elm_category_name" multiple="multiple">
        {foreach $categories as $category}
            <option  {foreach $document['categories_ids'] as $category_id} {if $category_id == $category.category_id} selected="selected" {/if} {/foreach} value="{$category.category_id}">{$category.name}</option>
        {/foreach}
        </select>
        </div>
    </div>

    <div class="control-group">
        <label for="elm_document_type" class="control-label cm-required">{__("type")}</label>
        <div class="controls">
        <select name="document_data[type]" id="elm_document_type">
            <option {if $document.type == "I"}selected="selected"{/if} value="I">{__("inside_type")}</option>
            <option {if $document.type == "O"}selected="selected"{/if} value="O">{__("outside_type")}</option>
        </select>
        </div>
    </div>

    <div class="control-group" id="document_text">
        <label class="control-label" for="elm_document_description">{__("description")}:</label>
        <div class="controls">
            <textarea id="elm_document_description" name="document_data[description]" cols="35" rows="8" class="input-large">{$document.description}</textarea>
        </div>
    </div>
    {include file="common/select_status.tpl" input_name="document_data[status]" id="elm_document_status" obj_id=$id obj=$document hidden=true}
    </div>

    <input type="hidden" name="document_data[files][attachment_id]" value="{$attachment_id}" />
    <input type="hidden" name="document_data[files][redirect_url]" value="{$config.current_url}" />
    <input type="hidden" name="document_data[files][description]" id="elm_description_{$attachment_id}" size="60" class="input-medium" value="1" />
    <input type="hidden" name="document_data[files][position]" id="elm_position_{$attachment_id}" size="3" class="input-micro" value="1" />

    <div class="control-group">
        <label for="type_{"attachment_files[`$attachment_id`]"|md5}" class="control-label">{__("file")}</label>
            <div class="controls">
            {if !$hide_inputs}
                {include file="common/fileuploader.tpl" var_name="attachment_files[`$attachment_id`]"}</div>
            {/if}
    </div>

    {if $attachment.attachment_id}
        {assign var="attachment_id" value=$attachment.attachment_id}    
    {else}
        {assign var="attachment_id" value="0"}
    {/if}

    </form>
    {capture name="tabsbox"}

    {if $attachments}
    <div id="content_general">
        <div class="control-group">
            <div class="controls">
            {foreach from=$attachments item="a"}
                <h4>{$a.filename}</h4>
                <a href="var/attachments/document/{$a.object_id}/{$a.filename}">Download</a> ({$a.filesize|formatfilesize nofilter})
                </div>
                </br>
            {/foreach}
        </div>
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}
    {/capture}
    {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox}

</div>

{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="handle_documents_form" but_name="dispatch[handle_documents.update]"}
    {else}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[handle_documents.update]" but_role="submit-link" but_target_form="handle_documents_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
    {/if}
{/capture}
</form>

{/capture}

{include file="common/mainbox.tpl"
    title=($id) ? $document.document : __("handle_documents.new_document")
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
}