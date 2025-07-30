import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/dashboard_models.dart';

// Dashboard state provider
final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(const DashboardState.loading()) {
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      // Simulate loading time
      await Future.delayed(const Duration(milliseconds: 500));
      
      final widgets = await _getDefaultWidgets();
      final activities = await _getMockActivities();
      final quickActions = _getDefaultQuickActions();
      
      state = DashboardState.loaded(
        widgets: widgets,
        activities: activities,
        quickActions: quickActions,
      );
    } catch (e) {
      state = DashboardState.error(e.toString());
    }
  }

  Future<List<DashboardWidget>> _getDefaultWidgets() async {
    return [
      const DashboardWidget(
        id: 'recent_photos',
        title: 'Recent Photos',
        type: DashboardWidgetType.recentPhotos,
        data: {'count': 5, 'lastPhoto': 'Vacation memories'},
        position: 0,
      ),
      const DashboardWidget(
        id: 'upcoming_events',
        title: 'Upcoming Events',
        type: DashboardWidgetType.upcomingBirthdays,
        data: {'event': 'Mom\'s birthday', 'date': 'Tomorrow'},
        position: 1,
      ),
      const DashboardWidget(
        id: 'family_chat',
        title: 'Family Chat',
        type: DashboardWidgetType.quickChat,
        data: {'unread': 12, 'lastMessage': 'Can\'t wait to see everyone!'},
        position: 2,
      ),
      const DashboardWidget(
        id: 'weather',
        title: 'Weather',
        type: DashboardWidgetType.weather,
        data: {'temp': '22°C', 'condition': 'Sunny', 'icon': 'sunny'},
        position: 3,
      ),
    ];
  }

  Future<List<FamilyActivity>> _getMockActivities() async {
    return [
      FamilyActivity(
        id: '1',
        userId: 'user1',
        userName: 'Sarah',
        userAvatar: '',
        action: 'shared',
        description: 'shared 3 new photos from the beach',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: 'beach_photo.jpg',
      ),
      FamilyActivity(
        id: '2',
        userId: 'user2',
        userName: 'Mike',
        userAvatar: '',
        action: 'posted',
        description: 'created an event: Family BBQ',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FamilyActivity(
        id: '3',
        userId: 'user3',
        userName: 'Emma',
        userAvatar: '',
        action: 'commented',
        description: 'commented on Dad\'s recipe',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  List<QuickAction> _getDefaultQuickActions() {
    return [
      const QuickAction(
        id: 'share_photo',
        title: 'Share Photo',
        icon: 'photo',
        color: '8B5CF6',
        route: '/share-photo',
      ),
      const QuickAction(
        id: 'new_event',
        title: 'New Event',
        icon: 'event',
        color: '06B6D4',
        route: '/create-event',
      ),
      const QuickAction(
        id: 'quick_chat',
        title: 'Quick Chat',
        icon: 'chat',
        color: '10B981',
        route: '/chat',
      ),
      const QuickAction(
        id: 'add_recipe',
        title: 'Add Recipe',
        icon: 'recipe',
        color: 'F59E0B',
        route: '/add-recipe',
      ),
    ];
  }

  Future<void> refreshDashboard() async {
    state = const DashboardState.loading();
    await _loadDashboard();
  }

  void reorderWidgets(List<DashboardWidget> newOrder) {
    state.maybeWhen(
      loaded: (widgets, activities, quickActions) {
        state = DashboardState.loaded(
          widgets: newOrder,
          activities: activities,
          quickActions: quickActions,
        );
      },
      orElse: () {},
    );
  }
}

// Dashboard state
abstract class DashboardState {
  const DashboardState();

  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded({
    required List<DashboardWidget> widgets,
    required List<FamilyActivity> activities,
    required List<QuickAction> quickActions,
  }) = _Loaded;
  const factory DashboardState.error(String message) = _Error;

  T when<T>({
    required T Function() loading,
    required T Function(
      List<DashboardWidget> widgets,
      List<FamilyActivity> activities,
      List<QuickAction> quickActions,
    ) loaded,
    required T Function(String message) error,
  }) {
    if (this is _Loading) return loading();
    if (this is _Loaded) {
      final state = this as _Loaded;
      return loaded(state.widgets, state.activities, state.quickActions);
    }
    if (this is _Error) return error((this as _Error).message);
    throw Exception('Unknown state');
  }

  T maybeWhen<T>({
    T Function()? loading,
    T Function(
      List<DashboardWidget> widgets,
      List<FamilyActivity> activities,
      List<QuickAction> quickActions,
    )? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    if (this is _Loading && loading != null) return loading();
    if (this is _Loaded && loaded != null) {
      final state = this as _Loaded;
      return loaded(state.widgets, state.activities, state.quickActions);
    }
    if (this is _Error && error != null) return error((this as _Error).message);
    return orElse();
  }
}

class _Loading extends DashboardState {
  const _Loading();
}

class _Loaded extends DashboardState {
  final List<DashboardWidget> widgets;
  final List<FamilyActivity> activities;
  final List<QuickAction> quickActions;

  const _Loaded({
    required this.widgets,
    required this.activities,
    required this.quickActions,
  });
}

class _Error extends DashboardState {
  final String message;
  const _Error(this.message);
}
