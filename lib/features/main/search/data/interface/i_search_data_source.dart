import '../../model/search_result_model.dart';

abstract class ISearchDataSource {
  Future<List<SearchResultModel>> search({
    required String query,
    SearchFilters? filters,
  });
  
  Future<List<String>> getLocations();
  Future<List<String>> getPositions();
  Future<List<String>> getTypesOfPlay();
}