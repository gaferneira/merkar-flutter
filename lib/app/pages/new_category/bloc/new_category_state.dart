import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewCategoryState extends Equatable {
  NewCategoryState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NewCategoryState {}
