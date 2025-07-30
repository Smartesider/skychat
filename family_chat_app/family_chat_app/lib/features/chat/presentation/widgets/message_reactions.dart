import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../domain/models/chat_models.dart';

class MessageReactions extends ConsumerStatefulWidget {
  final Map<String, int> reactions;
  final List<String> userReactions;
  final String messageId;
  final VoidCallback? onAddReaction;

  const MessageReactions({
    super.key,
    required this.reactions,
    required this.userReactions,
    required this.messageId,
    this.onAddReaction,
  });

  @override
  ConsumerState<MessageReactions> createState() => _MessageReactionsState();
}

class _MessageReactionsState extends ConsumerState<MessageReactions>
    with TickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _scaleAnimation;

  static const Map<String, String> reactionEmojis = {
    'like': '👍',
    'love': '❤️',
    'laugh': '😂',
    'wow': '😮',
    'sad': '😢',
    'angry': '😠',
  };

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _popController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          // Existing reactions
          ...widget.reactions.entries.map((entry) => _buildReactionChip(
                entry.key,
                entry.value,
                widget.userReactions.contains(entry.key),
              )),
          
          // Add reaction button
          if (widget.onAddReaction != null)
            _buildAddReactionButton(),
        ],
      ),
    );
  }

  Widget _buildReactionChip(String reaction, int count, bool userReacted) {
    final emoji = reactionEmojis[reaction] ?? '👍';
    
    return GestureDetector(
      onTap: () => _toggleReaction(reaction),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: userReacted ? _scaleAnimation.value : 1.0,
            child: GlassContainer(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: userReacted 
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.glassBackground.withOpacity(0.8),
              borderColor: userReacted 
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.glassBorder,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (count > 1) ...[
                    const SizedBox(width: 4),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: userReacted 
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddReactionButton() {
    return GestureDetector(
      onTap: () => _showReactionPicker(),
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        backgroundColor: AppColors.glassBackground.withOpacity(0.6),
        child: const Icon(
          Icons.add_reaction_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _toggleReaction(String reaction) {
    _popController.forward().then((_) => _popController.reverse());
    
    // TODO: Implement reaction toggle logic with chat service
    widget.onAddReaction?.call();
  }

  void _showReactionPicker() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => ReactionPickerDialog(
        messageId: widget.messageId,
        onReactionSelected: (reaction) {
          _addReaction(reaction);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _addReaction(String reaction) {
    _popController.forward().then((_) => _popController.reverse());
    
    // TODO: Implement add reaction logic with chat service
    widget.onAddReaction?.call();
  }
}

class ReactionPickerDialog extends ConsumerWidget {
  final String messageId;
  final Function(String) onReactionSelected;

  const ReactionPickerDialog({
    super.key,
    required this.messageId,
    required this.onReactionSelected,
  });

  static const Map<String, String> reactionEmojis = {
    'like': '👍',
    'love': '❤️',
    'laugh': '😂',
    'wow': '😮',
    'sad': '😢',
    'angry': '😠',
    'celebrate': '🎉',
    'fire': '🔥',
    'clap': '👏',
    'thinking': '🤔',
    'heart_eyes': '😍',
    'cry': '😭',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Velg reaksjon',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: reactionEmojis.length,
              itemBuilder: (context, index) {
                final entry = reactionEmojis.entries.elementAt(index);
                return _buildReactionButton(
                  entry.key,
                  entry.value,
                  () => onReactionSelected(entry.key),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String reaction, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.glassBackground.withOpacity(0.5),
          border: Border.all(
            color: AppColors.glassBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class MessageReactionsList extends ConsumerWidget {
  final Map<String, List<String>> reactionUsers;
  final String messageId;

  const MessageReactionsList({
    super.key,
    required this.reactionUsers,
    required this.messageId,
  });

  static const Map<String, String> reactionEmojis = {
    'like': '👍',
    'love': '❤️',
    'laugh': '😂',
    'wow': '😮',
    'sad': '😢',
    'angry': '😠',
    'celebrate': '🎉',
    'fire': '🔥',
    'clap': '👏',
    'thinking': '🤔',
    'heart_eyes': '😍',
    'cry': '😭',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reactionUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reaksjoner',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...reactionUsers.entries.map((entry) {
              final reaction = entry.key;
              final users = entry.value;
              final emoji = reactionEmojis[reaction] ?? '👍';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getReactionName(reaction),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            users.join(', '),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getReactionName(String reaction) {
    switch (reaction) {
      case 'like':
        return 'Liker';
      case 'love':
        return 'Elsker';
      case 'laugh':
        return 'Ler';
      case 'wow':
        return 'Wow';
      case 'sad':
        return 'Trist';
      case 'angry':
        return 'Sint';
      case 'celebrate':
        return 'Feirer';
      case 'fire':
        return 'Fire';
      case 'clap':
        return 'Klapper';
      case 'thinking':
        return 'Tenker';
      case 'heart_eyes':
        return 'Forelsket';
      case 'cry':
        return 'Gråter';
      default:
        return 'Reaksjon';
    }
  }
}
