import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/upload_video_screen.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/generated/l10n.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');

  final ValueNotifier<String?> _sportNotifier = ValueNotifier<String?>(null);
  File? _selectedThumbnail;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sportNotifier.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedThumbnail = File(image.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error picking image: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  int? _getSportIdFromName(String? sportName) {
    if (sportName == null) return null;
    final string = S.of(context);
    final sportMap = {
      string.football: 1,
      string.basketball: 2,
      string.volleyball: 3,
      string.handball: 4,
      string.teakwando: 5,
      string.gymnastics: 6,
    };
    return sportMap[sportName];
  }

  void _createCourse(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final sportId = _getSportIdFromName(_sportNotifier.value);
    if (sportId == null) {
      Fluttertoast.showToast(
        msg: 'Please select a sport',
        backgroundColor: Colors.orange,
      );
      return;
    }

    final price = double.tryParse(_priceController.text) ?? 0;

    context.read<CoursesBloc>().add(
          CreateCourse(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            sportTypeId: sportId,
            thumbnailFile: _selectedThumbnail,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final string = S.of(context);

    return BlocProvider(
      create: (context) => getIt<CoursesBloc>(),
      // ✅ FIX: Use Builder to get correct context with BLoC
      child: Builder(
        builder: (builderContext) => BlocListener<CoursesBloc, CoursesState>(
          listener: (context, state) {
            if (state is CourseCreated) {
              Fluttertoast.showToast(
                msg: 'Course created successfully',
                backgroundColor: Colors.green,
              );
              Navigator.pop(context);
              _showAddLessonDialog(context, state.course);
            } else if (state is CoursesError) {
              Fluttertoast.showToast(
                msg: state.message,
                backgroundColor: Colors.red,
              );
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
                'Create Course',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail picker
                      GestureDetector(
                        onTap: _pickThumbnail,
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
                              child: _selectedThumbnail != null
                                  ? Stack(
                                      children: [
                                        Image.file(
                                          _selectedThumbnail!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          right: 8.w,
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              _selectedThumbnail = null;
                                            }),
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
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 60.sp,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'Upload Course Thumbnail',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Title field
                      Text(
                        string.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _titleController,
                        hintText: 'Course Title',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Description field
                      Text(
                        string.description,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _descriptionController,
                        hintText: 'Course Description',
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Sport dropdown
                      ValueListenableBuilder<String?>(
                        valueListenable: _sportNotifier,
                        builder: (context, sport, _) {
                          return AppDropdownOverlay(
                            labelText: string.selectSport,
                            value: sport,
                            options: RegisterLists.sportNameOptions(string),
                            onChanged: (val) => _sportNotifier.value = val,
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Price field
                      Text(
                        'Price',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _priceController,
                        hintText: 'Enter price (0 for free)',
                        // keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a price';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price < 0) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40.h),

                      // Create button
                      BlocBuilder<CoursesBloc, CoursesState>(
                        builder: (context, state) {
                          final isLoading = state is CourseActionLoading;
                          return CustomElevatedButton(
                            text: 'Create Course',
                            isLoading: isLoading,
                            enabled: !isLoading,
                            onPressed: isLoading ? ()=>{} : () => _createCourse(builderContext),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
void _showAddLessonDialog(BuildContext context, CourseModel course) {
  // ✅ Save BLoC reference FIRST (while we have access to it)
  final coursesBloc = context.read<CoursesBloc>();
  
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Add Lesson'),
        content: const Text(
          'Would you like to add a lesson to this course now?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Add Later'),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            Navigator.push(
              context, // Use original context
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: coursesBloc, // ✅ Use saved reference
                  child: UploadVideoScreen(
                      courseId: course.id,
                      existingLessonsCount: 0, // First lesson
                    ),
                ),
              ),
            );
          },
          child: const Text('Add Now'),
        ),
      ],
    ),
  );
}
  // void _showAddLessonDialog(BuildContext context, CourseModel course) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       title: const Text('Add Lesson'),
  //       content: const Text(
  //         'Would you like to add a lesson to this course now?',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //           },
  //           child: const Text('Add Later'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (_) => BlocProvider.value(
  //                   value: context.read<CoursesBloc>(),
  //                   child: UploadVideoScreen(
  //                     courseId: course.id,
  //                     existingLessonsCount: 0, // First lesson
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           child: const Text('Add Now'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}