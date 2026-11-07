import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news/modules/layout/view/cubit/states.dart';

import '../../../../core/categorise/app_categories.dart';
import '../../data/models/news_response.dart';
import '../../data/models/sources_response.dart';
import '../../data/repo/repo.dart';


@injectable
class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(this.repo) : super(InitState());

  AppCategory? selectedCategory;
  Sources? selectedSource;

  List<Sources> sources = [];
  List<Articles> articles = [];

  Repo repo;

  void onChanceCategory(AppCategory category) {
    selectedCategory = category;
    getSources();
    emit(ChangeCategoryState());
  }

  void goToHome() {
    selectedCategory = null;
    sources = [];
    articles = [];
    selectedSource = null;
    emit(GoToHomeState());
  }

  void onChangeSource(Sources source) {
    selectedSource = source;
    articles = [];
    getNews();
    emit(ChangeSourceState());
  }

  Future<void> getSources() async {
    emit(GetSourceLoadingState());
    try {
      sources = await repo.getSources(selectedCategory!.id);
      selectedSource = sources.first;
      getNews();
      emit(GetSourceSuccessState());
    } catch (e) {
      getNews();
      emit(GetSourceErrorState(e.toString()));
      print(e.toString());
    }
  }

  Future<void> getNews() async {
    emit(GetNewsLoadingState());
    try {
      articles = await repo.getNews(selectedSource?.id ?? "");
      emit(GetNewsSuccessState());
    } catch (e) {
      emit(GetNewsErrorState(e.toString()));

      print(e.toString());
    }
  }
}
