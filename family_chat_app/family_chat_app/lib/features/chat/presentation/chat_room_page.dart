import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../shared/presentation/theme/app_theme.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/chat_providers.dart';
import '../domain/models/chat_models.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/voice_note_player.dart';
import 'widgets/image_message_viewer.dart';
import 'widgets/message_reactions.dart';

class ChatRoomPage extends ConsumerStatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({
    super.key,
    required this.chatRoomId,
  });

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  bool _showScrollToBottom = false;
  bool _isRecordingVoice = false;
  String? _replyToMessageId;
  MessageModel? _replyToMessage;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
    
    _scrollController.addListener(_onScroll);
    _messageFocusNode.addListener(_onFocusChange);
    
    // Start typing indicator when typing
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtBottom = _scrollController.position.pixels < 100;
    if (isAtBottom != !_showScrollToBottom) {
      setState(() {
        _showScrollToBottom = !isAtBottom;
      });
      if (_showScrollToBottom) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    }
  }

  void _onFocusChange() {
    if (_messageFocusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    final controller = ref.read(chatControllerProvider.notifier);
    
    if (hasText) {
      controller.startTyping(widget.chatRoomId);
    } else {
      controller.stopTyping(widget.chatRoomId);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoom = ref.watch(chatRoomProvider(widget.chatRoomId));
    final messages = ref.watch(messagesProvider(widget.chatRoomId));
    final currentUser = ref.watch(currentUserProvider);
    final typingUsers = ref.watch(typingUsersProvider(widget.chatRoomId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(chatRoom),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.when(
              data: (messageList) => _buildMessagesList(messageList, currentUser),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
          
          // Typing indicators
          if (typingUsers.isNotEmpty)
            _buildTypingIndicator(typingUsers),
          
          // Reply preview
          if (_replyToMessage != null)
            _buildReplyPreview(),
          
          // Message input
          _buildMessageInput(),
        ],
      ),
      floatingActionButton: _buildScrollToBottomFab(),
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncValue<ChatRoomModel?> chatRoom) {
    return AppBar(
      backgroundColor: AppColors.glassBackground,
      elevation: 0,
      leading: GlassButton(
        onPressed: () => context.pop(),
        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: chatRoom.when(
        data: (room) => room != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${room.participants.length} medlemmer',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : const Text('Chat'),
        loading: () => const Text('Laster...'),
        error: (_, __) => const Text('Feil'),
      ),
      actions: [
        GlassButton(
          onPressed: () => _showChatInfo(),
          child: const Icon(Icons.info_outline, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMessagesList(List<MessageModel> messages, AsyncValue currentUser) {
    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = currentUser.value?.uid == message.senderId;
        final showAvatar = index == 0 || 
          messages[index - 1].senderId != message.senderId;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildMessageWidget(message, isCurrentUser, showAvatar),
        );
      },
    );
  }

  Widget _buildMessageWidget(MessageModel message, bool isCurrentUser, bool showAvatar) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Column(
        children: [
          ChatBubble(
            message: message,
            isCurrentUser: isCurrentUser,
            showAvatar: showAvatar,
            onReply: () => _setReplyMessage(message),
            onReact: () => _showReactionPicker(message),
          ),
          
          // Additional content based on message type
          if (message.type == MessageType.voice && message.voiceNoteUrl != null)
            Padding(
              padding: EdgeInsets.only(
                left: isCurrentUser ? 50 : 0,
                right: isCurrentUser ? 0 : 50,
                top: 4,
              ),
              child: VoiceNotePlayer(
                voiceNoteUrl: message.voiceNoteUrl!,
                duration: message.voiceNoteDuration ?? 0,
              ),
            ),
          
          if (message.type == MessageType.image && message.imageUrl != null)
            Padding(
              padding: EdgeInsets.only(
                left: isCurrentUser ? 50 : 0,
                right: isCurrentUser ? 0 : 50,
                top: 4,
              ),
              child: ImageMessageViewer(
                imageUrl: message.imageUrl!,
                caption: message.content.isNotEmpty ? message.content : null,
              ),
            ),
          
          // Reactions
          if (message.reactions.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: isCurrentUser ? 50 : 0,
                right: isCurrentUser ? 0 : 50,
                top: 4,
              ),
              child: MessageReactions(
                reactions: message.reactions,
                userReactions: [], // TODO: Get user's reactions
                messageId: message.id,
                onAddReaction: () => _showReactionPicker(message),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(List<String> typingUsers) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingAnimation(),
                const SizedBox(width: 8),
                Text(
                  _getTypingText(typingUsers),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingAnimation() {
    return SizedBox(
      width: 20,
      height: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  String _getTypingText(List<String> typingUsers) {
    if (typingUsers.length == 1) {
      return '${typingUsers.first} skriver...';
    } else if (typingUsers.length == 2) {
      return '${typingUsers.first} og ${typingUsers.last} skriver...';
    } else {
      return '${typingUsers.length} personer skriver...';
    }
  }

  Widget _buildReplyPreview() {
    if (_replyToMessage == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Svarer på ${_replyToMessage!.senderName}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getReplyPreviewText(_replyToMessage!),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _clearReply(),
              child: const Icon(
                Icons.close,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Attachment button
          GlassButton(
            onPressed: () => _showAttachmentOptions(),
            child: const Icon(Icons.add, color: AppColors.textPrimary),
          ),
          
          const SizedBox(width: 8),
          
          // Message input field
          Expanded(
            child: GlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Skriv en melding...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send/Voice button
          GlassButton(
            onPressed: _messageController.text.trim().isNotEmpty
              ? _sendMessage
              : () => _toggleVoiceRecording(),
            child: Icon(
              _messageController.text.trim().isNotEmpty
                ? Icons.send
                : (_isRecordingVoice ? Icons.stop : Icons.mic),
              color: _isRecordingVoice ? Colors.red : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollToBottomFab() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: FloatingActionButton.small(
            onPressed: _scrollToBottom,
            backgroundColor: AppColors.glassBackground,
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
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
            'Kunne ikke laste meldinger',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GlassButton(
            onPressed: () => ref.refresh(messagesProvider(widget.chatRoomId)),
            child: const Text('Prøv igjen', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: AppColors.textSecondary,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Ingen meldinger ennå',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Send den første meldingen!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getReplyPreviewText(MessageModel message) {
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 Bilde';
      case MessageType.voice:
        return '🎵 Lydmelding';
      case MessageType.file:
        return '📎 Fil';
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final controller = ref.read(chatControllerProvider.notifier);
    controller.sendMessage(
      chatRoomId: widget.chatRoomId,
      content: content,
      replyToMessageId: _replyToMessageId,
    );

    _messageController.clear();
    _clearReply();
    _scrollToBottom();
  }

  void _setReplyMessage(MessageModel message) {
    setState(() {
      _replyToMessage = message;
      _replyToMessageId = message.id;
    });
    _messageFocusNode.requestFocus();
  }

  void _clearReply() {
    setState(() {
      _replyToMessage = null;
      _replyToMessageId = null;
    });
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
    });

    if (_isRecordingVoice) {
      // TODO: Start voice recording
    } else {
      // TODO: Stop voice recording and send
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppColors.primary),
              title: const Text('Kamera', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: AppColors.primary),
              title: const Text('Galleri', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open gallery
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: AppColors.primary),
              title: const Text('Fil', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open file picker
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(MessageModel message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply, color: AppColors.primary),
              title: const Text('Svar', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _setReplyMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.primary),
              title: const Text('Kopier', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Copy message
              },
            ),
            if (message.senderId == ref.read(currentUserProvider).value?.uid)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Slett', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Delete message
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(MessageModel message) {
    // TODO: Implement reaction picker
  }

  void _showChatInfo() {
    // TODO: Navigate to chat info page
  }
}
