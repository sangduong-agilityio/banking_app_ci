import 'package:banking_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:banking_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:banking_app/features/dashboard/models/card_model.dart';
import 'package:banking_app/features/dashboard/services/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardBloc extends Bloc<DashBoardEvt, DashBoardState> {
  DashBoardBloc({required this.repo}) : super(const DashBoardState()) {
    on<UserLoadCardEvt>(_onLoadUserCards);
    on<UserAddCardEvt>(_onAddCard);
    on<UserUpdateCardEvt>(_onUpdateCard);
    on<UserDeleteCardEvt>(_onDeleteCard);
    on<UserSetDefaultCard>(_onSetDefaultCard);
    on<UserRefreshCards>(_onRefreshCards);
  }
  final CardRepository repo;

  Future<void> _onLoadUserCards(
    UserLoadCardEvt event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(state.copyWith(status: const DashBoardStatus.loading()));

    try {
      final cards = await repo.getUserCards(event.userId);
      final defaultCard = await repo.getDefaultCard(event.userId);
      emit(
        state.copyWith(
          status: const DashBoardStatus.success(),
          cards: cards,
          defaultCard: defaultCard,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddCard(
    UserAddCardEvt event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(state.copyWith(updatingCardId: event.card.id, message: null));

    try {
      final newCard = await repo.addCard(event.card);
      final updatedCards = List<CardModel>.from(state.cards ?? [])
        ..add(newCard);

      // If this is the first card, make it default
      final defaultCard = state.defaultCard ?? newCard;

      emit(
        state.copyWith(
          status: const DashBoardStatus.success(),
          cards: updatedCards,
          defaultCard: defaultCard,
          updatingCardId: null,
          message: 'Card added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
          updatingCardId: null,
        ),
      );
    }
  }

  Future<void> _onUpdateCard(
    UserUpdateCardEvt event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(state.copyWith(updatingCardId: event.card.id, message: null));

    try {
      final updatedCard = await repo.updateCard(event.card);
      final updatedCards = (state.cards ?? []).map((c) {
        return c.id == updatedCard.id ? updatedCard : c;
      }).toList();

      // Update default card if it was the one updated
      final defaultCard = state.defaultCard?.id == updatedCard.id
          ? updatedCard
          : state.defaultCard;

      emit(
        state.copyWith(
          status: const DashBoardStatus.success(),
          cards: updatedCards,
          defaultCard: defaultCard,
          updatingCardId: null,
          message: 'Card updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
          updatingCardId: null,
        ),
      );
    }
  }

  Future<void> _onDeleteCard(
    UserDeleteCardEvt event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(state.copyWith(deletingCardId: event.cardId, message: null));

    try {
      await repo.deleteCard(event.cardId);
      final updatedCards = (state.cards ?? [])
          .where((card) => card.id != event.cardId)
          .toList();

      // If deleted card was default, set new default
      CardModel? defaultCard = state.defaultCard;
      if (defaultCard?.id == event.cardId) {
        defaultCard = updatedCards.isNotEmpty ? updatedCards.first : null;
        if (defaultCard != null) {
          await repo.updateCard(defaultCard.copyWith(isDefault: true));
        }
      }

      final newState = updatedCards.isEmpty
          ? const DashBoardState(
              status: DashBoardStatus.success(),
              cards: [],
              defaultCard: null,
              message: 'Card deleted successfully',
            )
          : state.copyWith(
              status: const DashBoardStatus.success(),
              cards: updatedCards,
              defaultCard: defaultCard,
              message: 'Card deleted successfully',
            );

      emit(newState.copyWith(deletingCardId: null));
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
          deletingCardId: null,
        ),
      );
    }
  }

  Future<void> _onSetDefaultCard(
    UserSetDefaultCard event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(state.copyWith(updatingCardId: event.cardId, message: null));

    try {
      final cardToSetDefault = (state.cards ?? []).firstWhere(
        (card) => card.id == event.cardId,
      );

      // Update previous default card
      if (state.defaultCard != null && state.defaultCard!.id != event.cardId) {
        final previousDefault = state.defaultCard!;
        await repo.updateCard(previousDefault.copyWith(isDefault: false));
      }

      // Set new default card
      final updatedCard = await repo.updateCard(
        cardToSetDefault.copyWith(isDefault: true),
      );
      final updatedCards = (state.cards ?? []).map((c) {
        return c.id == updatedCard.id ? updatedCard : c;
      }).toList();

      emit(
        state.copyWith(
          status: const DashBoardStatus.success(),
          cards: updatedCards,
          defaultCard: updatedCard,
          updatingCardId: null,
          message: 'Default card set successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
          updatingCardId: null,
        ),
      );
    }
  }

  Future<void> _onRefreshCards(
    UserRefreshCards event,
    Emitter<DashBoardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: const DashBoardStatus.loading(),
        message: null,
        errorMessage: null,
      ),
    );

    try {
      final cards = await repo.getUserCards(event.userId);
      final defaultCard = await repo.getDefaultCard(event.userId);
      emit(
        state.copyWith(
          status: const DashBoardStatus.success(),
          cards: cards,
          defaultCard: defaultCard,
          message: 'Cards refreshed successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const DashBoardStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
