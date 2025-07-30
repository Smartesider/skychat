import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/glassmorphism_container.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/organization_providers.dart';
import '../domain/models/organization_models.dart';
import '../../auth/auth_providers.dart';

class OrganizationPage extends ConsumerStatefulWidget {
  final String familyId;

  const OrganizationPage({
    super.key,
    required this.familyId,
  });

  @override
  ConsumerState<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends ConsumerState<OrganizationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Familie Organisering',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Oversikt'),
            Tab(text: 'Kalender'),
            Tab(text: 'Oppgaver'),
            Tab(text: 'Handlelister'),
            Tab(text: 'Dokumenter'),
            Tab(text: 'Kunngjøringer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCalendarTab(),
          _buildTasksTab(),
          _buildShoppingTab(),
          _buildDocumentsTab(),
          _buildAnnouncementsTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickActionDialog(),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Legg til',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 16),
          _buildStatsCards(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildUpcomingEvents(),
          const SizedBox(height: 16),
          _buildPendingTasks(),
          const SizedBox(height: 16),
          _buildRecentAnnouncements(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final user = ref.watch(currentUserProvider);
    
    return user.when(
      data: (userData) {
        if (userData == null) return const SizedBox.shrink();
        
        final greeting = _getGreeting();
        
        return GlassmorphismContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getGreetingIcon(),
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, ${userData.displayName ?? 'Familie'}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Velkommen til familieorganiseringen',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatsCards() {
    final stats = ref.watch(familyStatsProvider(widget.familyId));
    
    return stats.when(
      data: (statsData) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Aktive Oppgaver',
              '${statsData.totalTasks - statsData.completedTasks}',
              Icons.task_alt,
              AppColors.primary,
            ),
            _buildStatCard(
              'Kommende Hendelser',
              '${statsData.upcomingEvents}',
              Icons.event,
              AppColors.secondary,
            ),
            _buildStatCard(
              'Handlekurv Items',
              '${statsData.totalShoppingItems - statsData.completedShoppingItems}',
              Icons.shopping_cart,
              AppColors.accent,
            ),
            _buildStatCard(
              'Dokumenter',
              '${statsData.totalDocuments}',
              Icons.folder,
              AppColors.warning,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('Kunne ikke laste statistikk'),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassmorphismContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GlassmorphismContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hurtighandlinger',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionButton(
                'Ny Oppgave',
                Icons.add_task,
                AppColors.primary,
                () => _showCreateTaskDialog(),
              ),
              _buildQuickActionButton(
                'Ny Hendelse',
                Icons.event_note,
                AppColors.secondary,
                () => _showCreateEventDialog(),
              ),
              _buildQuickActionButton(
                'Handleliste',
                Icons.shopping_list,
                AppColors.accent,
                () => _showCreateShoppingListDialog(),
              ),
              _buildQuickActionButton(
                'Kunngjøring',
                Icons.campaign,
                AppColors.warning,
                () => _showCreateAnnouncementDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final events = ref.watch(upcomingEventsProvider(widget.familyId));
    
    return GlassmorphismContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kommende Hendelser',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => _tabController.animateTo(1),
                child: Text(
                  'Se alle',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            Text(
              'Ingen kommende hendelser',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            )
          else
            ...events.take(3).map((event) => _buildEventListItem(event)),
        ],
      ),
    );
  }

  Widget _buildEventListItem(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getEventTypeColor(event.type),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(event.startDate),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTasks() {
    final tasks = ref.watch(pendingTasksProvider(widget.familyId));
    
    return GlassmorphismContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ventende Oppgaver',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => _tabController.animateTo(2),
                child: Text(
                  'Se alle',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tasks.isEmpty)
            Text(
              'Ingen ventende oppgaver',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            )
          else
            ...tasks.take(3).map((task) => _buildTaskListItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskListItem(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getTaskPriorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (task.dueDate != null)
                  Text(
                    'Frist: ${DateFormat('dd.MM.yyyy').format(task.dueDate!)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnnouncements() {
    final announcements = ref.watch(unreadAnnouncementsProvider(widget.familyId));
    
    return GlassmorphismContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Uleste Kunngjøringer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => _tabController.animateTo(5),
                child: Text(
                  'Se alle',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (announcements.isEmpty)
            Text(
              'Ingen uleste kunngjøringer',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            )
          else
            ...announcements.take(2).map((announcement) => _buildAnnouncementListItem(announcement)),
        ],
      ),
    );
  }

  Widget _buildAnnouncementListItem(AnnouncementModel announcement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            _getAnnouncementIcon(announcement.priority),
            color: _getAnnouncementColor(announcement.priority),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  announcement.content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder methods for other tabs
  Widget _buildCalendarTab() {
    return const Center(
      child: Text(
        'Kalender kommer snart',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildTasksTab() {
    return const Center(
      child: Text(
        'Oppgaver kommer snart',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildShoppingTab() {
    return const Center(
      child: Text(
        'Handlelister kommer snart',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return const Center(
      child: Text(
        'Dokumenter kommer snart',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildAnnouncementsTab() {
    return const Center(
      child: Text(
        'Kunngjøringer kommer snart',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // Helper methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'God morgen';
    if (hour < 18) return 'God dag';
    return 'God kveld';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 18) return Icons.wb_cloudy;
    return Icons.nights_stay;
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.family:
        return AppColors.primary;
      case EventType.appointment:
        return AppColors.secondary;
      case EventType.birthday:
        return AppColors.accent;
      case EventType.holiday:
        return AppColors.success;
      case EventType.reminder:
        return AppColors.warning;
      case EventType.activity:
        return AppColors.info;
    }
  }

  Color _getTaskPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.urgent:
        return AppColors.accent;
    }
  }

  IconData _getAnnouncementIcon(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.info:
        return Icons.info_outline;
      case AnnouncementPriority.important:
        return Icons.priority_high;
      case AnnouncementPriority.urgent:
        return Icons.warning;
    }
  }

  Color _getAnnouncementColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.info:
        return AppColors.info;
      case AnnouncementPriority.important:
        return AppColors.warning;
      case AnnouncementPriority.urgent:
        return AppColors.error;
    }
  }

  // Dialog methods (placeholder implementations)
  void _showQuickActionDialog() {
    // Implementation for quick action dialog
  }

  void _showCreateTaskDialog() {
    // Implementation for create task dialog
  }

  void _showCreateEventDialog() {
    // Implementation for create event dialog
  }

  void _showCreateShoppingListDialog() {
    // Implementation for create shopping list dialog
  }

  void _showCreateAnnouncementDialog() {
    // Implementation for create announcement dialog
  }
}
