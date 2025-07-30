import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../shared/presentation/theme/app_theme.dart';
import '../providers/media_providers.dart';
import '../domain/models/media_models.dart';
import 'widgets/media_item_card.dart';
import 'widgets/upload_media_dialog.dart';
import 'widgets/create_album_dialog.dart';

class MediaGalleryPage extends ConsumerStatefulWidget {
  const MediaGalleryPage({super.key});

  @override
  ConsumerState<MediaGalleryPage> createState() => _MediaGalleryPageState();
}

class _MediaGalleryPageState extends ConsumerState<MediaGalleryPage>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Familie Gallery',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            GlassButton(
              onPressed: () => _showUploadDialog(),
              child: const Icon(Icons.add_photo_alternate, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            GlassButton(
              onPressed: () => _showCreateAlbumDialog(),
              child: const Icon(Icons.photo_album, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            onTap: (index) => setState(() => _selectedTabIndex = index),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Alle bilder', icon: Icon(Icons.photo_library)),
              Tab(text: 'Album', icon: Icon(Icons.collections)),
              Tab(text: 'Tidslinje', icon: Icon(Icons.timeline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllMediaTab(),
            _buildAlbumsTab(),
            _buildTimelineTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllMediaTab() {
    final familyMedia = ref.watch(familyMediaProvider);
    
    return familyMedia.when(
      data: (mediaItems) => mediaItems.isEmpty
        ? _buildEmptyMediaState()
        : _buildMediaGrid(mediaItems),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildAlbumsTab() {
    final familyAlbums = ref.watch(familyAlbumsProvider);
    
    return familyAlbums.when(
      data: (albums) => albums.isEmpty
        ? _buildEmptyAlbumsState()
        : _buildAlbumsGrid(albums),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildTimelineTab() {
    final timelineEvents = ref.watch(timelineEventsProvider);
    
    return timelineEvents.when(
      data: (events) => events.isEmpty
        ? _buildEmptyTimelineState()
        : _buildTimelineList(events),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildMediaGrid(List<MediaItemModel> mediaItems) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return MediaItemCard(
            mediaItem: mediaItem,
            onTap: () => _openMediaViewer(mediaItem, mediaItems),
            onLike: () => _toggleLike(mediaItem),
            onComment: () => _showCommentDialog(mediaItem),
            onShare: () => _shareMedia(mediaItem),
          );
        },
      ),
    );
  }

  Widget _buildAlbumsGrid(List<AlbumModel> albums) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return _buildAlbumCard(album);
        },
      ),
    );
  }

  Widget _buildTimelineList(List<TimelineEventModel> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildTimelineEventCard(event),
        );
      },
    );
  }

  Widget _buildAlbumCard(AlbumModel album) {
    return GestureDetector(
      onTap: () => _openAlbum(album),
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.glassBackground,
                ),
                child: album.coverPhotoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        album.coverPhotoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => _buildAlbumPlaceholder(),
                      ),
                    )
                  : _buildAlbumPlaceholder(),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Album info
            Text(
              album.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 2),
            
            Text(
              '${album.mediaItems.length} bilder',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.accent.withOpacity(0.2),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.photo_album,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildTimelineEventCard(TimelineEventModel event) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event header
          Row(
            children: [
              if (event.coverPhotoUrl != null)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(event.coverPhotoUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    Text(
                      _formatEventDate(event.date),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              Text(
                '${event.mediaItems.length}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          if (event.description != null) ...[
            const SizedBox(height: 12),
            Text(
              event.description!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ],
          
          if (event.location != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  event.location!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyMediaState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingen bilder ennå',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Del familie minner med alle',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassButton(
            onPressed: () => _showUploadDialog(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Last opp bilder',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAlbumsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_album_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingen album ennå',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Opprett album for spesielle anledninger',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassButton(
            onPressed: () => _showCreateAlbumDialog(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_album, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Opprett album',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTimelineState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'Tidslinjen vil fylle seg',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Når dere deler bilder vil de samles her',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.textSecondary,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Kunne ikke laste innhold',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GlassButton(
            onPressed: () {
              // Refresh data based on current tab
              if (_selectedTabIndex == 0) {
                ref.refresh(familyMediaProvider);
              } else if (_selectedTabIndex == 1) {
                ref.refresh(familyAlbumsProvider);
              } else {
                ref.refresh(timelineEventsProvider);
              }
            },
            child: const Text(
              'Prøv igjen',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    const months = [
      '', 'januar', 'februar', 'mars', 'april', 'mai', 'juni',
      'juli', 'august', 'september', 'oktober', 'november', 'desember'
    ];
    return '${date.day}. ${months[date.month]} ${date.year}';
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => const UploadMediaDialog(),
    );
  }

  void _showCreateAlbumDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => const CreateAlbumDialog(),
    );
  }

  void _openMediaViewer(MediaItemModel mediaItem, List<MediaItemModel> allMedia) {
    // TODO: Implement full-screen media viewer
  }

  void _openAlbum(AlbumModel album) {
    // TODO: Navigate to album detail page
  }

  void _toggleLike(MediaItemModel mediaItem) {
    final uploadController = ref.read(mediaUploadStateProvider.notifier);
    // Check if user already liked this media
    final currentUser = ref.read(currentUserProvider);
    final hasLiked = currentUser.value != null && 
                    mediaItem.likedBy.contains(currentUser.value!.uid);
    
    if (hasLiked) {
      uploadController.unlikeMedia(mediaItem.id);
    } else {
      uploadController.likeMedia(mediaItem.id);
    }
  }

  void _showCommentDialog(MediaItemModel mediaItem) {
    // TODO: Implement comment dialog
  }

  void _shareMedia(MediaItemModel mediaItem) {
    // TODO: Implement media sharing
  }
}
