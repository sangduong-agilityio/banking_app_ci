import 'package:equatable/equatable.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/setting/data/models/user_model.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure,
}
/// Represents the state of the home screen.
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
    this.errorMessage,
    this.cards = const [],
    this.currentCardIndex = 0,
    this.shouldPlayAnimation = false,
    this.isBalanceVisible = true,
  });

  final HomeStatus status;
  final UserModel? user;
  final List<CardModel> cards;
  final String? errorMessage;
  final int currentCardIndex;
  final bool shouldPlayAnimation;
  final bool isBalanceVisible;

  HomeState copyWith({
    HomeStatus? status,
    UserModel? user,
    List<CardModel>? cards,
    String? errorMessage,
    int? currentCardIndex,
    bool? shouldPlayAnimation,
    bool? isBalanceVisible,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      cards: cards ?? this.cards,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      shouldPlayAnimation: shouldPlayAnimation ?? this.shouldPlayAnimation,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
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
    isBalanceVisible,
  ];
}

