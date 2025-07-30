import 'package:flutter/material.dart';
import '../../../../shared/presentation/theme/app_theme.dart';

class TypingIndicator extends StatefulWidget {
  final List<String> typingUsers;

  const TypingIndicator({
    super.key,
    required this.typingUsers,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDots(),
                const SizedBox(width: 8),
                Text(
                  _getTypingText(),
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

  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 24,
          height: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final animValue = (_animation.value - delay).clamp(0.0, 1.0);
              final scale = (animValue * 2 - 1).abs();
              
              return Transform.scale(
                scale: 0.5 + (scale * 0.5),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.7 + (scale * 0.3)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  String _getTypingText() {
    final users = widget.typingUsers;
    
    if (users.length == 1) {
      return '${users.first} skriver...';
    } else if (users.length == 2) {
      return '${users.first} og ${users.last} skriver...';
    } else {
      return '${users.length} personer skriver...';
    }
  }
}
