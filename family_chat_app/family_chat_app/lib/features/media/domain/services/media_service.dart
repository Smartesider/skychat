import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;
import '../models/media_models.dart';

class MediaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String _mediaCollection = 'media_items';
  static const String _albumsCollection = 'albums';
  static const String _timelineCollection = 'timeline_events';

  // Upload media with compression and metadata extraction
  Future<MediaItemModel> uploadMedia({
    required File file,
    required String uploadedBy,
    required String uploaderName,
    String? uploaderAvatarUrl,
    String? caption,
    String? location,
    double? latitude,
    double? longitude,
    List<String> taggedUsers = const [],
    List<String> albumIds = const [],
    Function(MediaUploadProgress)? onProgress,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final fileExtension = path.extension(fileName).toLowerCase();
      final mediaType = _getMediaType(fileExtension);
      
      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = '${timestamp}_$fileName';
      
      // Compress and prepare file
      File processedFile = file;
      Map<String, String> metadata = {};
      
      if (mediaType == MediaType.photo) {
        final result = await _processImage(file);
        processedFile = result['file'] as File;
        metadata = result['metadata'] as Map<String, String>;
      }
      
      // Upload to Firebase Storage
      final storageRef = _storage.ref().child('media/$uniqueFileName');
      final uploadTask = storageRef.putFile(processedFile);
      
      // Monitor upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(MediaUploadProgress(
          fileName: fileName,
          progress: progress,
          uploadedBytes: snapshot.bytesTransferred,
          totalBytes: snapshot.totalBytes,
        ));
      });
      
      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();
      
      // Generate thumbnail for videos
      String? thumbnailUrl;
      if (mediaType == MediaType.video) {
        thumbnailUrl = await _generateVideoThumbnail(file, uniqueFileName);
      }
      
      // Create media item
      final mediaItem = MediaItemModel(
        id: '', // Will be set by Firestore
        uploadedBy: uploadedBy,
        uploaderName: uploaderName,
        uploaderAvatarUrl: uploaderAvatarUrl,
        fileName: fileName,
        fileUrl: downloadUrl,
        thumbnailUrl: thumbnailUrl,
        type: mediaType,
        fileSize: await file.length(),
        uploadedAt: DateTime.now(),
        takenAt: _extractDateTaken(metadata),
        caption: caption,
        location: location,
        latitude: latitude,
        longitude: longitude,
        taggedUsers: taggedUsers,
        metadata: metadata,
        width: metadata['width'] != null ? int.tryParse(metadata['width']!) : null,
        height: metadata['height'] != null ? int.tryParse(metadata['height']!) : null,
        duration: mediaType == MediaType.video ? await _getVideoDuration(file) : null,
        albumIds: albumIds,
      );
      
      // Save to Firestore
      final docRef = await _firestore.collection(_mediaCollection).add(mediaItem.toJson());
      final savedMediaItem = mediaItem.copyWith(id: docRef.id);
      
      // Update document with ID
      await docRef.update({'id': docRef.id});
      
      // Add to albums if specified
      for (final albumId in albumIds) {
        await _addMediaToAlbum(albumId, docRef.id);
      }
      
      // Create timeline event if significant
      await _maybeCreateTimelineEvent(savedMediaItem);
      
      onProgress?.call(MediaUploadProgress(
        fileName: fileName,
        progress: 1.0,
        uploadedBytes: await file.length(),
        totalBytes: await file.length(),
        isCompleted: true,
      ));
      
      return savedMediaItem;
    } catch (e) {
      onProgress?.call(MediaUploadProgress(
        fileName: path.basename(file.path),
        progress: 0.0,
        uploadedBytes: 0,
        totalBytes: await file.length(),
        error: e.toString(),
      ));
      rethrow;
    }
  }

  // Create album
  Future<AlbumModel> createAlbum({
    required String name,
    String? description,
    required String createdBy,
    required String creatorName,
    required AlbumType type,
    List<String> collaborators = const [],
    bool isCollaborative = true,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    List<String> tags = const [],
  }) async {
    final album = AlbumModel(
      id: '',
      name: name,
      description: description,
      createdBy: createdBy,
      creatorName: creatorName,
      createdAt: DateTime.now(),
      type: type,
      collaborators: collaborators,
      isCollaborative: isCollaborative,
      startDate: startDate,
      endDate: endDate,
      location: location,
      tags: tags,
    );
    
    final docRef = await _firestore.collection(_albumsCollection).add(album.toJson());
    final savedAlbum = album.copyWith(id: docRef.id);
    
    await docRef.update({'id': docRef.id});
    
    return savedAlbum;
  }

  // Get family media stream
  Stream<List<MediaItemModel>> getFamilyMediaStream() {
    return _firestore
        .collection(_mediaCollection)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MediaItemModel.fromJson(doc.data()))
            .toList());
  }

  // Get album media
  Stream<List<MediaItemModel>> getAlbumMediaStream(String albumId) {
    return _firestore
        .collection(_mediaCollection)
        .where('albumIds', arrayContains: albumId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MediaItemModel.fromJson(doc.data()))
            .toList());
  }

  // Get family albums
  Stream<List<AlbumModel>> getFamilyAlbumsStream() {
    return _firestore
        .collection(_albumsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlbumModel.fromJson(doc.data()))
            .toList());
  }

  // Get timeline events
  Stream<List<TimelineEventModel>> getTimelineEventsStream() {
    return _firestore
        .collection(_timelineCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimelineEventModel.fromJson(doc.data()))
            .toList());
  }

  // Like media
  Future<void> likeMedia(String mediaId, String userId) async {
    final docRef = _firestore.collection(_mediaCollection).doc(mediaId);
    await docRef.update({
      'likedBy': FieldValue.arrayUnion([userId]),
      'likesCount': FieldValue.increment(1),
    });
  }

  // Unlike media
  Future<void> unlikeMedia(String mediaId, String userId) async {
    final docRef = _firestore.collection(_mediaCollection).doc(mediaId);
    await docRef.update({
      'likedBy': FieldValue.arrayRemove([userId]),
      'likesCount': FieldValue.increment(-1),
    });
  }

  // Add comment
  Future<void> addComment(String mediaId, CommentModel comment) async {
    final docRef = _firestore.collection(_mediaCollection).doc(mediaId);
    await docRef.update({
      'comments': FieldValue.arrayUnion([comment.toJson()]),
    });
  }

  // Delete media
  Future<void> deleteMedia(String mediaId) async {
    try {
      final doc = await _firestore.collection(_mediaCollection).doc(mediaId).get();
      if (doc.exists) {
        final mediaItem = MediaItemModel.fromJson(doc.data()!);
        
        // Delete from Storage
        await _storage.refFromURL(mediaItem.fileUrl).delete();
        if (mediaItem.thumbnailUrl != null) {
          await _storage.refFromURL(mediaItem.thumbnailUrl!).delete();
        }
        
        // Delete from Firestore
        await doc.reference.delete();
        
        // Remove from albums
        for (final albumId in mediaItem.albumIds) {
          await _removeMediaFromAlbum(albumId, mediaId);
        }
      }
    } catch (e) {
      debugPrint('Error deleting media: $e');
      rethrow;
    }
  }

  // Private helper methods
  MediaType _getMediaType(String extension) {
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    const videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    
    if (imageExtensions.contains(extension)) {
      return MediaType.photo;
    } else if (videoExtensions.contains(extension)) {
      return MediaType.video;
    } else {
      return MediaType.document;
    }
  }

  Future<Map<String, dynamic>> _processImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        return {'file': file, 'metadata': <String, String>{}};
      }
      
      // Extract metadata
      final metadata = <String, String>{
        'width': image.width.toString(),
        'height': image.height.toString(),
        'format': image.format.toString(),
      };
      
      // Compress if too large
      const maxWidth = 1920;
      const maxHeight = 1080;
      
      img.Image processedImage = image;
      if (image.width > maxWidth || image.height > maxHeight) {
        processedImage = img.copyResize(
          image,
          width: image.width > image.height ? maxWidth : null,
          height: image.height > image.width ? maxHeight : null,
        );
      }
      
      // Save compressed image
      final compressedBytes = img.encodeJpg(processedImage, quality: 85);
      final compressedFile = File('${file.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);
      
      return {'file': compressedFile, 'metadata': metadata};
    } catch (e) {
      debugPrint('Error processing image: $e');
      return {'file': file, 'metadata': <String, String>{}};
    }
  }

  Future<String?> _generateVideoThumbnail(File videoFile, String fileName) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: null,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );
      
      if (thumbnailPath == null) return null;
      
      final thumbnailFile = File(thumbnailPath);
      final thumbnailRef = _storage.ref().child('thumbnails/${fileName}_thumb.jpg');
      await thumbnailRef.putFile(thumbnailFile);
      
      final thumbnailUrl = await thumbnailRef.getDownloadURL();
      
      // Clean up temporary file
      await thumbnailFile.delete();
      
      return thumbnailUrl;
    } catch (e) {
      debugPrint('Error generating video thumbnail: $e');
      return null;
    }
  }

  Future<int?> _getVideoDuration(File videoFile) async {
    // This would require a video processing package
    // For now, return null - implement based on your video package choice
    return null;
  }

  DateTime? _extractDateTaken(Map<String, String> metadata) {
    // Extract date from EXIF data if available
    // This would require an EXIF processing package
    return null;
  }

  Future<void> _addMediaToAlbum(String albumId, String mediaId) async {
    await _firestore.collection(_albumsCollection).doc(albumId).update({
      'mediaItems': FieldValue.arrayUnion([mediaId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _removeMediaFromAlbum(String albumId, String mediaId) async {
    await _firestore.collection(_albumsCollection).doc(albumId).update({
      'mediaItems': FieldValue.arrayRemove([mediaId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _maybeCreateTimelineEvent(MediaItemModel mediaItem) async {
    // Create timeline events for significant media uploads
    // (e.g., first photo of the day, videos, multiple photos)
    
    // Check if this is the first media of the day
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    final todayMedia = await _firestore
        .collection(_mediaCollection)
        .where('uploadedAt', isGreaterThanOrEqualTo: todayStart)
        .where('uploadedAt', isLessThan: todayEnd)
        .get();
    
    if (todayMedia.docs.length == 1) {
      // First media of the day - create timeline event
      final timelineEvent = TimelineEventModel(
        id: '',
        title: 'Nye minner fra ${_formatDate(today)}',
        description: mediaItem.caption ?? 'Nye bilder og videoer fra familien',
        date: today,
        createdBy: mediaItem.uploadedBy,
        creatorName: mediaItem.uploaderName,
        mediaItems: [mediaItem.id],
        location: mediaItem.location,
        coverPhotoUrl: mediaItem.type == MediaType.photo ? mediaItem.fileUrl : mediaItem.thumbnailUrl,
        createdAt: DateTime.now(),
      );
      
      final docRef = await _firestore.collection(_timelineCollection).add(timelineEvent.toJson());
      await docRef.update({'id': docRef.id});
    } else {
      // Add to existing timeline event
      final existingEvent = todayMedia.docs.first;
      await _firestore.collection(_timelineCollection).doc(existingEvent.id).update({
        'mediaItems': FieldValue.arrayUnion([mediaItem.id]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'januar', 'februar', 'mars', 'april', 'mai', 'juni',
      'juli', 'august', 'september', 'oktober', 'november', 'desember'
    ];
    return '${date.day}. ${months[date.month]} ${date.year}';
  }
}
