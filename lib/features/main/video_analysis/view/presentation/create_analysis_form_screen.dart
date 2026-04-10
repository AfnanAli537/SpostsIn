import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/features/main/video_analysis/data/repo/analysis_repo.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_event.dart';
import 'package:sports_in/features/main/video_analysis/view_model/create_analysis/create_analysis_state.dart';

import '../../data/enums/analysis_type.dart';

import '../widgets/analysis_info_bottom_sheet.dart';
import 'analysis_payment_screen.dart';
import 'analysis_processing_screen.dart';

class CreateAnalysisFormScreen extends StatefulWidget {
  final String targetUserId;
  final AnalysisType analysisType;

  /// Pre-filled from a post video URL. When set the upload area is hidden
  /// and the URL field shows the post video link directly.
  final String? prefilledVideoUrl;

  const CreateAnalysisFormScreen({
    super.key,
    required this.targetUserId,
    required this.analysisType,
    this.prefilledVideoUrl,
  });

  @override
  State<CreateAnalysisFormScreen> createState() =>
      _CreateAnalysisFormScreenState();
}

class _CreateAnalysisFormScreenState extends State<CreateAnalysisFormScreen> {
  final _videoUrlController = TextEditingController();
  final _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _pickedVideo;
  bool _isUploadingVideo = false;
  bool _isUploaded = false;

