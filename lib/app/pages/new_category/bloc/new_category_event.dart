import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewCategoryEvent extends Equatable {
  NewCategoryEvent([List props = const <dynamic>[]]) : super(props);
}
