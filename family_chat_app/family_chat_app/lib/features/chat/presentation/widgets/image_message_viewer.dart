import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';

class ImageMessageViewer extends ConsumerStatefulWidget {
  final String imageUrl;
  final String? caption;
  final VoidCallback? onTap;

  const ImageMessageViewer({
    super.key,
    required this.imageUrl,
    this.caption,
    this.onTap,
  });

  @override
  ConsumerState<ImageMessageViewer> createState() => _ImageMessageViewerState();
}

class _ImageMessageViewerState extends ConsumerState<ImageMessageViewer>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () => _showFullScreenImage(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Container(
            constraints: const BoxConstraints(
              maxWidth: 250,
              maxHeight: 300,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.glassBackground,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Loading shimmer
                  if (_isLoading)
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1.0 + _shimmerController.value * 2, 0),
                              end: Alignment(1.0 + _shimmerController.value * 2, 0),
                              colors: [
                                AppColors.glassBackground,
                                AppColors.glassBorder,
                                AppColors.glassBackground,
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Error state
                  if (_hasError)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: AppColors.textSecondary,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Kunne ikke laste bilde',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Actual image
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                              _hasError = false;
                            });
                          }
                        });
                        return child;
                      }
                      return const SizedBox.shrink();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _hasError = true;
                          });
                        }
                      });
                      return const SizedBox.shrink();
                    },
                  ),

                  // Glass overlay with download button
                  if (!_isLoading && !_hasError)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GlassContainer(
                        borderRadius: 20,
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () => _downloadImage(),
                          child: const Icon(
                            Icons.download,
                            color: AppColors.textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),

                  // Play button overlay for videos (if needed in the future)
                  // if (isVideo)
                  //   Positioned.fill(
                  //     child: Center(
                  //       child: GlassContainer(
                  //         borderRadius: 30,
                  //         padding: const EdgeInsets.all(12),
                  //         child: const Icon(
                  //           Icons.play_arrow,
                  //           color: AppColors.textPrimary,
                  //           size: 24,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),

          // Caption
          if (widget.caption != null && widget.caption!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.glassBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: Text(
                widget.caption!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImageViewer(
            imageUrl: widget.imageUrl,
            caption: widget.caption,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _downloadImage() {
    // TODO: Implement image download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laster ned bilde...'),
        backgroundColor: AppColors.glassBackground,
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? caption;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.caption,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final TransformationController _transformationController = TransformationController();
  bool _showControls = true;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            // Image with zoom
            Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: AppColors.textSecondary,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Kunne ikke laste bilde',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Top controls
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        // Download button
                        IconButton(
                          onPressed: () => _downloadImage(),
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                        ),
                        // Share button
                        IconButton(
                          onPressed: () => _shareImage(),
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom caption
            if (_showControls && widget.caption != null && widget.caption!.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.caption!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _downloadImage() {
    // TODO: Implement image download functionality
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laster ned bilde...'),
        backgroundColor: AppColors.glassBackground,
      ),
    );
  }

  void _shareImage() {
    // TODO: Implement image sharing functionality
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deler bilde...'),
        backgroundColor: AppColors.glassBackground,
      ),
    );
  }
}
