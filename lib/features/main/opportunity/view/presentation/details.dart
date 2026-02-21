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
  @override
  void initState() {
    super.initState();
    context.read<OpportunityBloc>().add(
      FetchOpportunityDetails(opportunityId: widget.opportunityId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.applyOpportunity,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: widget.isOwner == true
            ? [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: colorScheme.onSurface,
                    size: 20.sp,
                  ),
                  onPressed: () async {
                    context.read<OpportunityBloc>().add(
                          FetchOpportunityDetails(opportunityId: widget.opportunityId),
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
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.onSurface,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    ConfirmationDialog.show(
                      context: context,
                      title: strings.deleteOpportunity,
                      message: strings.deleteOpportunityConfirmation,
                      onConfirm: () {
                        context.read<OpportunityBloc>().add(
                              DeleteOpportunity(opportunityId: widget.opportunityId),
                            );

                        Fluttertoast.showToast(
                          msg: strings.deletingOpportunity,
                          backgroundColor: Colors.orange,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
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
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is OpportunityApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(strings.applicationSubmittedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );

            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context);
            });
          }

          if (state is OpportunityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is OpportunityDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OpportunityDetailsLoaded) {
            return _buildDetailsContent(
              state.opportunity,
              widget.isOwner ?? false,
              strings,
            );
          }

          if (state is OpportunityError) {
            return _buildErrorState(state.message, strings);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailsContent(DetailsModel opportunity, bool isOwner, S strings) {
    final isApplying = context.watch<OpportunityBloc>().state is OpportunityApplying;
    final applied = opportunity.isAlreadyApplied;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                _buildSection(
                  title: strings.requirements,
                  content: _buildRequirementsFromText(opportunity.requirements),
                ),
                SizedBox(height: 20.h),
                _buildSection(
                  title: strings.endDate,
                  content: Text(_formatEndDate(opportunity.endDate)),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
        if (isOwner)
          _buildShowApplicantsButton(strings)
        else
          _buildApplyButton(opportunity, isApplying, applied, strings),
      ],
    );
  }

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
      // decoration: const BoxDecoration(color: Colors.white),
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
      // decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isApplying || applied
                ? null
                : () => _showApplyConfirmation(opportunity, strings),
            style: ElevatedButton.styleFrom(
              backgroundColor: applied ? Colors.grey[600] : Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isApplying
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    applied ? strings.alreadyApplied : strings.applyNow,
                    style: GoogleFonts.poppins(
                      color: applied ?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.onPrimary,
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
              // color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsFromText(String text) {
    final requirements = text
        .split(RegExp(r'\n|•|\*'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return Column(
      children: requirements
          .map(
            (e) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• "),
                Expanded(child: Text(e.trim())),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildErrorState(String message, S strings) {
    return Center(child: Text(message));
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
              style:  TextStyle(color: Theme.of(context).colorScheme.surface),
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