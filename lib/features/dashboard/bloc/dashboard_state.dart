import 'package:banking_app/features/dashboard/models/card_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

class DashBoardState extends Equatable {
  const DashBoardState({
    this.status = const DashBoardStatus.initial(),
    this.cards,
    this.defaultCard,
    this.errorMessage,
    this.existingCards,
    this.updatingCardId,
    this.deletingCardId,
    this.message,
  });
  final DashBoardStatus status;
  final List<CardModel>? cards;
  final CardModel? defaultCard;
  final String? errorMessage;
  final List<CardModel>? existingCards;
  final String? updatingCardId;
  final String? deletingCardId;
  final String? message;

  DashBoardState copyWith({
    DashBoardStatus? status,
    List<CardModel>? cards,
    CardModel? defaultCard,
    String? errorMessage,
    List<CardModel>? existingCards,
    String? updatingCardId,
    String? deletingCardId,
    String? message,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      defaultCard: defaultCard ?? this.defaultCard,
      errorMessage: errorMessage ?? this.errorMessage,
      existingCards: existingCards ?? this.existingCards,
      updatingCardId: updatingCardId ?? this.updatingCardId,
      deletingCardId: deletingCardId ?? this.deletingCardId,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cards,
    defaultCard,
    errorMessage,
    existingCards,
    updatingCardId,
    deletingCardId,
    message,
  ];
}

@freezed
sealed class DashBoardStatus with _$DashBoardStatus {
  const factory DashBoardStatus.initial() = DashBoardStatusInitial;
  const factory DashBoardStatus.loading() = DashBoardStatusLoading;
  const factory DashBoardStatus.success() = DashBoardStatusSuccess;
  const factory DashBoardStatus.failure() = DashBoardStatusFailure;
}
