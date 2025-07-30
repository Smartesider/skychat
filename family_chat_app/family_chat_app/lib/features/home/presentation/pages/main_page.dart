import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/glass_widgets.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../chat/presentation/chat_list_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MainPage extends ConsumerStatefulWidget {
  final int initialTab;

  const MainPage({super.key, this.initialTab = 0});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _pages = [
    const DashboardPage(),
    const FeedPage(),
    const ChatListPage(),
    const ProfilePage(),
  ];

  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Feed',
    ),
    BottomNavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Chat',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GlassContainer(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        borderRadius: BorderRadius.circular(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isActive = _currentIndex == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Colors.white.withOpacity(0.2) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.6),
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isActive 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
