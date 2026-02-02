import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
                leading: const Icon(Icons.image, color: Color(0xFF1D2D3D)),
                title: const Text('Pick Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: Color(0xFF1D2D3D)),
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

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color:theme.surface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Content',
          style: TextStyle(
            color: Colors.black,
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
        color: Colors.white,
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
                    'Upload an Image or video',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Maximum file size is 200 MB',
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

              // Title Field
              Text(
                'Title',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _titleController,
                hintText: "Enter Your Title.",       ),

              SizedBox(height: 20.h),

              // Description Field
               Text(
                'Description',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextField(controller:
               _descriptionController,
               hintText:   'Enter Your Description...',
               maxLines: 5,
               ),
               SizedBox(height: 16.h,),
      ValueListenableBuilder<String?>(
                            valueListenable: sportNotifier,
                            builder: (context, sport, _) {
                              return AppDropdownOverlay(
                                labelText: string.sportProfession,
                                value: sport,
                                options:
                                    RegisterLists.sportProfessionOptions(
                                      string,
                                    ),
                                onChanged: (val) =>
                                     sportNotifier.value = val,
                                validator: (v) =>
                                    Validators.validateDropdown(
                                      context: context,
                                      value: v,
                                      fieldName: string.sportProfession
                                          .toLowerCase(),
                                    ),
                              );
                            },
                          ),
              SizedBox(height: 40.h),

           // احنا بنلف الزرار كله داخل Builder
Builder(
  builder: (context) {
    return CustomElevatedButton(
      onPressed: () {
        // Handle post action
        if (_titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty) {

          // Use the PostsBloc
          context.read<PostsBloc>().add(
            UploadPost(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              sport: sportNotifier.value!,
              mediaUrl: _selectedFile?.path,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields'),
            ),
          );
        }
      },
      text: 'Post',
    );
  },
)
   ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
 
}