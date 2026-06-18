// ignore_for_file: unnecessary_cast

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/payment_flow_helper.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/web_view_screen.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_description_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_lessons_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/course_progress_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/enrollees_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/course_details_tabs/revenue_tab.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/edit_lesson_screen.dart';
import 'package:sports_in/features/main/courses/view/presentation/provider/upload_video_screen.dart';
import 'package:sports_in/features/main/courses/view/widgets/course_header.dart';
import 'package:sports_in/features/main/courses/view/widgets/inline_edit_dialog.dart';
import 'package:sports_in/features/main/courses/view/widgets/shimmer_widget.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/payment/data/enums/enums.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/payment/presentation/widgets/processing_dailog.dart';
import 'package:sports_in/features/payment/presentation/widgets/sucess_dailog.dart';
import 'package:sports_in/generated/l10n.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CourseModel? _course;
  List<LessonModel> _allLessons = [];
  LessonModel? _currentPlayingLesson;

  bool _isEditMode = false;
  bool _hasUnsavedChanges = false;
  File? _newThumbnail;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isFreeEdit = false;
  String? _transId;
  bool _isManualActivationHandled = false; 

  // Processing dialog state — same pattern as AdPaymentScreen
  bool _isProcessingDialogOpen = false;
  String? _handledPaymentStateType;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
    _tabController = TabController(length: 2, vsync: this);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CourseDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      setState(() {
        _course = null;
        _allLessons = [];
        _currentPlayingLesson = null;
        _isEditMode = false;
        _hasUnsavedChanges = false;
        _newThumbnail = null;
        _handledPaymentStateType = null;
      });
      context.read<CoursesBloc>().add(FetchCourseDetail(courseId: widget.courseId));
    }
  }

  void _updateTabController(CourseModel course) {
    if (_course?.id != course.id) {
      _allLessons = [];
      _currentPlayingLesson = null;
    }
    if (_course == null ||
        _course!.isOwner != course.isOwner ||
        _course!.isEnrolled != course.isEnrolled) {
      _tabController.dispose();
      int length = 2;
      if (course.isOwner) {
        length = 4;
      } else if (course.isEnrolled) {
        length = 3;
      }
      _tabController = TabController(length: length, vsync: this);
    }
    _course = course;
    context.read<CoursesBloc>().add(FetchCourseLessons(courseId: widget.courseId, isEnrolled: course.isEnrolled,));
  }

  // ── Processing dialog helpers (same as AdPaymentScreen) ────────────────

  void _showProcessingDialog() {
    if (_isProcessingDialogOpen) return;
    _isProcessingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProcessingPaymentDialog(),
    ).then((_) => _isProcessingDialogOpen = false);
  }

  void _dismissProcessingDialog() {
    if (_isProcessingDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isProcessingDialogOpen = false;
    }
  }

  // ── Edit mode helpers ──────────────────────────────────────────────────────

  void _enterEditMode(CourseModel course) {
    setState(() {
      _isEditMode = true;
      _titleController.text = course.title;
      _descriptionController.text = course.description ?? '';
      _priceController.text = course.price.toString();
      _isFreeEdit = course.isFree;
      _newThumbnail = null;
      _hasUnsavedChanges = false;
    });
  }

  void _cancelEditMode() => setState(() {
        _isEditMode = false;
        _hasUnsavedChanges = false;
      });

  void _onFieldChanged() => setState(() => _hasUnsavedChanges = true);

  Future<void> _pickThumbnail() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _newThumbnail = File(picked.path);
        _onFieldChanged();
      });
    }
  }

  Future<void> _saveAllChanges(CourseModel course, S string) async {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: string.titleCannotBeEmpty, backgroundColor: Colors.orange);
      return;
    }
    if (!_isFreeEdit) {
      final price = double.tryParse(_priceController.text);
      if (price == null || price < 0) {
        Fluttertoast.showToast(
            msg: string.invalidPrice, backgroundColor: Colors.orange);
        return;
      }
    }
    final newPrice = _isFreeEdit ? 0.0 : double.parse(_priceController.text);
    context.read<CoursesBloc>().add(UpdateCourse(
          courseId: course.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: newPrice,
          sportTypeId: course.sportTypeId,
          thumbnail: _newThumbnail?.path ?? course.thumbnailUrl ?? '',
        ));
    setState(() {
      _isEditMode = false;
      _hasUnsavedChanges = false;
      _newThumbnail = null;
    });
    Fluttertoast.showToast(
        msg: string.savingChanges, backgroundColor: Colors.blue);
  }

  Future<void> _deleteLesson(LessonModel lesson, S string) async {
    final confirmed = await InlineEditDialog.showConfirmation(
      context: context,
      string: string,
      title: string.deleteLesson,
      message: string.deleteLessonConfirmation(lesson.title),
      confirmText: string.delete,
      isDestructive: true,
    );
    if (confirmed) {
      context.read<CoursesBloc>().add(DeleteLesson(lessonId: lesson.id));
      Fluttertoast.showToast(
          msg: string.deletingLesson, backgroundColor: Colors.orange);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context
              .read<CoursesBloc>()
              .add(FetchCourseLessons(courseId: widget.courseId));
        }
      });
    }
  }

  void _navigateToEditLesson(LessonModel lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CoursesBloc>(),
          child: EditLessonScreen(lesson: lesson, courseId: widget.courseId),
        ),
      ),
    ).then((updated) {
      if (updated == true) {
        context
            .read<CoursesBloc>()
            .add(FetchCourseLessons(courseId: widget.courseId));
      }
    });
  }

  // ── Payment ────────────────────────────────────────────────────────────────

  Future<void> _handleEnroll(BuildContext enrollContext, CourseModel course) async {
    if (course.isFree) {
      enrollContext.read<CoursesBloc>().add(EnrollInCourse(courseId: course.id));
      return;
    }

    // Reset guard for a fresh payment attempt — same as AdPaymentScreen
    setState(() => _handledPaymentStateType = null);

    final paymentBloc = enrollContext.read<PaymentBloc>();
    await initiatePaymentFlow(
      context: enrollContext,
      paymentBloc: paymentBloc,
      targetId: course.id,
      targetType: PaymentTargetType.course,
      price: course.price,
    );
    // initiatePaymentFlow awaits the showGeneralDialog, so by the time
    // we're back here Fawry/Vodafone screens have already handled their
    // own dialogs and navigation. Nothing more to do for those methods.
    // Credit card redirect is handled by the BlocListener below.
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);

    return BlocProvider<PaymentBloc>(
      create: (_) => getIt<PaymentBloc>(),
      child: Builder(
        builder: (paymentContext) {
          return BlocListener<PaymentBloc, PaymentState>(
            listener: (ctx, state) {
              // ── Processing overlay for credit card initiation only ──────
              // Fawry and Vodafone manage their own processing dialogs
              // internally, just like in the ad payment flow.
              if (state is PaymentInitiating) {
                _showProcessingDialog();
              }

              // ── Credit card: redirect to WebView ──────────────────────
              if (state is PaymentRedirectReady) {
                final stateKey =
                    state.runtimeType.toString() + state.redirectUrl;
                if (stateKey == _handledPaymentStateType) return;
                _handledPaymentStateType = stateKey;

                _dismissProcessingDialog();
                _transId = state.transactionId;

                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      prevScreen: AppRoutes.mainLayout,
                      url: state.redirectUrl,
                      title: string.completePayment,
                    ),
                  ),
                );
              }

              // ── Free course success (ProcessSuccessful) ────────────────
              // Show success dialog, then trigger enrollment, then navigate
              // back. This mirrors how AdPaymentScreen handles free/redirect.
              if (state is ProcessSuccessful) {
                final stateKey = state.runtimeType.toString();
                if (stateKey == _handledPaymentStateType) return;
                _handledPaymentStateType = stateKey;

                _dismissProcessingDialog();
                if (!mounted || _course == null) return;

                final courseId = _course!.id;
                showDialog(
                  context: ctx,
                  barrierDismissible: false,
                  builder: (_) => PaymentSuccessDialog(
                    transactionId: _transId ?? string.unKnown,
                    onDismissed: () {
                      if (mounted) {
                        ctx
                            .read<CoursesBloc>()
                            .add(EnrollInCourse(courseId: courseId));
                      }
                    },
                  ),
                );
              }

              // ── FAWRY / VODAFONE success (ManualActivateSuccess) ──────────────
              // Do NOT show a dialog here — Fawry shows it on its own screen and
              // Vodafone shows it on its own screen then navigates away.
              // We just dismiss the processing overlay (safety) and reset state.
              if (state is ManualActivateSuccess && !_isManualActivationHandled) {
                _isManualActivationHandled = true;
                _dismissProcessingDialog();
                // Reset guard so the next payment attempt is fresh.
                setState(() => _handledPaymentStateType = null);
                // Trigger enrollment after successful payment
                if (mounted && _course != null) {
                  ctx
                      .read<CoursesBloc>()
                      .add(EnrollInCourse(courseId: _course!.id));
                }
              }

              // ── Errors ─────────────────────────────────────────────────
              if (state is PaymentInitiateError) {
                _dismissProcessingDialog();
                Fluttertoast.showToast(
                    msg: state.message, backgroundColor: Colors.red);
              }
              if (state is ManualActivateError) {
                _dismissProcessingDialog();
                Fluttertoast.showToast(
                    msg: state.message, backgroundColor: Colors.red);
              }
            },
            child: BlocConsumer<CoursesBloc, CoursesState>(
              listener: (ctx, state) {
                if (state is LessonsLoaded && state.courseId == widget.courseId) {
                  setState(() {
                    _allLessons = List.from(state.lessons);
                  });
                } else if (state is EnrollmentSuccess) {
                  Fluttertoast.showToast(
                      msg: string.enrolledSuccessfully,
                      backgroundColor: Colors.green);
                  Navigator.of(ctx).pushNamedAndRemoveUntil(
                    AppRoutes.mainLayout,
                    (route) => false,
                  );
                } else if (state is CourseDeleted) {
                  Fluttertoast.showToast(
                      msg: string.courseDeleted,
                      backgroundColor: Colors.green);
                  Navigator.pop(ctx, true);
                } else if (state is CoursesError) {
                  Fluttertoast.showToast(
                      msg: state.message, backgroundColor: Colors.red);
                }
              },
              buildWhen: (previous, current) =>
                  current is CourseDetailLoading ||
                  current is CourseDetailLoaded ||
                  (current is CoursesError && previous is! CourseDetailLoaded),
              builder: (ctx, state) {
                if (state is CourseDetailLoaded) {
                  _updateTabController(state.course);
                }

                final course = _course ??
                    (state is CourseDetailLoaded ? state.course : null);

                if (course == null) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const CourseDetailShimmer(),
                  );
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text(course.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    actions: _buildAppBarActions(course, string),
                  ),
                  body: NestedScrollView(
                    headerSliverBuilder: (_, __) => [
                      SliverToBoxAdapter(
                        child: CourseHeader(
                          currentPlayingLesson: _currentPlayingLesson,
                          allLessons: _allLessons,
                          courseId: widget.courseId,
                          thumbnailUrl: course.thumbnailUrl,
                          onBack: () =>
                              setState(() => _currentPlayingLesson = null),
                          onNextLesson: (l) =>
                              setState(() => _currentPlayingLesson = l),
                          onPreviousLesson: (l) =>
                              setState(() => _currentPlayingLesson = l),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: Theme.of(ctx).colorScheme.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: _buildTabs(course, string),
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      controller: _tabController,
                      children: _buildTabViews(course, string),
                    ),
                  ),
                  bottomNavigationBar: (!course.isOwner && !course.isEnrolled)
                      ? _buildEnrollButton(paymentContext, course, string)
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTabs(CourseModel course, S string) {
    final tabs = [
      Tab(text: string.lessons),
      Tab(text: string.description),
    ];
    if (course.isOwner) {
      tabs.addAll([Tab(text: string.enrolled), Tab(text: string.revenue)]);
    } else if (course.isEnrolled) {
      tabs.add(Tab(text: string.progress));
    }
    return tabs;
  }

  List<Widget> _buildTabViews(CourseModel course, S string) {
    final views = <Widget>[
      CourseLessonsTab(
        course: course,
        lessons: _allLessons,
        currentPlayingLesson: _currentPlayingLesson,
        isEditMode: _isEditMode,
        onRefresh: () => context
            .read<CoursesBloc>()
            .add(FetchCourseLessons(courseId: widget.courseId, isEnrolled: course.isEnrolled)),
        onLessonTap: (l) => setState(() => _currentPlayingLesson = l),
        onUpdateLesson: _navigateToEditLesson,
        onDeleteLesson: (lesson) => _deleteLesson(lesson, string),
      ),
      CourseDescriptionTab(
        course: course,
        isEditMode: _isEditMode,
        hasUnsavedChanges: _hasUnsavedChanges,
        newThumbnail: _newThumbnail,
        titleController: _titleController,
        descriptionController: _descriptionController,
        priceController: _priceController,
        isFree: _isFreeEdit,
        onPickThumbnail: _pickThumbnail,
        onCancelEdit: _cancelEditMode,
        onSaveChanges: () => _saveAllChanges(course, string),
        onFreeChanged: (v) => _isFreeEdit = v,
        onFieldChanged: _onFieldChanged,
      ),
    ];
    if (course.isOwner) {
      views.add(EnrolleesTab(courseId: course.id));
      views.add(RevenueTab(courseId: course.id));
    } else if (course.isEnrolled) {
      views.add(CourseProgressTab(course: course));
    }
    return views;
  }

  List<Widget> _buildAppBarActions(CourseModel course, S string) {
    if (!course.isOwner) return [];
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _isEditMode ? _cancelEditMode() : _enterEditMode(course);
          } else if (value == 'delete') {
            _showDeleteConfirmation(course.id, string);
          } else if (value == 'add_lesson') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<CoursesBloc>(),
                  child: UploadLessonScreen(
                    courseId: course.id,
                    existingLessonsCount: course.lessonsCount,
                  ),
                ),
              ),
            );
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'add_lesson',
            child: Row(children: [
              const Icon(Icons.video_library),
              SizedBox(width: 8.w),
              Text(string.addLesson),
            ]),
          ),
          PopupMenuItem(
            value: 'edit',
            child: Row(children: [
              Icon(_isEditMode ? Icons.close : Icons.edit),
              SizedBox(width: 8.w),
              Text(_isEditMode ? string.cancelEdit : string.editCourse),
            ]),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(children: [
              const Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8.w),
              Text(string.delete, style: const TextStyle(color: Colors.red)),
            ]),
          ),
        ],
      ),
    ];
  }

  Widget _buildEnrollButton(
      BuildContext paymentContext, CourseModel course, S string) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(paymentContext).colorScheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (_, state) {
            final isLoading = state is EnrollmentLoading;
            return CustomElevatedButton(
              text: course.isFree
                  ? string.enrollNow
                  : string.enrollForPrice('${course.price} ${string.egp}'),
              isLoading: isLoading,
              onPressed: isLoading
                  ? () {}
                  : () => _handleEnroll(paymentContext, course),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String courseId, S string) {
    ConfirmationDialog.show(
      context: context,
      title: string.deleteCourse,
      message: string.deleteCourseConfirmation,
      onConfirm: () =>
          context.read<CoursesBloc>().add(DeleteCourse(courseId: courseId)),
      confirmText: string.delete,
      cancelText: string.cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _tabBar,
      );

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}