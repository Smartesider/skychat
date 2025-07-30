import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_models.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  CollectionReference get _chatRoomsCollection => _firestore.collection('chatRooms');
  CollectionReference get _messagesCollection => _firestore.collection('messages');
  CollectionReference get _typingIndicatorsCollection => _firestore.collection('typingIndicators');

  // Get chat rooms for a family
  Stream<List<ChatRoomModel>> getFamilyChatRooms(String familyId) {
    return _chatRoomsCollection
        .where('familyId', isEqualTo: familyId)
        .where('isActive', isEqualTo: true)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ChatRoomModel.fromJson(data);
      }).toList();
    });
  }

  // Get user's chat rooms
  Stream<List<ChatRoomModel>> getUserChatRooms(String userId) {
    return _chatRoomsCollection
        .where('memberIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ChatRoomModel.fromJson(data);
      }).toList();
    });
  }

  // Get messages for a chat room
  Stream<List<MessageModel>> getChatMessages(String chatRoomId, {int limit = 50}) {
    return _messagesCollection
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      final messages = <MessageModel>[];
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        
        // Fetch reply message if exists
        if (data['replyToMessageId'] != null) {
          try {
            final replyDoc = await _messagesCollection.doc(data['replyToMessageId']).get();
            if (replyDoc.exists) {
              final replyData = replyDoc.data() as Map<String, dynamic>;
              replyData['id'] = replyDoc.id;
              data['replyToMessage'] = replyData;
            }
          } catch (e) {
            // Handle error silently
          }
        }
        
        messages.add(MessageModel.fromJson(data));
      }
      
      return messages.reversed.toList(); // Reverse to show oldest first
    });
  }

  // Send a message
  Future<String> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required CreateMessageData messageData,
  }) async {
    final now = DateTime.now();
    final messageId = _messagesCollection.doc().id;

    // Create message
    final message = MessageModel(
      id: messageId,
      chatRoomId: chatRoomId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      type: messageData.type,
      content: messageData.content,
      imageUrls: messageData.imageUrls,
      voiceNoteUrl: messageData.voiceNoteUrl,
      voiceNoteDuration: messageData.voiceNoteDuration,
      metadata: messageData.metadata,
      replyToMessageId: messageData.replyToMessageId,
      reactions: {},
      status: MessageStatus.sending,
      readStatus: {
        senderId: MessageReadStatus(
          userId: senderId,
          readAt: now,
          deliveredAt: now,
        ),
      },
      createdAt: now,
    );

    // Save message
    await _messagesCollection.doc(messageId).set(message.toJson());

    // Update chat room last message
    await _updateChatRoomLastMessage(chatRoomId, message);

    // Update message status to sent
    await _messagesCollection.doc(messageId).update({
      'status': MessageStatus.sent.name,
    });

    return messageId;
  }

  // Upload voice note
  Future<String> uploadVoiceNote(File audioFile, String chatRoomId) async {
    final fileName = 'voice_notes/$chatRoomId/${DateTime.now().millisecondsSinceEpoch}.m4a';
    final ref = _storage.ref().child(fileName);
    
    final uploadTask = ref.putFile(
      audioFile,
      SettableMetadata(contentType: 'audio/m4a'),
    );

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Upload images
  Future<List<String>> uploadImages(List<File> imageFiles, String chatRoomId) async {
    final urls = <String>[];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final fileName = 'chat_images/$chatRoomId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child(fileName);
      
      final uploadTask = ref.putFile(
        imageFiles[i],
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }
    
    return urls;
  }

  // Add reaction to message
  Future<void> addReaction(String messageId, String userId, String emoji) async {
    await _messagesCollection.doc(messageId).update({
      'reactions.$userId': MessageReaction(
        userId: userId,
        emoji: emoji,
        createdAt: DateTime.now(),
      ).toJson(),
    });
  }

  // Remove reaction from message
  Future<void> removeReaction(String messageId, String userId) async {
    await _messagesCollection.doc(messageId).update({
      'reactions.$userId': FieldValue.delete(),
    });
  }

  // Mark message as read
  Future<void> markMessageAsRead(String messageId, String userId) async {
    final now = DateTime.now();
    await _messagesCollection.doc(messageId).update({
      'readStatus.$userId': MessageReadStatus(
        userId: userId,
        readAt: now,
        deliveredAt: now,
      ).toJson(),
    });
  }

  // Mark all messages in chat room as read
  Future<void> markChatAsRead(String chatRoomId, String userId) async {
    final batch = _firestore.batch();
    final now = DateTime.now();

    // Get unread messages
    final unreadMessages = await _messagesCollection
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('readStatus.$userId', isNull: true)
        .get();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'readStatus.$userId': MessageReadStatus(
          userId: userId,
          readAt: now,
          deliveredAt: now,
        ).toJson(),
      });
    }

    // Update chat room unread count
    batch.update(_chatRoomsCollection.doc(chatRoomId), {
      'unreadCounts.$userId': 0,
    });

    await batch.commit();
  }

  // Start typing indicator
  Future<void> startTyping(String chatRoomId, String userId, String userName) async {
    final typingId = '${chatRoomId}_$userId';
    await _typingIndicatorsCollection.doc(typingId).set(
      TypingIndicator(
        userId: userId,
        userName: userName,
        chatRoomId: chatRoomId,
        startedAt: DateTime.now(),
      ).toJson(),
    );
  }

  // Stop typing indicator
  Future<void> stopTyping(String chatRoomId, String userId) async {
    final typingId = '${chatRoomId}_$userId';
    await _typingIndicatorsCollection.doc(typingId).delete();
  }

  // Get typing indicators for chat room
  Stream<List<TypingIndicator>> getTypingIndicators(String chatRoomId) {
    return _typingIndicatorsCollection
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('startedAt', isGreaterThan: DateTime.now().subtract(const Duration(seconds: 10)))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TypingIndicator.fromJson(data);
      }).toList();
    });
  }

  // Create a chat room
  Future<String> createChatRoom({
    required String name,
    String? description,
    String? imageUrl,
    required ChatRoomType type,
    required List<String> memberIds,
    required String familyId,
    required String createdBy,
    Map<String, dynamic>? settings,
  }) async {
    final now = DateTime.now();
    final roomId = _chatRoomsCollection.doc().id;

    final chatRoom = ChatRoomModel(
      id: roomId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      type: type,
      memberIds: memberIds,
      familyId: familyId,
      unreadCounts: {for (String id in memberIds) id: 0},
      isActive: true,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
      settings: settings,
    );

    await _chatRoomsCollection.doc(roomId).set(chatRoom.toJson());
    return roomId;
  }

  // Get unread message count for user
  Stream<int> getTotalUnreadCount(String userId) {
    return _chatRoomsCollection
        .where('memberIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      int totalUnread = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final unreadCounts = data['unreadCounts'] as Map<String, dynamic>? ?? {};
        totalUnread += (unreadCounts[userId] as int?) ?? 0;
      }
      return totalUnread;
    });
  }

  // Private helper methods
  Future<void> _updateChatRoomLastMessage(String chatRoomId, MessageModel message) async {
    await _chatRoomsCollection.doc(chatRoomId).update({
      'lastMessageId': message.id,
      'lastMessageContent': message.content,
      'lastMessageTime': message.createdAt,
      'lastMessageSenderId': message.senderId,
      'updatedAt': DateTime.now(),
    });

    // Increment unread count for all members except sender
    final chatRoomDoc = await _chatRoomsCollection.doc(chatRoomId).get();
    if (chatRoomDoc.exists) {
      final data = chatRoomDoc.data() as Map<String, dynamic>;
      final memberIds = List<String>.from(data['memberIds'] ?? []);
      final updates = <String, dynamic>{};

      for (final memberId in memberIds) {
        if (memberId != message.senderId) {
          final currentCount = (data['unreadCounts'] as Map<String, dynamic>?)?[memberId] as int? ?? 0;
          updates['unreadCounts.$memberId'] = currentCount + 1;
        }
      }

      if (updates.isNotEmpty) {
        await _chatRoomsCollection.doc(chatRoomId).update(updates);
      }
    }
  }
}
