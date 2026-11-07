// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/layout/data/data_source/local_data_source.dart' as _i344;
import '../../modules/layout/data/data_source/remote_data_source.dart' as _i291;
import '../../modules/layout/data/repo/repo.dart' as _i963;
import '../../modules/layout/view/cubit/cubit.dart' as _i524;
import '../services/api_service.dart' as _i137;
import '../services/hive_service.dart' as _i1047;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i137.ApiService>(() => _i137.ApiService());
    gh.singleton<_i1047.HiveService>(() => _i1047.HiveService());
    gh.factory<_i344.LocalDataSource>(
      () => _i344.LocalDataSourceImp(gh<_i1047.HiveService>()),
    );
    gh.factory<_i291.RemoteDataSource>(
      () => _i291.RemoteDataSourceImp(gh<_i137.ApiService>()),
    );
    gh.factory<_i963.Repo>(
      () => _i963.RepoImp(
        gh<_i344.LocalDataSource>(),
        gh<_i291.RemoteDataSource>(),
      ),
    );
    gh.factory<_i524.LayoutCubit>(() => _i524.LayoutCubit(gh<_i963.Repo>()));
    return this;
  }
}
