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
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/repo/register_repo.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class UpdateOpportunityScreen extends StatefulWidget {
  final String opportunityId;

  const UpdateOpportunityScreen({super.key, required this.opportunityId});

  @override
  State<UpdateOpportunityScreen> createState() =>
      _UpdateOpportunityScreenState();
}

class _UpdateOpportunityScreenState extends State<UpdateOpportunityScreen> {
  // ── Basic info controllers ────────────────────────────────────────────────
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _additionalNotesController;

  // ── Match criteria controllers ────────────────────────────────────────────
  late final TextEditingController _minAgeController;
  late final TextEditingController _maxAgeController;
  late final TextEditingController _minHeightController;
  late final TextEditingController _maxHeightController;
  late final TextEditingController _minWeightController;
  late final TextEditingController _maxWeightController;
  late final TextEditingController _minExperienceController;
  late final TextEditingController _targetSpecializationController;
  late final TextEditingController _preferredClubExperienceController;

  // ── Notifiers ─────────────────────────────────────────────────────────────
  late final ValueNotifier<String?> _targetUserTypeNotifier;
  late final ValueNotifier<String?> _targetGenderNotifier;
  late final ValueNotifier<String?> _targetLocationNotifier;
  late final ValueNotifier<String?> _targetPositionNotifier;
  late final ValueNotifier<List<int>> _selectedCertificationIdsNotifier;

  // ── Other state ───────────────────────────────────────────────────────────
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedSportKey;
  int? _selectedSportId;
  DateTime? _selectedEndDate;
  bool _showMatchCriteria = false;
  bool _isLoading = true;
  DetailsModel? _opportunityDetails;

  // Locally provided bloc
  late final RegistrationBloc _registrationBloc;
  bool _certificationsLoaded = false;

  final Map<String, int> _sportTypes = {
    'football': 1,
    'basketball': 2,
    'volleyball': 3,
    'handball': 4,
    'taekwondo': 5,
  };

  @override
  void initState() {
    super.initState();
    // Create the bloc locally
    _registrationBloc = RegistrationBloc(getIt<RegisterRepo>());
    _initializeControllers();

    // Fetch opportunity details (uses OpportunityBloc from ancestor)
    context.read<OpportunityBloc>().add(
      FetchOpportunityDetails(opportunityId: widget.opportunityId),
    );
  }

  void _initializeControllers() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _additionalNotesController = TextEditingController();
    _minAgeController = TextEditingController();
    _maxAgeController = TextEditingController();
    _minHeightController = TextEditingController();
    _maxHeightController = TextEditingController();
    _minWeightController = TextEditingController();
    _maxWeightController = TextEditingController();
    _minExperienceController = TextEditingController();
    _targetSpecializationController = TextEditingController();
    _preferredClubExperienceController = TextEditingController();

    _targetUserTypeNotifier = ValueNotifier<String?>(null);
    _targetGenderNotifier = ValueNotifier<String?>(null);
    _targetLocationNotifier = ValueNotifier<String?>(null);
    _targetPositionNotifier = ValueNotifier<String?>(null);
    _selectedCertificationIdsNotifier = ValueNotifier<List<int>>([]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _additionalNotesController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _minHeightController.dispose();
    _maxHeightController.dispose();
    _minWeightController.dispose();
    _maxWeightController.dispose();
    _minExperienceController.dispose();
    _targetUserTypeNotifier.dispose();
    _targetGenderNotifier.dispose();
    _targetLocationNotifier.dispose();
    _targetPositionNotifier.dispose();
    _targetSpecializationController.dispose();
    _selectedCertificationIdsNotifier.dispose();
    _preferredClubExperienceController.dispose();
    _registrationBloc.close(); 
    super.dispose();
  }

