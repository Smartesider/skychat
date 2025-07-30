import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create a new post
  Future<String> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required CreatePostData postData,
  }) async {
    try {
      // Upload images if any
      List<String> imageUrls = [];
      if (postData.imagePaths.isNotEmpty) {
        imageUrls = await _uploadImages(postData.imagePaths, authorId);
      }

      // Create post document
      final postRef = _firestore.collection('posts').doc();
      final post = PostModel(
        id: postRef.id,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        content: postData.content,
        type: postData.type,
        imageUrls: imageUrls,
        metadata: postData.metadata,
        createdAt: DateTime.now(),
      );

      await postRef.set(post.toJson());
      return postRef.id;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Get posts feed
  Stream<List<PostModel>> getPostsFeed({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) {
    Query query = _firestore
        .collection('posts')
        .where('isVisible', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  // Like/unlike a post
  Future<void> togglePostLike(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      
      await _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) throw Exception('Post not found');

        final data = postDoc.data()!;
        final likedBy = List<String>.from(data['likedBy'] ?? []);
        
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
        } else {
          likedBy.add(userId);
        }
        
        transaction.update(postRef, {'likedBy': likedBy});
      });
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // Add comment to post
  Future<void> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final commentRef = _firestore.collection('comments').doc();
      final comment = CommentModel(
        id: commentRef.id,
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        content: content,
        createdAt: DateTime.now(),
        parentCommentId: parentCommentId,
      );

      await commentRef.set(comment.toJson());

      // Update post with comment reference (simplified approach)
      await _firestore.collection('posts').doc(postId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Get comments for a post
  Stream<List<CommentModel>> getPostComments(String postId) {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CommentModel.fromJson(data);
      }).toList();
    });
  }

  // Upload images to Firebase Storage
  Future<List<String>> _uploadImages(List<String> imagePaths, String userId) async {
    final List<String> downloadUrls = [];
    
    for (int i = 0; i < imagePaths.length; i++) {
      final file = File(imagePaths[i]);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child('posts/$userId/$fileName');
      
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    
    return downloadUrls;
  }

  // Delete post
  Future<void> deletePost(String postId, String authorId) async {
    try {
      // Only author can delete their own posts
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      if (!postDoc.exists) throw Exception('Post not found');
      
      final data = postDoc.data()!;
      if (data['authorId'] != authorId) {
        throw Exception('Not authorized to delete this post');
      }

      // Delete post
      await _firestore.collection('posts').doc(postId).delete();
      
      // Delete associated comments
      final commentsQuery = await _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in commentsQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}

// Provider for PostService
final postServiceProvider = Provider<PostService>((ref) {
  return PostService();
});
