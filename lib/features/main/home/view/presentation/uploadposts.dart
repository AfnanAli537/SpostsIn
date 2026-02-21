import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'dart:io';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/generated/l10n.dart';

class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({super.key});

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  final sportNotifier = ValueNotifier<String?>(null);
  final positionNotifier = ValueNotifier<String?>(null);

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedFile = File(video.path);
      });
    }
  }

  void _showPickerOptions() {
    final strings = S.of(context);
    
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
                leading: Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
                title: Text(strings.pickImage),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Theme.of(context).colorScheme.primary),
                title: Text(strings.pickVideo),
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
  Future<void> _showError(BuildContext context, String message) async {
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
      context,
      message,
    );
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }
  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    
    return BlocListener<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is PostsUploadSuccess) {
          Fluttertoast.showToast(
            msg: strings.postUploadedSuccessfully,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
          
          _titleController.clear();
          _descriptionController.clear();
          sportNotifier.value = null;
          setState(() {
            _selectedFile = null;
          });
          Navigator.pop(context);
        } else if (state is PostsError) {
          _showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            strings.uploadContent,
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
                GestureDetector(
                  onTap: _showPickerOptions,
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
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 60.sp,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    strings.uploadImageOrVideo,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    strings.maximumFileSize,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
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
                                      onTap: () {
                                        setState(() {
                                          _selectedFile = null;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  strings.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextField(
                  controller: _titleController,
                  label: strings.enterYourTitle,
                ),
                SizedBox(height: 20.h),
                Text(
                  strings.description,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextField(
                  controller: _descriptionController,
                  label: strings.enterYourDescription,
                  maxLines: 5,
                ),
                SizedBox(height: 16.h),
                ValueListenableBuilder<String?>(
                  valueListenable: sportNotifier,
                  builder: (context, sport, _) {
                    return AppDropdownOverlay(
                      labelText: strings.sportProfession,
                      value: sport,
                      options: RegisterLists.sportNameOptions(strings),
                      onChanged: (val) => sportNotifier.value = val,
                      validator: (v) => Validators.validateDropdown(
                        context: context,
                        value: v,
                        fieldName: strings.sportProfession.toLowerCase(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.h),
                BlocBuilder<PostsBloc, PostsState>(
                  builder: (context, state) {
                    final isUploading = state is PostsLoaded && state.isUploading;
                    return CustomElevatedButton(
                      text: strings.post,
                      isLoading: isUploading,
                      enabled: !isUploading,
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty ||
                            _descriptionController.text.trim().isEmpty ||
                            sportNotifier.value == null) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseFillAllFields,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        context.read<PostsBloc>().add(
                          UploadPost(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            sport: sportNotifier.value!,
                            mediaUrl: _selectedFile?.path,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    sportNotifier.dispose();
    positionNotifier.dispose();
    super.dispose();
  }
}