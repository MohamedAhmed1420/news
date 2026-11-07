sealed class LayoutState {}


class InitState extends LayoutState{}

class ChangeCategoryState extends LayoutState{}
class GoToHomeState extends LayoutState{}
class ChangeSourceState extends LayoutState{}

class GetSourceLoadingState extends LayoutState{}
class GetSourceSuccessState extends LayoutState{}
class GetSourceErrorState extends LayoutState{
  String error;
  GetSourceErrorState(this.error);
}


class GetNewsLoadingState extends LayoutState{}
class GetNewsSuccessState extends LayoutState{}
class GetNewsErrorState extends LayoutState{
  String error;
  GetNewsErrorState(this.error);
}