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

class AddOpportunityScreen extends StatefulWidget {
  const AddOpportunityScreen({super.key});

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  // ── Basic info controllers ────────────────────────────────────────────────
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  // ── Match criteria controllers ────────────────────────────────────────────
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _maxAgeController = TextEditingController();
  final TextEditingController _minHeightController = TextEditingController();
  final TextEditingController _maxHeightController = TextEditingController();
  final TextEditingController _minWeightController = TextEditingController();
  final TextEditingController _maxWeightController = TextEditingController();
  final TextEditingController _minExperienceController =
      TextEditingController();
  final TextEditingController _targetSpecializationController =
      TextEditingController();
  final TextEditingController _preferredClubExperienceController =
      TextEditingController();

  // ── Notifiers ─────────────────────────────────────────────────────────────
  final ValueNotifier<String?> _targetUserTypeNotifier = ValueNotifier<String?>(
    null,
  );
  final ValueNotifier<String?> _targetGenderNotifier = ValueNotifier<String?>(
    null,
  );
  final ValueNotifier<String?> _targetLocationNotifier = ValueNotifier<String?>(
    null,
  );
  final ValueNotifier<String?> _targetPositionNotifier = ValueNotifier<String?>(
    null,
  );
  final _selectedCertificationIdsNotifier = ValueNotifier<List<int>>([]);

