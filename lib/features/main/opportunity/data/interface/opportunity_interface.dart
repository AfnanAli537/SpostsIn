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
    required String requirements,
    required String endDate,
    required int sportTypeId,
    String? mediaFile,
    String? mediaUrl,
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
    required String requirements,
    required DateTime endDate,
    required int sportTypeId,
    String? mediaFile,
  });

  Future<void> deleteOpportunity({required String opportunityId});
}
