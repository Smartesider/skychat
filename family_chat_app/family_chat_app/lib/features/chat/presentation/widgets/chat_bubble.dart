import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/chat_providers.dart';
import '../../domain/models/chat_models.dart';
import 'voice_note_player.dart';
import 'image_message_viewer.dart';
import 'message_reactions.dart';

class ChatBubble extends ConsumerStatefulWidget {
  final MessageModel message;
  final bool showAvatar;
  final bool showTimestamp;
  final VoidCallback? onReply;

  const ChatBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.showTimestamp = true,
    this.onReply,
  });

  @override
  ConsumerState<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends ConsumerState<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showReactions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();

    // Mark message as read when displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatInteractionsControllerProvider.notifier)
          .markAsRead(widget.message.id);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showReactionPicker() {
    setState(() {
      _showReactions = !_showReactions;
    });
  }

  void _addReaction(String emoji) {
    ref.read(chatInteractionsControllerProvider.notifier)
        .addReaction(widget.message.id, emoji);
    setState(() {
      _showReactions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isOwnMessage = user?.id == widget.message.senderId;
    
    // Configure Norwegian timeago messages
    timeago.setLocaleMessages('no', timeago.NoMessages());

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Column(
              crossAxisAlignment: isOwnMessage 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                // Reply indicator
                if (widget.message.replyToMessage != null) ...[
                  _buildReplyIndicator(isOwnMessage),
                  const SizedBox(height: 4),
                ],

                // Main message
                Row(
                  mainAxisAlignment: isOwnMessage 
                      ? MainAxisAlignment.end 
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Avatar for other users
                    if (!isOwnMessage && widget.showAvatar) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.glassBorder,
                        backgroundImage: widget.message.senderAvatar != null
                            ? NetworkImage(widget.message.senderAvatar!)
                            : null,
                        child: widget.message.senderAvatar == null
                            ? Text(
                                widget.message.senderName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Message bubble
                    Flexible(
                      child: GestureDetector(
                        onLongPress: _showReactionPicker,
                        onTap: widget.onReply,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Stack(
                            children: [
                              // Main bubble
                              GlassContainer(
                                borderRadius: _getBorderRadius(isOwnMessage),
                                color: isOwnMessage 
                                    ? AppColors.primary.withOpacity(0.2)
                                    : AppColors.glassBackground,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Sender name for group chats
                                    if (!isOwnMessage) ...[
                                      Text(
                                        widget.message.senderName,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],

                                    // Message content
                                    _buildMessageContent(),

                                    // Message info
                                    _buildMessageInfo(isOwnMessage),
                                  ],
                                ),
                              ),

                              // Reaction picker
                              if (_showReactions)
                                Positioned(
                                  top: -60,
                                  left: isOwnMessage ? null : 0,
                                  right: isOwnMessage ? 0 : null,
                                  child: _buildReactionPicker(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Avatar spacing for own messages
                    if (isOwnMessage && widget.showAvatar)
                      const SizedBox(width: 40),
                  ],
                ),

                // Reactions
                if (widget.message.reactions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  MessageReactions(
                    reactions: widget.message.reactions,
                    onReactionTap: (emoji) => _addReaction(emoji),
                    isOwnMessage: isOwnMessage,
                  ),
                ],

                // Timestamp
                if (widget.showTimestamp) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.only(
                      left: isOwnMessage ? 0 : 40,
                      right: isOwnMessage ? 40 : 0,
                    ),
                    child: Text(
                      timeago.format(widget.message.createdAt, locale: 'no'),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReplyIndicator(bool isOwnMessage) {
    final replyMessage = widget.message.replyToMessage!;
    
    return Container(
      margin: EdgeInsets.only(
        left: isOwnMessage ? 40 : 40,
        right: isOwnMessage ? 40 : 40,
      ),
      child: GlassContainer(
        borderRadius: 8,
        padding: const EdgeInsets.all(8),
        color: AppColors.glassBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              replyMessage.senderName,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getMessagePreview(replyMessage),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (widget.message.type) {
      case MessageType.text:
      case MessageType.emoji:
        return Text(
          widget.message.content,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            height: 1.4,
          ),
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message.content.isNotEmpty) ...[
              Text(
                widget.message.content,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
            ],
            ImageMessageViewer(
              imageUrls: widget.message.imageUrls ?? [],
            ),
          ],
        );

      case MessageType.voice:
        return VoiceNotePlayer(
          voiceNoteUrl: widget.message.voiceNoteUrl!,
          duration: widget.message.voiceNoteDuration ?? 0,
        );

      case MessageType.system:
        return Text(
          widget.message.content,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        );
    }
  }

  Widget _buildMessageInfo(bool isOwnMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit indicator
          if (widget.message.isEdited == true) ...[
            const Icon(
              Icons.edit,
              size: 12,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
          ],

          // Time
          Text(
            '${widget.message.createdAt.hour.toString().padLeft(2, '0')}:${widget.message.createdAt.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),

          // Message status for own messages
          if (isOwnMessage) ...[
            const SizedBox(width: 4),
            _buildMessageStatus(),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageStatus() {
    switch (widget.message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary),
          ),
        );

      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 12,
          color: AppColors.textSecondary,
        );

      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all,
          size: 12,
          color: AppColors.textSecondary,
        );

      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 12,
          color: AppColors.primary,
        );

      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 12,
          color: Colors.red,
        );
    }
  }

  Widget _buildReactionPicker() {
    final reactions = ['❤️', '😂', '😮', '😢', '😡', '👍', '👎'];
    
    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((emoji) {
          return GestureDetector(
            onTap: () => _addReaction(emoji),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  BorderRadius _getBorderRadius(bool isOwnMessage) {
    if (isOwnMessage) {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(4),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(16),
      );
    }
  }

  String _getMessagePreview(MessageModel message) {
    switch (message.type) {
      case MessageType.text:
      case MessageType.emoji:
        return message.content;
      case MessageType.image:
        return '📷 Bilde';
      case MessageType.voice:
        return '🎤 Talemelding';
      case MessageType.system:
        return message.content;
    }
  }
}
