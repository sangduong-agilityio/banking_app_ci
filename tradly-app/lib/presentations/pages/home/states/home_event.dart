import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class HomeFetchAllEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
