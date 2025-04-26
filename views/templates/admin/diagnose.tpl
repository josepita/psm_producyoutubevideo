{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div class="panel">
    <div class="panel-heading">
        <i class="icon-info"></i> {l s='YouTube Video Module Diagnostics' d='Modules.ProductYoutubeVideo.Admin'}
    </div>
    
    <div class="alert alert-info">
        <p><strong>{l s='Module Status:' d='Modules.ProductYoutubeVideo.Admin'}</strong> {$module_status}</p>
        <p><strong>{l s='Hooks Status:' d='Modules.ProductYoutubeVideo.Admin'}</strong></p>
        <ul>
            {foreach from=$hooks_status item=hook}
                <li>
                    <strong>{$hook.name}:</strong> 
                    {if $hook.registered}
                        <span class="text-success">{l s='Registered' d='Modules.ProductYoutubeVideo.Admin'}</span>
                    {else}
                        <span class="text-danger">{l s='Not registered' d='Modules.ProductYoutubeVideo.Admin'}</span>
                    {/if}
                </li>
            {/foreach}
        </ul>
        
        <p><strong>{l s='Database Status:' d='Modules.ProductYoutubeVideo.Admin'}</strong></p>
        <ul>
            <li>
                <strong>{l s='YouTube Video URL field:' d='Modules.ProductYoutubeVideo.Admin'}</strong> 
                {if $field_exists}
                    <span class="text-success">{l s='Exists' d='Modules.ProductYoutubeVideo.Admin'}</span>
                {else}
                    <span class="text-danger">{l s='Does not exist' d='Modules.ProductYoutubeVideo.Admin'}</span>
                {/if}
            </li>
        </ul>
        
        {if isset($products_with_videos) && count($products_with_videos) > 0}
            <p><strong>{l s='Products with YouTube Videos:' d='Modules.ProductYoutubeVideo.Admin'}</strong></p>
            <table class="table">
                <thead>
                    <tr>
                        <th>{l s='Product ID' d='Modules.ProductYoutubeVideo.Admin'}</th>
                        <th>{l s='Product Name' d='Modules.ProductYoutubeVideo.Admin'}</th>
                        <th>{l s='YouTube URL' d='Modules.ProductYoutubeVideo.Admin'}</th>
                        <th>{l s='YouTube ID' d='Modules.ProductYoutubeVideo.Admin'}</th>
                        <th>{l s='Status' d='Modules.ProductYoutubeVideo.Admin'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$products_with_videos item=product}
                        <tr>
                            <td>{$product.id_product}</td>
                            <td>{$product.name}</td>
                            <td>{$product.youtube_url}</td>
                            <td>{$product.youtube_id}</td>
                            <td>
                                {if $product.youtube_id}
                                    <span class="text-success">{l s='Valid' d='Modules.ProductYoutubeVideo.Admin'}</span>
                                {else}
                                    <span class="text-danger">{l s='Invalid URL' d='Modules.ProductYoutubeVideo.Admin'}</span>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {else}
            <div class="alert alert-warning">
                {l s='No products with YouTube videos found.' d='Modules.ProductYoutubeVideo.Admin'}
            </div>
        {/if}
    </div>
    
    <div class="panel-footer">
        <a href="{$refresh_url}" class="btn btn-default">
            <i class="process-icon-refresh"></i> {l s='Refresh' d='Modules.ProductYoutubeVideo.Admin'}
        </a>
        <a href="{$fix_url}" class="btn btn-primary">
            <i class="process-icon-ok"></i> {l s='Fix Issues' d='Modules.ProductYoutubeVideo.Admin'}
        </a>
    </div>
</div>
