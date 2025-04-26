{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div class="product-video-background">
    <div class="video-banner">
        <div class="video-media">
            <div class="video-wrapper">
                <iframe 
                    src="https://www.youtube-nocookie.com/embed/{$youtube_video_id}?autoplay=1&mute=1&controls=0&loop=1&playlist={$youtube_video_id}&playsinline=1&rel=0&showinfo=0&modestbranding=1" 
                    frameborder="0" 
                    allowfullscreen>
                </iframe>
            </div>
        </div>
        
        {if isset($show_content) && $show_content}
        <div class="video-content">
            <h2>{$product->name}</h2>
            <p>{$product->description_short|strip_tags}</p>
            <a href="#product-details" class="btn btn-primary">{l s='Ver detalles' d='Modules.ProductYoutubeVideo.Shop'}</a>
        </div>
        {/if}
    </div>
</div>

<style>
    .product-video-background {
        margin-bottom: 20px;
    }
    
    .video-banner {
        position: relative;
        width: 100%;
        height: 350px;
        overflow: hidden;
    }
    
    .video-media {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
    }
    
    .video-wrapper {
        position: absolute;
        width: 177.5%;
        height: 177.5%;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
    }
    
    .video-wrapper iframe {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        pointer-events: none;
    }
    
    .video-content {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        z-index: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        color: white;
        text-align: center;
        padding: 20px;
        box-sizing: border-box;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.7);
    }
    
    .video-content h2 {
        font-size: 28px;
        margin-bottom: 15px;
    }
    
    .video-content p {
        margin-bottom: 20px;
    }
</style>