  // ── Other state ───────────────────────────────────────────────────────────
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedSportKey;
  int? _selectedSportId;
  DateTime? _selectedEndDate;
  bool _showMatchCriteria = false;
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
    // Load certifications when screen initializes
    _registrationBloc = RegistrationBloc(getIt<RegisterRepo>());
  }

  // ── Target user type options (Player / Coach only) ────────────────────────
  List<String> _targetUserTypeOptions(S strings) => [
    strings.player,
    strings.coach,
  ];

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

  // ── Image picker ──────────────────────────────────────────────────────────
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _selectedFile = File(image.path));
    }
  }

  // ── Date picker ───────────────────────────────────────────────────────────
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
    if (picked != null) setState(() => _selectedEndDate = picked);
  }

  // ── Sport picker dialog ───────────────────────────────────────────────────
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
                final localizedName = _getLocalizedSportName(
                  entry.key,
                  strings,
                );
                return ListTile(
                  title: Text(
                    localizedName,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                  selected: _selectedSportKey == entry.key,
                  selectedTileColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _selectedSportKey = entry.key;
                      _selectedSportId = entry.value;
                      // Reset position when sport changes
                      _targetPositionNotifier.value = null;
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
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
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

  // ── Submit ────────────────────────────────────────────────────────────────
  void _submit(S strings) {
    if (_titleController.text.trim().isEmpty) {
      _toast(strings.pleaseEnterTitle, Colors.orange);
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _toast(strings.pleaseEnterDescription, Colors.orange);
      return;
    }
    if (_selectedSportId == null) {
      _toast(strings.pleaseSelectSport, Colors.orange);
      return;
    }
    if (_selectedEndDate == null) {
      _toast(strings.pleaseSelectEndDate, Colors.orange);
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
    final S s = strings;
    String? genderApiValue;
    if (genderDisplay != null) {
      if (genderDisplay == s.male) {
        genderApiValue = 'Male';
      } else if (genderDisplay == s.female) {
        genderApiValue = 'Female';
      } else {
        genderApiValue = genderDisplay;
      }
    }

    // Map display location to API value
    final locationDisplay = _targetLocationNotifier.value;
    final locationApiValue = locationDisplay != null
        ? RegisterLists.getLocationApiValue(s, locationDisplay)
        : null;

    // Map display position to abbreviation
    final positionDisplay = _targetPositionNotifier.value;
    final positionApiValue =
        positionDisplay != null && _selectedSportKey != null
        ? RegisterLists.getPositionApiValue(
            s,
            _getLocalizedSportName(_selectedSportKey!, s),
            positionDisplay,
          )
        : null;

    // Get certification IDs as comma-separated string
    final certificationIds = _selectedCertificationIdsNotifier.value.isNotEmpty
        ? _selectedCertificationIdsNotifier.value.join(',')
        : null;

    context.read<OpportunityBloc>().add(
      CreateOpportunity(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        endDate: _selectedEndDate!.toIso8601String(),
        sportTypeId: _selectedSportId!,
        additionalNotes: _additionalNotesController.text.trim().isEmpty
            ? null
            : _additionalNotesController.text.trim(),
        mediaFile: _selectedFile?.path,
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

  // ── Dispose ───────────────────────────────────────────────────────────────
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

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return BlocProvider<RegistrationBloc>.value(
      value: _registrationBloc,
      child: Builder(
        builder: (context) {
          if (!_certificationsLoaded) {
            _certificationsLoaded = true;
            context.read<RegistrationBloc>().add(
              const LoadCertificationsEvent(),
            );
          }

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
                // Reset form
                _titleController.clear();
                _descriptionController.clear();
                _additionalNotesController.clear();
                setState(() {
                  _selectedFile = null;
                  _selectedSportKey = null;
                  _selectedSportId = null;
                  _selectedEndDate = null;
                  _showMatchCriteria = false;
                });
                _minAgeController.clear();
                _maxAgeController.clear();
                _minHeightController.clear();
                _maxHeightController.clear();
                _minWeightController.clear();
                _maxWeightController.clear();
                _minExperienceController.clear();
                _targetUserTypeNotifier.value = null;
                _targetGenderNotifier.value = null;
                _targetLocationNotifier.value = null;
                _targetPositionNotifier.value = null;
                _targetSpecializationController.clear();
                _selectedCertificationIdsNotifier.value = [];
                _preferredClubExperienceController.clear();
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
                  icon: Icon(Icons.arrow_back, color: theme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  strings.uploadContent,
                  style: GoogleFonts.poppins(
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
                                            onTap: () => setState(
                                              () => _selectedFile = null,
                                            ),
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
          
                      // ── Title ───────────────────────────────────────────────────
                      _sectionLabel(strings.title, theme),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _titleController,
                        label: strings.enterYourTitle,
                      ),
                      SizedBox(height: 20.h),
          
                      // ── Description ─────────────────────────────────────────────
                      _sectionLabel(strings.description, theme),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _descriptionController,
                        label: strings.enterYourDescription,
                        maxLines: 5,
                      ),
                      SizedBox(height: 20.h),
          
                      // ── Additional Notes ────────────────────────────────────────
                      _sectionLabel(strings.additionalNotes, theme),
                      SizedBox(height: 8.h),
                      AuthTextField(
                        controller: _additionalNotesController,
                        label: strings.enterAdditionalNotes,
                        maxLines: 3,
                      ),
                      SizedBox(height: 20.h),
          
                      // ── Sport ───────────────────────────────────────────────────
                      _sectionLabel(strings.sport, theme),
                      SizedBox(height: 8.h),
                      _buildSportPicker(strings, theme),
                      SizedBox(height: 20.h),
          
                      // ── End Date ────────────────────────────────────────────────
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
          
                      // ── Submit button ───────────────────────────────────────────
                      BlocBuilder<OpportunityBloc, OpportunityState>(
                        builder: (context, state) {
                          final isCreating = state is OpportunityCreating;
                          return CustomElevatedButton(
                            text: strings.upload,
                            isLoading: isCreating,
                            enabled: !isCreating,
                            onPressed: () => _submit(strings),
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
      ),
    );
  }

  // ── Match criteria toggle ─────────────────────────────────────────────────
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

  // ── Match criteria section ────────────────────────────────────────────────
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
          // ── Target User Type (Player / Coach) ─────────────────────────────
          _sectionLabel(strings.targetUserType, theme),
          SizedBox(height: 8.h),
          ValueListenableBuilder<String?>(
            valueListenable: _targetUserTypeNotifier,
            builder: (context, value, _) {
              return AppDropdownOverlay(
                labelText: strings.selectTargetUserType,
                value: value,
                options: _targetUserTypeOptions(strings),
                onChanged: (val) {
                  _targetUserTypeNotifier.value = val;
                  // Reset position & specialization when user type changes
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

          // ── Preferred Club Experience (Both Player & Coach) ───────────────
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

          // ── Height range (Players) ────────────────────────────────────────
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

          // ── Weight range (Players) ────────────────────────────────────────
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

          // ── Position (Players with team sports) ───────────────────────────
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

          // ── Required Certifications (Coaches) ─────────────────────────────
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

  // ── Reusable sub-widgets ──────────────────────────────────────────────────
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
    return InkWell(
      onTap: () => _showSportDropdown(strings),
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
              _selectedSportKey != null
                  ? _getLocalizedSportName(_selectedSportKey!, strings)
                  : strings.selectSport,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: _selectedSportKey != null
                    ? theme.onSurface
                    : Colors.grey[500],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
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
}
