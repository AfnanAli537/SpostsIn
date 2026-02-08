import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

abstract class OpportunityInterface {
 Future <List<OpportunityModel>>  getOpportunities({required int pageNumber,
  int pageSize,String? searchTerm,int? sportTypeId});
  Future<void> postOpportunity({required String title,required String description,
  required String requirements,required String endDate,required int sportTypeId, String? mediaFile,String? mediaUrl});
  Future<DetailsModel> opportunityDetails({required String opportunityID});
  Future<void> applyOpportunity({required String opportunityID });
  // Future<> getApplicants({required int pageNumber, int pageSize,required String opportunityID,String? status });
  // Future <> acceptOrRejectApplicant({required String applicationId,String? status});
}