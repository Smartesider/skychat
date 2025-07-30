import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showParticles;

  const AppBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDark 
            ? AppTheme.darkBackgroundGradient 
            : AppTheme.lightBackgroundGradient,
      ),
      child: Stack(
        children: [
          // Animated particles/orbs (optional)
          if (showParticles) ...[
            const Positioned(
              top: 100,
              right: 50,
              child: _FloatingOrb(
                size: 60,
                color: AppTheme.primaryColor,
                duration: Duration(seconds: 4),
              ),
            ),
            const Positioned(
              bottom: 200,
              left: 30,
              child: _FloatingOrb(
                size: 40,
                color: AppTheme.secondaryColor,
                duration: Duration(seconds: 6),
              ),
            ),
            const Positioned(
              top: 300,
              left: 100,
              child: _FloatingOrb(
                size: 20,
                color: AppTheme.accentColor,
                duration: Duration(seconds: 5),
              ),
            ),
          ],
          
          // Main content
          child,
        ],
      ),
    );
  }
}

class _FloatingOrb extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const _FloatingOrb({
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<_FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<_FloatingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value * 20),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withOpacity(0.3),
                  widget.color.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
