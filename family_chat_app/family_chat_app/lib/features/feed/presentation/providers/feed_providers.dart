import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/post_model.dart';
import '../domain/services/post_service.dart';

// Feed posts provider
final feedPostsProvider = StreamProvider<List<PostModel>>((ref) {
  final postService = ref.watch(postServiceProvider);
  return postService.getPostsFeed();
});

// Create post controller
final createPostControllerProvider = StateNotifierProvider<CreatePostController, CreatePostState>((ref) {
  final postService = ref.watch(postServiceProvider);
  return CreatePostController(postService);
});

class CreatePostController extends StateNotifier<CreatePostState> {
  final PostService _postService;

  CreatePostController(this._postService) : super(const CreatePostState.initial());

  Future<void> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required CreatePostData postData,
  }) async {
    state = const CreatePostState.loading();
    try {
      await _postService.createPost(
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        postData: postData,
      );
      state = const CreatePostState.success();
    } catch (e) {
      state = CreatePostState.error(e.toString());
    }
  }

  void resetState() {
    state = const CreatePostState.initial();
  }
}

// Post interaction controller
final postInteractionControllerProvider = StateNotifierProvider<PostInteractionController, Map<String, bool>>((ref) {
  final postService = ref.watch(postServiceProvider);
  return PostInteractionController(postService);
});

class PostInteractionController extends StateNotifier<Map<String, bool>> {
  final PostService _postService;

  PostInteractionController(this._postService) : super({});

  Future<void> toggleLike(String postId, String userId) async {
    // Optimistic update
    state = {...state, postId: true};
    
    try {
      await _postService.togglePostLike(postId, userId);
    } catch (e) {
      // Revert on error
      state = {...state, postId: false};
      // TODO: Show error to user
    } finally {
      // Remove loading state
      final newState = Map<String, bool>.from(state);
      newState.remove(postId);
      state = newState;
    }
  }

  Future<void> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      await _postService.addComment(
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        content: content,
        parentCommentId: parentCommentId,
      );
    } catch (e) {
      // TODO: Handle error
      rethrow;
    }
  }
}

// Post comments provider
final postCommentsProvider = StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  final postService = ref.watch(postServiceProvider);
  return postService.getPostComments(postId);
});

// Create post state
abstract class CreatePostState {
  const CreatePostState();

  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.loading() = _Loading;
  const factory CreatePostState.success() = _Success;
  const factory CreatePostState.error(String message) = _Error;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() success,
    required T Function(String message) error,
  }) {
    if (this is _Initial) return initial();
    if (this is _Loading) return loading();
    if (this is _Success) return success();
    if (this is _Error) return error((this as _Error).message);
    throw Exception('Unknown state');
  }
}

class _Initial extends CreatePostState {
  const _Initial();
}

class _Loading extends CreatePostState {
  const _Loading();
}

class _Success extends CreatePostState {
  const _Success();
}

class _Error extends CreatePostState {
  final String message;
  const _Error(this.message);
}
