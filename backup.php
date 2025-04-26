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
 * Script para hacer respaldo de datos de vídeos de productos
 */

// Inicialización
require_once(dirname(__FILE__) . '/../../config/config.inc.php');
require_once(dirname(__FILE__) . '/../../init.php');

// Verificar autorización (solo administradores pueden ejecutar esto)
if (!Context::getContext()->employee->isLoggedBack()) {
    die('Acceso denegado');
}

// Crear directorio para respaldos si no existe
$backupDir = dirname(__FILE__) . '/backups';
if (!is_dir($backupDir)) {
    mkdir($backupDir, 0755, true);
}

// Fecha actual para el nombre del archivo
$date = date('Y-m-d_H-i-s');
$backupFile = $backupDir . '/youtube_videos_' . $date . '.csv';

// Obtener datos de vídeos de la base de datos
$db = Db::getInstance();
$sql = 'SELECT p.id_product, pl.name, p.youtube_video_url 
         FROM `' . _DB_PREFIX_ . 'product` p 
         LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON p.id_product = pl.id_product 
         WHERE p.youtube_video_url IS NOT NULL AND p.youtube_video_url != "" 
         AND pl.id_lang = ' . (int)Context::getContext()->language->id . ' 
         ORDER BY p.id_product ASC';

$results = $db->executeS($sql);

// Si no hay resultados
if (empty($results)) {
    echo "No se encontraron productos con vídeos de YouTube.";
    exit;
}

// Crear archivo CSV
$csv = fopen($backupFile, 'w');

// Cabeceras CSV
fputcsv($csv, ['ID Producto', 'Nombre del Producto', 'URL de YouTube']);

// Datos
foreach ($results as $row) {
    fputcsv($csv, [
        $row['id_product'],
        $row['name'],
        $row['youtube_video_url']
    ]);
}

fclose($csv);

// Opciones para restaurar
echo '<h1>Respaldo creado con éxito</h1>';
echo '<p>Se ha creado un respaldo de ' . count($results) . ' productos con vídeos de YouTube.</p>';
echo '<p>Archivo de respaldo: ' . $backupFile . '</p>';

// Enlace para descargar
echo '<a href="backups/youtube_videos_' . $date . '.csv" download>Descargar respaldo</a>';

// Información sobre restauración
echo '<h2>Para restaurar:</h2>';
echo '<p>Utiliza la función "Fix Issues" en la configuración del módulo y luego importa este CSV.</p>';
