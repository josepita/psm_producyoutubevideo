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
 */

/**
 * Script para restaurar datos de vídeos de productos desde un respaldo
 */

// Inicialización
require_once(dirname(__FILE__) . '/../../config/config.inc.php');
require_once(dirname(__FILE__) . '/../../init.php');

// Verificar autorización (solo administradores pueden ejecutar esto)
if (!Context::getContext()->employee->isLoggedBack()) {
    die('Acceso denegado');
}

// Si se envió un archivo
if (isset($_FILES['backup_file']) && $_FILES['backup_file']['error'] == 0) {
    $csvFile = $_FILES['backup_file']['tmp_name'];
    
    // Abrir el archivo
    if (($handle = fopen($csvFile, "r")) !== FALSE) {
        // Leer la cabecera
        $header = fgetcsv($handle);
        
        // Verificar que el formato es correcto
        if ($header[0] == 'ID Producto' && $header[1] == 'Nombre del Producto' && $header[2] == 'URL de YouTube') {
            
            $db = Db::getInstance();
            $restored = 0;
            $errors = 0;
            
            // Procesar cada línea
            while (($data = fgetcsv($handle)) !== FALSE) {
                // Extraer datos
                $id_product = (int)$data[0];
                $youtube_url = pSQL($data[2]);
                
                // Actualizar base de datos
                $result = $db->execute('
                    UPDATE `' . _DB_PREFIX_ . 'product` 
                    SET `youtube_video_url` = "' . $youtube_url . '" 
                    WHERE `id_product` = ' . $id_product
                );
                
                if ($result) {
                    $restored++;
                } else {
                    $errors++;
                }
            }
            
            // Mostrar resultado
            echo '<h1>Restauración completada</h1>';
            echo '<p>Se restauraron ' . $restored . ' productos con vídeos de YouTube.</p>';
            
            if ($errors > 0) {
                echo '<p>Hubo ' . $errors . ' errores durante la restauración.</p>';
            }
            
            // Limpiar caché
            $module = Module::getInstanceByName('productyoutubevideo');
            if ($module) {
                $module->_clearCache('*');
            }
            
            echo '<p><a href="../../' . basename(_PS_ADMIN_DIR_) . '/' . Context::getContext()->link->getAdminLink('AdminModules') . '&configure=productyoutubevideo">Volver a la configuración del módulo</a></p>';
            
        } else {
            echo '<h1>Error</h1>';
            echo '<p>El formato del archivo CSV no es correcto. Debe tener las columnas: ID Producto, Nombre del Producto, URL de YouTube.</p>';
        }
        
        fclose($handle);
    }
} else {
    // Mostrar formulario para subir archivo
    echo '<!DOCTYPE html>
    <html>
    <head>
        <title>Restaurar vídeos de YouTube</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            h1 { color: #333; }
            form { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
            label { display: block; margin-bottom: 10px; }
            input[type="file"] { margin-bottom: 20px; }
            input[type="submit"] { background: #0078d7; color: white; border: none; padding: 10px 20px; border-radius: 3px; cursor: pointer; }
            .note { background: #ffffd0; padding: 10px; border-radius: 3px; margin-top: 20px; }
        </style>
    </head>
    <body>
        <h1>Restaurar vídeos de YouTube desde respaldo</h1>
        
        <form action="" method="post" enctype="multipart/form-data">
            <label for="backup_file">Seleccionar archivo CSV de respaldo:</label>
            <input type="file" name="backup_file" id="backup_file" accept=".csv" required>
            
            <input type="submit" value="Restaurar">
        </form>
        
        <div class="note">
            <strong>Nota:</strong> Este proceso actualizará los vídeos de YouTube de los productos según el archivo CSV.
            Asegúrate de que el archivo tenga el formato correcto: ID Producto, Nombre del Producto, URL de YouTube.
        </div>
        
        <p><a href="../../' . basename(_PS_ADMIN_DIR_) . '/' . Context::getContext()->link->getAdminLink('AdminModules') . '&configure=productyoutubevideo">Volver a la configuración del módulo</a></p>
    </body>
    </html>';
}
