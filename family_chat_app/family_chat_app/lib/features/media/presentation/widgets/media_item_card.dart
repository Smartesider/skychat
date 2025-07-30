import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../domain/models/media_models.dart';

class MediaItemCard extends StatelessWidget {
  final MediaItemModel mediaItem;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const MediaItemCard({
    super.key,
    required this.mediaItem,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media content
            _buildMediaContent(),
            
            const SizedBox(height: 8),
            
            // Media info
            _buildMediaInfo(),
            
            const SizedBox(height: 8),
            
            // Actions
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            // Main image/video
            if (mediaItem.type == MediaType.photo)
              Image.network(
                mediaItem.fileUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: AppColors.glassBackground,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) => _buildErrorPlaceholder(),
              )
            else if (mediaItem.type == MediaType.video && mediaItem.thumbnailUrl != null)
              Image.network(
                mediaItem.thumbnailUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stack) => _buildVideoPlaceholder(),
              )
            else
              _buildDocumentPlaceholder(),
            
            // Video play button overlay
            if (mediaItem.type == MediaType.video)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            
            // Duration badge for videos
            if (mediaItem.type == MediaType.video && mediaItem.duration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(mediaItem.duration!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Uploader info
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: mediaItem.uploaderAvatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      mediaItem.uploaderAvatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _buildAvatarFallback(),
                    ),
                  )
                : _buildAvatarFallback(),
            ),
            
            const SizedBox(width: 8),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mediaItem.uploaderName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeago.format(mediaItem.uploadedAt, locale: 'no'),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // Caption
        if (mediaItem.caption != null && mediaItem.caption!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            mediaItem.caption!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        // Location
        if (mediaItem.location != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.textSecondary,
                size: 12,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  mediaItem.location!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Like button
        GestureDetector(
          onTap: onLike,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: mediaItem.likesCount > 0 ? Colors.red : AppColors.textSecondary,
                size: 16,
              ),
              if (mediaItem.likesCount > 0) ...[
                const SizedBox(width: 4),
                Text(
                  mediaItem.likesCount.toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Comment button
        GestureDetector(
          onTap: onComment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.textSecondary,
                size: 16,
              ),
              if (mediaItem.comments.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  mediaItem.comments.length.toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const Spacer(),
        
        // Share button
        GestureDetector(
          onTap: onShare,
          child: const Icon(
            Icons.share,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: AppColors.glassBackground,
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: AppColors.textSecondary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.videocam,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildDocumentPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              mediaItem.fileName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Text(
        mediaItem.uploaderName.isNotEmpty 
          ? mediaItem.uploaderName[0].toUpperCase()
          : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
