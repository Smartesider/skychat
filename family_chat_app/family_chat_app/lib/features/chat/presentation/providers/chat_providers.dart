import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/chat_models.dart';
import '../../domain/services/chat_service.dart';

// Chat rooms provider
final chatRoomsProvider = StreamProvider<List<ChatRoomModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  final chatService = ref.watch(chatServiceProvider);
  return chatService.getUserChatRooms(user.id);
});

// Family chat rooms provider
final familyChatRoomsProvider = StreamProvider.family<List<ChatRoomModel>, String>((ref, familyId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getFamilyChatRooms(familyId);
});

// Chat messages provider
final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, chatRoomId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getChatMessages(chatRoomId);
});

// Typing indicators provider
final typingIndicatorsProvider = StreamProvider.family<List<TypingIndicator>, String>((ref, chatRoomId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getTypingIndicators(chatRoomId);
});

// Total unread count provider
final totalUnreadCountProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);

  final chatService = ref.watch(chatServiceProvider);
  return chatService.getTotalUnreadCount(user.id);
});

// Send message controller
final sendMessageControllerProvider = StateNotifierProvider<SendMessageController, SendMessageState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final user = ref.watch(currentUserProvider);
  return SendMessageController(chatService, user);
});

class SendMessageController extends StateNotifier<SendMessageState> {
  final ChatService _chatService;
  final user;

  SendMessageController(this._chatService, this.user) : super(const SendMessageState.idle());

  Future<void> sendTextMessage({
    required String chatRoomId,
    required String content,
    String? replyToMessageId,
  }) async {
    if (user == null || content.trim().isEmpty) return;

    state = const SendMessageState.sending();

    try {
      final messageData = CreateMessageData(
        type: MessageType.text,
        content: content.trim(),
        replyToMessageId: replyToMessageId,
      );

      await _chatService.sendMessage(
        chatRoomId: chatRoomId,
        senderId: user.id,
        senderName: user.displayName,
        senderAvatar: user.photoUrl,
        messageData: messageData,
      );

      state = const SendMessageState.success();
    } catch (e) {
      state = SendMessageState.error(e.toString());
    }
  }

  Future<void> sendImageMessage({
    required String chatRoomId,
    required List<File> imageFiles,
    String? content,
    String? replyToMessageId,
  }) async {
    if (user == null || imageFiles.isEmpty) return;

    state = const SendMessageState.sending();

    try {
      // Upload images
      final imageUrls = await _chatService.uploadImages(imageFiles, chatRoomId);

      final messageData = CreateMessageData(
        type: MessageType.image,
        content: content ?? '',
        imageUrls: imageUrls,
        replyToMessageId: replyToMessageId,
      );

      await _chatService.sendMessage(
        chatRoomId: chatRoomId,
        senderId: user.id,
        senderName: user.displayName,
        senderAvatar: user.photoUrl,
        messageData: messageData,
      );

      state = const SendMessageState.success();
    } catch (e) {
      state = SendMessageState.error(e.toString());
    }
  }

  Future<void> sendVoiceMessage({
    required String chatRoomId,
    required File audioFile,
    required int duration,
  }) async {
    if (user == null) return;

    state = const SendMessageState.sending();

    try {
      // Upload voice note
      final voiceUrl = await _chatService.uploadVoiceNote(audioFile, chatRoomId);

      final messageData = CreateMessageData(
        type: MessageType.voice,
        content: 'Voice message',
        voiceNoteUrl: voiceUrl,
        voiceNoteDuration: duration,
      );

      await _chatService.sendMessage(
        chatRoomId: chatRoomId,
        senderId: user.id,
        senderName: user.displayName,
        senderAvatar: user.photoUrl,
        messageData: messageData,
      );

      state = const SendMessageState.success();
    } catch (e) {
      state = SendMessageState.error(e.toString());
    }
  }

  void resetState() {
    state = const SendMessageState.idle();
  }
}

// Chat interactions controller
final chatInteractionsControllerProvider = StateNotifierProvider<ChatInteractionsController, Map<String, bool>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final user = ref.watch(currentUserProvider);
  return ChatInteractionsController(chatService, user);
});

class ChatInteractionsController extends StateNotifier<Map<String, bool>> {
  final ChatService _chatService;
  final user;

  ChatInteractionsController(this._chatService, this.user) : super({});

  Future<void> addReaction(String messageId, String emoji) async {
    if (user == null) return;

    // Optimistic update
    state = {...state, messageId: true};

    try {
      await _chatService.addReaction(messageId, user.id, emoji);
    } catch (e) {
      // Revert on error
      state = {...state, messageId: false};
      rethrow;
    } finally {
      // Remove loading state
      final newState = Map<String, bool>.from(state);
      newState.remove(messageId);
      state = newState;
    }
  }

