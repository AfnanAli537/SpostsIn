import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/advertisement/data/enums/target_audience_enum.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_payment_screen.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_success_screen.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/generated/l10n.dart';

/// Pass an [existingAd] to edit, leave null to create.
class CreateAdScreen extends StatefulWidget {
  final AdModel? existingAd;

  const CreateAdScreen({super.key, this.existingAd});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _actionUrlController = TextEditingController();
  final _actionTextController = TextEditingController();

  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  final _sportNotifier = ValueNotifier<String?>(null);

  DateTime? _startDate;
  DateTime? _endDate;

  /// Selected audience labels e.g. ['Player', 'Coach']
  List<String> _selectedAudienceLabels = [];

  bool get _isEditing => widget.existingAd != null;

  bool get _hasExistingMedia =>
      _selectedFile == null &&
      _isEditing &&
      widget.existingAd?.mediaUrl != null &&
      widget.existingAd!.mediaUrl!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final ad = widget.existingAd!;
      _titleController.text = ad.title;
      _descriptionController.text = ad.description;
      _actionUrlController.text = ad.actionUrl ?? '';
      _actionTextController.text = ad.actionText ?? '';
      _startDate = ad.startDate;
      _endDate = ad.endDate;
      _sportNotifier.value = EnumMapper.sportIdToLabel(ad.sportTypeId);
      // Convert the existing int list → display labels for the checkbox widget
      _selectedAudienceLabels = TargetAudienceMapper.idsToLabels(
        ad.targetAudiences,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _actionUrlController.dispose();
    _actionTextController.dispose();
    _sportNotifier.dispose();
    super.dispose();
  }

  // ─── Date / price helpers ──────────────────────────────────────────────────

  DateTime _buildStartDateTime(DateTime pickedDay) {
    final now = DateTime.now();
    final isToday =
        pickedDay.year == now.year &&
        pickedDay.month == now.month &&
        pickedDay.day == now.day;
    return isToday
        ? now
        : DateTime(pickedDay.year, pickedDay.month, pickedDay.day);
  }

  DateTime _buildEndDateTime(DateTime pickedDay) {
    if (_startDate == null) {
      return DateTime(pickedDay.year, pickedDay.month, pickedDay.day);
    }
    final isSameDay =
        pickedDay.year == _startDate!.year &&
        pickedDay.month == _startDate!.month &&
        pickedDay.day == _startDate!.day;
    return isSameDay
        ? _startDate!.add(const Duration(hours: 23))
        : DateTime(pickedDay.year, pickedDay.month, pickedDay.day);
  }

