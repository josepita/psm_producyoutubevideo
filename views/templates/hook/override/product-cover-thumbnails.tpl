{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 *}
<div class="images-container js-images-container">
  {block name='product_cover_thumbnails'}
    {if $isMobile && $dmobile_swipe}
      <div class="list-images-mobile">
        {foreach from=$product.images item=image}
          <div>
            <img
              class="js-qv-product-cover img-fluid"
              src="{$product.default_image.bySize.medium_default.url}"
              {if !empty($product.default_image.legend)}
                alt="{$product.default_image.legend}"
                title="{$product.default_image.legend}"
              {else}
                alt="{$product.name}"
              {/if}
              loading="lazy"
              width="{$product.default_image.bySize.medium_default.width}"
              height="{$product.default_image.bySize.medium_default.height}"
            >
          </div>
        {/foreach}
      </div>
    {else}
      {block name='product_cover'}
        <div class="product-cover">
          {block name='product_flags'}
            <ul class="product-flags">
              {foreach from=$product.flags item=flag}
                <li class="product-flag {$flag.type}">{$flag.label}</li>
              {/foreach}
            </ul>
          {/block}
          
          {* Material icon *}
          {if $product.grouped_features} 
            {foreach from=$product.grouped_features item=feature} 
              {if $feature.name=="Material"}
                {assign var="material" value=$feature.value} 
              {/if} 
            {/foreach} 
          {/if}
          <span id="view_full_size">
            {if $material|strpos:'18K' !== false}
              <span class="ico-material">
                <img src="{$urls.theme_assets}/img/icono-oro.png" alt="Producto hecho en oro de 18 kilates"/>
              </span> 
            {elseif $material|strpos:'9K' !== false}
              <span class="ico-material">
                <img src="{$urls.theme_assets}/img/icono-oro-9k.png" alt="Producto hecho en oro de 9 kilates"/>
              </span> 
            {elseif $material|strpos:'de ley' !== false}
              <span class="ico-material">
                <img src="{$urls.theme_assets}/img/icono-plata.png" alt="Producto hecho en plata de ley"/>
              </span> 
            {/if}
          </span>
          
          {if $product.default_image}
            <img id="zoom_product" data-type-zoom="" class="js-qv-product-cover img-fluid" src="{$product.default_image.bySize.large_default.url}" alt="{$product.default_image.legend}" title="{$product.default_image.legend}" itemprop="image">
            <div class="layer hidden-sm-down" data-toggle="modal" data-target="#product-modal">
              <i class="material-icons zoom-in">&#xE8FF;</i>
            </div>
          {else}
            <img
              class="img-fluid"
              src="{$urls.no_picture_image.bySize.medium_default.url}"
              loading="lazy"
              width="{$urls.no_picture_image.bySize.medium_default.width}"
              height="{$urls.no_picture_image.bySize.medium_default.height}"
            >
          {/if}
        </div>
      {/block}

      {block name='product_images'}
        <div id="thumb-gallery" class="product-thumb-images">
          {foreach from=$product.images item=image}
            <div class="thumb-container js-thumb-container {if $image.id_image == $product.default_image.id_image} active {/if}">
              <a  href="javascript:void(0)" data-image="{$image.bySize.large_default.url}" data-zoom-image="{$image.bySize.large_default.url}"> 
                <img
                  class="img-fluid thumb js-thumb {if $image.id_image == $product.default_image.id_image} selected js-thumb-selected {/if}"
                  data-image-medium-src="{$image.bySize.medium_default.url}"
                  data-image-large-src="{$image.bySize.large_default.url}"
                  src="{$image.bySize.small_default.url}"
                  {if !empty($image.legend)}
                    alt="{$image.legend}"
                    title="{$image.legend}"
                  {else}
                    alt="{$product.name}"
                  {/if}
                  loading="lazy"
                  width="{$product.default_image.bySize.small_default.width}"
                  height="{$product.default_image.bySize.small_default.height}"
                >
              </a>
            </div>
          {/foreach}
          
          {* Video thumbnail added here *}
          {hook h='displayAfterProductThumbs' product=$product}
        </div>
      {/block}

      {if $product.images|@count > 1}
        <div class="arrows-product-fake slick-arrows">
          <button class="slick-prev slick-arrow" aria-label="Previous" type="button" >{l s='Previous' d='Shop.Theme.Catalog'}</button>
          <button class="slick-next slick-arrow" aria-label="Next" type="button">{l s='Next' d='Shop.Theme.Catalog'}</button>
        </div>
      {/if}
    {/if}
  {/block}
</div>
