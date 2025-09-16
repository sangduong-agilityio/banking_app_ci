import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = const HomeStatus.initial(),
    this.user,
    this.errorMessage,
    this.cards = const [],
    this.currentCardIndex = 0,
    this.shouldPlayAnimation = false,
  });

  final HomeStatus status;
  final UserModel? user;
  final List<CardModel> cards;
  final String? errorMessage;
  final int currentCardIndex;
  final bool shouldPlayAnimation;

  HomeState copyWith({
    HomeStatus? status,
    UserModel? user,
    String? errorMessage,
    List<CardModel>? cards,
    int? currentCardIndex,
    bool? shouldPlayAnimation,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      cards: cards ?? this.cards,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      shouldPlayAnimation: shouldPlayAnimation ?? this.shouldPlayAnimation,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    user,
    cards,
    currentCardIndex,
    shouldPlayAnimation,
  ];
}

@freezed
sealed class HomeStatus with _$HomeStatus {
  const factory HomeStatus.initial() = HomeStatusInitial;
  const factory HomeStatus.loading() = HomeStatusLoading;
  const factory HomeStatus.success() = HomeStatusSuccess;
  const factory HomeStatus.failure() = HomeStatusFailure;
}
