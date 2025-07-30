import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../data/organization_service.dart';
import '../domain/models/organization_models.dart';
import '../../auth/auth_providers.dart';

// Service Provider
final organizationServiceProvider = Provider<OrganizationService>((ref) {
  return OrganizationService();
});

// Events Providers
final eventsProvider = StreamProvider.family<List<EventModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getEvents(familyId);
});

final upcomingEventsProvider = Provider.family<List<EventModel>, String>((ref, familyId) {
  final events = ref.watch(eventsProvider(familyId));
  return events.when(
    data: (eventList) {
      final now = DateTime.now();
      return eventList.where((event) => event.startDate.isAfter(now)).take(5).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Tasks Providers
final tasksProvider = StreamProvider.family<List<TaskModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getTasks(familyId);
});

final myTasksProvider = StreamProvider.family<List<TaskModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  final user = ref.watch(currentUserProvider);
  
  return user.when(
    data: (userData) {
      if (userData != null) {
        return service.getTasks(familyId, assignedTo: userData.uid);
      }
      return Stream.value(<TaskModel>[]);
    },
    loading: () => Stream.value(<TaskModel>[]),
    error: (_, __) => Stream.value(<TaskModel>[]),
  );
});

final pendingTasksProvider = Provider.family<List<TaskModel>, String>((ref, familyId) {
  final tasks = ref.watch(tasksProvider(familyId));
  return tasks.when(
    data: (taskList) => taskList.where((task) => task.status == TaskStatus.pending).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final completedTasksProvider = Provider.family<List<TaskModel>, String>((ref, familyId) {
  final tasks = ref.watch(tasksProvider(familyId));
  return tasks.when(
    data: (taskList) => taskList.where((task) => task.status == TaskStatus.completed).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Shopping Providers
final shoppingListsProvider = StreamProvider.family<List<ShoppingListModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getShoppingLists(familyId);
});

final shoppingItemsProvider = StreamProvider.family<List<ShoppingItemModel>, ({String familyId, String listId})>((ref, params) {
  final service = ref.read(organizationServiceProvider);
  return service.getShoppingItems(params.familyId, params.listId);
});

final activeShoppingItemsProvider = Provider.family<List<ShoppingItemModel>, ({String familyId, String listId})>((ref, params) {
  final items = ref.watch(shoppingItemsProvider(params));
  return items.when(
    data: (itemList) => itemList.where((item) => !item.isCompleted).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Documents Providers
final documentsProvider = StreamProvider.family<List<DocumentModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getDocuments(familyId);
});

final documentsByTypeProvider = Provider.family<List<DocumentModel>, ({String familyId, DocumentType type})>((ref, params) {
  final documents = ref.watch(documentsProvider(params.familyId));
  return documents.when(
    data: (docList) => docList.where((doc) => doc.type == params.type).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Announcements Providers
final announcementsProvider = StreamProvider.family<List<AnnouncementModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getAnnouncements(familyId);
});

final unreadAnnouncementsProvider = Provider.family<List<AnnouncementModel>, String>((ref, familyId) {
  final announcements = ref.watch(announcementsProvider(familyId));
  final user = ref.watch(currentUserProvider);
  
  return announcements.when(
    data: (announcementList) {
      return user.when(
        data: (userData) {
          if (userData != null) {
            return announcementList.where((announcement) => 
              !announcement.readBy.contains(userData.uid)).toList();
          }
          return announcementList;
        },
        loading: () => announcementList,
        error: (_, __) => announcementList,
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Location Sharing Providers
final sharedLocationsProvider = StreamProvider.family<List<LocationShareModel>, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getSharedLocations(familyId);
});

// Family Stats Provider
final familyStatsProvider = FutureProvider.family<FamilyStatsModel, String>((ref, familyId) {
  final service = ref.read(organizationServiceProvider);
  return service.getFamilyStats(familyId);
});

// Upload Progress Provider
final documentUploadProgressProvider = StateNotifierProvider<DocumentUploadController, DocumentUploadState>((ref) {
  return DocumentUploadController(ref.read(organizationServiceProvider));
});

class DocumentUploadState {
  final bool isUploading;
  final double progress;
  final String? error;
  final DocumentModel? uploadedDocument;

  DocumentUploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.error,
    this.uploadedDocument,
  });

  DocumentUploadState copyWith({
    bool? isUploading,
    double? progress,
    String? error,
    DocumentModel? uploadedDocument,
  }) {
    return DocumentUploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      error: error,
      uploadedDocument: uploadedDocument ?? this.uploadedDocument,
    );
  }
}

class DocumentUploadController extends StateNotifier<DocumentUploadState> {
  final OrganizationService _service;

  DocumentUploadController(this._service) : super(DocumentUploadState());

  Future<void> uploadDocument({
    required String familyId,
    required PlatformFile file,
    required DocumentType type,
    required String uploadedBy,
    required String uploaderName,
    String? description,
    List<String>? tags,
    DateTime? expiryDate,
  }) async {
    try {
      state = state.copyWith(isUploading: true, progress: 0.0, error: null);

      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        state = state.copyWith(progress: i / 100);
      }

      final document = await _service.uploadDocument(
        familyId: familyId,
        file: file,
        type: type,
        uploadedBy: uploadedBy,
        uploaderName: uploaderName,
        description: description,
        tags: tags,
        expiryDate: expiryDate,
      );

      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        uploadedDocument: document,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  void clearState() {
    state = DocumentUploadState();
  }
}

// Organization Action Providers - for handling business logic
final organizationActionsProvider = Provider<OrganizationActions>((ref) {
  return OrganizationActions(ref);
});

class OrganizationActions {
  final Ref _ref;

  OrganizationActions(this._ref);

  OrganizationService get _service => _ref.read(organizationServiceProvider);

  // Event Actions
  Future<void> createEvent(String familyId, EventModel event) async {
    await _service.createEvent(familyId, event);
  }

  Future<void> updateEvent(String familyId, EventModel event) async {
    await _service.updateEvent(familyId, event);
  }

  Future<void> deleteEvent(String familyId, String eventId) async {
    await _service.deleteEvent(familyId, eventId);
  }

  // Task Actions
  Future<void> createTask(String familyId, TaskModel task) async {
    await _service.createTask(familyId, task);
  }

  Future<void> updateTask(String familyId, TaskModel task) async {
    await _service.updateTask(familyId, task);
  }

  Future<void> completeTask(String familyId, String taskId, String userId) async {
    await _service.updateTaskStatus(familyId, taskId, TaskStatus.completed, completedBy: userId);
  }

  Future<void> reopenTask(String familyId, String taskId) async {
    await _service.updateTaskStatus(familyId, taskId, TaskStatus.pending);
  }

  Future<void> deleteTask(String familyId, String taskId) async {
    await _service.deleteTask(familyId, taskId);
  }

  // Shopping Actions
  Future<void> createShoppingList(String familyId, ShoppingListModel shoppingList) async {
    await _service.createShoppingList(familyId, shoppingList);
  }

  Future<void> addShoppingItem(String familyId, String listId, ShoppingItemModel item) async {
    await _service.addShoppingItem(familyId, listId, item);
  }

  Future<void> toggleShoppingItem(
    String familyId,
    String listId,
    String itemId,
    bool isCompleted,
    String userId,
    String userName,
  ) async {
    await _service.toggleShoppingItemComplete(familyId, listId, itemId, isCompleted, userId, userName);
  }

  // Announcement Actions
  Future<void> createAnnouncement(String familyId, AnnouncementModel announcement) async {
    await _service.createAnnouncement(familyId, announcement);
  }

  Future<void> markAnnouncementAsRead(String familyId, String announcementId, String userId) async {
    await _service.markAnnouncementAsRead(familyId, announcementId, userId);
  }

  // Location Actions
  Future<void> shareLocation({
    required String familyId,
    required String userId,
    required String userName,
    String? userAvatarUrl,
    required double latitude,
    required double longitude,
    double? accuracy,
    String? address,
    Duration? duration,
    String? message,
  }) async {
    await _service.shareLocation(
      familyId: familyId,
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      address: address,
      duration: duration,
      message: message,
    );
  }

  Future<void> stopLocationSharing(String familyId, String locationId) async {
    await _service.stopLocationSharing(familyId, locationId);
  }

  // Document Actions
  Future<void> deleteDocument(String familyId, String documentId, String fileName) async {
    await _service.deleteDocument(familyId, documentId, fileName);
  }
}
