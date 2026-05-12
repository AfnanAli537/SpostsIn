import 'package:injectable/injectable.dart';
import '../../model/search_result_model.dart';
import '../interface/i_search_data_source.dart';

@injectable
class SearchRepo {
  final ISearchDataSource _dataSource;

  SearchRepo(this._dataSource);

  Future<List<SearchResultModel>> search({
    required String query,
    SearchFilters? filters,
  }) async {
    return await _dataSource.search(query: query, filters: filters);
  }

  Future<List<String>> getLocations() async {
    return await _dataSource.getLocations();
  }

  Future<List<String>> getPositions() async {
    return await _dataSource.getPositions();
  }

  Future<List<String>> getTypesOfPlay() async {
    return await _dataSource.getTypesOfPlay();
  }
}