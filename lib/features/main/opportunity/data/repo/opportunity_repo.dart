import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/opportunity/data/interface/opportunity_interface.dart';
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

@lazySingleton
class OpportunityReposatory {
  final OpportunityInterface repo;

  OpportunityReposatory(this.repo);
  Future <List<OpportunityModel>>  getOpportunities({required int pageNumber,
   int pageSize=10,String? searchTerm,int? sportTypeId}){
    return repo.getOpportunities(pageNumber: pageNumber,searchTerm: searchTerm,sportTypeId: sportTypeId);
   }

  Future<void> postOpportunity({required String title,required String description,
  required String requirements,
  required String endDate,required int sportTypeId, String? mediaFile,String? mediaUrl}){
     return repo.postOpportunity(title: title, description: description, requirements: requirements, endDate: endDate, sportTypeId: sportTypeId,mediaFile: mediaFile,mediaUrl: mediaUrl);
  }

  Future<DetailsModel> opportunityDetails({required String opportunityID}){ return repo.opportunityDetails(opportunityID: opportunityID);}

  Future<void> applyOpportunity({required String opportunityID }){ return repo.applyOpportunity(opportunityID: opportunityID);}

  Future<ApplicantsResponseModel> getApplicants({required int pageNumber, 
  int pageSize=10,required String opportunityID,String? status }){ return repo.getApplicants(pageNumber: pageNumber, opportunityID: opportunityID,status: status);}
  
  Future <ApplicantsResponseModel> acceptOrRejectApplicant({required String applicationId, required String status}){ return repo.acceptOrRejectApplicant(applicationId: applicationId,status: status);}

}
