import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/glass_widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_widget_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/activity_list.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(currentUserDataProvider);
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: GlassAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dashboardProvider.notifier).refreshDashboard();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authControllerProvider.notifier).signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(dashboardProvider.notifier).refreshDashboard();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                _buildWelcomeCard(userDataAsync),
                
                const SizedBox(height: 24),
                
                // Dashboard content
                dashboardState.when(
                  loading: () => _buildLoadingState(),
                  loaded: (widgets, activities, quickActions) => Column(
                    children: [
                      // Quick actions
                      _buildQuickActions(quickActions),
                      
                      const SizedBox(height: 24),
                      
                      // Recent activity
                      _buildRecentActivity(activities),
                      
                      const SizedBox(height: 24),
                      
                      // Widget grid
                      _buildWidgetGrid(widgets),
                    ],
                  ),
                  error: (message) => _buildErrorState(message),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(AsyncValue userDataAsync) {
    return userDataAsync.when(
      data: (userData) {
        final userName = userData != null 
            ? '${userData.firstName} ${userData.lastName}'
            : 'User';
        final greeting = _getGreeting();
        
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: userData?.profileImageUrl != null 
                        ? NetworkImage(userData!.profileImageUrl!)
                        : null,
                    child: userData?.profileImageUrl == null
                        ? Text(
                            userData != null 
                                ? '${userData.firstName[0]}${userData.lastName[0]}'
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(userData?.status.name ?? 'offline'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome back! Check out what\'s new with your family today.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildErrorCard(),
    );
  }

  Widget _buildStatusIndicator(String status) {
    final isOnline = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List quickActions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: QuickActionCard(action: action),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(List activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to full activity feed
              },
              child: Text(
                'See All',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ActivityList(activities: activities.take(3).toList()),
      ],
    );
  }

  Widget _buildWidgetGrid(List widgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Updates',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            final widget = widgets[index];
            return DashboardWidgetCard(widget: widget);
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildLoadingCard(),
        const SizedBox(height: 16),
        _buildLoadingCard(),
        const SizedBox(height: 16),
        _buildLoadingCard(),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return GlassCard(
      child: Column(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            'Unable to load user data',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GlassButton(
            onPressed: () {
              ref.read(dashboardProvider.notifier).refreshDashboard();
            },
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning!';
    } else if (hour < 17) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }
}
