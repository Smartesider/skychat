import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_widgets.dart';
import '../../domain/models/dashboard_models.dart';

class QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const QuickActionCard({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: GlassButton(
        onPressed: () => _handleActionTap(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getActionColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getActionColor().withOpacity(0.3),
                ),
              ),
              child: Icon(
                _getActionIcon(),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor() {
    return Color(int.parse('0xFF${action.color}'));
  }

  IconData _getActionIcon() {
    switch (action.icon) {
      case 'photo':
        return Icons.add_photo_alternate;
      case 'event':
        return Icons.event_note;
      case 'chat':
        return Icons.chat_bubble;
      case 'recipe':
        return Icons.restaurant_menu;
      default:
        return Icons.add;
    }
  }

  void _handleActionTap(BuildContext context) {
    // TODO: Navigate to action route
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${action.title} action triggered'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
