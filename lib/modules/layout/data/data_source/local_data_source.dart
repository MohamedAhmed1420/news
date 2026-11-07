import 'package:injectable/injectable.dart';
import 'package:news/core/services/hive_service.dart';

abstract class LocalDataSource {
  Future<void> saveNews(dynamic data);

  Future<dynamic> getNews();
}



@Injectable(as: LocalDataSource)
class LocalDataSourceImp extends LocalDataSource {
  HiveService hiveService;
  LocalDataSourceImp(this.hiveService);

  @override
  Future<dynamic> getNews() async {
    var ref = await hiveService.getRef();
    var box = await ref.openBox("news");
    var data = await box.get("articles");
    ref.close();
    return data;
  }

  @override
  Future<void> saveNews(data) async {
    var ref = await hiveService.getRef();
    var box = await ref.openBox("news");
    await box.put("articles", data);
    ref.close();
  }
}
