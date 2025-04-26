/**
 * Funcionalidad básica de la galería y reproducción de videos
 * Script compatible con cualquier versión de Fancybox o sin Fancybox
 */
document.addEventListener('DOMContentLoaded', function() {
    // Comprobar si hay thumbnails de video independientes a la galería principal
    const standaloneVideoThumbs = document.querySelectorAll('.js-video-thumb');
    
    // Integrarlos en el sistema de galería de PrestaShop si existen
    if (standaloneVideoThumbs.length > 0) {
        standaloneVideoThumbs.forEach(function(videoThumb) {
            videoThumb.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Extraer el ID del video
                const videoId = videoThumb.getAttribute('data-video-id');
                
                if (videoId) {
                    // Si estamos usando FancyBox, abrir el video en FancyBox
                    if (typeof Fancybox !== 'undefined') {
                        Fancybox.show([{
                            src: `https://www.youtube.com/watch?v=${videoId}`,
                            type: 'video'
                        }]);
                    } else {
                        // Alternativa para mostrar el video si no hay FancyBox
                        const videoModalHTML = `
                            <div class="modal fade" id="videoModal${videoId}" tabindex="-1" role="dialog">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <div class="embed-responsive embed-responsive-16by9">
                                                <iframe class="embed-responsive-item" src="https://www.youtube-nocookie.com/embed/${videoId}?rel=0&showinfo=0&autoplay=1" allowfullscreen></iframe>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `;
                        
                        // Añadir modal al DOM si no existe
                        if (!document.getElementById(`videoModal${videoId}`)) {
                            document.body.insertAdjacentHTML('beforeend', videoModalHTML);
                        }
                        
                        // Abrir modal
                        if (typeof $ !== 'undefined') {
                            $(`#videoModal${videoId}`).modal('show');
                        }
                    }
                }
            });
        });
    }
    
    // Seleccionar todos los elementos necesarios
    const galleries = document.querySelectorAll('.product-custom-gallery');
    
    galleries.forEach(function(gallery) {
        const thumbs = gallery.querySelectorAll('.thumb-item');
        const slides = gallery.querySelectorAll('.gallery-slide-item');
        const prevBtn = gallery.querySelector('.custom-gallery-prev');
        const nextBtn = gallery.querySelector('.custom-gallery-next');
        const videoThumbs = gallery.querySelectorAll('.video-thumb');
        
        let currentIndex = 0;
        
        // Mostrar slide según índice
        function showSlide(index) {
            // Ocultar todos los slides
            slides.forEach(slide => slide.classList.remove('active'));
            
            // Mostrar el slide seleccionado
            if (slides[index]) {
                slides[index].classList.add('active');
                currentIndex = index;
                
                // Si hay un video reproduciéndose en otro slide, detenerlo
                resetOtherVideos(index);
            }
            
            // Actualizar miniaturas activas
            thumbs.forEach(thumb => thumb.classList.remove('active'));
            if (thumbs[index]) {
                thumbs[index].classList.add('active');
            }
        }
        
        // Detiene la reproducción de videos en slides no activos
        function resetOtherVideos(currentIndex) {
            slides.forEach(function(slide, idx) {
                if (idx !== currentIndex && slide.classList.contains('video-slide')) {
                    const iframe = slide.querySelector('iframe');
                    const overlay = slide.querySelector('.custom-video-overlay');
                    
                    if (iframe && iframe.src) {
                        // Guardar el data-src y limpiar el src para detener el video
                        iframe.src = '';
                        
                        // Mostrar nuevamente el overlay
                        if (overlay) {
                            overlay.classList.remove('hidden');
                            overlay.classList.add('active');
                        }
                    }
                }
            });
        }
        
        // Inicializar reproducción de video
        function initVideoPlayback(videoSlide) {
            if (!videoSlide) return;
            
            const videoOverlay = videoSlide.querySelector('.custom-video-overlay');
            const iframe = videoSlide.querySelector('iframe');
            
            if (videoOverlay && iframe) {
                // Asegurar que solo se añada un listener al overlay
                if (!videoOverlay.hasAttribute('data-listener-added')) {
                    videoOverlay.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        const dataSrc = iframe.getAttribute('data-src');
                        if (dataSrc) {
                            iframe.src = dataSrc;
                            videoOverlay.classList.add('hidden');
                        }
                    });
                    
                    // Marcar que ya se asignó el event listener
                    videoOverlay.setAttribute('data-listener-added', 'true');
                }
            }
        }
        
        // Configurar eventos para miniaturas
        thumbs.forEach(function(thumb, index) {
            thumb.addEventListener('click', function(e) {
                e.preventDefault();
                
                if (thumb.classList.contains('video-thumb')) {
                    // Si es una miniatura de video, preparar la reproducción
                    showSlide(index);
                    const videoSlide = slides[index];
                    initVideoPlayback(videoSlide);
                } else {
                    // Si es una imagen normal
                    showSlide(index);
                }
            });
        });
        
        // Configurar eventos para botones de navegación
        if (prevBtn) {
            prevBtn.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentIndex > 0) {
                    const newIndex = currentIndex - 1;
                    showSlide(newIndex);
                    
                    // Si el nuevo slide es un video, prepararlo para reproducción
                    if (slides[newIndex] && slides[newIndex].classList.contains('video-slide')) {
                        initVideoPlayback(slides[newIndex]);
                    }
                }
            });
        }
        
        if (nextBtn) {
            nextBtn.addEventListener('click', function(e) {
                e.preventDefault();
                if (currentIndex < slides.length - 1) {
                    const newIndex = currentIndex + 1;
                    showSlide(newIndex);
                    
                    // Si el nuevo slide es un video, prepararlo para reproducción
                    if (slides[newIndex] && slides[newIndex].classList.contains('video-slide')) {
                        initVideoPlayback(slides[newIndex]);
                    }
                }
            });
        }
        
        // Iniciar con el primer slide
        showSlide(0);
        
        // Inicializar todos los videos al principio
        slides.forEach(function(slide) {
            if (slide.classList.contains('video-slide')) {
                initVideoPlayback(slide);
            }
        });
    });
});
