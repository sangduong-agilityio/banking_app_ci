import 'package:banking_app/features/dashboard/models/card_model.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

class DashBoardState extends Equatable {
  const DashBoardState({
    this.status = const DashBoardStatus.initial(),
    this.user,
    this.errorMessage,
    this.cards = const [],
  });

  final DashBoardStatus status;
  final UserModel? user;
  final List<CardModel> cards;
  final String? errorMessage;

  DashBoardState copyWith({
    DashBoardStatus? status,
    UserModel? user,
    String? errorMessage,
    List<CardModel>? cards,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user, cards];
}

@freezed
sealed class DashBoardStatus with _$DashBoardStatus {
  const factory DashBoardStatus.initial() = DashBoardStatusInitial;
  const factory DashBoardStatus.loading() = DashBoardStatusLoading;
  const factory DashBoardStatus.success() = DashBoardStatusSuccess;
  const factory DashBoardStatus.failure() = DashBoardStatusFailure;
}
