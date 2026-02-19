// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
// import 'package:sports_in/core/widgets/custom_elevated_button.dart';
// import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';

// class AddOpportunityScreen extends StatefulWidget {
//   const AddOpportunityScreen({super.key});

//   @override
//   State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
// }

// class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _requirementsController = TextEditingController();
  
//   File? _selectedFile;
//   final ImagePicker _picker = ImagePicker();
  
//   String? _selectedSportName;
//   int? _selectedSportId;
//   DateTime? _selectedEndDate;

//   // Sport types mapping
//   final Map<String, int> _sportTypes = {
//     'Football': 1,
//     'Basketball': 2,
//     'Volleyball': 3,
//     'Handball': 4,
//     'Taekwondo': 5,
//   };

//   // 👇 Only pick image now
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85, // Optional: compress image
//     );
//     if (image != null) {
//       setState(() {
//         _selectedFile = File(image.path);
//       });
//     }
//   }

//   Future<void> _selectEndDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF1A5F4E),
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedEndDate = picked;
//       });
//     }
//   }

//   void _showSportDropdown() {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           title: Text(
//             'Select Sport',
//             style: GoogleFonts.poppins(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: _sportTypes.entries.map((entry) {
//                 final icon = _getSportIcon(entry.key);
//                 return ListTile(
//                   leading: Text(icon, style: TextStyle(fontSize: 24.sp)),
//                   title: Text(
//                     entry.key,
//                     style: GoogleFonts.poppins(fontSize: 14.sp),
//                   ),
//                   selected: _selectedSportName == entry.key,
//                   selectedTileColor: const Color(0xFF1A5F4E).withOpacity(0.1),
//                   onTap: () {
//                     setState(() {
//                       _selectedSportName = entry.key;
//                       _selectedSportId = entry.value;
//                     });
//                     Navigator.pop(dialogContext);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: Text(
//                 'Cancel',
//                 style: GoogleFonts.poppins(
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _getSportIcon(String sport) {
//     final icons = {
//       'Football': '⚽',
//       'Basketball': '🏀',
//       'Volleyball': '🏐',
//       'Handball': '🤾',
//       'Taekwondo': '🥋',
//     };
//     return icons[sport] ?? '🏆';
//   }

//   String _formatDate(DateTime date) {
//     final months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;
//     return BlocListener<OpportunityBloc, OpportunityState>(
//       listener: (context, state) {
//         if (state is OpportunityCreated) {
//           Fluttertoast.showToast(
//             msg: 'Opportunity created successfully!',
//             backgroundColor: Colors.green,
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.TOP,
//           );

//           // 👇 Fetch opportunities again after success
//           context.read<OpportunityBloc>().add(
//             const FetchOpportunities(isRefresh: true),
//           );

//           // Clear fields
//           _titleController.clear();
//           _descriptionController.clear();
//           _requirementsController.clear();
//           setState(() {
//             _selectedFile = null;
//             _selectedSportName = null;
//             _selectedSportId = null;
//             _selectedEndDate = null;
//           });

//           // Navigate back
//           Navigator.pop(context);
//         } else if (state is OpportunityError) {
//           Fluttertoast.showToast(
//             msg: state.message,
//             backgroundColor: Colors.red,
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.TOP,
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.grey[50],
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             'Upload Content',
//             style: GoogleFonts.poppins(
//               color: Colors.black,
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(24.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 👇 Upload Area - Now shows image when selected
//                 GestureDetector(
//                   onTap: _pickImage, // 👈 Direct image picker
//                   child: DottedBorder(
//                    options: RoundedRectDottedBorderOptions(
//                       color: Colors.grey[400]!,
//                       strokeWidth: 2.w,
//                       dashPattern: const [20, 6],
//                       radius: Radius.circular(12.r),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12.r),
//                       child: Container(
//                         height: 200.h,
//                         width: double.infinity,
//                         color: Colors.white,
//                         child: _selectedFile == null
//                             ? Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.cloud_upload_outlined,
//                                     size: 60.sp,
//                                     color: Colors.grey[600],
//                                   ),
//                                   SizedBox(height: 12.h),
//                                   Text(
//                                     'Upload an Image',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14.sp,
//                                       color: Colors.grey[800],
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   SizedBox(height: 4.h),
//                                   Text(
//                                     'Tap to select from gallery',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 12.sp,
//                                       color: Colors.grey[500],
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Stack(
//                                 children: [
//                                   // 👇 Show selected image
//                                   Image.file(
//                                     _selectedFile!,
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   // Remove button
//                                   Positioned(
//                                     top: 8.h,
//                                     right: 8.w,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _selectedFile = null;
//                                         });
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(6.w),
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 20.sp,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 28.h),

//                 // Title Field
//                 Text(
//                   'Title',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 AuthTextField(
//                   controller: _titleController,
//                   hintText: "Enter Your Title.",
//                 ),
//                 SizedBox(height: 20.h),

//                 // Description Field
//                 Text(
//                   'Description',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 AuthTextField(
//                   controller: _descriptionController,
//                   hintText: 'Enter Your Description...',
//                   maxLines: 5,
//                 ),
//                 SizedBox(height: 20.h),

//                 // Requirements Field
//                 Text(
//                   'Requirements',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 AuthTextField(
//                   controller: _requirementsController,
//                   hintText: 'Enter Requirements (one per line)...',
//                   maxLines: 4,
//                 ),
//                 SizedBox(height: 20.h),

//                 // Sport Dropdown
//                 Text(
//                   'Sport',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 InkWell(
//                   onTap: _showSportDropdown,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(
//                         color: Colors.grey.shade300,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _selectedSportName ?? 'Select Sport',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14.sp,
//                             color: _selectedSportName != null
//                                 ? Colors.black87
//                                 : Colors.grey[500],
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: Colors.grey[600],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // End Date Picker
//                 Text(
//                   'End Date',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: theme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 InkWell(
//                   onTap: _selectEndDate,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 16.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(
//                         color: Colors.grey.shade300,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _selectedEndDate != null
//                               ? _formatDate(_selectedEndDate!)
//                               : 'Select End Date',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14.sp,
//                             color: _selectedEndDate != null
//                                 ? Colors.black87
//                                 : Colors.grey[500],
//                           ),
//                         ),
//                         Icon(
//                           Icons.calendar_today,
//                           color: Colors.grey[600],
//                           size: 20.sp,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 40.h),

//                 // Upload Button with Loading State
//                 BlocBuilder<OpportunityBloc, OpportunityState>(
//                   builder: (context, state) {
//                     final isCreating = state is OpportunityCreating;

//                     return CustomElevatedButton(
//                       text: 'Upload',
//                       isLoading: isCreating,
//                       enabled: !isCreating,
//                       onPressed: () {
//                         // Validation
//                         if (_titleController.text.trim().isEmpty) {
//                           Fluttertoast.showToast(
//                             msg: 'Please enter a title',
//                             backgroundColor: Colors.orange,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );
//                           return;
//                         }

//                         if (_descriptionController.text.trim().isEmpty) {
//                           Fluttertoast.showToast(
//                             msg: 'Please enter a description',
//                             backgroundColor: Colors.orange,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );
//                           return;
//                         }

//                         if (_requirementsController.text.trim().isEmpty) {
//                           Fluttertoast.showToast(
//                             msg: 'Please enter requirements',
//                             backgroundColor: Colors.orange,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );
//                           return;
//                         }

//                         if (_selectedSportId == null) {
//                           Fluttertoast.showToast(
//                             msg: 'Please select a sport',
//                             backgroundColor: Colors.orange,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );
//                           return;
//                         }

//                         if (_selectedEndDate == null) {
//                           Fluttertoast.showToast(
//                             msg: 'Please select an end date',
//                             backgroundColor: Colors.orange,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );
//                           return;
//                         }

//                         // Create Opportunity
//                         context.read<OpportunityBloc>().add(
//                               CreateOpportunity(
//                                 title: _titleController.text.trim(),
//                                 description: _descriptionController.text.trim(),
//                                 requirements: _requirementsController.text.trim(),
//                                 endDate: _selectedEndDate!.toIso8601String(),
//                                 sportTypeId: _selectedSportId!,
//                                 mediaFile: _selectedFile?.path,
//                               ),
//                             );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _requirementsController.dispose();
//     super.dispose();
//   }
// }



import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class AddOpportunityScreen extends StatefulWidget {
  const AddOpportunityScreen({super.key});

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  
  String? _selectedSportName;
  int? _selectedSportId;
  DateTime? _selectedEndDate;

  final Map<String, int> _sportTypes = {
    'Football': 1,
    'Basketball': 2,
    'Volleyball': 3,
    'Handball': 4,
    'Taekwondo': 5,
  };

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
    }
  }

  Future<void> _selectEndDate(S strings) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A5F4E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  void _showSportDropdown(S strings) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            strings.selectSport,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _sportTypes.entries.map((entry) {
                final icon = _getSportIcon(entry.key);
                return ListTile(
                  leading: Text(icon, style: TextStyle(fontSize: 24.sp)),
                  title: Text(
                    entry.key,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                  selected: _selectedSportName == entry.key,
                  selectedTileColor: const Color(0xFF1A5F4E).withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _selectedSportName = entry.key;
                      _selectedSportId = entry.value;
                    });
                    Navigator.pop(dialogContext);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                strings.cancel,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getSportIcon(String sport) {
    final icons = {
      'Football': '⚽',
      'Basketball': '🏀',
      'Volleyball': '🏐',
      'Handball': '🤾',
      'Taekwondo': '🥋',
    };
    return icons[sport] ?? '🏆';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocListener<OpportunityBloc, OpportunityState>(
      listener: (context, state) {
        if (state is OpportunityCreated) {
          Fluttertoast.showToast(
            msg: strings.opportunityCreatedSuccessfully,
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );

          context.read<OpportunityBloc>().add(
            const FetchOpportunities(isRefresh: true),
          );

          _titleController.clear();
          _descriptionController.clear();
          _requirementsController.clear();
          setState(() {
            _selectedFile = null;
            _selectedSportName = null;
            _selectedSportId = null;
            _selectedEndDate = null;
          });

          Navigator.pop(context);
        } else if (state is OpportunityError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            strings.uploadContent,
            style: GoogleFonts.poppins(
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
                GestureDetector(
                  onTap: _pickImage,
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
                                    strings.uploadAnImage,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    strings.tapToSelectFromGallery,
                                    style: GoogleFonts.poppins(
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
                                        padding: EdgeInsets.all(6.w),
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
                  hintText: strings.enterYourTitle,
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
                  hintText: strings.enterYourDescription,
                  maxLines: 5,
                ),
                SizedBox(height: 20.h),
                Text(
                  strings.requirements,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                AuthTextField(
                  controller: _requirementsController,
                  hintText: strings.enterYourRequirements,
                  maxLines: 4,
                ),
                SizedBox(height: 20.h),
                Text(
                  strings.sport,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () => _showSportDropdown(strings),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedSportName ?? strings.selectSport,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: _selectedSportName != null
                                ? Colors.black87
                                : Colors.grey[500],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  strings.endDate,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () => _selectEndDate(strings),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedEndDate != null
                              ? _formatDate(_selectedEndDate!)
                              : strings.selectEndDate,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: _selectedEndDate != null
                                ? Colors.black87
                                : Colors.grey[500],
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[600],
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                BlocBuilder<OpportunityBloc, OpportunityState>(
                  builder: (context, state) {
                    final isCreating = state is OpportunityCreating;

                    return CustomElevatedButton(
                      text: strings.upload,
                      isLoading: isCreating,
                      enabled: !isCreating,
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseEnterTitle,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        if (_descriptionController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseEnterDescription,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        if (_requirementsController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseEnterRequirements,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        if (_selectedSportId == null) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseSelectSport,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        if (_selectedEndDate == null) {
                          Fluttertoast.showToast(
                            msg: strings.pleaseSelectEndDate,
                            backgroundColor: Colors.orange,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        context.read<OpportunityBloc>().add(
                              CreateOpportunity(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                requirements: _requirementsController.text.trim(),
                                endDate: _selectedEndDate!.toIso8601String(),
                                sportTypeId: _selectedSportId!,
                                mediaFile: _selectedFile?.path,
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
    _requirementsController.dispose();
    super.dispose();
  }
}