import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/feed_providers.dart';
import '../../domain/models/post_model.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    ref.read(postInteractionControllerProvider.notifier)
        .toggleLike(widget.post.id, user.id);
  }

  Future<void> _addComment() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      await ref.read(postInteractionControllerProvider.notifier).addComment(
        postId: widget.post.id,
        authorId: user.id,
        authorName: user.displayName,
        authorAvatar: user.photoUrl,
        content: content,
      );
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feil ved posting av kommentar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isLiked = user != null && widget.post.likedBy.contains(user.id);
    final comments = ref.watch(postCommentsProvider(widget.post.id));

    // Configure Norwegian timeago messages
    timeago.setLocaleMessages('no', timeago.NoMessages());

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with author info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.glassBorder,
                backgroundImage: widget.post.authorAvatar != null
                    ? NetworkImage(widget.post.authorAvatar!)
                    : null,
                child: widget.post.authorAvatar == null
                    ? const Icon(Icons.person, color: AppColors.textSecondary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      timeago.format(widget.post.createdAt, locale: 'no'),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: Show post options
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          if (widget.post.content.isNotEmpty) ...[
            Text(
              widget.post.content,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Images
          if (widget.post.imageUrls.isNotEmpty) ...[
            if (widget.post.imageUrls.length == 1)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.imageUrls.first,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.glassBackground,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.textSecondary,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.post.imageUrls[index],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: AppColors.glassBackground,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.textSecondary,
                                  size: 32,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
          ],

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.likeCount}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.commentCount}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  // TODO: Share post
                },
              ),
            ],
          ),

          // Comments section
          if (_showComments) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.glassBorder),
            const SizedBox(height: 16),

            // Add comment
            if (user != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.glassBorder,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 16,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GlassContainer(
                      borderRadius: 20,
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Skriv en kommentar...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        maxLines: null,
                        onSubmitted: (_) => _addComment(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: _addComment,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Comments list
            comments.when(
              data: (commentsList) {
                if (commentsList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Ingen kommentarer ennå',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return Column(
                  children: commentsList.map((comment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.glassBorder,
                            backgroundImage: comment.authorAvatar != null
                                ? NetworkImage(comment.authorAvatar!)
                                : null,
                            child: comment.authorAvatar == null
                                ? const Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                    size: 14,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlassContainer(
                                  borderRadius: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.authorName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        comment.content,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeago.format(comment.createdAt, locale: 'no'),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Feil ved lasting av kommentarer',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