  void _prefillForm(DetailsModel details) {
    setState(() {
      _opportunityDetails = details;
      _titleController.text = details.title;
      _descriptionController.text = details.description;
      _additionalNotesController.text = details.additionalNotes ?? '';
      _selectedEndDate = details.endDate;
      _selectedSportId = details.sportTypeId;

      // Find sport name from ID
      _selectedSportKey = _sportTypes.entries
          .firstWhere(
            (entry) => entry.value == details.sportTypeId,
            orElse: () => const MapEntry('', 0),
          )
          .key;

      // Prefill match criteria if available
      if (details.matchCriteria != null) {
        final mc = details.matchCriteria!;
        _targetUserTypeNotifier.value = mc.targetUserType;

        // ✅ FIX: Use genderDisplayValue to convert int to String
        _targetGenderNotifier.value = mc.genderDisplayValue;

        _targetLocationNotifier.value = mc.targetLocation;
        _targetPositionNotifier.value = mc.targetPosition;
        _preferredClubExperienceController.text =
            mc.preferredClubExperience ?? '';
        _targetSpecializationController.text = mc.targetSpecialization ?? '';

        if (mc.minAge != null) _minAgeController.text = mc.minAge.toString();
        if (mc.maxAge != null) _maxAgeController.text = mc.maxAge.toString();
        if (mc.minHeight != null)
          _minHeightController.text = mc.minHeight.toString();
        if (mc.maxHeight != null)
          _maxHeightController.text = mc.maxHeight.toString();
        if (mc.minWeight != null)
          _minWeightController.text = mc.minWeight.toString();
        if (mc.maxWeight != null)
          _maxWeightController.text = mc.maxWeight.toString();
        if (mc.minExperienceYears != null) {
          _minExperienceController.text = mc.minExperienceYears.toString();
        }

        // Set certification IDs
        _selectedCertificationIdsNotifier.value = mc.getCertificationIds();
      }

      _isLoading = false;
    });
  }

