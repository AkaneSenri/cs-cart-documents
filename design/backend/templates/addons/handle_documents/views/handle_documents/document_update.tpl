{if $attachment.attachment_id}
    {assign var="attachment_id" value=$attachment.attachment_id}    
{else}
    {assign var="attachment_id" value="0"}
{/if}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit  {$hide_inputs}" name="attachments_form_{$attachment_id}" enctype="multipart/form-data">

<div class="cm-tabs-content">
    <div class="control-group">
        <label for="type_{"attachment_files[`$attachment_id`]"|md5}" class="control-label {if !$attachment}cm-required{/if}">{__("file")}</label>
        <div class="controls">
            {if $attachment.filename}
                <div class="text-type-value">
                    <a href="{"attachments.getfile?attachment_id=`$attachment.attachment_id`&object_type=`$object_type`&object_id=`$object_id`"|fn_url}">{$attachment.filename}</a> ({$attachment.filesize|formatfilesize nofilter})
                </div>
            {/if}
    </div>
</div>

</form>


