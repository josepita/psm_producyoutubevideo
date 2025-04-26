{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div id="product-gallery-modal" class="product-gallery-modal">
    <div class="gallery-modal-content">
        <span class="gallery-close">&times;</span>
        
        <div class="gallery-main-container">
            {* Container for images *}
            <div class="gallery-slides-container">
                {foreach from=$product_images item=image name=productImages}
                    <div class="gallery-slide" data-index="{$smarty.foreach.productImages.index}">
                        <div class="material-icon-container">
                            {if $material|strpos:'18K' !== false}
                                <span class="ico-material">
                                    <img src="{$theme_url}assets/img/icono-oro.png" alt="Producto hecho en oro de 18 kilates"/>
                                </span>
                            {elseif $material|strpos:'9K' !== false}
                                <span class="ico-material">
                                    <img src="{$theme_url}assets/img/icono-oro-9k.png" alt="Producto hecho en oro de 9 kilates"/>
                                </span>
                            {elseif $material|strpos:'de ley' !== false}
                                <span class="ico-material">
                                    <img src="{$theme_url}assets/img/icono-plata.png" alt="Producto hecho en plata de ley"/>
                                </span>
                            {/if}
                        </div>
                        <img class="gallery-image" src="{$base_url}img/p/{$id_product}-{$image.id_image}-large_default.jpg" alt="{$image.legend}">
                    </div>
                {/foreach}
                
                {* Video slide *}
                {if $youtube_video_id}
                    <div class="gallery-slide video-slide" data-index="{$product_images|count}">
                        <div class="video-container">
                            <div class="material-icon-container">
                                {if $material|strpos:'18K' !== false}
                                    <span class="ico-material">
                                        <img src="{$theme_url}assets/img/icono-oro.png" alt="Producto hecho en oro de 18 kilates"/>
                                    </span>
                                {elseif $material|strpos:'9K' !== false}
                                    <span class="ico-material">
                                        <img src="{$theme_url}assets/img/icono-oro-9k.png" alt="Producto hecho en oro de 9 kilates"/>
                                    </span>
                                {elseif $material|strpos:'de ley' !== false}
                                    <span class="ico-material">
                                        <img src="{$theme_url}assets/img/icono-plata.png" alt="Producto hecho en plata de ley"/>
                                    </span>
                                {/if}
                            </div>
                            <iframe 
                                src="https://www.youtube-nocookie.com/embed/{$youtube_video_id}?autoplay=0&rel=0&showinfo=0&modestbranding=1" 
                                frameborder="0" 
                                allowfullscreen>
                            </iframe>
                        </div>
                    </div>
                {/if}
            </div>
            
            {* Navigation controls *}
            <a class="gallery-prev">&#10094;</a>
            <a class="gallery-next">&#10095;</a>
        </div>
        
        {* Slide indicators *}
        <div class="gallery-dots-container">
            {foreach from=$product_images item=image name=productImages}
                <span class="gallery-dot" data-index="{$smarty.foreach.productImages.index}"></span>
            {/foreach}
            
            {if $youtube_video_id}
                <span class="gallery-dot video-dot" data-index="{$product_images|count}"></span>
            {/if}
        </div>
    </div>
</div>
