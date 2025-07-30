import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';

class VoiceNotePlayer extends ConsumerStatefulWidget {
  final String voiceNoteUrl;
  final int duration;

  const VoiceNotePlayer({
    super.key,
    required this.voiceNoteUrl,
    required this.duration,
  });

  @override
  ConsumerState<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends ConsumerState<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isLoading = false;
  double _progress = 0.0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      _pausePlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    setState(() {
      _isPlaying = true;
      _isLoading = true;
    });

    _waveController.repeat();

    // Simulate audio playback
    // In a real implementation, you would use an audio player package
    // like just_audio or audioplayers
    _simulatePlayback();
  }

  void _pausePlayback() {
    setState(() {
      _isPlaying = false;
    });
    _waveController.stop();
  }

  void _simulatePlayback() async {
    setState(() {
      _isLoading = false;
    });

    // Simulate progress
    const updateInterval = Duration(milliseconds: 100);
    const totalSteps = 100;
    int currentStep = 0;

    while (_isPlaying && currentStep < totalSteps) {
      await Future.delayed(updateInterval);
      if (_isPlaying) {
        setState(() {
          _progress = currentStep / totalSteps;
        });
        currentStep++;
      }
    }

    if (_isPlaying) {
      // Playback completed
      setState(() {
        _isPlaying = false;
        _progress = 0.0;
      });
      _waveController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.primary,
                      size: 20,
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Waveform visualization
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform
                SizedBox(
                  height: 30,
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WaveformPainter(
                          progress: _progress,
                          isPlaying: _isPlaying,
                          animationValue: _waveController.value,
                        ),
                        size: const Size(double.infinity, 30),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 4),

                // Duration
                Text(
                  _formatDuration(widget.duration),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Download/Save button
          GestureDetector(
            onTap: () {
              // TODO: Implement download functionality
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glassBorder,
              ),
              child: const Icon(
                Icons.download,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final bool isPlaying;
  final double animationValue;

  WaveformPainter({
    required this.progress,
    required this.isPlaying,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const int barCount = 20;
    final double barWidth = size.width / barCount;
    final double centerY = size.height / 2;

    final Paint playedPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final Paint unplayedPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Generate waveform heights
    final List<double> heights = List.generate(barCount, (index) {
      // Create a natural-looking waveform pattern
      double baseHeight = (index / barCount) * 2;
      if (baseHeight > 1) baseHeight = 2 - baseHeight;
      
      // Add some randomness
      baseHeight += (index % 3) * 0.1;
      baseHeight += (index % 5) * 0.05;
      
      // Animate if playing
      if (isPlaying) {
        final animOffset = (animationValue + index * 0.1) % 1.0;
        baseHeight += (animOffset * 0.2);
      }
      
      return (baseHeight * size.height * 0.8).clamp(4.0, size.height * 0.8);
    });

    for (int i = 0; i < barCount; i++) {
      final double x = i * barWidth + barWidth / 2;
      final double height = heights[i];
      
      final bool isPlayed = (i / barCount) <= progress;
      final Paint paint = isPlayed ? playedPaint : unplayedPaint;

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }

    // Draw progress indicator
    if (progress > 0) {
      final double progressX = progress * size.width;
      final Paint progressPaint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(progressX, 0),
        Offset(progressX, size.height),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.isPlaying != isPlaying ||
           oldDelegate.animationValue != animationValue;
  }
}
