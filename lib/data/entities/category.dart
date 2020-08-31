import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Category extends Equatable {
  final String name;

  Category({
    @required this.name,
  }) : super([name]);
}
