import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/glass_widgets.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.family_restroom,
      title: 'Welcome to Family Chat',
      description: 'A beautiful, private space for your family to stay connected and share precious moments together.',
      color: const Color(0xFF6366F1),
    ),
    OnboardingData(
      icon: Icons.security,
      title: 'Privacy First',
      description: 'Your family data belongs to you. No ads, no data selling. Just secure, private family communication.',
      color: const Color(0xFF8B5CF6),
    ),
    OnboardingData(
      icon: Icons.photo_library,
      title: 'Share & Remember',
      description: 'Create a digital family archive. Share photos, events, and memories that last for generations.',
      color: const Color(0xFF06B6D4),
    ),
    OnboardingData(
      icon: Icons.favorite,
      title: 'Stay Close',
      description: 'From grandparents to grandchildren - an intuitive app that brings everyone together.',
      color: const Color(0xFF10B981),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top navigation
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      GlassButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      )
                    else
                      const SizedBox(width: 48),
                    
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page indicators
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page dots
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Next/Get Started button
                    GlassButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/login');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          GlassContainer(
            width: 120,
            height: 120,
            borderRadius: BorderRadius.circular(30),
            color: data.color.withOpacity(0.2),
            child: Icon(
              data.icon,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
