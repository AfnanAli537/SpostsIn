import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';

part 'applicants_event.dart';
part 'applicants_state.dart';

class ApplicantsBloc extends Bloc<ApplicantsEvent, ApplicantsState> {
  final OpportunityReposatory repository;

  ApplicantsBloc({required this.repository}) : super(ApplicantsInitial()) {
    on<FetchApplicants>(_onFetchApplicants);
    on<AcceptApplicant>(_onAcceptApplicant);
    on<RejectApplicant>(_onRejectApplicant);
    on<LoadMoreApplicants>(_onLoadMoreApplicants);
  }

  Future<void> _onFetchApplicants(
    FetchApplicants event,
    Emitter<ApplicantsState> emit,
  ) async {
    try {
      emit(ApplicantsLoading());

      final response = await repository.getApplicants(
        opportunityID: event.opportunityId,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        status: event.status,
      );

      emit(ApplicantsLoaded(response: response));
    } catch (e) {
      log(' Error fetching applicants: $e');
      emit(ApplicantsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreApplicants(
    LoadMoreApplicants event,
    Emitter<ApplicantsState> emit,
  ) async {
    if (state is ApplicantsLoaded) {
      final currentState = state as ApplicantsLoaded;

      if (!currentState.response.hasNextPage || currentState.isLoadingMore) {
        return;
      }

      try {
        emit(currentState.copyWith(isLoadingMore: true));

        final response = await repository.getApplicants(
          opportunityID: event.opportunityId,
          pageNumber: currentState.response.pageNumber + 1,
          pageSize: currentState.response.pageSize,
          status: event.status,
        );

        final updatedItems = [
          ...currentState.response.items,
          ...response.items,
        ];

        final updatedResponse = ApplicantsResponseModel(
          items: updatedItems,
          totalCount: response.totalCount,
          pageNumber: response.pageNumber,
          pageSize: response.pageSize,
          totalPages: response.totalPages,
          hasNextPage: response.hasNextPage,
          hasPreviousPage: response.hasPreviousPage,
        );

        emit(ApplicantsLoaded(response: updatedResponse));
      } catch (e) {
        log(' Error loading more applicants: $e');
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onAcceptApplicant(
    AcceptApplicant event,
    Emitter<ApplicantsState> emit,
  ) async {
    final previousState = state;

    try {
      emit(ApplicantActionLoading(event.applicationId));

      await repository.acceptOrRejectApplicant(
        applicationId: event.applicationId,
        status: 'Accepted',
      );

      emit(
        ApplicantActionSuccess(
          message: 'Applicant accepted successfully',
          applicationId: event.applicationId,
        ),
      );
    } catch (e) {
      log(' Error accepting applicant: $e');
      emit(ApplicantsError(e.toString()));
      if (previousState is ApplicantsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onRejectApplicant(
    RejectApplicant event,
    Emitter<ApplicantsState> emit,
  ) async {
    final previousState = state;

    try {
      emit(ApplicantActionLoading(event.applicationId));

      await repository.acceptOrRejectApplicant(
        applicationId: event.applicationId,
        status: 'Rejected',
      );

      emit(
        ApplicantActionSuccess(
          message: 'Applicant rejected successfully',
          applicationId: event.applicationId,
        ),
      );
    } catch (e) {
      log(' Error rejecting applicant: $e');
      emit(ApplicantsError(e.toString()));

      if (previousState is ApplicantsLoaded) {
        emit(previousState);
      }
    }
  }
}
