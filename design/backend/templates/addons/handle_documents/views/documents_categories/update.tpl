{if $category}
    {assign var="id" value=$category.category_id}
{else}
    {assign var="id" value=0}
{/if}

{$allow_save = $category|fn_allow_save_object:"categories"}
{$hide_inputs = ""|fn_check_form_permissions}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit{if !$allow_save || $hide_inputs} cm-hide-inputs{/if}" name="documents_categories_form" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
<input type="hidden" class="cm-no-hide-input" name="category_id" value="{$id}" />

{capture name="tabsbox"}

    <div id="content_general">
        <div class="control-group">
            <label for="elm_category_name" class="control-label cm-required">{__("name")}</label>
            <div class="controls">
            <input type="text" name="category_data[name]" id="elm_category_name" value="{$category.name}" size="25" class="input-large" /></div>
        </div>

        {include file="common/select_status.tpl" input_name="category_data[status]" id="elm_category_status" obj_id=$id obj=$category hidden=true}
        </div>

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="documents_categories_form" but_name="dispatch[documents_categories.update]"}
    {else}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[documents_categories.update]" but_role="submit-link" but_target_form="documents_categories_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
    {/if}
{/capture}
</form>

{/capture}

{include file="common/mainbox.tpl"
    title=($id) ? $document.document : __("documents_categories.new_category")
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
}
