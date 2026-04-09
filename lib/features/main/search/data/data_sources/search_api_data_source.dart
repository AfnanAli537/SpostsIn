import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import '../../model/search_result_model.dart';
import '../interface/i_search_data_source.dart';

@LazySingleton(as: ISearchDataSource)
class SearchDataSource implements ISearchDataSource {
  final ApiClient _apiClient; // replace with your actual http client

  SearchDataSource(this._apiClient);
  @override
  Future<List<SearchResultModel>> search({
    required String query,
    SearchFilters? filters,
  }) async {
    final queryParams = <String, dynamic>{
      'Query': query,
      // 'MinAge': filters?.minAge ,
      // 'MaxAge': filters?.maxAge ?? 99,
      'pageNumber': filters?.pageNumber ?? 1,
      'pageSize': filters?.pageSize ?? 20,
    };

    // Only add optional params if they have a value
    if (filters?.minAge != null && filters?.userType?.apiValue == "Player") {
      queryParams['MinAge'] = filters!.minAge;
    }
    if (filters?.maxAge != null && filters?.userType?.apiValue == "Player") {
      queryParams['MaxAge'] = filters!.maxAge;
    }
    if (filters?.location != null && filters!.location!.isNotEmpty) {
      queryParams['Location'] = filters.location;
    }
    if (filters?.position != null && filters!.position!.isNotEmpty) {
      queryParams['Position'] = filters.position;
    }
    if (filters?.sportTypeId != null) {
      queryParams['SportTypeId'] = filters!.sportTypeId;
    }
    if (filters?.userType != null) {
      queryParams['UserType'] = filters!.userType!.apiValue;
    }

    log('🔍 Search params: $queryParams');

    final response = await _apiClient.get(
      Endpoints.search,
      params: queryParams,
    );

    log('✅ Search response: ${response.data}');

    final responseData = response.data;
    List data = [];

    if (responseData is List) {
      data = responseData;
    } else if (responseData is Map) {
      data =
          responseData['data'] ??
          responseData['items'] ??
          responseData['result'] ??
          responseData['results'] ??
          [];
    }

    return data
        .map((e) => SearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // These are now static — no API needed
  @override
  Future<List<String>> getLocations() async => [];

  @override
  Future<List<String>> getPositions() async => [];

  @override
  Future<List<String>> getTypesOfPlay() async => [];
}
