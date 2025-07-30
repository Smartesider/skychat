import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/feed_providers.dart';
import '../widgets/create_post_dialog.dart';
import '../widgets/post_card.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreatePostDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final feedPosts = ref.watch(feedPostsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (user != null)
                    GlassButton(
                      onPressed: () => _showCreatePostDialog(context),
                      icon: Icons.add,
                      child: const Text('Nytt innlegg'),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Create post quick action
              if (user != null) ...[
                GestureDetector(
                  onTap: () => _showCreatePostDialog(context),
                  child: GlassCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.glassBorder,
                          backgroundImage: user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: user.photoUrl == null
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Hva tenker du på?',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.photo_library,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Feed content
              Expanded(
                child: feedPosts.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const Center(
                        child: GlassCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.rss_feed,
                                size: 64,
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Ingen innlegg ennå!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Opprett ditt første innlegg for å dele\nmed familien din',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(feedPostsProvider);
                      },
                      backgroundColor: AppColors.glassBackground,
                      color: AppColors.primary,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(post: posts[index]);
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: GlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Feil ved lasting av feed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GlassButton(
                            onPressed: () {
                              ref.invalidate(feedPostsProvider);
                            },
                            child: const Text('Prøv igjen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
