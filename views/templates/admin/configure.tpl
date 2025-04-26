{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
*
* @author    YourName <your.email@example.com>
* @copyright 2023 YourCompany
* @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

<div class="panel">
  <h3><i class="icon icon-tag"></i> {l s='Product YouTube Video' mod='productyoutubevideo'}</h3>
  <div class="alert alert-info">
    {l s='This module allows you to add YouTube videos to your product pages' mod='productyoutubevideo'}
  </div>
  
  <div class="alert alert-success">
    {l s='Your YouTube video data is now protected and will not be lost if you uninstall or reset the module.' mod='productyoutubevideo'}
    {l s='We recommend making regular backups of your YouTube URLs using the backup button below.' mod='productyoutubevideo'}
  </div>
  
  <div class="panel-body">
    <div class="row">
      <div class="col-md-12">
        <h4>{l s='How to use:' mod='productyoutubevideo'}</h4>
        <ol>
          <li>{l s='Edit any product' mod='productyoutubevideo'}</li>
          <li>{l s='Find the YouTube Video URL field in the Basic Settings tab' mod='productyoutubevideo'}</li>
          <li>{l s='Paste a YouTube video URL' mod='productyoutubevideo'}</li>
          <li>{l s='Save the product' mod='productyoutubevideo'}</li>
        </ol>
        <p>{l s='The video will automatically appear in the product gallery' mod='productyoutubevideo'}</p>
      </div>
    </div>
    
    <div class="row">
      <div class="col-md-12">
        <h4>{l s='Supported URL formats:' mod='productyoutubevideo'}</h4>
        <ul>
          <li>https://www.youtube.com/watch?v=VIDEO_ID</li>
          <li>https://youtu.be/VIDEO_ID</li>
          <li>https://www.youtube.com/embed/VIDEO_ID</li>
        </ul>
      </div>
    </div>
    
    <div class="row">
      <div class="col-md-12">
        <h4>{l s='YouTube Thumbnails and Black Bars' mod='productyoutubevideo'}</h4>
        <p>{l s='If your thumbnails show black bars on the top and bottom, you can use a custom thumbnail image:' mod='productyoutubevideo'}</p>
                
        <ol>
          <li>{l s='Create a screenshot from your video with the correct dimensions (16:9 ratio, recommended 1280x720px)' mod='productyoutubevideo'}</li>
          <li>{l s='Rename the image to match the YouTube video ID (e.g., for a video with URL youtube.com/watch?v=ABC123, use ABC123.jpg)' mod='productyoutubevideo'}</li>
          <li>{l s='Upload the image to the following directory:' mod='productyoutubevideo'} <code>{$thumbnails_path}</code></li>
        </ol>
                
        <div class="alert alert-info">
          <p>{l s='The module will automatically use your custom thumbnail image if it exists in the thumbnails directory.' mod='productyoutubevideo'}</p>
        </div>
      </div>
    </div>
  </div>
  
  <div class="panel-footer">
    <div class="row">
      <div class="col-md-6">
        <p>
          <strong>{l s='Version:' mod='productyoutubevideo'}</strong> 1.1.0
        </p>
      </div>
      <div class="col-md-6 text-right">
        <a href="{$module_dir}backup.php" class="btn btn-default" target="_blank">
          <i class="icon icon-download"></i> {l s='Backup YouTube URLs' mod='productyoutubevideo'}
        </a>
        <a href="{$module_dir}restore.php" class="btn btn-primary" target="_blank">
          <i class="icon icon-upload"></i> {l s='Restore from Backup' mod='productyoutubevideo'}
        </a>
      </div>
    </div>
  </div>
</div>