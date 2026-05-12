import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart';

part 'opportunity_event.dart';
part 'opportunity_state.dart';

@injectable
class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  final OpportunityReposatory opportunityRepo;
  final IProfileDataSource profileRepo;
  final prefs = getIt<SharedPref>();

  String? _currentSearchTerm;
  int? _currentSportTypeId;
  String? _currentSportName;

  OpportunityBloc({required this.opportunityRepo, required this.profileRepo})
    : super(OpportunityInitial()) {
    on<FetchOpportunities>(_onFetchOpportunities);
    on<UpdateSearchTerm>(_onUpdateSearchTerm);
    on<UpdateSportFilter>(_onUpdateSportFilter);
    on<ClearFilters>(_onClearFilters);
    on<CreateOpportunity>(_onCreateOpportunity);
    on<FetchOpportunityDetails>(_onFetchOpportunityDetails);
    on<ApplyToOpportunity>(_onApplyToOpportunity);
    on<UpdateOpportunity>(_onUpdateOpportunity);
    on<DeleteOpportunity>(_onDeleteOpportunity);
    on<FetchMyOpportunities>(_onFetchMyOpportunities);
    on<ToggleOpportunityVisibility>(_onToggleOpportunityVisibility);
    on<LoadMoreMyOpportunities>(_onLoadMoreMyOpportunities);
  }

  String? get currentUserId => prefs.getUserId();

  Future<void> _onFetchOpportunities(
    FetchOpportunities event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      if (event.isRefresh || state is! OpportunityLoaded) {
        emit(OpportunityLoading());
        if (event.userId != null) {
      // ── Profile user opportunities (uses MyOpportunities* states) ──────
      if (event.isRefresh || state is! MyOpportunitiesLoaded) {
        emit(MyOpportunitiesLoading());
      } else {
        final currentState = state;
        if (currentState is MyOpportunitiesLoaded) {
          emit(MyOpportunitiesLoadingMore(currentState.opportunities));
        } else {
          emit(MyOpportunitiesLoading());
        }
      }

      final int page;
      if (event.isRefresh || state is! MyOpportunitiesLoaded) {
        page = 1;
      } else {
        final currentState = state;
        page = currentState is MyOpportunitiesLoaded
            ? currentState.currentPage + 1
            : 1;
      }

      final response = await profileRepo.getOpportunities(
        userId: event.userId!,
        page: page,
        pageSize: 10,
      );

      log('Fetched ${response.items.length} opportunities for user ${event.userId}');

      List<OpportunityModel> allOpps;
      if (page == 1) {
        allOpps = response.items;
      } else {
        final currentState = state;
        if (currentState is MyOpportunitiesLoaded) {
          allOpps = [...currentState.opportunities, ...response.items];
        } else if (currentState is MyOpportunitiesLoadingMore) {
          allOpps = [...currentState.currentOpportunities, ...response.items];
        } else {
          allOpps = response.items;
        }
      }

      emit(
        MyOpportunitiesLoaded(
          opportunities: allOpps,
          hasMore: response.hasNextPage,
          currentPage: page,
        ),
      );
    } else {
      // ── General opportunities feed ────────────────────────────────────
      if (event.isRefresh || state is! OpportunityLoaded) {
        emit(OpportunityLoading());

        final opportunities = await opportunityRepo.getOpportunities(
          pageNumber: 1,
          searchTerm: _currentSearchTerm,
          sportTypeId: _currentSportTypeId,
        );

        log('Fetched ${opportunities.length} opportunities');

        emit(
          OpportunityLoaded(
            opportunities: opportunities,
            hasNextPage: opportunities.length >= 10,
            currentPage: 1,
            totalCount: opportunities.length,
            searchTerm: _currentSearchTerm,
            sportTypeId: _currentSportTypeId,
            sportName: _currentSportName,
          ),
        );
      } else {
          final opportunities = await opportunityRepo.getOpportunities(
            pageNumber: 1,
            searchTerm: _currentSearchTerm,
            sportTypeId: _currentSportTypeId,
          );

          log(' Fetched ${opportunities.length} opportunities');

          emit(
            OpportunityLoaded(
              opportunities: opportunities,
              hasNextPage: opportunities.length >= 10,
              currentPage: 1,
              totalCount: opportunities.length,
              searchTerm: _currentSearchTerm,
              sportTypeId: _currentSportTypeId,
              sportName: _currentSportName,
            ),
          );
        }}
      } else {
        final currentState = state;
        if (currentState is OpportunityLoaded) {
          if (!currentState.hasNextPage) return;

          emit(OpportunityLoadingMore(currentState.opportunities));

          final nextPage = currentState.currentPage + 1;
          final newOpportunities = await opportunityRepo.getOpportunities(
            pageNumber: nextPage,
            searchTerm: _currentSearchTerm,
            sportTypeId: _currentSportTypeId,
          );

          log(
            ' Fetched ${newOpportunities.length} more opportunities (page $nextPage)',
          );

          final allOpportunities = [
            ...currentState.opportunities,
            ...newOpportunities,
          ];

          emit(
            OpportunityLoaded(
              opportunities: allOpportunities,
              hasNextPage: newOpportunities.length >= 10,
              currentPage: nextPage,
              totalCount: allOpportunities.length,
              searchTerm: _currentSearchTerm,
              sportTypeId: _currentSportTypeId,
              sportName: _currentSportName,
            ),
          );
        }
      }
    } catch (e) {
      log('Error fetching opportunities: $e');
      emit(
        OpportunityError(
          'Failed to load opportunities: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateSearchTerm(
    UpdateSearchTerm event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      _currentSearchTerm = event.searchTerm.isEmpty ? null : event.searchTerm;

      emit(OpportunityLoading());

      final opportunities = await opportunityRepo.getOpportunities(
        pageNumber: 1,
        searchTerm: _currentSearchTerm,
        sportTypeId: _currentSportTypeId,
      );

      log(
        ' Search results: ${opportunities.length} opportunities for "${event.searchTerm}"',
      );

      emit(
        OpportunityLoaded(
          opportunities: opportunities,
          hasNextPage: opportunities.length >= 10,
          currentPage: 1,
          totalCount: opportunities.length,
          searchTerm: _currentSearchTerm,
          sportTypeId: _currentSportTypeId,
          sportName: _currentSportName,
        ),
      );
    } catch (e) {
      log('Error searching opportunities: $e');
      emit(
        OpportunityError(
          'Failed to search opportunities: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateSportFilter(
    UpdateSportFilter event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      _currentSportTypeId = event.sportTypeId;
      _currentSportName = event.sportName;

      emit(OpportunityLoading());

      final opportunities = await opportunityRepo.getOpportunities(
        pageNumber: 1,
        searchTerm: _currentSearchTerm,
        sportTypeId: _currentSportTypeId,
      );

      log(
        ' Filter by sport: ${opportunities.length} opportunities for "${event.sportName}"',
      );

      emit(
        OpportunityLoaded(
          opportunities: opportunities,
          hasNextPage: opportunities.length >= 10,
          currentPage: 1,
          totalCount: opportunities.length,
          searchTerm: _currentSearchTerm,
          sportTypeId: _currentSportTypeId,
          sportName: _currentSportName,
        ),
      );
    } catch (e) {
      log('Error filtering opportunities: $e');
      emit(
        OpportunityError(
          'Failed to filter opportunities: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      _currentSearchTerm = null;
      _currentSportTypeId = null;
      _currentSportName = null;

      emit(OpportunityLoading());

      final opportunities = await opportunityRepo.getOpportunities(
        pageNumber: 1,
      );

      log(' Filters cleared: ${opportunities.length} opportunities');

      emit(
        OpportunityLoaded(
          opportunities: opportunities,
          hasNextPage: opportunities.length >= 10,
          currentPage: 1,
          totalCount: opportunities.length,
        ),
      );
    } catch (e) {
      log('Error clearing filters: $e');
      emit(
        OpportunityError(
          'Failed to load opportunities: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCreateOpportunity(
    CreateOpportunity event,
    Emitter<OpportunityState> emit,
  ) async {
    emit(OpportunityCreating());
    try {
      await opportunityRepo.postOpportunity(
        title: event.title,
        description: event.description,
        endDate: event.endDate,
        sportTypeId: event.sportTypeId,
        additionalNotes: event.additionalNotes,
        mediaFile: event.mediaFile,
        targetUserType: event.targetUserType,
        targetGender: event.targetGender,
        minAge: event.minAge,
        maxAge: event.maxAge,
        targetLocation: event.targetLocation,
        targetPosition: event.targetPosition,
        minHeight: event.minHeight,
        maxHeight: event.maxHeight,
        minWeight: event.minWeight,
        maxWeight: event.maxWeight,
        targetSpecialization: event.targetSpecialization,
        minExperienceYears: event.minExperienceYears,
        preferredClubExperience: event.preferredClubExperience,
        requiredCertifications: event.requiredCertifications,
      );
      emit(OpportunityCreated());

      log(' Opportunity created successfully');

      emit(const OpportunityCreated());

      await Future.delayed(const Duration(milliseconds: 500));
      add(const FetchOpportunities(isRefresh: true));
    } catch (e) {
      log('Error creating opportunity: $e');
      emit(
        OpportunityError(
          'Failed to create opportunity: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onFetchOpportunityDetails(
    FetchOpportunityDetails event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      emit(OpportunityDetailsLoading());

      final opportunity = await opportunityRepo.opportunityDetails(
        opportunityID: event.opportunityId,
      );

      log(' Fetched opportunity details: ${opportunity.title}');

      emit(OpportunityDetailsLoaded(opportunity: opportunity));
    } catch (e) {
      log('Error fetching opportunity details: $e');
      emit(
        OpportunityError(
          'Failed to load opportunity details: ${e is ApiException ? e.message : e.toString()}',
        ),
      );
    }
  }

  Future<void> _onApplyToOpportunity(
    ApplyToOpportunity event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      emit(OpportunityApplying());

      await opportunityRepo.applyOpportunity(
        opportunityID: event.opportunityId,
      );

      log(' Applied to opportunity successfully');

      emit(const OpportunityApplied());
    } catch (e) {
      log(' Error applying to opportunity: $e');
      emit(OpportunityError('Failed to apply to opportunity: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMyOpportunities(
    FetchMyOpportunities event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      // Emit loading states
      if (event.page == 1) {
        emit(MyOpportunitiesLoading());
      } else {
        final currentState = state;
        if (currentState is MyOpportunitiesLoaded) {
          emit(MyOpportunitiesLoadingMore(currentState.opportunities));
        } else {
          emit(MyOpportunitiesLoading());
        }
      }

      final response = await opportunityRepo.getMyOpportunities(
        showActive: event.showActive,
        page: event.page,
        pageSize: event.pageSize,
      );

      List<OpportunityModel> allOpps;
      if (event.page == 1) {
        allOpps = response.items;
      } else {
        final currentState = state;
        if (currentState is MyOpportunitiesLoaded) {
          allOpps = [...currentState.opportunities, ...response.items];
        } else if (currentState is MyOpportunitiesLoadingMore) {
          allOpps = [...currentState.currentOpportunities, ...response.items];
        } else {
          allOpps = response.items;
        }
      }

      emit(
        MyOpportunitiesLoaded(
          opportunities: allOpps,
          hasMore: response.hasNextPage,
          currentPage: event.page,
        ),
      );
    } catch (e) {
      emit(OpportunityError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMoreMyOpportunities(
    LoadMoreMyOpportunities event,
    Emitter<OpportunityState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyOpportunitiesLoaded && currentState.hasMore) {
      // Dispatch a FetchMyOpportunities with the next page
      add(
        FetchMyOpportunities(
          showActive: event.showActive,
          page: currentState.currentPage + 1,
          pageSize: 10, // use default or stored
        ),
      );
    }
  }

  Future<void> _onUpdateOpportunity(
    UpdateOpportunity event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      emit(OpportunityLoading());

      await opportunityRepo.updateOpportunity(
        id: event.opportunityId,
        title: event.title,
        description: event.description,
        endDate: event.endDate,
        sportTypeId: event.sportTypeId,
        additionalNotes: event.additionalNotes,
        mediaFile: event.mediaFile,
        targetUserType: event.targetUserType,
        targetGender: event.targetGender,
        minAge: event.minAge,
        maxAge: event.maxAge,
        targetLocation: event.targetLocation,
        targetPosition: event.targetPosition,
        minHeight: event.minHeight,
        maxHeight: event.maxHeight,
        minWeight: event.minWeight,
        maxWeight: event.maxWeight,
        targetSpecialization: event.targetSpecialization,
        minExperienceYears: event.minExperienceYears,
        preferredClubExperience: event.preferredClubExperience,
        requiredCertifications: event.requiredCertifications,
      );

      emit(OpportunityUpdated(opportunityId: event.opportunityId));
    } catch (e) {
      emit(OpportunityError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onDeleteOpportunity(
    DeleteOpportunity event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      emit(OpportunityLoading());

      await opportunityRepo.deleteOpportunity(event.opportunityId);

      emit(OpportunityDeleted(opportunityId: event.opportunityId));
    } catch (e) {
      emit(OpportunityError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onToggleOpportunityVisibility(
    ToggleOpportunityVisibility event,
    Emitter<OpportunityState> emit,
  ) async {
    try {
      emit(OpportunityLoading());

      await opportunityRepo.toggleOpportunityVisibility(
        opportunityId: event.opportunityId,
      );

      emit(OpportunityToggeled(opportunityId: event.opportunityId));
    } catch (e) {
      emit(OpportunityError(e is ApiException ? e.message : e.toString()));
    }
  }
}