  double _calculatePrice() {
    if (_startDate == null || _endDate == null) return 0;
    final days = _endDate!.difference(_startDate!).inDays;
    return (days < 1 ? 1 : days) * 5.0;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate ?? now),
      firstDate: isStart ? now : (_startDate ?? now),
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = _buildStartDateTime(picked);
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      } else {
        _endDate = _buildEndDateTime(picked);
      }
    });
  }

  // ─── Media pickers ─────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _selectedFile = File(img.path));
  }

  Future<void> _pickVideo() async {
    final vid = await _picker.pickVideo(source: ImageSource.gallery);
    if (vid != null) setState(() => _selectedFile = File(vid.path));
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Pick Image'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.video_library,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Pick Video'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Error helper ──────────────────────────────────────────────────────────

  Future<void> _showError(String message) async {
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

  // ─── Submit ────────────────────────────────────────────────────────────────

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        _sportNotifier.value == null ||
        _startDate == null ||
        _endDate == null) {
      Fluttertoast.showToast(
        msg: S.of(context).pleaseFillAllFields,
        backgroundColor: Colors.orange,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final sportId = EnumMapper.getSportId(
      EnumMapper.fromLabel(EnumMapper.sportLabels(), _sportNotifier.value!) ??
          EnumMapper.sportLabels().keys.first,
    );

    final price = _calculatePrice();

    // Convert selected audience labels → list of ints for the API
    final audienceIds = (TargetAudienceMapper.labelsToIds(
      _selectedAudienceLabels,
    )..sort());

    if (_isEditing) {
      context.read<AdsBloc>().add(
        UpdateAd(
          adId: widget.existingAd!.id,
          title: title,
          description: description,
          mediaFilePath: _selectedFile?.path,
          price: price,
          actionUrl: _actionUrlController.text.trim(),
          actionText: _actionTextController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          sportTypeId: sportId,
          targetAudiences: audienceIds,
        ),
      );
    } else {
      context.read<AdsBloc>().add(
        CreateAd(
          title: title,
          description: description,
          mediaFilePath: _selectedFile?.path,
          price: price,
          actionUrl: _actionUrlController.text.trim(),
          actionText: _actionTextController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          sportTypeId: sportId,
          targetAudiences: audienceIds,
        ),
      );
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return BlocListener<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AdCreated) {
          if (state.isPaid && state.isActive) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AdsBloc>(),
                  child: const AdSuccessScreen(),
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AdsBloc>(),
                  child: AdPaymentScreen(
                    price: _calculatePrice(),
                    adId: state.adId,
                  ),
                ),
              ),
            );
          }
        } else if (state is AdUpdated) {
          Fluttertoast.showToast(
            msg: 'Advertisement updated successfully',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
          );
          Navigator.pop(context);
        } else if (state is AdsError) {
          _showError(state.message);
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
            _isEditing ? 'Edit Advertisement' : 'Create Advertisement',
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Media picker ───────────────────────────────────────────────
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
                      child: _buildMediaPreview(theme),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Title ──────────────────────────────────────────────────────
              _sectionLabel('Title *'),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _titleController,
                label: 'Enter ad title',
              ),
              SizedBox(height: 20.h),

              // ── Description ────────────────────────────────────────────────
              _sectionLabel('Description *'),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _descriptionController,
                label: 'Enter ad description',
                maxLines: 4,
              ),
              SizedBox(height: 20.h),

              // ── Sport ──────────────────────────────────────────────────────
              ValueListenableBuilder<String?>(
                valueListenable: _sportNotifier,
                builder: (_, sport, __) => AppDropdownOverlay(
                  labelText: strings.sportProfession,
                  value: sport,
                  options: RegisterLists.sportNameOptions(strings),
                  onChanged: (val) => _sportNotifier.value = val,
                  validator: (_) => null,
                ),
              ),
              SizedBox(height: 20.h),

              // ── Target Audiences ───────────────────────────────────────────
              _sectionLabel('Target Audience'),
              SizedBox(height: 8.h),
              CheckboxDropdownOverlay(
                labelText: 'Who should see this ad?',
                value: _selectedAudienceLabels,
                options: TargetAudienceMapper.allLabels(),
                onChanged: (selected) {
                  setState(() => _selectedAudienceLabels = selected);
                },
              ),
              SizedBox(height: 20.h),

              // ── Date range ─────────────────────────────────────────────────
              _sectionLabel('Campaign Duration *'),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _DatePickerTile(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DatePickerTile(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),

              // ── Price display ──────────────────────────────────────────────
              if (_startDate != null && _endDate != null)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: theme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Estimated cost: ${_calculatePrice().toStringAsFixed(0)} EGP',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.primary,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(5 EGP/day)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.h),

              // ── Action URL ─────────────────────────────────────────────────
              _sectionLabel('Action URL (optional)'),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _actionUrlController,
                label: 'https://...',
              ),
              SizedBox(height: 20.h),

              // ── CTA text ───────────────────────────────────────────────────
              _sectionLabel('CTA Button Text (optional)'),
              SizedBox(height: 8.h),
              AuthTextField(
                controller: _actionTextController,
                label: 'e.g. Learn More, Buy Now',
              ),
              SizedBox(height: 40.h),

              // ── Submit ─────────────────────────────────────────────────────
              BlocBuilder<AdsBloc, AdsState>(
                builder: (_, state) {
                  final isLoading = state is AdsLoaded && state.isUploading;
                  return CustomElevatedButton(
                    text: _isEditing ? 'Update Ad' : 'Continue',
                    isLoading: isLoading,
                    enabled:
                        true, // Always true - let isLoading control the visual state
                    onPressed: _submit,
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Media preview ─────────────────────────────────────────────────────────

  Widget _buildMediaPreview(ColorScheme theme) {
    if (_selectedFile != null) {
      return Stack(
        children: [
          Image.file(
            _selectedFile!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          _clearMediaButton(),
        ],
      );
    }

    if (_hasExistingMedia) {
      return Stack(
        children: [
          Image.network(
            widget.existingAd!.mediaUrl!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => _emptyMediaPlaceholder(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              color: Colors.black45,
              child: Text(
                'Tap to change media',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _clearMediaButton(),
        ],
      );
    }

    return _emptyMediaPlaceholder();
  }

  Widget _clearMediaButton() {
    return Positioned(
      top: 8.h,
      right: 8.w,
      child: GestureDetector(
        onTap: () => setState(() => _selectedFile = null),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }

  Widget _emptyMediaPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 60.sp, color: Colors.grey[600]),
        SizedBox(height: 12.h),
        Text(
          'Upload Image or Video',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Optional',
          style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

// ── Date picker tile ──────────────────────────────────────────────────────────

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: theme.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  date != null
                      ? '${date!.day}/${date!.month}/${date!.year}'
                      : 'Select',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: date != null ? theme.onSurface : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
