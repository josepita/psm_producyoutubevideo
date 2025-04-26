{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div class="form-group">
    <label class="control-label col-lg-3">
        <span class="label">{l s='YouTube Video URL' d='Modules.ProductYoutubeVideo.Admin'}</span>
    </label>
    <div class="col-lg-9">
        <input 
            type="text" 
            name="youtube_video_url" 
            class="form-control" 
            value="{$youtube_video_url|escape:'html':'UTF-8'}" 
            placeholder="https://www.youtube.com/watch?v=VIDEO_ID"
        />
        <p class="help-block">
            {l s='Enter a YouTube video URL. Example: https://www.youtube.com/watch?v=abcd1234' d='Modules.ProductYoutubeVideo.Admin'}
        </p>
    </div>
</div>