import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../domain/models/organization_models.dart';

class OrganizationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Events
  Stream<List<EventModel>> getEvents(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('events')
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> createEvent(String familyId, EventModel event) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('events')
        .add(event.toJson()..remove('id'));
  }

  Future<void> updateEvent(String familyId, EventModel event) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('events')
        .doc(event.id)
        .update(event.copyWith(updatedAt: DateTime.now()).toJson()..remove('id'));
  }

  Future<void> deleteEvent(String familyId, String eventId) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('events')
        .doc(eventId)
        .delete();
  }

  // Tasks
  Stream<List<TaskModel>> getTasks(String familyId, {String? assignedTo}) {
    Query query = _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .orderBy('priority', descending: true)
        .orderBy('dueDate', descending: false);

    if (assignedTo != null) {
      query = query.where('assignedTo', isEqualTo: assignedTo);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList());
  }

  Future<void> createTask(String familyId, TaskModel task) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .add(task.toJson()..remove('id'));
  }

  Future<void> updateTask(String familyId, TaskModel task) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .doc(task.id)
        .update(task.copyWith(updatedAt: DateTime.now()).toJson()..remove('id'));
  }

  Future<void> updateTaskStatus(String familyId, String taskId, TaskStatus status, {String? completedBy}) async {
    final updates = <String, dynamic>{
      'status': status.name,
      'updatedAt': DateTime.now(),
    };

    if (status == TaskStatus.completed && completedBy != null) {
      updates['completedAt'] = DateTime.now();
      updates['completedBy'] = completedBy;
    }

    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .doc(taskId)
        .update(updates);
  }

  Future<void> deleteTask(String familyId, String taskId) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Shopping Lists & Items
  Stream<List<ShoppingListModel>> getShoppingLists(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShoppingListModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<ShoppingItemModel>> getShoppingItems(String familyId, String listId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .orderBy('isCompleted')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShoppingItemModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> createShoppingList(String familyId, ShoppingListModel shoppingList) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .add(shoppingList.toJson()..remove('id'));
  }

  Future<void> addShoppingItem(String familyId, String listId, ShoppingItemModel item) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .add(item.toJson()..remove('id'));
  }

  Future<void> updateShoppingItem(String familyId, String listId, ShoppingItemModel item) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(item.id)
        .update(item.copyWith(updatedAt: DateTime.now()).toJson()..remove('id'));
  }

  Future<void> toggleShoppingItemComplete(
    String familyId,
    String listId,
    String itemId,
    bool isCompleted,
    String userId,
    String userName,
  ) async {
    final updates = <String, dynamic>{
      'isCompleted': isCompleted,
      'updatedAt': DateTime.now(),
    };

    if (isCompleted) {
      updates['completedBy'] = userId;
      updates['completedByName'] = userName;
      updates['completedAt'] = DateTime.now();
    } else {
      updates['completedBy'] = null;
      updates['completedByName'] = null;
      updates['completedAt'] = null;
    }

    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update(updates);
  }

  // Documents
  Stream<List<DocumentModel>> getDocuments(String familyId, {DocumentType? type}) {
    Query query = _firestore
        .collection('families')
        .doc(familyId)
        .collection('documents')
        .orderBy('uploadedAt', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => DocumentModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList());
  }

  Future<DocumentModel> uploadDocument({
    required String familyId,
    required PlatformFile file,
    required DocumentType type,
    required String uploadedBy,
    required String uploaderName,
    String? description,
    List<String>? tags,
    DateTime? expiryDate,
  }) async {
    // Upload file to Firebase Storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final ref = _storage.ref().child('families/$familyId/documents/$fileName');
    
    final uploadTask = ref.putData(file.bytes!);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    // Create document model
    final document = DocumentModel(
      id: '',
      name: file.name,
      description: description,
      fileUrl: downloadUrl,
      fileName: fileName,
      fileSize: file.size,
      type: type,
      uploadedBy: uploadedBy,
      uploaderName: uploaderName,
      tags: tags ?? [],
      expiryDate: expiryDate,
      uploadedAt: DateTime.now(),
    );

    // Save to Firestore
    final docRef = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('documents')
        .add(document.toJson()..remove('id'));

    return document.copyWith(id: docRef.id);
  }

  Future<void> deleteDocument(String familyId, String documentId, String fileName) async {
    // Delete from Storage
    try {
      await _storage.ref().child('families/$familyId/documents/$fileName').delete();
    } catch (e) {
      // File might not exist, continue with Firestore deletion
    }

    // Delete from Firestore
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('documents')
        .doc(documentId)
        .delete();
  }

  // Announcements
  Stream<List<AnnouncementModel>> getAnnouncements(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('announcements')
        .where('isActive', isEqualTo: true)
        .orderBy('priority', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AnnouncementModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> createAnnouncement(String familyId, AnnouncementModel announcement) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('announcements')
        .add(announcement.toJson()..remove('id'));
  }

  Future<void> markAnnouncementAsRead(String familyId, String announcementId, String userId) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('announcements')
        .doc(announcementId)
        .update({
      'readBy': FieldValue.arrayUnion([userId]),
    });
  }

  // Location Sharing
  Stream<List<LocationShareModel>> getSharedLocations(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('location_shares')
        .where('isActive', isEqualTo: true)
        .where('expiresAt', isGreaterThan: DateTime.now())
        .orderBy('expiresAt')
        .orderBy('sharedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LocationShareModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

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
    final location = LocationShareModel(
      id: '',
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      address: address,
      expiresAt: duration != null ? DateTime.now().add(duration) : null,
      message: message,
      sharedAt: DateTime.now(),
    );

    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('location_shares')
        .add(location.toJson()..remove('id'));
  }

  Future<void> stopLocationSharing(String familyId, String locationId) async {
    await _firestore
        .collection('families')
        .doc(familyId)
        .collection('location_shares')
        .doc(locationId)
        .update({
      'isActive': false,
      'updatedAt': DateTime.now(),
    });
  }

  // Family Stats
  Future<FamilyStatsModel> getFamilyStats(String familyId) async {
    final tasks = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('tasks')
        .get();

    final events = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('events')
        .where('startDate', isGreaterThan: DateTime.now())
        .get();

    final shoppingLists = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .get();

    final documents = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('documents')
        .get();

    final announcements = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('announcements')
        .get();

    // Calculate shopping items
    int totalShoppingItems = 0;
    int completedShoppingItems = 0;
    
    for (final listDoc in shoppingLists.docs) {
      final items = await _firestore
          .collection('families')
          .doc(familyId)
          .collection('shopping_lists')
          .doc(listDoc.id)
          .collection('items')
          .get();
      
      totalShoppingItems += items.docs.length;
      completedShoppingItems += items.docs.where((doc) => doc.data()['isCompleted'] == true).length;
    }

    // Calculate task stats by user
    final tasksByUser = <String, int>{};
    final completedTasksByUser = <String, int>{};
    final pointsByUser = <String, int>{};

    for (final taskDoc in tasks.docs) {
      final taskData = taskDoc.data();
      final assignedTo = taskData['assignedTo'] as String?;
      final status = taskData['status'] as String?;
      final points = taskData['points'] as int? ?? 0;

      if (assignedTo != null) {
        tasksByUser[assignedTo] = (tasksByUser[assignedTo] ?? 0) + 1;
        
        if (status == 'completed') {
          completedTasksByUser[assignedTo] = (completedTasksByUser[assignedTo] ?? 0) + 1;
          pointsByUser[assignedTo] = (pointsByUser[assignedTo] ?? 0) + points;
        }
      }
    }

    return FamilyStatsModel(
      familyId: familyId,
      totalTasks: tasks.docs.length,
      completedTasks: tasks.docs.where((doc) => doc.data()['status'] == 'completed').length,
      totalEvents: events.docs.length,
      upcomingEvents: events.docs.length,
      totalShoppingItems: totalShoppingItems,
      completedShoppingItems: completedShoppingItems,
      totalDocuments: documents.docs.length,
      totalAnnouncements: announcements.docs.length,
      activeAnnouncements: announcements.docs.where((doc) => doc.data()['isActive'] == true).length,
      tasksByUser: tasksByUser,
      completedTasksByUser: completedTasksByUser,
      pointsByUser: pointsByUser,
      lastUpdated: DateTime.now(),
    );
  }
}
