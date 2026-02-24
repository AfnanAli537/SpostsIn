import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
// import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/generated/l10n.dart';

class UpdatePostScreen extends StatefulWidget {
  final PostModel post;

  const UpdatePostScreen({super.key, required this.post});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  late final ValueNotifier<String?> sportNotifier;
  bool _isUpdating = false; // ✅ Track loading state locally

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _descriptionController = TextEditingController(text: widget.post.description);
    sportNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    sportNotifier.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedFile = File(image.path));
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() => _selectedFile = File(video.path));
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: ColorManager.darkPrimary),
                title: const Text('Pick Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: ColorManager.darkPrimary),
                title: const Text('Pick Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleUpdate() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        sportNotifier.value == null) {
      Fluttertoast.showToast(
        msg: 'Please fill all required fields',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final sportEnum = EnumMapper.fromLabel(
      EnumMapper.sportLabels(),
      sportNotifier.value!,
    );
    final sportId = sportEnum != null ? EnumMapper.getSportId(sportEnum) : 0;

    if (sportId == 0) {
      Fluttertoast.showToast(
        msg: 'Invalid sport selected',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // ✅ Set loading state
    setState(() => _isUpdating = true);

    context.read<PostsBloc>().add(
          UpdatePost(
            postId: widget.post.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            sportTypeId: sportId,
            mediaFile: _selectedFile?.path,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocListener<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is PostUpdateSuccess) {
          setState(() => _isUpdating = false);
          Fluttertoast.showToast(
            msg: string.postUpdated,
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          // ✅ Use addPostFrameCallback to avoid "build scheduled during frame"
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pop(context, true);
            }
          });
        } else if (state is PostsError) {
          setState(() => _isUpdating = false);
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: ColorManager.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.onSurface),
                onPressed: _isUpdating ? null : () => Navigator.pop(context),
              ),
              title: Text(
                string.updatePost,
                style: TextStyle(
                  color: theme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload Area
                    GestureDetector(
                      onTap: _isUpdating ? null : _showPickerOptions,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Colors.grey[400]!,
                          strokeWidth: 2.w,
                          dashPattern: const [20, 6],
                          radius: Radius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            color: theme.surface,
                            child: _selectedFile == null
                                ? _buildExistingMediaPreview(theme)
                                : _buildNewMediaPreview(),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Title Field
                    AuthTextField(
                      controller: _titleController,
                      hintText: 'Post Title',
                    ),

                    SizedBox(height: 16.h),

                    // Description Field
                    AuthTextField(
                      controller: _descriptionController,
                      hintText: 'Post Description',
                      maxLines: 5,
                    ),

                    SizedBox(height: 16.h),

                    // Sport Dropdown
                    ValueListenableBuilder<String?>(
                      valueListenable: sportNotifier,
                      builder: (context, sport, _) {
                        return IgnorePointer(
                          ignoring: _isUpdating,
                          child: Opacity(
                            opacity: _isUpdating ? 0.5 : 1.0,
                            child: AppDropdownOverlay(
                              labelText: string.sportProfession,
                              value: sport,
                              options: RegisterLists.sportNameOptions(string),
                              onChanged: (val) => sportNotifier.value = val,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 32.h),

                    // Update Button
                    CustomElevatedButton(
                      text: _isUpdating ? 'Updating...' : 'Update Post',
                      isLoading: _isUpdating,
                      enabled: !_isUpdating,
                      onPressed: _handleUpdate,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // ✅ Full-screen loading overlay
          if (_isUpdating)
            Container(
              color: Colors.black26,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250.w),
                        child: Text(
                          string.updatingPost,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExistingMediaPreview(ColorScheme theme) {
    // ✅ Check if media URL is valid
    final hasValidMedia = widget.post.mediaUrl != null &&
        widget.post.mediaUrl!.isNotEmpty &&
        widget.post.mediaUrl != 'placeholder.com' &&
        widget.post.mediaUrl!.startsWith('http');

    if (!hasValidMedia) {
      return _buildUploadPlaceholder();
    }

    return Stack(
      children: [
        Image.network(
          widget.post.mediaUrl!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildUploadPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Change',
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewMediaPreview() {
    return Stack(
      children: [
        Image.file(
          _selectedFile!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () => setState(() => _selectedFile = null),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 60.sp, color: Colors.grey[600]),
        SizedBox(height: 12.h),
        Text(
          'Upload an Image or Video',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Maximum file size is 200 MB',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
        ),
      ],
    );
  }
}