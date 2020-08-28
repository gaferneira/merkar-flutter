import 'dart:async';

import 'package:bloc/bloc.dart';

import 'new_category_event.dart';
import 'new_category_state.dart';

class NewCategoryBloc extends Bloc<NewCategoryEvent, NewCategoryState> {
  @override
  NewCategoryState get initialState => Empty();

  @override
  Stream<NewCategoryState> mapEventToState(
    NewCategoryEvent event,
  ) async* {}
}
