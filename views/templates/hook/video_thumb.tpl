{*
* 2023 YourCompany
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
*}

<div class="thumb-container video-thumb js-video-thumb js-thumb-container thumb" data-video-id="{$youtube_video_id}">
    <a href="javascript:void(0);" 
       class="thumb-video-link js-thumb-video-link thumb js-thumb" 
       tabindex="0"
       data-video-id="{$youtube_video_id}"
       data-image-medium-src="https://img.youtube.com/vi/{$youtube_video_id}/mqdefault.jpg"
       data-image-large-src="https://img.youtube.com/vi/{$youtube_video_id}/hqdefault.jpg"
       data-caption="Ver vídeo del producto">
        <div class="video-thumb-wrapper">
            <img
                class="thumb js-thumb product_video_thumb"
                data-image-medium-src="https://img.youtube.com/vi/{$youtube_video_id}/mqdefault.jpg"
                data-image-large-src="https://img.youtube.com/vi/{$youtube_video_id}/hqdefault.jpg"
                src="https://img.youtube.com/vi/{$youtube_video_id}/default.jpg"
                alt="Ver vídeo del producto"
                title="Ver vídeo del producto"
                width="100%"
                height="100%"
                itemprop="image"
            >
            <div class="video-play-icon">
                <i class="material-icons">play_arrow</i>
            </div>
        </div>
    </a>
</div>

{* Estilo adicional para asegurar la integración correcta *}
<style>
/* Estilos principales con !important para forzar la prioridad */
.thumb-container.video-thumb {
    position: relative !important;
    cursor: pointer !important;
    display: block !important;
    opacity: 1 !important;
    visibility: visible !important;
    overflow: hidden !important;
    max-width: 100% !important;
    max-height: 100% !important;
    width: auto !important;
    height: auto !important;
    border: 2px solid red !important;
    box-shadow: 0 0 5px rgba(255, 0, 0, 0.5) !important;
    border-radius: 5px !important;
    margin: 5px !important;
    transition: all 0.3s ease !important;
}

.thumb-container.video-thumb:hover {
    transform: scale(1.05) !important;
    border-color: #ff0000 !important;
    box-shadow: 0 0 8px rgba(255, 0, 0, 0.8) !important;
}

.video-play-icon {
    position: absolute !important;
    top: 50% !important;
    left: 50% !important;
    transform: translate(-50%, -50%) !important;
    background-color: rgba(255, 0, 0, 0.7) !important;
    border-radius: 50% !important;
    width: 30px !important;
    height: 30px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    z-index: 10 !important;
    transition: all 0.3s ease !important;
}

.thumb-container.video-thumb:hover .video-play-icon {
    background-color: rgba(255, 0, 0, 0.9) !important;
    transform: translate(-50%, -50%) scale(1.1) !important;
}

.video-play-icon i {
    color: white !important;
    font-size: 20px !important;
}

/* Compatibilidad con diferentes temas */
.product-images .video-thumb,
#product-thumbs .video-thumb,
.images-container .video-thumb,
.thumb-container.video-thumb,
.js-thumb-container.video-thumb {
    display: inline-block !important;
    visibility: visible !important;
    opacity: 1 !important;
}

/* Añadimos una animación suave para llamar la atención */
@keyframes pulse-border {
    0% {
        border-color: #ff5555;
        box-shadow: 0 0 5px rgba(255, 0, 0, 0.5);
    }
    50% {
        border-color: #ff0000;
        box-shadow: 0 0 10px rgba(255, 0, 0, 0.8);
    }
    100% {
        border-color: #ff5555;
        box-shadow: 0 0 5px rgba(255, 0, 0, 0.5);
    }
}

.thumb-container.video-thumb {
    animation: pulse-border 2s infinite !important;
}
</style>
