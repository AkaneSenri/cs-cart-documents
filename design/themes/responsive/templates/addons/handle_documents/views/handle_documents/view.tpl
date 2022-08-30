{if $document}
    {assign var="id" value=$document.document_id}
{else}
    {assign var="id" value=0}
{/if}

<div id="content_general">
    <div class="control-group">
        <label for="elm_document_name" class="control-label"><b>{__("name")}:</b> {$document.document}</label>
    </div>
</div>
</br>
<div id="content_general">
    <div class="control-group">
        <label for="elm_document_description" class="control-label"><b>{__("description")}:</b> {$document.description}</label>
    </div>
</div>
</br>

{if $attachments}
<div id="content_general">
    <div class="control-group">
        <label for="elm_description_{$attachment_id}" class="control-label"><b>{__("attachments")}:</b></label>
        <div class="controls">
        {foreach from=$attachments item="a"}
            <p>{$a.filename}</p>
            <a href="var/attachments/document/{$a.object_id}/{$a.filename}">Download</a> ({$a.filesize|formatfilesize nofilter})
            </div>
            </br>
        {/foreach}
    </div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}