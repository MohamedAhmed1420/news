import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:news/modules/layout/data/data_source/local_data_source.dart';
import 'package:news/modules/layout/data/data_source/remote_data_source.dart';

import '../models/news_response.dart';
import '../models/sources_response.dart';

abstract class Repo {
  Future<List<Articles>> getNews(String sourceId);
  Future<List<Sources>> getSources(String categoryId);
  Future<List<Articles>> searchNews(String query);
}

@Injectable(as: Repo)
class RepoImp implements Repo {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  RepoImp(this.localDataSource, this.remoteDataSource);

  @override
  Future<List<Articles>> getNews(String sourceId) async {
    final isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      final response = await remoteDataSource.getNews(sourceId);
      if (response.statusCode != 200) throw response.data["message"];
      await localDataSource.saveNews(response.data);
      return NewsResponse.fromJson(response.data).articles ?? [];
    }
    final cached = await localDataSource.getNews();
    if (cached == null) return [];
    return NewsResponse.fromJson(cached).articles ?? [];
  }

  @override
  Future<List<Sources>> getSources(String categoryId) async {
    final response = await remoteDataSource.getSources(categoryId);
    if (response.statusCode != 200) throw response.data["message"];
    return SourcesResponse.fromJson(response.data).sources ?? [];
  }

  @override
  Future<List<Articles>> searchNews(String query) async {
    final response = await remoteDataSource.searchNews(query);
    if (response.statusCode != 200) throw response.data["message"];
    return NewsResponse.fromJson(response.data).articles ?? [];
  }
}
