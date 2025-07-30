import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../domain/models/media_models.dart';
import '../domain/services/media_service.dart';
import '../../auth/providers/auth_providers.dart';

// Media service provider
final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService();
});

// Family media stream provider
final familyMediaProvider = StreamProvider<List<MediaItemModel>>((ref) {
  final mediaService = ref.watch(mediaServiceProvider);
  return mediaService.getFamilyMediaStream();
});

// Family albums stream provider
final familyAlbumsProvider = StreamProvider<List<AlbumModel>>((ref) {
  final mediaService = ref.watch(mediaServiceProvider);
  return mediaService.getFamilyAlbumsStream();
});

// Timeline events stream provider
final timelineEventsProvider = StreamProvider<List<TimelineEventModel>>((ref) {
  final mediaService = ref.watch(mediaServiceProvider);
  return mediaService.getTimelineEventsStream();
});

// Album media stream provider
final albumMediaProvider = StreamProvider.family<List<MediaItemModel>, String>((ref, albumId) {
  final mediaService = ref.watch(mediaServiceProvider);
  return mediaService.getAlbumMediaStream(albumId);
});

// Media upload state provider
final mediaUploadStateProvider = StateNotifierProvider<MediaUploadController, MediaUploadState>((ref) {
  final mediaService = ref.watch(mediaServiceProvider);
  final currentUser = ref.watch(currentUserProvider);
  return MediaUploadController(mediaService, currentUser.value);
});

// Media upload state model
class MediaUploadState {
  final List<MediaUploadProgress> uploads;
  final bool isUploading;
  final String? error;

  MediaUploadState({
    this.uploads = const [],
    this.isUploading = false,
    this.error,
  });

  MediaUploadState copyWith({
    List<MediaUploadProgress>? uploads,
    bool? isUploading,
    String? error,
  }) {
    return MediaUploadState(
      uploads: uploads ?? this.uploads,
      isUploading: isUploading ?? this.isUploading,
      error: error,
    );
  }
}

// Media upload controller
class MediaUploadController extends StateNotifier<MediaUploadState> {
  final MediaService _mediaService;
  final dynamic _currentUser; // UserModel type would be here

  MediaUploadController(this._mediaService, this._currentUser) : super(MediaUploadState());

  // Upload single media file
  Future<MediaItemModel?> uploadMedia({
    required File file,
    String? caption,
    String? location,
    double? latitude,
    double? longitude,
    List<String> taggedUsers = const [],
    List<String> albumIds = const [],
  }) async {
    if (_currentUser == null) {
      state = state.copyWith(error: 'User not authenticated');
      return null;
    }

    try {
      state = state.copyWith(isUploading: true, error: null);

      final mediaItem = await _mediaService.uploadMedia(
        file: file,
        uploadedBy: _currentUser.uid,
        uploaderName: _currentUser.displayName ?? 'Unknown',
        uploaderAvatarUrl: _currentUser.photoURL,
        caption: caption,
        location: location,
        latitude: latitude,
        longitude: longitude,
        taggedUsers: taggedUsers,
        albumIds: albumIds,
        onProgress: (progress) {
          final updatedUploads = [...state.uploads];
          final existingIndex = updatedUploads.indexWhere(
            (upload) => upload.fileName == progress.fileName,
          );

          if (existingIndex != -1) {
            updatedUploads[existingIndex] = progress;
          } else {
            updatedUploads.add(progress);
          }

          state = state.copyWith(uploads: updatedUploads);
        },
      );

      // Remove completed upload from state
      final updatedUploads = state.uploads
          .where((upload) => upload.fileName != file.path)
          .toList();

      state = state.copyWith(
        uploads: updatedUploads,
        isUploading: false,
      );

      return mediaItem;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  // Upload multiple media files
  Future<List<MediaItemModel>> uploadMultipleMedia({
    required List<File> files,
    String? caption,
    String? location,
    double? latitude,
    double? longitude,
    List<String> taggedUsers = const [],
    List<String> albumIds = const [],
  }) async {
    final results = <MediaItemModel>[];

    for (final file in files) {
      final result = await uploadMedia(
        file: file,
        caption: caption,
        location: location,
        latitude: latitude,
        longitude: longitude,
        taggedUsers: taggedUsers,
        albumIds: albumIds,
      );

      if (result != null) {
        results.add(result);
      }
    }

    return results;
  }

  // Create album
  Future<AlbumModel?> createAlbum({
    required String name,
    String? description,
    required AlbumType type,
    List<String> collaborators = const [],
    bool isCollaborative = true,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    List<String> tags = const [],
  }) async {
    if (_currentUser == null) {
      state = state.copyWith(error: 'User not authenticated');
      return null;
    }

    try {
      final album = await _mediaService.createAlbum(
        name: name,
        description: description,
        createdBy: _currentUser.uid,
        creatorName: _currentUser.displayName ?? 'Unknown',
        type: type,
        collaborators: collaborators,
        isCollaborative: isCollaborative,
        startDate: startDate,
        endDate: endDate,
        location: location,
        tags: tags,
      );

      return album;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  // Like media
  Future<void> likeMedia(String mediaId) async {
    if (_currentUser == null) return;

    try {
      await _mediaService.likeMedia(mediaId, _currentUser.uid);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Unlike media
  Future<void> unlikeMedia(String mediaId) async {
    if (_currentUser == null) return;

    try {
      await _mediaService.unlikeMedia(mediaId, _currentUser.uid);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Add comment
  Future<void> addComment(String mediaId, String content) async {
    if (_currentUser == null) return;

    try {
      final comment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: _currentUser.uid,
        authorName: _currentUser.displayName ?? 'Unknown',
        authorAvatarUrl: _currentUser.photoURL,
        content: content,
        createdAt: DateTime.now(),
      );

      await _mediaService.addComment(mediaId, comment);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Delete media
  Future<void> deleteMedia(String mediaId) async {
    try {
      await _mediaService.deleteMedia(mediaId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
