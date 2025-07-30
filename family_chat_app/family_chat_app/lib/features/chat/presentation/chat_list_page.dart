import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../shared/presentation/theme/app_theme.dart';
import '../providers/chat_providers.dart';
import '../domain/models/chat_models.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final chatRooms = ref.watch(userChatRoomsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GlassButton(
            onPressed: () => _showNewChatDialog(),
            child: const Icon(Icons.add_comment, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: chatRooms.when(
        data: (rooms) => rooms.isEmpty
          ? _buildEmptyState()
          : _buildChatList(rooms),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildChatList(List<ChatRoomModel> chatRooms) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildChatListItem(chatRoom),
        );
      },
    );
  }

  Widget _buildChatListItem(ChatRoomModel chatRoom) {
    final lastMessage = chatRoom.lastMessage;
    final unreadCount = chatRoom.unreadCount;
    
    return GestureDetector(
      onTap: () => context.go('/home/chat/room/${chatRoom.id}'),
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar/Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: chatRoom.type == ChatRoomType.group
                ? const Icon(
                    Icons.group,
                    color: AppColors.primary,
                    size: 24,
                  )
                : const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 24,
                  ),
            ),
            
            const SizedBox(width: 12),
            
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          timeago.format(
                            lastMessage.createdAt,
                            locale: 'no',
                          ),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getLastMessagePreview(lastMessage),
                          style: TextStyle(
                            color: unreadCount > 0 
                              ? AppColors.textPrimary 
                              : AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: unreadCount > 0 
                              ? FontWeight.w500 
                              : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          minWidth: 20,
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingen chats ennå',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start en ny samtale med familien',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassButton(
            onPressed: () => _showNewChatDialog(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_comment, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Start ny chat',
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
          const Text(
            'Kunne ikke laste chats',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GlassButton(
            onPressed: () => ref.refresh(userChatRoomsProvider),
            child: const Text(
              'Prøv igjen',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastMessagePreview(MessageModel? message) {
    if (message == null) {
      return 'Ingen meldinger ennå';
    }

    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 Bilde';
      case MessageType.voice:
        return '🎵 Lydmelding';
      case MessageType.file:
        return '📎 ${message.fileName ?? 'Fil'}';
    }
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => NewChatDialog(),
    );
  }
}

class NewChatDialog extends ConsumerStatefulWidget {
  const NewChatDialog({super.key});

  @override
  ConsumerState<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends ConsumerState<NewChatDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isGroup = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ny chat',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            
            // Chat type toggle
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isGroup = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isGroup 
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !_isGroup 
                            ? AppColors.primary
                            : AppColors.glassBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            color: !_isGroup 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Privat',
                            style: TextStyle(
                              color: !_isGroup 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isGroup = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isGroup 
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isGroup 
                            ? AppColors.primary
                            : AppColors.glassBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.group,
                            color: _isGroup 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gruppe',
                            style: TextStyle(
                              color: _isGroup 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Chat name
            GlassContainer(
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: _isGroup ? 'Gruppenavn' : 'Navn på chat',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            
            if (_isGroup) ...[
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Beskrivelse (valgfritt)',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GlassButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Avbryt',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                GlassButton(
                  onPressed: _createChat,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  borderColor: AppColors.primary,
                  child: const Text(
                    'Opprett',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createChat() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    try {
      final controller = ref.read(chatControllerProvider.notifier);
      final chatRoomId = await controller.createChatRoom(
        name: name,
        description: _descriptionController.text.trim(),
        isGroup: _isGroup,
      );

      if (mounted) {
        Navigator.of(context).pop();
        context.go('/home/chat/room/$chatRoomId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kunne ikke opprette chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
