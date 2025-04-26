<?php
/**
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
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

class ProductYoutubeVideo extends Module
{
    public function __construct()
    {
        $this->name = 'productyoutubevideo';
        $this->tab = 'front_office_features';
        $this->version = '1.1.0';
        $this->author = 'YourName';
        $this->need_instance = 0;
        $this->bootstrap = true;
        
        parent::__construct();
        
        $this->displayName = $this->l('Product Gallery with YouTube Video');
        $this->description = $this->l('Adds enhanced gallery with YouTube video functionality to product pages');
        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');
        
        // Define la ruta de las plantillas
        if (file_exists(_PS_THEME_DIR_.'modules/'.$this->name)) {
            $this->theme_path = _PS_THEME_DIR_.'modules/'.$this->name.'/';
        } else {
            $this->theme_path = _PS_MODULE_DIR_.$this->name.'/views/templates/hook/';
        }
        
        // Comprobar compatibilidad con PS
        $this->ps_versions_compliancy = [
            'min' => '1.7.0.0',
            'max' => '8.99.99',
        ];
    }

    /**
     * Install the module
     */
    public function install()
    {
        // Create database field if doesn't exist
        $result = Db::getInstance()->executeS(
            'SHOW COLUMNS FROM `'._DB_PREFIX_.'product` LIKE "youtube_video_url"'
        );
        
        // Add database field for video URL if it doesn't exist
        if (empty($result)) {
            $sql = 'ALTER TABLE `' . _DB_PREFIX_ . 'product` 
                    ADD `youtube_video_url` VARCHAR(255) NULL AFTER `available_date`';
            Db::getInstance()->execute($sql);
        }
        
        // Register hook in database if it doesn't exist
        $hook_id = Db::getInstance()->getValue('SELECT id_hook FROM `'._DB_PREFIX_.'hook` WHERE name = "displayMuestraVideo"');
        if (!$hook_id) {
            Db::getInstance()->execute('
                INSERT INTO `'._DB_PREFIX_.'hook` (name, title, description, position) 
                VALUES (
                    "displayMuestraVideo",
                    "Display YouTube Video",
                    "This hook displays a YouTube video on product page",
                    1
                )
            ');
        }

        return parent::install() && 
                $this->registerHook('displayAdminProductsMainStepLeftColumnMiddle') &&
                $this->registerHook('displayBackOfficeHeader') &&
                $this->registerHook('actionProductUpdate') &&
                $this->registerHook('actionProductSave') &&
                $this->registerHook('displayHeader') &&
                $this->registerHook('displayMuestraVideo') &&
                $this->registerHook('displayAfterProductThumbs');
    }

    /**
     * Uninstall the module
     */
    public function uninstall()
    {
        // No eliminaremos la columna de la base de datos para preservar los datos
        // incluso si el módulo se desinstala temporalmente
        
        return parent::uninstall();
    }

    /**
     * Add CSS and JS to back office
     */
    public function hookDisplayBackOfficeHeader()
    {
        if ($this->context->controller->controller_name == 'AdminProducts') {
            $this->context->controller->addJS($this->_path . 'views/js/admin.js');
            $this->context->controller->addCSS($this->_path . 'views/css/productyoutubevideo.css');
        }
    }

    /**
     * Display input field in product form
     */
    public function hookDisplayAdminProductsMainStepLeftColumnMiddle($params)
    {
        if (!isset($params['id_product'])) {
            return '';
        }
        
        $id_product = (int)$params['id_product'];
        $product = new Product($id_product);
        
        // Obtener la URL del video de la base de datos directamente
        $sql = 'SELECT `youtube_video_url` 
                FROM `' . _DB_PREFIX_ . 'product` 
                WHERE `id_product` = ' . $id_product;
        $videoUrl = Db::getInstance()->getValue($sql);

        $this->context->smarty->assign([
            'youtube_video_url' => $videoUrl,
            'id_product' => $id_product
        ]);

        return $this->display(__FILE__, 'views/templates/admin/product_field.tpl');
    }

    /**
     * Save video URL on product update
     */
    public function hookActionProductUpdate($params)
    {
        $this->saveVideoUrl($params);
    }

    /**
     * Save video URL on product save
     */
    public function hookActionProductSave($params)
    {
        $this->saveVideoUrl($params);
    }

    /**
     * Common method to save video URL
     */
    private function saveVideoUrl($params)
    {
        $id_product = (int)$params['id_product'];
        
        if (Tools::isSubmit('youtube_video_url')) {
            $videoUrl = pSQL(Tools::getValue('youtube_video_url'));
            
            // Update product with video URL
            Db::getInstance()->execute(
                'UPDATE `' . _DB_PREFIX_ . 'product` 
                SET `youtube_video_url` = "' . $videoUrl . '" 
                WHERE `id_product` = ' . $id_product
            );
        }
    }

    /**
     * Add CSS and JS to front office
     */
    public function hookDisplayHeader()
    {
        if ($this->context->controller->php_self == 'product') {
            // Añadimos FancyBox 5 desde CDN (para imagenes solamente)
            $this->context->controller->registerStylesheet(
                'fancybox5-css',
                'https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css',
                ['server' => 'remote', 'media' => 'all', 'priority' => 150]
            );
            
            $this->context->controller->registerJavascript(
                'fancybox5-js',
                'https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js',
                ['server' => 'remote', 'position' => 'bottom', 'priority' => 150]
            );
            
            // CSS unificado para el módulo
            $this->context->controller->addCSS($this->_path . 'views/css/productyoutubevideo.css', 'all', null, ['media' => 'all', 'priority' => 200]);
            
            // Añadimos nuestro script de funcionalidad básica
            $this->context->controller->addJS($this->_path . 'views/js/gallery-basic.js', ['position' => 'bottom', 'priority' => 190]);
            
            // Script para el modal simple de video
            $this->context->controller->addJS($this->_path . 'views/js/simple-video-modal.js', ['position' => 'bottom', 'priority' => 200]);
            
            // FancyBox básico para imágenes (sin videos)
            $jsCode = "document.addEventListener('DOMContentLoaded', function() { 
                if (typeof Fancybox !== 'undefined') { 
                    try { 
                        Fancybox.bind('[data-fancybox=\"product-gallery\"]', { dragToClose: false }); 
                        console.log('FancyBox inicializado correctamente'); 
                    } catch(e) { 
                        console.error('Error al inicializar FancyBox:', e); 
                    } 
                } 
            });";
            
            $this->context->controller->registerJavascript(
                'basic-fancybox-init',
                'data:text/javascript;base64,' . base64_encode($jsCode),
                ['server' => 'remote', 'position' => 'bottom', 'priority' => 220]
            );
            
            // Obtener el ID del producto actual
            $id_product = (int)Tools::getValue('id_product');
            
            // Obtener la URL del vídeo para este producto
            $sql = 'SELECT `youtube_video_url` 
                    FROM `' . _DB_PREFIX_ . 'product` 
                    WHERE `id_product` = ' . $id_product;
            
            $videoUrl = Db::getInstance()->getValue($sql);
            $videoId = $this->extractYoutubeId($videoUrl);
            
            // Si hay un vídeo para este producto, añadir metadatos
            if ($videoId) {
                $this->context->smarty->assign([
                    'youtube_video_id' => $videoId
                ]);
                
                // Añadir metadato con el ID del vídeo para que el JS pueda acceder a él
                $metaContent = htmlspecialchars($videoId, ENT_QUOTES, 'UTF-8');
                $metaCode = "document.head.insertAdjacentHTML('beforeend', '<meta name=\"product-youtube-id\" content=\"" . $metaContent . "\">');";
                
                $this->context->controller->registerJavascript(
                    'youtube-video-meta',
                    'data:text/javascript;base64,' . base64_encode($metaCode),
                    ['server' => 'remote', 'position' => 'head', 'priority' => 150]
                );
            }
            
            // Override template file for product gallery
            $this->context->smarty->assign([
                'override_template_path' => $this->theme_path . 'override/product-cover-thumbnails.tpl'
            ]);
        }
    }
    
    /**
     * Module configuration page
     */
    public function getContent()
    {
        $output = '';
        
        // Ejecutar diagnóstico
        if (Tools::isSubmit('fix_youtube_module')) {
            $this->fixModuleIssues();
            $output .= $this->displayConfirmation($this->l('Module issues fixed successfully.'));
        }
        
        // Obtener estado del módulo
        $moduleStatus = Module::isEnabled($this->name) ? $this->l('Enabled') : $this->l('Disabled');
        
        // Comprobar si la columna existe en la tabla de productos
        $fieldExists = !empty(Db::getInstance()->executeS(
            'SHOW COLUMNS FROM `'._DB_PREFIX_.'product` LIKE "youtube_video_url"'
        ));
        
        // Comprobar hooks registrados
        $hooksToCheck = [
            'displayAdminProductsMainStepLeftColumnMiddle',
            'displayBackOfficeHeader',
            'actionProductUpdate',
            'actionProductSave',
            'displayHeader',
            'displayMuestraVideo',
            'displayAfterProductThumbs'
        ];
        
        $hooksStatus = [];
        
        foreach ($hooksToCheck as $hook) {
            $registered = $this->isRegisteredInHook($hook);
            $hooksStatus[] = [
                'name' => $hook,
                'registered' => $registered
            ];
        }
        
        // Obtener productos con videos de YouTube
        $productsWithVideos = $this->getProductsWithYouTubeVideos();
        
        $this->context->smarty->assign([
            'module_dir' => $this->_path,
            'youtube_video_help' => true,
            'thumbnails_path' => _PS_MODULE_DIR_ . $this->name . '/views/img/thumbnails/',
            'module_status' => $moduleStatus,
            'hooks_status' => $hooksStatus,
            'field_exists' => $fieldExists,
            'products_with_videos' => $productsWithVideos,
            'refresh_url' => $this->context->link->getAdminLink('AdminModules') . '&configure=' . $this->name,
            'fix_url' => $this->context->link->getAdminLink('AdminModules') . '&configure=' . $this->name . '&fix_youtube_module=1'
        ]);
        
        // Mostrar diagnóstico
        $diagOutput = $this->display(__FILE__, 'views/templates/admin/diagnose.tpl');
        
        return $output . $this->display(__FILE__, 'views/templates/admin/configure.tpl') . $diagOutput;
    }
    
    /**
     * Check if module is registered in a hook
     */
    public function isRegisteredInHook($hookName)
    {
        return !empty(Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `'._DB_PREFIX_.'hook_module` hm
            LEFT JOIN `'._DB_PREFIX_.'hook` h ON h.id_hook = hm.id_hook
            WHERE h.name = "'.pSQL($hookName).'" AND hm.id_module = '.(int)$this->id
        ));
    }
    
    /**
     * Get products with YouTube videos
     */
    private function getProductsWithYouTubeVideos()
    {
        $products = [];
        
        $results = Db::getInstance()->executeS(
            'SELECT p.id_product, p.youtube_video_url, pl.name 
             FROM `'._DB_PREFIX_.'product` p 
             LEFT JOIN `'._DB_PREFIX_.'product_lang` pl ON p.id_product = pl.id_product 
             WHERE p.youtube_video_url IS NOT NULL AND p.youtube_video_url != "" 
             AND pl.id_lang = '.(int)$this->context->language->id.' 
             ORDER BY p.id_product DESC'
        );
        
        if (!empty($results)) {
            foreach ($results as $row) {
                $products[] = [
                    'id_product' => $row['id_product'],
                    'name' => $row['name'],
                    'youtube_url' => $row['youtube_video_url'],
                    'youtube_id' => $this->extractYoutubeId($row['youtube_video_url'])
                ];
            }
        }
        
        return $products;
    }
    
    /**
     * Fix module issues
     */
    private function fixModuleIssues()
    {
        // 1. Asegurarse de que la columna en la base de datos existe
        $fieldExists = !empty(Db::getInstance()->executeS(
            'SHOW COLUMNS FROM `'._DB_PREFIX_.'product` LIKE "youtube_video_url"'
        ));
        
        if (!$fieldExists) {
            Db::getInstance()->execute(
                'ALTER TABLE `'._DB_PREFIX_.'product` 
                 ADD `youtube_video_url` VARCHAR(255) NULL AFTER `available_date`'
            );
        }
        
        // 2. Registrar todos los hooks necesarios
        $hooksToRegister = [
            'displayAdminProductsMainStepLeftColumnMiddle',
            'displayBackOfficeHeader',
            'actionProductUpdate',
            'actionProductSave',
            'displayHeader',
            'displayMuestraVideo',
            'displayAfterProductThumbs'
        ];
        
        foreach ($hooksToRegister as $hook) {
            if (!$this->isRegisteredInHook($hook)) {
                $this->registerHook($hook);
            }
        }
        
        // 3. Asegurarse de que el hook personalizado existe
        $hookId = Db::getInstance()->getValue(
            'SELECT id_hook FROM `'._DB_PREFIX_.'hook` WHERE name = "displayMuestraVideo"'
        );
        
        if (!$hookId) {
            Db::getInstance()->execute(
                'INSERT INTO `'._DB_PREFIX_.'hook` (name, title, description, position) 
                 VALUES (
                    "displayMuestraVideo",
                    "Display YouTube Video",
                    "This hook displays a YouTube video on product page",
                    1
                )'
            );
        }
        
        // 4. Limpiar caché para que los cambios tengan efecto
        $this->_clearCache('*');
        
        return true;
    }

    /**
    * Custom hook to render gallery in any position
    */
    public function hookProductgalleryvideo($params)
    {
        return '';
    }
    
    /**
    * Add gallery container to product page footer (for backward compatibility)
    */
    public function hookDisplayFooterProduct($params)
    {
        return '';
    }

    /**
    * Add video to the product thumbs
    */
    public function hookDisplayAfterProductThumbs($params)
    {
        $id_product = (int)$params['product']->id;
        
        // Obtener la URL del video de la base de datos directamente
        $sql = 'SELECT `youtube_video_url` 
                FROM `' . _DB_PREFIX_ . 'product` 
                WHERE `id_product` = ' . $id_product;
        $videoUrl = Db::getInstance()->getValue($sql);
        
        // Si no hay URL de video, no mostramos nada
        if (empty($videoUrl)) {
            return '';
        }
        
        $videoId = $this->extractYoutubeId($videoUrl);
        
        // Si no se pudo extraer el ID del video, no mostramos nada
        if (!$videoId) {
            return '';
        }
        
        $this->context->smarty->assign([
            'youtube_video_id' => $videoId
        ]);
        
        return $this->display(__FILE__, 'views/templates/hook/video_thumb.tpl');
    }

    /**
     * Display video in product page (legacy support)
     */
    public function hookDisplayMuestraVideo($params)
    {
        $id_product = (int)Tools::getValue('id_product');
        
        // Debug info
        PrestaShopLogger::addLog('ProductYoutubeVideo: Se ha llamado al hook displayMuestraVideo para el producto ID: ' . $id_product);
        
        if (!$id_product) {
            PrestaShopLogger::addLog('ProductYoutubeVideo: ID de producto no encontrado');
            return '';
        }

        // Get video URL from database
        $sql = 'SELECT `youtube_video_url` 
                FROM `' . _DB_PREFIX_ . 'product` 
                WHERE `id_product` = ' . $id_product;
        
        $videoUrl = Db::getInstance()->getValue($sql);
        $videoId = $this->extractYoutubeId($videoUrl);
        
        // Get product images
        $product = new Product($id_product);
        $images = $product->getImages($this->context->language->id);
        
        // Si no hay imágenes, no mostramos nada
        if (empty($images)) {
            PrestaShopLogger::addLog('ProductYoutubeVideo: No hay imágenes para el producto ' . $id_product);
            return '';
        }
        
        // Get product features for material icon
        $features = $product->getFrontFeatures($this->context->language->id);
        $material = '';
        
        foreach ($features as $feature) {
            if ($feature['name'] == 'Material') {
                $material = $feature['value'];
                break;
            }
        }
        
        // Obtener link_rewrite del producto para las URLs de imágenes
        $product_link_rewrite = $product->link_rewrite[$this->context->language->id];
        
        // Asignar variables para la plantilla
        $this->context->smarty->assign([
            'youtube_video_id' => $videoId,
            'product_images' => $images,
            'material' => $material,
            'id_product' => $id_product,
            'base_url' => $this->context->link->getBaseLink(),
            'theme_url' => _PS_THEME_URI_,
            'product_link_rewrite' => $product_link_rewrite,
            'link' => $this->context->link
        ]);

        // Renderizar la galería completa en lugar de solo el video
        return $this->display(__FILE__, 'views/templates/hook/custom_gallery.tpl');
    }

    /**
     * Extract YouTube video ID from URL
     */
    private function extractYoutubeId($url)
    {
        if (empty($url)) {
            return false;
        }
        
        // Pattern también incluye youtube-nocookie.com
        $pattern = '/(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/';
        preg_match($pattern, $url, $matches);
        
        if (isset($matches[1])) {
            return $matches[1];
        }
        
        // Patrón alternativo para URLs de embed directas (como youtube-nocookie.com/embed/VIDEO_ID)
        $pattern2 = '/(?:youtube(?:-nocookie)?\.com\/embed\/)([a-zA-Z0-9_-]{11})(?:\?|$)/';
        preg_match($pattern2, $url, $matches);
        
        return isset($matches[1]) ? $matches[1] : false;
    }
    
    /**
     * Reset module
     */
    public function reset()
    {
        // Solo limpiar caché sin afectar a los datos de la base de datos
        $this->_clearCache('*');
        return true;
    }
}
