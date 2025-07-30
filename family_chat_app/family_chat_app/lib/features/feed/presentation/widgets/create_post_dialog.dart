import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/presentation/widgets/glass_widgets.dart';
import '../../../../shared/presentation/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/feed_providers.dart';
import '../../domain/models/post_model.dart';

class CreatePostDialog extends ConsumerStatefulWidget {
  const CreatePostDialog({super.key});

  @override
  ConsumerState<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends ConsumerState<CreatePostDialog> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  PostType _selectedType = PostType.text;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (images.length + _selectedImages.length > 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Du kan maksimalt velge 5 bilder'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
      if (_selectedImages.isNotEmpty) {
        _selectedType = PostType.photo;
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (_selectedImages.isEmpty) {
        _selectedType = PostType.text;
      }
    });
  }

  Future<void> _createPost() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skriv noe eller legg til bilder'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final postData = CreatePostData(
      type: _selectedType,
      content: content,
      imageFiles: _selectedImages,
    );

    await ref.read(createPostControllerProvider.notifier).createPost(
      authorId: user.id,
      authorName: user.displayName,
      authorAvatar: user.photoUrl,
      postData: postData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostControllerProvider);
    
    ref.listen<CreatePostState>(createPostControllerProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Innlegget ble publisert!'),
              backgroundColor: Colors.green,
            ),
          );
          ref.read(createPostControllerProvider.notifier).resetState();
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Feil: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.edit_note,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Opprett innlegg',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Content input
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassContainer(
                        borderRadius: 12,
                        child: TextField(
                          controller: _contentController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Hva tenker du på?',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      if (_selectedImages.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _selectedImages[index],
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Actions row
                      Row(
                        children: [
                          GlassButton(
                            onPressed: _pickImages,
                            icon: Icons.photo_library,
                            child: const Text('Bilder'),
                          ),
                          const SizedBox(width: 12),
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            borderRadius: 20,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _selectedType == PostType.text 
                                    ? Icons.text_fields 
                                    : Icons.photo,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _selectedType == PostType.text 
                                    ? 'Tekst' 
                                    : 'Bilder',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GlassButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Avbryt'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: createPostState.when(
                      initial: () => GlassButton(
                        onPressed: _createPost,
                        isPrimary: true,
                        child: const Text('Publiser'),
                      ),
                      loading: () => const GlassButton(
                        onPressed: null,
                        isPrimary: true,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      success: () => const GlassButton(
                        onPressed: null,
                        isPrimary: true,
                        child: Icon(Icons.check, color: Colors.green),
                      ),
                      error: (message) => GlassButton(
                        onPressed: _createPost,
                        isPrimary: true,
                        child: const Text('Prøv igjen'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
