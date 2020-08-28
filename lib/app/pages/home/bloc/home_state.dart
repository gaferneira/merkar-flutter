import 'package:equatable/equatable.dart';
import 'package:merkar/domain/entities/category.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends HomeState {}

class Loading extends HomeState {}

class Loaded extends HomeState {
  final List<Category> categories;

  Loaded({@required this.categories}) : super([categories]);
}

class Error extends HomeState {
  final String message;

  Error({@required this.message}) : super([message]);
}