  AnalysisType get _type => widget.analysisType;
  bool get _hasPrefilledUrl =>
      widget.prefilledVideoUrl != null &&
      widget.prefilledVideoUrl!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasPrefilledUrl) {
      _videoUrlController.text = widget.prefilledVideoUrl!;
      _isUploaded = true;
    }
  }

  @override
  void dispose() {
    _videoUrlController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // ─── Video picking & uploading ──────────────────────────────────────────────

  Future<void> _pickVideo() async {
    final vid = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5));
    if (vid == null) return;
    setState(() {
      _pickedVideo = File(vid.path);
      _isUploaded = false;
      _videoUrlController.clear();
    });
    await _uploadVideo(_pickedVideo!);
  }

  Future<void> _pickFromCamera() async {
    final vid = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5));
    if (vid == null) return;
    setState(() {
      _pickedVideo = File(vid.path);
      _isUploaded = false;
      _videoUrlController.clear();
    });
    await _uploadVideo(_pickedVideo!);
  }

  Future<void> _uploadVideo(File file) async {
    setState(() => _isUploadingVideo = true);
    try {
      final dio = Dio();
      final url =
          'https://api.cloudinary.com/v1_1/${StringKeys.cloudName}/video/upload';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': StringKeys.uploadPreset,
        'folder': 'analysis/videos',
        'resource_type': 'video',
      });
      final res = await dio.post(url, data: formData);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.data['secure_url'] != null) {
        setState(() {
          _videoUrlController.text = res.data['secure_url'] as String;
          _isUploaded = true;
        });
      } else {
        _toast('Upload failed. Paste a URL manually.', err: true);
      }
    } catch (e) {
      _toast('Upload error: $e', err: true);
    } finally {
      setState(() => _isUploadingVideo = false);
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 44.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            ListTile(
              leading: Icon(Icons.video_library,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam_outlined,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Record with Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
          ]),
        ),
      ),
    );
  }

  // ─── Submit ─────────────────────────────────────────────────────────────────

  void _submit(BuildContext blocCtx) {
    if (!_formKey.currentState!.validate()) return;

    final videoUrl = _videoUrlController.text.trim();
    if (videoUrl.isEmpty) {
      _toast('Please provide a video URL or upload a video.', err: true);
      return;
    }

    double? height;
    if (_type == AnalysisType.goalkeeper) {
      height = double.tryParse(_heightController.text.trim());
      if (height == null || height < 1.0 || height > 2.5) {
        _toast('Please enter a valid height (1.0 – 2.5 m).', err: true);
        return;
      }
    }

    blocCtx.read<CreateAnalysisBloc>().add(SubmitAnalysisEvent(
          type: _type,
          targetUserId: widget.targetUserId,
          videoUrl: videoUrl,
          keeperHeightM: height,
        ));
  }

  void _toast(String msg, {bool err = false}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: err ? Colors.red : Colors.green,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => CreateAnalysisBloc(getIt<IAnalysisRepo>()),
      child: Builder(
        builder: (blocCtx) => BlocListener<CreateAnalysisBloc,
            CreateAnalysisState>(
          listener: (ctx, state) async {
            if (state is CreateAnalysisSuccess) {
              Navigator.pushReplacement(
                ctx,
                MaterialPageRoute(
                    builder: (_) =>
                        AnalysisProcessingScreen(type: _type)),
              );
            } else if (state is CreateAnalysisRequiresPayment) {
              // Pass the same bloc instance into payment screen so
              // ExecutePaidAnalysisEvent fires into the correct sink.
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: ctx.read<CreateAnalysisBloc>(),
                    child: AnalysisPaymentScreen(
                      analysisId: state.analysisId,
                      price: state.price,
                      analysisType: _type,
                    ),
                  ),
                ),
              );
            } else if (state is CreateAnalysisError) {
              final msg =
                  await TranslateErrorHelper.translateErrorKeyAsync(
                      ctx, state.message);
              _toast(msg, err: true);
            }
          },
          child: BlocBuilder<CreateAnalysisBloc, CreateAnalysisState>(
            builder: (ctx, state) {
              final isLoading =
                  state is CreateAnalysisLoading || _isUploadingVideo;

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.onSurface),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  title: Text(
                    '${_type.label} Analysis',
                    style: TextStyle(
                        color: theme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.info_outline, color: theme.primary),
                      tooltip: 'What to expect',
                      onPressed: () => showAnalysisInfoSheet(ctx, _type),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TypeBadge(type: _type),
                        SizedBox(height: 24.h),

                        // ── Upload area (hidden when pre-filled) ──────────
                        if (!_hasPrefilledUrl) ...[
                          _label(ctx, 'Upload or Link Your Video'),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: _isUploadingVideo
                                ? null
                                : _showSourceSheet,
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: _isUploaded
                                    ? Colors.green
                                    : theme.outline.withOpacity(0.4),
                                strokeWidth: 2.w,
                                dashPattern: const [20, 6],
                                radius: Radius.circular(14.r),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(14.r),
                                child: Container(
                                  height: 150.h,
                                  width: double.infinity,
                                  color: theme.surface,
                                  child: _videoPreview(theme),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _orDivider(theme),
                          SizedBox(height: 16.h),
                          _label(ctx, 'Or Paste a Video URL'),
                          SizedBox(height: 10.h),
                        ] else ...[
                          // ── Pre-filled from post ─────────────────────────
                          _label(ctx, 'Video from Post'),
                          SizedBox(height: 10.h),
                          _PrefilledChip(url: widget.prefilledVideoUrl!),
                          SizedBox(height: 20.h),
                        ],

                        // ── URL field ─────────────────────────────────────
                        AuthTextField(
                          controller: _videoUrlController,
                          label: 'Video URL (Cloudinary, YouTube, etc.)',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please provide a video URL';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // ── Goalkeeper height ─────────────────────────────
                        if (_type == AnalysisType.goalkeeper) ...[
                          _label(ctx, 'Goalkeeper Height (meters)'),
                          SizedBox(height: 10.h),
                          AuthTextField(
                            controller: _heightController,
                            label: 'e.g. 1.85',
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Height is required for goalkeeper analysis';
                              }
                              final h = double.tryParse(v.trim());
                              if (h == null || h < 1.0 || h > 2.5) {
                                return 'Enter a valid height (1.0 – 2.5 m)';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.h),
                          Row(children: [
                            Icon(Icons.info_outline,
                                size: 14.sp,
                                color: theme.onSurface.withOpacity(0.45)),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                'Height calibrates extension & velocity measurements.',
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color:
                                        theme.onSurface.withOpacity(0.45)),
                              ),
                            ),
                          ]),
                          SizedBox(height: 24.h),
                        ],

                        // ── Tips ──────────────────────────────────────────
                        _QuickTipsCard(type: _type),
                        SizedBox(height: 32.h),

                        // ── Submit ────────────────────────────────────────
                        CustomElevatedButton(
                          text: 'Start Analysis',
                          isLoading: isLoading,
                          enabled: !isLoading,
                          onPressed: () => _submit(ctx),
                        ),
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            'If payment is required, you\'ll be prompted before analysis starts.',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: theme.onSurface.withOpacity(0.4)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Widget _videoPreview(ColorScheme theme) {
    if (_isUploadingVideo) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32.w,
              height: 32.w,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: theme.primary),
            ),
            SizedBox(height: 10.h),
            Text('Uploading…',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: theme.onSurface.withOpacity(0.6))),
          ]);
    }
    if (_isUploaded) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 36.sp, color: Colors.green),
            SizedBox(height: 8.h),
            Text('Video uploaded',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => setState(() {
                _pickedVideo = null;
                _isUploaded = false;
                _videoUrlController.clear();
              }),
              child: Text('Remove',
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: theme.primary,
                      decoration: TextDecoration.underline)),
            ),
          ]);
    }
    if (_pickedVideo != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_file_outlined,
                size: 36.sp, color: theme.onSurface.withOpacity(0.4)),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(_pickedVideo!.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.onSurface.withOpacity(0.55))),
            ),
          ]);
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file_outlined,
              size: 40.sp, color: theme.onSurface.withOpacity(0.35)),
          SizedBox(height: 10.h),
          Text('Tap to upload video',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.onSurface.withOpacity(0.5))),
          SizedBox(height: 4.h),
          Text('MP4 · MOV · AVI',
              style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.onSurface.withOpacity(0.3))),
        ]);
  }

  Widget _orDivider(ColorScheme theme) => Row(children: [
        Expanded(
            child: Divider(color: theme.outline.withOpacity(0.3))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text('OR PASTE URL',
              style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.onSurface.withOpacity(0.38),
                  letterSpacing: 1)),
        ),
        Expanded(
            child: Divider(color: theme.outline.withOpacity(0.3))),
      ]);

  Widget _label(BuildContext context, String text) => Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface),
      );
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _PrefilledChip extends StatelessWidget {
  final String url;
  const _PrefilledChip({required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(Icons.link, size: 16.sp, color: Colors.green[700]),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(url,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.onSurface.withOpacity(0.7))),
        ),
        Icon(Icons.check_circle, size: 16.sp, color: Colors.green[700]),
      ]),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final AnalysisType type;
  const _TypeBadge({required this.type});

  Color get _color {
    switch (type) {
      case AnalysisType.goalkeeper:
        return const Color(0xFF4FC3F7);
      case AnalysisType.passing:
        return const Color(0xFF81C784);
      case AnalysisType.dribbling:
        return const Color(0xFFFFB74D);
      case AnalysisType.match:
        return const Color(0xFFBA68C8);
    }
  }

  IconData get _icon {
    switch (type) {
      case AnalysisType.goalkeeper:
        return Icons.sports_handball_outlined;
      case AnalysisType.passing:
        return Icons.compare_arrows_rounded;
      case AnalysisType.dribbling:
        return Icons.sports_soccer;
      case AnalysisType.match:
        return Icons.stadium_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(_icon, size: 18.sp, color: _color),
        SizedBox(width: 8.w),
        Text(type.label,
            style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _color)),
      ]),
    );
  }
}

class _QuickTipsCard extends StatelessWidget {
  final AnalysisType type;
  const _QuickTipsCard({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: theme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: theme.shadow.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.videocam_outlined,
              size: 18.sp, color: theme.primary),
          SizedBox(width: 8.w),
          Text('Video Tips',
              style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.onSurface)),
          const Spacer(),
          GestureDetector(
            onTap: () => showAnalysisInfoSheet(context, type),
            child: Text('More info',
                style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.primary,
                    decoration: TextDecoration.underline)),
          ),
        ]),
        SizedBox(height: 10.h),
        Text(type.videoInstructions,
            style: TextStyle(
                fontSize: 12.sp,
                color: theme.onSurface.withOpacity(0.6),
                height: 1.7)),
      ]),
    );
  }
}