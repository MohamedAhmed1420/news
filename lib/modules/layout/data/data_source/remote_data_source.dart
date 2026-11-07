import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/api_service.dart';

abstract class RemoteDataSource {
  Future<Response> getNews(String sourceId);
  Future<Response> getSources(String categoryId);
  Future<Response> searchNews(String query);
}

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImp extends RemoteDataSource {
  final ApiService apiService;
  RemoteDataSourceImp(this.apiService);

  @override
  Future<Response<dynamic>> getNews(String sourceId) =>
      apiService.dio.get("everything", queryParameters: {"sources": sourceId});

  @override
  Future<Response<dynamic>> getSources(String categoryId) => apiService.dio.get(
    "top-headlines/sources",
    queryParameters: {"category": categoryId},
  );

  @override
  Future<Response<dynamic>> searchNews(String query) => apiService.dio.get(
    "everything",
    queryParameters: {"q": query, "sortBy": "publishedAt"},
  );
}
