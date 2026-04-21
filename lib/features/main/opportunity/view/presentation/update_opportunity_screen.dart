import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';

class UpdateOpportunityScreen extends StatefulWidget {
  final String opportunityId;

  const UpdateOpportunityScreen({
    super.key,
    required this.opportunityId,
  });

  @override
  State<UpdateOpportunityScreen> createState() => _UpdateOpportunityScreenState();
}

class _UpdateOpportunityScreenState extends State<UpdateOpportunityScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requirementsController;

  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  String? _selectedSportName;
  int? _selectedSportId;
  DateTime? _selectedEndDate;
  bool _isLoading = true;
  DetailsModel? _opportunityDetails;

  // Sport types mapping
  final Map<String, int> _sportTypes = {
    'Football': 1,
    'Basketball': 2,
    'Volleyball': 3,
    'Handball': 4,
    'Taekwondo': 5,
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _requirementsController = TextEditingController();

    // Fetch opportunity details
    context.read<OpportunityBloc>().add(
          FetchOpportunityDetails(opportunityId: widget.opportunityId),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _prefillForm(DetailsModel details) {
    setState(() {
      _opportunityDetails = details;
      _titleController.text = details.title;
      _descriptionController.text = details.description;
      // _requirementsController.text = details.requirements;
      _selectedEndDate = details.endDate;
      _selectedSportId = details.sportTypeId;
      
      // Find sport name from ID
      _selectedSportName = _sportTypes.entries
          .firstWhere(
            (entry) => entry.value == details.sportTypeId,
            orElse: () => const MapEntry('', 0),
          )
          .key;
      
      _isLoading = false;
    });
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

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedEndDate = picked);
    }
  }

  void _handleUpdate() {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a title',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a description',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_requirementsController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter requirements',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedEndDate == null) {
      Fluttertoast.showToast(
        msg: 'Please select an end date',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedSportId == null) {
      Fluttertoast.showToast(
        msg: 'Please select a sport',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Trigger update
    context.read<OpportunityBloc>().add(
          UpdateOpportunity(
            opportunityId: widget.opportunityId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            requirements: _requirementsController.text.trim(),
            endDate: _selectedEndDate!,
            sportTypeId: _selectedSportId!,
            mediaFile: _selectedFile?.path,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocListener<OpportunityBloc, OpportunityState>(
      listener: (context, state) {
        if (state is OpportunityDetailsLoaded) {
          _prefillForm(state.opportunity);
        } else if (state is OpportunityUpdateSuccess) {
          Fluttertoast.showToast(
            msg: 'Opportunity updated successfully!',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pop(context, true);
            }
          });
        } else if (state is OpportunityError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
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
            'Edit Opportunity',
            style: GoogleFonts.poppins(
              color: theme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Media Upload Area
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
                              child: _buildMediaPreview(),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Title Field
                      AuthTextField(
                        controller: _titleController,
                        hintText: 'Opportunity Title',
                      ),

                      SizedBox(height: 16.h),

                      // Description Field
                      AuthTextField(
                        controller: _descriptionController,
                        hintText: 'Description',
                        maxLines: 4,
                      ),

                      SizedBox(height: 16.h),

                      // Requirements Field
                      AuthTextField(
                        controller: _requirementsController,
                        hintText: 'Requirements',
                        maxLines: 3,
                      ),

                      SizedBox(height: 16.h),

                      // End Date Picker
                      InkWell(
                        onTap: _selectEndDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey[600]),
                              SizedBox(width: 12.w),
                              Text(
                                _selectedEndDate != null
                                    ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                                    : 'Select End Date',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: _selectedEndDate != null
                                      ? Colors.black87
                                      : Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Sport Selector
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSportName,
                            hint: Text(
                              'Select Sport',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                            isExpanded: true,
                            items: _sportTypes.keys.map((String sport) {
                              return DropdownMenuItem<String>(
                                value: sport,
                                child: Text(
                                  sport,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSportName = newValue;
                                _selectedSportId = _sportTypes[newValue];
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Update Button
                      BlocBuilder<OpportunityBloc, OpportunityState>(
                        builder: (context, state) {
                          final isUpdating = state is OpportunityCreating;
                          return CustomElevatedButton(
                            text: isUpdating ? 'Updating...' : 'Update Opportunity',
                            isLoading: isUpdating,
                            enabled: !isUpdating,
                            onPressed: _handleUpdate,
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

  Widget _buildMediaPreview() {
    if (_selectedFile != null) {
      // Show newly selected file
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

    // Show existing media URL
    if (_opportunityDetails?.uploadedMediaUrl != null &&
        _opportunityDetails!.uploadedMediaUrl!.isNotEmpty) {
      return Stack(
        children: [
          Image.network(
            _opportunityDetails!.uploadedMediaUrl!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildUploadPlaceholder();
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

    return _buildUploadPlaceholder();
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 60.sp, color: Colors.grey[600]),
        SizedBox(height: 12.h),
        Text(
          'Upload an Image or Video',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Maximum file size is 200 MB',
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}