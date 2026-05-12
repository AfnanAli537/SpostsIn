import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/applicants_screen.dart';
import 'package:sports_in/features/main/opportunity/view_model/applicants_bloc/applicants_bloc.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/repo/register_repo.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class OpportunityDetailsPage extends StatefulWidget {
  final String opportunityId;
  final bool? isOwner;

  const OpportunityDetailsPage({
    super.key,
    required this.opportunityId,
    this.isOwner,
  });

  @override
  State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
}

class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
  late final RegistrationBloc _registrationBloc;
  bool _certificationsLoaded = false;

  @override
  void initState() {
    super.initState();
    _registrationBloc = RegistrationBloc(getIt<RegisterRepo>());
    context.read<OpportunityBloc>().add(
      FetchOpportunityDetails(opportunityId: widget.opportunityId),
    );
  }

  @override
  void dispose() {
    _registrationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return BlocProvider<RegistrationBloc>.value(
      value: _registrationBloc,
      child: Builder(
        builder: (contextWithBloc) {
          // Load certifications once using the context that has the bloc
          if (!_certificationsLoaded) {
            _certificationsLoaded = true;
            contextWithBloc.read<RegistrationBloc>().add(
              const LoadCertificationsEvent(),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(strings.applyOpportunity),
                    actions: widget.isOwner == true
            ? [
                IconButton(
                  icon: Icon(Icons.edit_outlined,
                      color: colorScheme.onSurface, size: 20.sp),
                  onPressed: () async {
                    context.read<OpportunityBloc>().add(
                          FetchOpportunityDetails(
                              opportunityId: widget.opportunityId),
                        );
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.opportunityEditScreen,
                      arguments: widget.opportunityId,
                    );
                    if (result == true && mounted) {
                      context.read<OpportunityBloc>().add(
                            const FetchOpportunities(isRefresh: true),
                          );
                      Navigator.pop(context);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: colorScheme.onSurface, size: 20.sp),
                  onPressed: () {
                    ConfirmationDialog.show(
                      context: context,
                      title: strings.deleteOpportunity,
                      message: strings.deleteOpportunityConfirmation,
                      onConfirm: () {
                        context.read<OpportunityBloc>().add(
                              DeleteOpportunity(
                                  opportunityId: widget.opportunityId),
                            );
                        Fluttertoast.showToast(
                          msg: strings.deletingOpportunity,
                          backgroundColor: Colors.orange,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        if (mounted) {
                      context.read<OpportunityBloc>().add(
                            const FetchOpportunities(isRefresh: true),
                          );
                      Navigator.pop(context);
                        }
                      },
                      confirmText: strings.delete,
                      cancelText: strings.cancel,
                      icon: Icons.delete_outline,
                      isDestructive: true,
                    );
                  },
                ),
              ]
            : null,
            elevation: 0),
            body: BlocBuilder<OpportunityBloc, OpportunityState>(
              builder: (context, state) {
                if (state is OpportunityDetailsLoaded) {
                  return _buildDetailsContent(
                    context,
                    state.opportunity,
                    strings,
                  );
                }
                if (state is OpportunityLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OpportunityError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    DetailsModel opportunity,
    S strings,
  ) {
    final isOwner = widget.isOwner ?? false;

    return Column(
      // ✅ Column as root
      children: [
        Flexible(
          // ✅ Flexible, not Expanded
          child: SingleChildScrollView(
            // ✅ single scroll view
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(opportunity),
                SizedBox(height: 24.h),

                _buildSection(
                  title: strings.title,
                  content: Text(opportunity.title),
                ),
                SizedBox(height: 20.h),

                _buildSection(
                  title: strings.description,
                  content: Text(opportunity.description),
                ),
                SizedBox(height: 20.h),

                if (opportunity.additionalNotes != null &&
                    opportunity.additionalNotes!.isNotEmpty) ...[
                  _buildSection(
                    title: strings.additionalNotes,
                    content: Text(opportunity.additionalNotes!),
                  ),
                  SizedBox(height: 20.h),
                ],

                _buildSection(
                  title: strings.endDate,
                  content: Text(_formatEndDate(opportunity.endDate)),
                ),
                SizedBox(height: 20.h),

                if (opportunity.matchCriteria != null)
                  _buildMatchCriteriaSection(
                    opportunity.matchCriteria!,
                    strings,
                  ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        // ✅ Button sits outside the scroll, always visible at bottom
        if (isOwner)
          _buildShowApplicantsButton(strings)
        else
          _buildApplyButton(opportunity, false, false, strings),
      ],
    );
  }
  // ── Match Criteria section ────────────────────────────────────────────────

  Widget _buildMatchCriteriaSection(MatchCriteria criteria, S strings) {
    final colorScheme = Theme.of(context).colorScheme;
    final rows = <_CriteriaRow>[];

    if (criteria.targetUserType != null) {
      rows.add(_CriteriaRow(strings.targetUserType, criteria.targetUserType!));
    }
    if (criteria.targetGender != null) {
      rows.add(_CriteriaRow(strings.targetGender, (criteria.targetGender)== 0? 'Male':'Female' ));
    }
    if (criteria.minAge != null || criteria.maxAge != null) {
      rows.add(
        _CriteriaRow(
          strings.ageRange,
          '${criteria.minAge ?? '-'} – ${criteria.maxAge ?? '-'}',
        ),
      );
    }
    if (criteria.targetLocation != null) {
      rows.add(_CriteriaRow(strings.targetLocation, criteria.targetLocation!));
    }
    if (criteria.targetPosition != null) {
      rows.add(
        _CriteriaRow(
          strings.position,
          RegisterLists.getPositionDisplayFromAbbreviation(
            criteria.targetPosition!,
            strings,
          )!,
        ),
      );
    }
    if (criteria.minHeight != null || criteria.maxHeight != null) {
      rows.add(
        _CriteriaRow(
          strings.heightRange,
          '${criteria.minHeight?.toStringAsFixed(0) ?? '-'} – ${criteria.maxHeight?.toStringAsFixed(0) ?? '-'} cm',
        ),
      );
    }
    if (criteria.minWeight != null || criteria.maxWeight != null) {
      rows.add(
        _CriteriaRow(
          strings.weightRange,
          '${criteria.minWeight?.toStringAsFixed(0) ?? '-'} – ${criteria.maxWeight?.toStringAsFixed(0) ?? '-'} kg',
        ),
      );
    }
    if (criteria.targetSpecialization != null) {
      rows.add(
        _CriteriaRow(strings.specialist, criteria.targetSpecialization!),
      );
    }
    if (criteria.minExperienceYears != null) {
      rows.add(
        _CriteriaRow(
          strings.minExperienceYears,
          '${criteria.minExperienceYears} ${strings.years}',
        ),
      );
    }
    if (criteria.preferredClubExperience != null) {
      rows.add(
        _CriteriaRow(
          strings.PreferredClubExperience,
          '${criteria.preferredClubExperience}',
        ),
      );
    }

    final hasCertifications =
        criteria.requiredCertifications != null &&
        criteria.requiredCertifications!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.tune_rounded, size: 18.sp, color: colorScheme.primary),
            SizedBox(width: 6.w),
            Text(
              strings.matchCriteria,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // ── Card ────────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static rows
              ...rows.map(_buildCriteriaRow),

              // Certifications row — resolved via BlocBuilder
              if (hasCertifications)
                BlocBuilder<RegistrationBloc, RegistrationState>(
                  builder: (context, state) {
                    // ✅ Use the extension — no mutation of `rows`
                    final names = state is RegistrationCertificationsLoaded
                        ? criteria.requiredCertifications!
                              .mapCertificationIdsToNames(state.certifications)
                        : '${strings.loading}...';

                    return _buildCriteriaRow(
                      _CriteriaRow(strings.certifications, names),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCriteriaRow(_CriteriaRow row) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(
              row.label,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // /// Maps certification IDs to their names
  // List<String> _mapCertificationIdsToNames(
  //   List<int> certificationIds,
  //   List<CertificationModel> certifications,
  // ) {
  //   return certificationIds
  //       .map((id) {
  //         try {
  //           final cert = certifications.firstWhere(
  //             (c) => c.id == id,
  //             orElse: () => CertificationModel(id: 0, name: ''),
  //           );
  //           return cert.name.isNotEmpty ? cert.name : null;
  //         } catch (_) {
  //           return null;
  //         }
  //       })
  //       .where((name) => name != null)
  //       .cast<String>()
  //       .toList();
  // }

  // ── Shared widgets ────────────────────────────────────────────────────────

  Widget _buildHeaderImage(DetailsModel opportunity) {
    final imageUrl = opportunity.uploadedMediaUrl ?? opportunity.mediaFile;
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16.r),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Icon(
                Icons.event_available_outlined,
                size: 60.sp,
                color: Colors.white.withOpacity(.9),
              ),
            )
          : null,
    );
  }

  Widget _buildShowApplicantsButton(S strings) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ApplicantsBloc(
                      repository: getIt<OpportunityReposatory>(),
                    ),
                    child: ApplicantsPage(opportunityId: widget.opportunityId),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              strings.showApplicants,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(
    DetailsModel opportunity,
    bool isApplying,
    bool applied,
    S strings,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isApplying || applied
                ? null
                : () => _showApplyConfirmation(opportunity, strings),
            style: ElevatedButton.styleFrom(
              backgroundColor: applied
                  ? Colors.grey[600]
                  : Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isApplying
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    applied ? strings.alreadyApplied : strings.applyNow,
                    style: GoogleFonts.poppins(
                      color: applied
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: content,
          ),
        ),
      ],
    );
  }

  void _showApplyConfirmation(DetailsModel opportunity, S strings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.apply),
        content: Text('${strings.apply} for "${opportunity.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OpportunityBloc>().add(
                ApplyToOpportunity(opportunityId: widget.opportunityId),
              );
            },
            child: Text(
              strings.apply,
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEndDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Helper data class for match criteria rows
class _CriteriaRow {
  final String label;
  final String value;

  const _CriteriaRow(this.label, this.value);
}
