import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_widgets.dart';
import '../../domain/models/dashboard_models.dart';

class DashboardWidgetCard extends StatelessWidget {
  final DashboardWidget widget;

  const DashboardWidgetCard({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => _handleWidgetTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getWidgetColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getWidgetColor().withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  _getWidgetIcon(),
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getWidgetContent(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Color _getWidgetColor() {
    switch (widget.type) {
      case DashboardWidgetType.recentPhotos:
        return const Color(0xFF8B5CF6);
      case DashboardWidgetType.upcomingBirthdays:
        return const Color(0xFF06B6D4);
      case DashboardWidgetType.quickChat:
        return const Color(0xFF10B981);
      case DashboardWidgetType.weather:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getWidgetIcon() {
    switch (widget.type) {
      case DashboardWidgetType.recentPhotos:
        return Icons.photo_library;
      case DashboardWidgetType.upcomingBirthdays:
        return Icons.event;
      case DashboardWidgetType.quickChat:
        return Icons.chat_bubble;
      case DashboardWidgetType.weather:
        return Icons.wb_sunny;
      case DashboardWidgetType.familyActivity:
        return Icons.people;
      case DashboardWidgetType.quickPost:
        return Icons.add_circle;
      case DashboardWidgetType.countdown:
        return Icons.timer;
      case DashboardWidgetType.onThisDay:
        return Icons.today;
    }
  }

  String _getWidgetContent() {
    switch (widget.type) {
      case DashboardWidgetType.recentPhotos:
        final count = widget.data['count'] ?? 0;
        final lastPhoto = widget.data['lastPhoto'] ?? '';
        return '$count new photos - $lastPhoto';
      
      case DashboardWidgetType.upcomingBirthdays:
        final event = widget.data['event'] ?? '';
        final date = widget.data['date'] ?? '';
        return '$event - $date';
      
      case DashboardWidgetType.quickChat:
        final unread = widget.data['unread'] ?? 0;
        return '$unread unread messages';
      
      case DashboardWidgetType.weather:
        final temp = widget.data['temp'] ?? '';
        final condition = widget.data['condition'] ?? '';
        return '$temp $condition';
      
      default:
        return 'No data available';
    }
  }

  void _handleWidgetTap(BuildContext context) {
    // TODO: Navigate to widget-specific details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} widget tapped'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