  Future<void> _refreshDetails() async {
    setState(() => _isLoading = true);
    context.read<OpportunityBloc>().add(
      FetchOpportunityDetails(opportunityId: widget.opportunityId),
    );
  }

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
      setState(() => _selectedFile = File(image.path));
    }
  }

  Future<void> _selectEndDate(S strings) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedEndDate ?? DateTime.now().add(const Duration(days: 1)),
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
    if (picked != null) setState(() => _selectedEndDate = picked);
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  bool _isPlayerSelected() {
    final userType = _targetUserTypeNotifier.value ?? '';
    return userType.toLowerCase().contains('player') ||
        userType.toLowerCase().contains('لاعب');
  }

  bool _isCoachSelected() {
    final userType = _targetUserTypeNotifier.value ?? '';
    return userType.toLowerCase().contains('coach') ||
        userType.toLowerCase().contains('مدرب');
  }

  bool _sportHasPositions() {
    if (_selectedSportKey == null) return false;
    return _selectedSportKey != 'taekwondo';
  }

  void _handleUpdate(S strings) {
    if (_titleController.text.trim().isEmpty) {
      _toast(strings.pleaseEnterTitle, Colors.orange);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _toast(strings.pleaseEnterDescription, Colors.orange);
      return;
    }

    if (_selectedEndDate == null) {
      _toast(strings.pleaseSelectEndDate, Colors.orange);
      return;
    }

    if (_selectedSportId == null) {
      _toast(strings.pleaseSelectSport, Colors.orange);
      return;
    }

    // Parse numeric match criteria
    final minAge = int.tryParse(_minAgeController.text.trim());
    final maxAge = int.tryParse(_maxAgeController.text.trim());
    final minHeight = double.tryParse(_minHeightController.text.trim());
    final maxHeight = double.tryParse(_maxHeightController.text.trim());
    final minWeight = double.tryParse(_minWeightController.text.trim());
    final maxWeight = double.tryParse(_maxWeightController.text.trim());
    final minExp = int.tryParse(_minExperienceController.text.trim());

    // Map display gender to API value
    final genderDisplay = _targetGenderNotifier.value;
    String? genderApiValue;
    if (genderDisplay != null) {
      if (genderDisplay == strings.male) {
        genderApiValue = 'Male';
      } else if (genderDisplay == strings.female) {
        genderApiValue = 'Female';
      } else {
        genderApiValue = genderDisplay;
      }
    }

    // Map display location to API value
    final locationDisplay = _targetLocationNotifier.value;
    final locationApiValue = locationDisplay != null
        ? RegisterLists.getLocationApiValue(strings, locationDisplay)
        : null;

    // Map display position to abbreviation
    final positionDisplay = _targetPositionNotifier.value;
    final positionApiValue =
        positionDisplay != null && _selectedSportKey != null
        ? RegisterLists.getPositionApiValue(
            strings,
            _getLocalizedSportName(_selectedSportKey!, strings),
            positionDisplay,
          )
        : null;

    // Get certification IDs as comma-separated string
    final certificationIds = _selectedCertificationIdsNotifier.value.isNotEmpty
        ? _selectedCertificationIdsNotifier.value.join(',')
        : null;

    context.read<OpportunityBloc>().add(
      UpdateOpportunity(
        opportunityId: widget.opportunityId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        endDate: _selectedEndDate!,
        sportTypeId: _selectedSportId!,
        mediaFile: _selectedFile?.path,
        additionalNotes: _additionalNotesController.text.trim().isEmpty
            ? null
            : _additionalNotesController.text.trim(),
        targetUserType: _targetUserTypeNotifier.value,
        targetGender: genderApiValue,
        minAge: minAge,
        maxAge: maxAge,
        targetLocation: locationApiValue,
        targetPosition: positionApiValue,
        minHeight: minHeight,
        maxHeight: maxHeight,
        minWeight: minWeight,
        maxWeight: maxWeight,
        targetSpecialization:
            _targetSpecializationController.text.trim().isEmpty
            ? null
            : _targetSpecializationController.text.trim(),
        minExperienceYears: minExp,
        preferredClubExperience:
            _preferredClubExperienceController.text.trim().isEmpty
            ? null
            : _preferredClubExperienceController.text.trim(),
        requiredCertifications: certificationIds,
      ),
    );
  }

  void _toast(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    // Provide the local RegisterBloc to the entire screen subtree
    return BlocProvider<RegistrationBloc>.value(
      value: _registrationBloc,
      child: Builder(
        builder: (contextWithBloc) {
          // Dispatch the load event once using the context that has the bloc
          if (!_certificationsLoaded) {
            _certificationsLoaded = true;
            contextWithBloc.read<RegistrationBloc>().add(
              const LoadCertificationsEvent(),
            );
          }

          return BlocListener<OpportunityBloc, OpportunityState>(
            listener: (context, state) {
              if (state is OpportunityDetailsLoaded) {
                _prefillForm(state.opportunity);
              } else if (state is OpportunityUpdated) {
                Fluttertoast.showToast(
                  msg: strings.opportunityUpdatedSuccessfully,
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP,
                );
                Navigator.pop(context, true);
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
                  icon: Icon(Icons.arrow_back, color: theme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  strings.editOpportunity,
                  style: GoogleFonts.poppins(
                    color: theme.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
              ),
              // ✅ FIX: Wrap body with RefreshIndicator for pull-to-refresh
              body: RefreshIndicator(
                onRefresh: _refreshDetails,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Image picker ────────────────────────────────────────────
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
                                      child: _buildMediaPreview(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // ── Title ───────────────────────────────────────────────────
                              _sectionLabel(strings.title, theme),
                              SizedBox(height: 8.h),
                              AuthTextField(
                                controller: _titleController,
                                label: strings.enterYourTitle,
                              ),
                              SizedBox(height: 16.h),

                              // ── Description ─────────────────────────────────────────────
                              _sectionLabel(strings.description, theme),
                              SizedBox(height: 8.h),
                              AuthTextField(
                                controller: _descriptionController,
                                label: strings.enterYourDescription,
                                maxLines: 5,
                              ),
                              SizedBox(height: 16.h),

                              // ── Additional Notes ────────────────────────────────────────
                              _sectionLabel(strings.additionalNotes, theme),
                              SizedBox(height: 8.h),
                              AuthTextField(
                                controller: _additionalNotesController,
                                label: strings.enterAdditionalNotes,
                                maxLines: 3,
                              ),
                              SizedBox(height: 16.h),

                              // ── Sport Selector ──────────────────────────────────────────
                              _sectionLabel(strings.sport, theme),
                              SizedBox(height: 8.h),
                              _buildSportPicker(strings, theme),
                              SizedBox(height: 16.h),

                              // ── End Date Picker ────────────────────────────────────────
                              _sectionLabel(strings.endDate, theme),
                              SizedBox(height: 8.h),
                              _buildDatePicker(strings, theme),
                              SizedBox(height: 28.h),

                              // ── Match Criteria toggle ───────────────────────────────────
                              _buildMatchCriteriaToggle(strings, theme),
                              SizedBox(height: 8.h),

                              // ── Match Criteria fields (collapsible) ─────────────────────
                              if (_showMatchCriteria) ...[
                                _buildMatchCriteriaSection(strings, theme),
                              ],

                              SizedBox(height: 40.h),

                              // ── Update button ───────────────────────────────────────────
                              BlocBuilder<OpportunityBloc, OpportunityState>(
                                builder: (context, state) {
                                  final isUpdating =
                                      state is OpportunityLoading;
                                  return CustomElevatedButton(
                                    text: strings.update,
                                    isLoading: isUpdating,
                                    enabled: !isUpdating,
                                    onPressed: () => _handleUpdate(strings),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedFile != null) {
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
          'Upload an Image',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text, ColorScheme theme) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: theme.onSurface,
      ),
    );
  }

  Widget _buildSportPicker(S strings, ColorScheme theme) {
    final Map<String, String> sportNames = {
      'football': strings.football,
      'basketball': strings.basketball,
      'volleyball': strings.volleyball,
      'handball': strings.handball,
      'taekwondo': strings.taekwondo,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSportKey,
          hint: Text(
            strings.selectSport,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
          ),
          isExpanded: true,
          items: _sportTypes.keys.map((String sport) {
            return DropdownMenuItem<String>(
              value: sport,
              child: Text(
                sportNames[sport] ?? sport,
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSportKey = newValue;
              _selectedSportId = _sportTypes[newValue];
              _targetPositionNotifier.value = null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker(S strings, ColorScheme theme) {
    return InkWell(
      onTap: () => _selectEndDate(strings),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
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
                    ? theme.onSurface
                    : Colors.grey[500],
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCriteriaToggle(S strings, ColorScheme theme) {
    return InkWell(
      onTap: () => setState(() => _showMatchCriteria = !_showMatchCriteria),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: _showMatchCriteria
              ? theme.primary.withOpacity(0.08)
              : theme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _showMatchCriteria ? theme.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.tune_rounded,
              color: _showMatchCriteria ? theme.primary : Colors.grey[600],
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.matchCriteria,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: _showMatchCriteria
                          ? theme.primary
                          : theme.onSurface,
                    ),
                  ),
                  Text(
                    strings.matchCriteriaSubtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _showMatchCriteria
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: _showMatchCriteria ? theme.primary : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCriteriaSection(S strings, ColorScheme theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Target User Type ─────────────────────────────────────────────────
          _sectionLabel(strings.targetUserType, theme),
          SizedBox(height: 8.h),
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, value, _) {
              return AppDropdownOverlay(
                labelText: strings.selectTargetUserType,
                value: value,
                options: [strings.player, strings.coach],
                onChanged: (val) {
                  _targetUserTypeNotifier.value = val;
                  _targetPositionNotifier.value = null;
                  _targetSpecializationController.clear();
                  _selectedCertificationIdsNotifier.value = [];
                },
              );
            },
          ),
          SizedBox(height: 16.h),

          // ── Target Gender ─────────────────────────────────────────────────
          _sectionLabel(strings.targetGender, theme),
          SizedBox(height: 8.h),
          ValueListenableBuilder<String?>(
            valueListenable: _targetGenderNotifier,
            builder: (context, value, _) {
              return AppDropdownOverlay(
                labelText: strings.selectGender,
                value: value,
                options: RegisterLists.genderOptions(strings),
                onChanged: (val) => _targetGenderNotifier.value = val,
              );
            },
          ),
          SizedBox(height: 16.h),

          // ── Target Location ───────────────────────────────────────────────
          _sectionLabel(strings.targetLocation, theme),
          SizedBox(height: 8.h),
          ValueListenableBuilder<String?>(
            valueListenable: _targetLocationNotifier,
            builder: (context, value, _) {
              return AppDropdownOverlay(
                labelText: strings.selectLocation,
                value: value,
                options: RegisterLists.locationOptions(strings),
                onChanged: (val) => _targetLocationNotifier.value = val,
              );
            },
          ),
          SizedBox(height: 16.h),

          // ── Preferred Club Experience ─────────────────────────────────────
          _sectionLabel(strings.PreferredClubExperience, theme),
          SizedBox(height: 8.h),
          RegisterTextField(
            controller: _preferredClubExperienceController,
            labelText: strings.PreferredClubExperience,
          ),
          SizedBox(height: 16.h),

          // ── Age range ─────────────────────────────────────────────────────
          _sectionLabel(strings.ageRange, theme),
          SizedBox(height: 8.h),
          RegisterTwoFieldsRow(
            leftField: RegisterTextField(
              controller: _minAgeController,
              labelText: strings.minAge,
              keyboardType: TextInputType.number,
            ),
            rightField: RegisterTextField(
              controller: _maxAgeController,
              labelText: strings.maxAge,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(height: 16.h),

          // ── Height range (Players) ───────────────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isPlayerSelected()) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(strings.heightRange, theme),
                  SizedBox(height: 8.h),
                  RegisterTwoFieldsRow(
                    leftField: RegisterTextField(
                      controller: _minHeightController,
                      labelText: strings.minHeight,
                      keyboardType: TextInputType.number,
                    ),
                    rightField: RegisterTextField(
                      controller: _maxHeightController,
                      labelText: strings.maxHeight,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            },
          ),

          // ── Weight range (Players) ───────────────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isPlayerSelected()) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(strings.weightRange, theme),
                  SizedBox(height: 8.h),
                  RegisterTwoFieldsRow(
                    leftField: RegisterTextField(
                      controller: _minWeightController,
                      labelText: strings.minWeight,
                      keyboardType: TextInputType.number,
                    ),
                    rightField: RegisterTextField(
                      controller: _maxWeightController,
                      labelText: strings.maxWeight,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            },
          ),

          // ── Position (Players with team sports) ──────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isPlayerSelected() || !_sportHasPositions()) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(strings.position, theme),
                  SizedBox(height: 8.h),
                  ValueListenableBuilder<String?>(
                    valueListenable: _targetPositionNotifier,
                    builder: (context, position, _) {
                      return AppDropdownOverlay(
                        labelText: strings.selectPosition,
                        value: position,
                        options: RegisterLists.positionOptions(
                          strings,
                          _selectedSportKey != null
                              ? _getLocalizedSportName(
                                  _selectedSportKey!,
                                  strings,
                                )
                              : null,
                        ),
                        onChanged: (val) => _targetPositionNotifier.value = val,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            },
          ),

          // ── Specialization (Coaches) ──────────────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isCoachSelected()) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(strings.specialist, theme),
                  SizedBox(height: 8.h),
                  RegisterTextField(
                    controller: _targetSpecializationController,
                    labelText: strings.selectSpecialization,
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            },
          ),

          // ── Required Certifications (Coaches) ──────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isCoachSelected()) return const SizedBox.shrink();

              return BlocBuilder<RegistrationBloc, RegistrationState>(
                builder: (context, state) {
                  List<CertificationModel> certifications = [];
                  if (state is RegistrationCertificationsLoaded) {
                    certifications = state.certifications;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(strings.certifications, theme),
                      SizedBox(height: 8.h),
                      ValueListenableBuilder<List<int>>(
                        valueListenable: _selectedCertificationIdsNotifier,
                        builder: (context, selectedIds, _) {
                          return CheckboxDropdownOverlay(
                            labelText: strings.certifications,
                            value: certifications
                                .where((c) => selectedIds.contains(c.id))
                                .map((c) => c.name)
                                .toList(),
                            options: certifications.map((c) => c.name).toList(),
                            onChanged: (updatedNames) {
                              final updatedIds = updatedNames
                                  .map((name) {
                                    final cert = certifications.firstWhere(
                                      (c) => c.name == name,
                                      orElse: () =>
                                          CertificationModel(id: 0, name: ''),
                                    );
                                    return cert.id;
                                  })
                                  .where((id) => id != 0)
                                  .toList();

                              _selectedCertificationIdsNotifier.value =
                                  updatedIds;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                },
              );
            },
          ),

          // ── Min Experience (Coaches) ──────────────────────────────────────
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, userType, _) {
              if (!_isCoachSelected()) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(strings.minExperienceYears, theme),
                  SizedBox(height: 8.h),
                  RegisterTextField(
                    controller: _minExperienceController,
                    labelText: strings.enterMinExperience,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.h),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