  Future<void> removeReaction(String messageId) async {
    if (user == null) return;

    try {
      await _chatService.removeReaction(messageId, user.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(String messageId) async {
    if (user == null) return;

    try {
      await _chatService.markMessageAsRead(messageId, user.id);
    } catch (e) {
      // Silently handle read status errors
    }
  }

  Future<void> markChatAsRead(String chatRoomId) async {
    if (user == null) return;

    try {
      await _chatService.markChatAsRead(chatRoomId, user.id);
    } catch (e) {
      // Silently handle read status errors
    }
  }
}

// Typing controller
final typingControllerProvider = StateNotifierProvider.family<TypingController, bool, String>((ref, chatRoomId) {
  final chatService = ref.watch(chatServiceProvider);
  final user = ref.watch(currentUserProvider);
  return TypingController(chatService, user, chatRoomId);
});

class TypingController extends StateNotifier<bool> {
  final ChatService _chatService;
  final user;
  final String _chatRoomId;

  TypingController(this._chatService, this.user, this._chatRoomId) : super(false);

  Future<void> startTyping() async {
    if (user == null || state) return;

    state = true;
    try {
      await _chatService.startTyping(_chatRoomId, user.id, user.displayName);
    } catch (e) {
      state = false;
    }
  }

  Future<void> stopTyping() async {
    if (user == null || !state) return;

    state = false;
    try {
      await _chatService.stopTyping(_chatRoomId, user.id);
    } catch (e) {
      // Silently handle typing errors
    }
  }
}

// Create chat room controller
final createChatRoomControllerProvider = StateNotifierProvider<CreateChatRoomController, CreateChatRoomState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final user = ref.watch(currentUserProvider);
  return CreateChatRoomController(chatService, user);
});

class CreateChatRoomController extends StateNotifier<CreateChatRoomState> {
  final ChatService _chatService;
  final user;

  CreateChatRoomController(this._chatService, this.user) : super(const CreateChatRoomState.idle());

  Future<String?> createChatRoom({
    required String name,
    String? description,
    String? imageUrl,
    required ChatRoomType type,
    required List<String> memberIds,
    required String familyId,
    Map<String, dynamic>? settings,
  }) async {
    if (user == null) return null;

    state = const CreateChatRoomState.creating();

    try {
      final roomId = await _chatService.createChatRoom(
        name: name,
        description: description,
        imageUrl: imageUrl,
        type: type,
        memberIds: memberIds,
        familyId: familyId,
        createdBy: user.id,
        settings: settings,
      );

      state = CreateChatRoomState.success(roomId);
      return roomId;
    } catch (e) {
      state = CreateChatRoomState.error(e.toString());
      return null;
    }
  }

  void resetState() {
    state = const CreateChatRoomState.idle();
  }
}

// State classes
abstract class SendMessageState {
  const SendMessageState();

  const factory SendMessageState.idle() = _SendMessageIdle;
  const factory SendMessageState.sending() = _SendMessageSending;
  const factory SendMessageState.success() = _SendMessageSuccess;
  const factory SendMessageState.error(String message) = _SendMessageError;

  T when<T>({
    required T Function() idle,
    required T Function() sending,
    required T Function() success,
    required T Function(String message) error,
  }) {
    if (this is _SendMessageIdle) return idle();
    if (this is _SendMessageSending) return sending();
    if (this is _SendMessageSuccess) return success();
    if (this is _SendMessageError) return error((this as _SendMessageError).message);
    throw Exception('Unknown state');
  }
}

class _SendMessageIdle extends SendMessageState {
  const _SendMessageIdle();
}

class _SendMessageSending extends SendMessageState {
  const _SendMessageSending();
}

class _SendMessageSuccess extends SendMessageState {
  const _SendMessageSuccess();
}

class _SendMessageError extends SendMessageState {
  final String message;
  const _SendMessageError(this.message);
}

abstract class CreateChatRoomState {
  const CreateChatRoomState();

  const factory CreateChatRoomState.idle() = _CreateChatRoomIdle;
  const factory CreateChatRoomState.creating() = _CreateChatRoomCreating;
  const factory CreateChatRoomState.success(String roomId) = _CreateChatRoomSuccess;
  const factory CreateChatRoomState.error(String message) = _CreateChatRoomError;

  T when<T>({
    required T Function() idle,
    required T Function() creating,
    required T Function(String roomId) success,
    required T Function(String message) error,
  }) {
    if (this is _CreateChatRoomIdle) return idle();
    if (this is _CreateChatRoomCreating) return creating();
    if (this is _CreateChatRoomSuccess) return success((this as _CreateChatRoomSuccess).roomId);
    if (this is _CreateChatRoomError) return error((this as _CreateChatRoomError).message);
    throw Exception('Unknown state');
  }
}

class _CreateChatRoomIdle extends CreateChatRoomState {
  const _CreateChatRoomIdle();
}

class _CreateChatRoomCreating extends CreateChatRoomState {
  const _CreateChatRoomCreating();
}

class _CreateChatRoomSuccess extends CreateChatRoomState {
  final String roomId;
  const _CreateChatRoomSuccess(this.roomId);
}

class _CreateChatRoomError extends CreateChatRoomState {
  final String message;
  const _CreateChatRoomError(this.message);
}
