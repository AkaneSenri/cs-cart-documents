{capture name="mainbox"}

<form action="{""|fn_url}" method="post" id="categories_form" name="categories_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />

{$has_permission = fn_check_permissions("documents_categories", "update_status", "admin", "POST")}

{if $categories}
    {capture name="categories_table"}
    <p>{$user_login.userlogin}</p>
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-middle table--relative table-responsive">
            <thead
                data-ca-bulkedit-default-object="true"
                data-ca-bulkedit-component="defaultObject"
            >
            <tr>
                <th width="6%" class="left mobile-hide">
                    {include file="common/check_items.tpl" is_check_disabled=!$has_permission check_statuses=($has_permission) ? $categories_statuses : '' }

                    <input type="checkbox"
                        class="bulkedit-toggler hide"
                        data-ca-bulkedit-disable="[data-ca-bulkedit-default-object=true]"
                        data-ca-bulkedit-enable="[data-ca-bulkedit-expanded-object=true]"
                    />
                </th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("category")}{if $search.sort_by === "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>

                <th width="6%" class="mobile-hide">&nbsp;</th>
                <th width="10%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status")}{if $search.sort_by === "status"}{$c_icon nofilter}{/if}</a></th>
            </tr>
            </thead>
            {foreach from=$categories item=category}
            <tr class="cm-row-status-{$category.status|lower} cm-longtap-target"
                {if $has_permission}
                    data-ca-longtap-action="setCheckBox"
                    data-ca-longtap-target="input.cm-item"
                    data-ca-id="{$category.category_id}"
                {/if}
            >
                {$allow_save=$category|fn_allow_save_object:"category"}

                {if $allow_save}
                    {$no_hide_input="cm-no-hide-input"}
                {else}
                    {$no_hide_input=""}
                {/if}

                <td width="6%" class="left mobile-hide">
                    <input type="checkbox" name="category_id" value="{$category.category_id}" class="cm-item {$no_hide_input} cm-item-status-{$category.status|lower} hide" /></td>
                <td class="{$no_hide_input}" data-th="{__("category")}">
                    <a class="row-status" href="{"documents_categories.update?category_id=`$category.category_id`"|fn_url}">{$category.name}</a>
                    {include file="views/companies/components/company_name.tpl" object=$category}
                </td>

                <td width="6%" class="mobile-hide">
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("edit") href="documents_categories.update?category_id=`$category.category_id`"}</li>
                    {if $allow_save}
                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="documents_categories.delete?category_id=`$category.category_id`" method="POST"}</li>
                    {/if}
                    {/capture}
                    <div class="hidden-tools">
                        {dropdown content=$smarty.capture.tools_list}
                    </div>
                </td>
                <td width="10%" class="right" data-th="{__("status")}">
                    {include file="common/select_popup.tpl" id=$category.category_id status=$category.status hidden=true object_id_name="category_id" table="categories" popup_additional_class="`$no_hide_input` dropleft"}
                </td>
            </tr>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="categories_form"
        object="categories"
        items=$smarty.capture.categories_table
        has_permissions=$has_permission
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="documents_categories.add" prefix="top" hide_tools="true" title=__("add_category") icon="icon-plus"}
{/capture}

</form>

{/capture}

{$page_title = __("documents_categories")}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}