import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:merkar/domain/base/usecase.dart';
import 'package:merkar/domain/entities/category.dart';
import 'package:merkar/domain/entities/error/failures.dart';
import 'package:merkar/domain/usecases/get_categories.dart';
import 'package:meta/meta.dart';

import 'home_event.dart';
import 'home_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  HomeBloc({@required this.getCategoriesUseCase});

  @override
  HomeState get initialState => Loading();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetCategories) {
      yield Loading();
      final failureOrTrivia = await getCategoriesUseCase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<HomeState> _eitherLoadedOrErrorState(
    Either<Failure, List<Category>> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (categories) => Loaded(categories: categories),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
