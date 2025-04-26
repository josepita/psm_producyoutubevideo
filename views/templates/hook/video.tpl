{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div class="product-video-container">
    <div class="product-video-wrapper">
        <iframe 
            src="https://www.youtube-nocookie.com/embed/{$youtube_video_id}?autoplay=0&rel=0&showinfo=0&modestbranding=1" 
            frameborder="0" 
            allowfullscreen>
        </iframe>
    </div>
</div>

<style>
    .product-video-container {
        position: relative;
        width: 100%;
        margin-bottom: 20px;
        overflow: hidden;
    }
    
    .product-video-wrapper {
        position: relative;
        padding-bottom: 56.25%; /* 16:9 aspect ratio */
        height: 0;
        overflow: hidden;
    }
    
    .product-video-wrapper iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
    }
</style>