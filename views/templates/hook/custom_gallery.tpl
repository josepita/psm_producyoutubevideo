{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

{* Contenedor principal de la galería personalizada *}
<div class="product-custom-gallery product-mobile-gallery">
    <div class="row no-gutters">
        {* Miniaturas a la izquierda *}
        <div class="col-md-2 custom-gallery-thumbs-col">
            <div class="custom-gallery-thumbs">
                {foreach from=$product_images item=image name=productImages}
                    <div class="thumb-item{if $smarty.foreach.productImages.first} active{/if}" data-index="{$smarty.foreach.productImages.index}">
                        <img
                            src="{$link->getImageLink($product_link_rewrite, $id_product|cat:'-'|cat:$image.id_image, 'small_default')}"
                            alt="{if !empty($image.legend)}{$image.legend}{else}Imagen del producto{/if}"
                            loading="lazy"
                            width="100%"
                        >
                    </div>
                {/foreach}
                
                {* Miniatura del video *}
                {if $youtube_video_id}
                    <div class="thumb-item video-thumb" data-index="{$product_images|count}">
                        <div class="video-thumb-wrapper">
                            <img src="https://img.youtube.com/vi/{$youtube_video_id}/hqdefault.jpg" alt="Video" width="100%">
                            <div class="video-icon">
                                <i class="material-icons">play_arrow</i>
                            </div>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
        
        {* Galería de imágenes principal a la derecha *}
        <div class="col-md-10 custom-gallery-main-col">
            <div class="custom-gallery-main">
                {* Flags del producto *}
                <div class="product-flags"></div>
                
                {* Slider principal con imágenes y video *}
                <div class="custom-gallery-slider">
                    {* Imágenes del producto con soporte para FancyBox *}
                    {foreach from=$product_images item=image name=productImages}
                        <div class="gallery-slide-item{if $smarty.foreach.productImages.first} active{/if}" data-index="{$smarty.foreach.productImages.index}">
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
                            <a href="{$link->getImageLink($product_link_rewrite, $id_product|cat:'-'|cat:$image.id_image, 'large_default')}" 
                               data-fancybox="product-gallery"
                               data-caption="{if !empty($image.legend)}{$image.legend}{else}Imagen del producto{/if}"
                               data-thumb="{$link->getImageLink($product_link_rewrite, $id_product|cat:'-'|cat:$image.id_image, 'small_default')}"
                               class="product-image-link fullscreen-view">
                                <img class="gallery-image"
                                    src="{$link->getImageLink($product_link_rewrite, $id_product|cat:'-'|cat:$image.id_image, 'large_default')}"
                                    alt="{if !empty($image.legend)}{$image.legend}{else}Imagen del producto{/if}"
                                    title="{if !empty($image.legend)}{$image.legend}{else}Imagen del producto{/if}"
                                    itemprop="image"
                                    width="100%"
                                >
                            </a>
                        </div>
                    {/foreach}
                    
                    {* Slide de video, si existe *}
                    {if $youtube_video_id}
                        <div class="gallery-slide-item video-slide" data-index="{$product_images|count}">
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
                            <div class="video-container" id="video-container-{$youtube_video_id}">
                                <div class="custom-video-overlay active" style="background-image: url('https://img.youtube.com/vi/{$youtube_video_id}/maxresdefault.jpg'); background-size: cover; background-position: center;">
                                    <div class="custom-play-button">
                                        <i class="material-icons">play_arrow</i>
                                    </div>
                                </div>
                                <iframe 
                                    id="youtube-player-{$youtube_video_id}"
                                    data-src="https://www.youtube-nocookie.com/embed/{$youtube_video_id}?rel=0&showinfo=0&controls=1&autoplay=1&modestbranding=1&enablejsapi=1&playsinline=1" 
                                    style="width:100%; height:100%; position:absolute; top:0; left:0;"
                                    frameborder="0" 
                                    allow="autoplay; encrypted-media"
                                    allowfullscreen>
                                </iframe>
                            </div>
                            
                            {* Enlace oculto para FancyBox video *}
                            <a href="https://www.youtube.com/watch?v={$youtube_video_id}" 
                               data-fancybox="product-video"
                               class="video-fancybox-link"
                               id="video-fancybox-{$youtube_video_id}">
                                <span class="video-overlay-button">
                                    <i class="material-icons">fullscreen</i>
                                </span>
                            </a>
                        </div>
                    {/if}
                </div>
                
                {* Controles de navegación visibles como en la imagen 2 *}
                <div class="custom-gallery-controls">
                    <div class="custom-gallery-prev">
                        <i class="material-icons">chevron_left</i>
                    </div>
                    <div class="custom-gallery-next">
                        <i class="material-icons">chevron_right</i>
                    </div>
                </div>
            </div>
        </div>
</div>
</div>
