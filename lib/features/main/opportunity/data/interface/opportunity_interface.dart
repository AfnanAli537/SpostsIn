// import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
// import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
// import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

// abstract class OpportunityInterface {
//   Future<List<OpportunityModel>> getOpportunities({
//     required int pageNumber,
//     int pageSize,
//     String? searchTerm,
//     int? sportTypeId,
//   });
//   Future<void> postOpportunity({
//     required String title,
//     required String description,
//     required String requirements,
//     required String endDate,
//     required int sportTypeId,
//     String? mediaFile,
//     String? mediaUrl,
//   });
//   Future<DetailsModel> opportunityDetails({required String opportunityID});
//   Future<void> applyOpportunity({required String opportunityID});
//   Future<ApplicantsResponseModel> getApplicants({
//     required int pageNumber,
//     int pageSize,
//     required String opportunityID,
//     String? status,
//   });
//   Future<ApplicantsResponseModel> acceptOrRejectApplicant({
//     required String applicationId,
//     required String status,
//   });
//   Future<PaginatedOpportunitiesResponse> getMyOpportunities({
//     required bool showActive,
//     int page = 1,
//     int pageSize = 10,
//   });
//   Future<void> updateOpportunity({
//     required String opportunityId,
//     required String title,
//     required String description,
//     required String requirements,
//     required DateTime endDate,
//     required int sportTypeId,
//     String? mediaFile,
//   });
//   Future<void> toggleOpportunityVisibility({required String opportunityId});
//   Future<void> deleteOpportunity({required String opportunityId});
// }



import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

abstract class OpportunityInterface {
  Future<List<OpportunityModel>> getOpportunities({
    required int pageNumber,
    int pageSize,
    String? searchTerm,
    int? sportTypeId,
  });

  Future<void> postOpportunity({
    required String title,
    required String description,
    required String endDate,
    required int sportTypeId,
    String? additionalNotes,
    String? mediaFile,
    String? mediaUrl,
    // matchCriteria fields
    String? targetUserType,
    String? targetGender,
    int? minAge,
    int? maxAge,
    String? targetLocation,
    String? targetPosition,
    double? minHeight,
    double? maxHeight,
    double? minWeight,
    double? maxWeight,
    String? targetSpecialization,
    int? minExperienceYears,
  });

  Future<DetailsModel> opportunityDetails({required String opportunityID});

  Future<void> applyOpportunity({required String opportunityID});

  Future<ApplicantsResponseModel> getApplicants({
    required int pageNumber,
    int pageSize,
    required String opportunityID,
    String? status,
  });

  Future<ApplicantsResponseModel> acceptOrRejectApplicant({
    required String applicationId,
    required String status,
  });

  Future<PaginatedOpportunitiesResponse> getMyOpportunities({
    required bool showActive,
    int page = 1,
    int pageSize = 10,
  });

  Future<void> updateOpportunity({
    required String opportunityId,
    required String title,
    required String description,
    required DateTime endDate,
    required int sportTypeId,
    String? mediaFile,
  });

  Future<void> toggleOpportunityVisibility({required String opportunityId});

  Future<void> deleteOpportunity({required String opportunityId});

  Future<RecommendationsResponseModel> getRecommendations({
    required String opportunityId,
    int pageNumber = 1,
    int pageSize = 10,
  });
}