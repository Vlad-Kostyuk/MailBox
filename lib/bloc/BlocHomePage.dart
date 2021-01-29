import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(HomePageState initialState) : super(initialState);

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) {
    if(event is HomePageLoadedEvent) {

    }
  }

}


//--------State--------

abstract class HomePageState {}

class HomePageEmptyState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {}

class HomePageErrorState extends HomePageState {}

//---------------------


//--------Event--------

abstract class HomePageEvent {}

class HomePageLoadedEvent extends HomePageEvent {}

//---------------------