/**
 * Script simple para mostrar videos de YouTube sin depender de FancyBox
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('SimplVideoModal: Inicializando...');
    
    // Crear el modal para videos
    createVideoModal();
    
    // Buscar todos los productos con videos
    detectAndSetupYoutubeVideos();
    
    /**
     * Crea el modal para mostrar videos
     */
    function createVideoModal() {
        // Verificar si ya existe
        if (document.getElementById('simple-video-modal')) {
            return;
        }
        
        // Crear el HTML del modal
        const modalHTML = `
            <div id="simple-video-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0.9); z-index:9999; overflow:hidden;">
                <div style="position:relative; width:90%; max-width:800px; margin:50px auto; padding-bottom:56.25%; height:0;">
                    <iframe id="simple-video-iframe" style="position:absolute; top:0; left:0; width:100%; height:100%; border:none;" frameborder="0" allowfullscreen></iframe>
                    <button id="simple-video-close" style="position:absolute; top:-40px; right:0; background:#ff0000; color:white; border:none; border-radius:50%; width:30px; height:30px; text-align:center; font-size:20px; line-height:1; cursor:pointer;">×</button>
                </div>
            </div>
        `;
        
        // Añadir el modal al body
        document.body.insertAdjacentHTML('beforeend', modalHTML);
        
        // Configurar el botón de cierre
        document.getElementById('simple-video-close').addEventListener('click', function() {
            closeVideoModal();
        });
        
        // Cerrar al hacer clic fuera del video
        document.getElementById('simple-video-modal').addEventListener('click', function(e) {
            if (e.target.id === 'simple-video-modal') {
                closeVideoModal();
            }
        });
        
        // Cerrar con ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeVideoModal();
            }
        });
        
        console.log('SimpleVideoModal: Modal creado');
    }
    
    /**
     * Cierra el modal de video
     */
    function closeVideoModal() {
        const modal = document.getElementById('simple-video-modal');
        const iframe = document.getElementById('simple-video-iframe');
        
        if (modal) {
            modal.style.display = 'none';
        }
        
        if (iframe) {
            iframe.src = '';
        }
    }
    
    /**
     * Abre el modal con un video de YouTube
     */
    function openVideoModal(videoId) {
        if (!videoId) {
            console.error('SimpleVideoModal: No se proporcionó ID de video');
            return;
        }
        
        const modal = document.getElementById('simple-video-modal');
        const iframe = document.getElementById('simple-video-iframe');
        
        if (!modal || !iframe) {
            console.error('SimpleVideoModal: Modal o iframe no encontrados');
            return;
        }
        
        // Establecer la URL del video
        iframe.src = `https://www.youtube-nocookie.com/embed/${videoId}?autoplay=1&rel=0`;
        
        // Mostrar el modal
        modal.style.display = 'block';
    }
    
    /**
     * Detecta y configura los videos de YouTube
     */
    function detectAndSetupYoutubeVideos() {
        // Crear un elemento para la miniatura de video si no existe
        createVideoThumbnail();
        
        // Configurar los eventos de clic para los elementos existentes
        setupExistingVideoElements();
    }
    
    /**
     * Crea una miniatura de video y la añade a la galería
     */
    function createVideoThumbnail() {
        // Buscar el contenedor de miniaturas
        const thumbsContainer = findThumbsContainer();
        if (!thumbsContainer) {
            console.error('SimpleVideoModal: No se encontró el contenedor de miniaturas');
            return;
        }
        
        // Buscar el ID de YouTube en los metadatos del producto
        const videoIdMeta = document.querySelector('meta[name="product-youtube-id"]');
        let videoId = videoIdMeta ? videoIdMeta.getAttribute('content') : null;
        
        // Como alternativa, buscar en los elementos existentes
        if (!videoId) {
            const existingElement = document.querySelector('[data-video-id]');
            videoId = existingElement ? existingElement.getAttribute('data-video-id') : null;
        }
        
        // Si no se encontró ningún ID, buscar en la URL de la página por un parámetro video_id
        if (!videoId) {
            const urlParams = new URLSearchParams(window.location.search);
            videoId = urlParams.get('video_id');
        }
        
        // Si aún no hay videoId, intentar extraer de elementos con href de youtube
        if (!videoId) {
            const youtubeLink = document.querySelector('a[href*="youtube.com/watch"], a[href*="youtu.be/"]');
            if (youtubeLink) {
                const href = youtubeLink.getAttribute('href');
                if (href.includes('youtube.com/watch')) {
                    videoId = href.split('v=')[1].split('&')[0];
                } else if (href.includes('youtu.be/')) {
                    videoId = href.split('youtu.be/')[1].split('?')[0];
                }
            }
        }
        
        // Si no se encontró ningún ID, salir
        if (!videoId) {
            console.log('SimpleVideoModal: No se encontró ID de video para este producto');
            return;
        }
        
        console.log('SimpleVideoModal: ID de video encontrado:', videoId);
        
        // Comprobar si ya existe una miniatura de video
        const existingThumb = document.querySelector('.video-thumb, .js-video-thumb');
        if (existingThumb) {
            console.log('SimpleVideoModal: Ya existe una miniatura de video');
            setupVideoThumbnail(existingThumb, videoId);
            return;
        }
        
        // Crear miniatura de video
        const thumbHTML = `
            <div class="thumb-container video-thumb js-video-thumb" data-video-id="${videoId}" style="position:relative; cursor:pointer; margin:5px; border:2px solid #ff0000; border-radius:4px; overflow:hidden;">
                <img src="https://img.youtube.com/vi/${videoId}/mqdefault.jpg" alt="Ver video del producto" style="width:100%; height:auto; display:block;">
                <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); background-color:rgba(255,0,0,0.7); border-radius:50%; width:30px; height:30px; display:flex; align-items:center; justify-content:center;">
                    <span style="color:white; font-size:16px; line-height:1;">▶</span>
                </div>
            </div>
        `;
        
        // Añadir la miniatura al contenedor
        thumbsContainer.insertAdjacentHTML('beforeend', thumbHTML);
        
        // Configurar el evento de clic
        const newThumb = document.querySelector('.js-video-thumb[data-video-id="' + videoId + '"]');
        if (newThumb) {
            setupVideoThumbnail(newThumb, videoId);
        }
        
        console.log('SimpleVideoModal: Miniatura de video creada y añadida');
    }
    
    /**
     * Busca el contenedor de miniaturas adecuado
     */
    function findThumbsContainer() {
        const possibleContainers = [
            '.product-images-thumbs',
            '.product-thumbs',
            '.js-qv-product-images',
            '.custom-gallery-thumbs',
            '.images-container .js-qv-mask',
            '.thumb-container',
            '.js-thumb-container',
            '.product-cover-thumbnails',
            '#thumb-gallery'
        ];
        
        for (const selector of possibleContainers) {
            const container = document.querySelector(selector);
            if (container) {
                console.log('SimpleVideoModal: Contenedor de miniaturas encontrado:', selector);
                return container;
            }
        }
        
        // Buscar cualquier contenedor que tenga miniaturas como último recurso
        const thumbs = document.querySelectorAll('.thumb, .js-thumb');
        if (thumbs.length > 0) {
            const parent = thumbs[0].closest('div');
            console.log('SimpleVideoModal: Contenedor alternativo encontrado');
            return parent;
        }
        
        return null;
    }
    
    /**
     * Configura eventos para una miniatura de video
     */
    function setupVideoThumbnail(thumbnail, videoId) {
        if (!thumbnail || !videoId) return;
        
        // Asegurarse de que sea visible
        thumbnail.style.display = 'block';
        thumbnail.style.visibility = 'visible';
        thumbnail.style.opacity = '1';
        
        // Añadir evento de clic
        thumbnail.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            openVideoModal(videoId);
        });
        
        console.log('SimpleVideoModal: Evento de clic configurado para miniatura');
    }
    
    /**
     * Configura eventos para elementos de video existentes
     */
    function setupExistingVideoElements() {
        // Miniaturas de video
        document.querySelectorAll('.video-thumb, .js-video-thumb').forEach(function(thumb) {
            const videoId = thumb.getAttribute('data-video-id');
            if (videoId) {
                setupVideoThumbnail(thumb, videoId);
            }
        });
        
        // Enlaces de video
        document.querySelectorAll('a[href*="youtube.com/watch"], a[href*="youtu.be/"]').forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                let videoId;
                const href = link.getAttribute('href');
                
                if (href.includes('youtube.com/watch')) {
                    videoId = href.split('v=')[1].split('&')[0];
                } else if (href.includes('youtu.be/')) {
                    videoId = href.split('youtu.be/')[1].split('?')[0];
                }
                
                if (videoId) {
                    openVideoModal(videoId);
                }
            });
        });
        
        console.log('SimpleVideoModal: Eventos configurados para elementos existentes');
    }
});
