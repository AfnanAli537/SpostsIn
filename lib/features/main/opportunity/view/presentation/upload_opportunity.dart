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

  String? _selectedSportKey;
  int? _selectedSportId;
  DateTime? _selectedEndDate;

  final Map<String, int> _sportTypes = {
    'football': 1,
    'basketball': 2,
    'volleyball': 3,
    'handball': 4,
    'taekwondo': 5,
  };

  String _getLocalizedSportName(String key, S strings) {
    final Map<String, String> names = {
      'football': strings.football,
      'basketball': strings.basketball,
      'volleyball': strings.volleyball,
      'handball': strings.handball,
      'taekwondo': strings.taekwondo,
    };
    return names[key] ?? key;
  }

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
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now().add(const Duration(days: 1)),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    builder: (context, child) {
      final theme = Theme.of(context);

      return Theme(
        data: theme.copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: theme.colorScheme.primary,
                  onPrimary: theme.colorScheme.onPrimary,
                  surface: theme.colorScheme.surface,
                  onSurface: theme.colorScheme.onSurface,
                )
              : ColorScheme.light(
                  primary: theme.colorScheme.primary,
                  onPrimary: theme.colorScheme.onPrimary,
                  surface: theme.colorScheme.surface,
                  onSurface: theme.colorScheme.onSurface,
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
                // final icon = _getSportIcon(entry.key);
                final localizedName = _getLocalizedSportName(entry.key, strings);
                return ListTile(
                  // leading: Text(icon, style: TextStyle(fontSize: 24.sp)),
                  title: Text(
                    localizedName,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                  selected: _selectedSportKey == entry.key,
                  selectedTileColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    setState(() {
                      _selectedSportKey = entry.key;
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

  // String _getSportIcon(String key) {
  //   final icons = {
  //     'football': '⚽',
  //     'basketball': '🏀',
  //     'volleyball': '🏐',
  //     'handball': '🤾',
  //     'taekwondo': '🥋',
  //   };
  //   return icons[key] ?? '🏆';
  // }

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
            _selectedSportKey = null;
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
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon:  Icon(Icons.arrow_back, color: theme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            strings.uploadContent,
            style: GoogleFonts.poppins(
              color:  theme.onSurface,
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
                  label: strings.enterYourRequirements,
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
                      color: theme.surface,
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
                          _selectedSportKey != null
                              ? _getLocalizedSportName(_selectedSportKey!, strings)
                              : strings.selectSport,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: _selectedSportKey != null
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
                      color: theme.surface,
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