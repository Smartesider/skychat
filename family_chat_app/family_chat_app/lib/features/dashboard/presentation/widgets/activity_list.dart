import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/glass_widgets.dart';
import '../../domain/models/dashboard_models.dart';

class ActivityList extends StatelessWidget {
  final List<FamilyActivity> activities;

  const ActivityList({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return GlassCard(
        child: Column(
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.white54,
            ),
            const SizedBox(height: 8),
            Text(
              'No recent activity',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: activities.map((activity) => _buildActivityItem(context, activity)).toList(),
    );
  }

  Widget _buildActivityItem(BuildContext context, FamilyActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // User avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.2),
              backgroundImage: activity.userAvatar.isNotEmpty 
                  ? NetworkImage(activity.userAvatar)
                  : null,
              child: activity.userAvatar.isEmpty
                  ? Text(
                      activity.userName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Activity content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      children: [
                        TextSpan(
                          text: activity.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' ${activity.description}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(activity.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            // Action icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getActionColor(activity.action).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getActionColor(activity.action).withOpacity(0.3),
                ),
              ),
              child: Icon(
                _getActionIcon(activity.action),
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'shared':
        return const Color(0xFF8B5CF6);
      case 'posted':
        return const Color(0xFF06B6D4);
      case 'commented':
        return const Color(0xFF10B981);
      case 'liked':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'shared':
        return Icons.share;
      case 'posted':
        return Icons.add_circle;
      case 'commented':
        return Icons.chat_bubble;
      case 'liked':
        return Icons.favorite;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
