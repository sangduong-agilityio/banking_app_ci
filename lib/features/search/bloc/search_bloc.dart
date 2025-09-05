import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../services/search_repository.dart';

class SearchBloc extends Bloc<SearchEvt, SearchState> {
  SearchBloc({required this.repo}) : super(const SearchState()) {
    on<InterestRateInitializeEvt>(_onInitializeInterestRate);
    on<ExchangeRateInitializeEvt>(_onInitializeExchangeRate);
    on<ExchangeInitializeEvt>(_onInitializeExchange);
    on<ExchangeRateChangedEvt>(_onExchangeRateChanged);
    on<ConvertCurrencyEvt>(_onConvertCurrency);
    on<SwapCurrenciesEvt>(_onSwapCurrencies);
    on<SelectCurrencyEvt>(_onSelectCurrency);
  }

  final SearchRepository repo;

  Future<void> _onInitializeInterestRate(
    InterestRateInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: const SearchStatus.loading()));
    try {
      final interestRates = await repo.fetchInterestRates();
      emit(
        state.copyWith(
          interestRates: interestRates,
          status: const SearchStatus.success(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  Future<void> _onInitializeExchangeRate(
    ExchangeRateInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: const SearchStatus.loading()));
    try {
      final exchangeRates = await repo.fetchExchangeRates();
      final currencies = await repo.fetchCurrencies();
      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          currencies: currencies,
          status: const SearchStatus.success(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  Future<void> _onInitializeExchange(
    ExchangeInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
      ),
    );

    add(ExchangeRateChangedEvt(event.fromCurrency, event.toCurrency));
  }

  Future<void> _onExchangeRateChanged(
    ExchangeRateChangedEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (event.fromCurrency == event.toCurrency) {
      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: 1.0,
        ),
      );
      return;
    }

    emit(state.copyWith(status: const SearchStatus.loading()));

    try {
      final exchangeResult = await repo.exchange(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        fromAmount: 1.0,
      );

      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: exchangeResult.exchangeRate,
          status: const SearchStatus.success(),
        ),
      );
    } catch (e) {
      try {
        final rate = state.exchangeRates?.firstWhere(
          (e) => e.country.toUpperCase() == event.toCurrency.toUpperCase(),
          orElse: () => throw Exception('Rate not found'),
        );

        final exchangeRate = double.tryParse(rate!.buy) ?? 1.0;

        emit(
          state.copyWith(
            fromCurrency: event.fromCurrency,
            toCurrency: event.toCurrency,
            exchangeRate: exchangeRate,
            status: const SearchStatus.success(),
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: const SearchStatus.failure()));
      }
    }
  }

  void _onConvertCurrency(ConvertCurrencyEvt event, Emitter<SearchState> emit) {
    if (state.exchangeRate == null || state.exchangeRate == 0) return;

    final converted = event.amount * state.exchangeRate!;
    emit(
      state.copyWith(
        fromAmount: event.amount.toString(),
        toAmount: _formatAmount(converted),
      ),
    );
  }

  void _onSwapCurrencies(SwapCurrenciesEvt event, Emitter<SearchState> emit) {
    if (state.fromCurrency == null || state.toCurrency == null) return;

    final newExchangeRate =
        state.exchangeRate == null || state.exchangeRate == 0
        ? 0.0
        : 1 / state.exchangeRate!;

    emit(
      state.copyWith(
        fromCurrency: state.toCurrency,
        toCurrency: state.fromCurrency,
        fromAmount: state.toAmount,
        toAmount: state.fromAmount,
        exchangeRate: newExchangeRate,
      ),
    );

    add(ExchangeRateChangedEvt(state.toCurrency!, state.fromCurrency!));
  }

  void _onSelectCurrency(SelectCurrencyEvt event, Emitter<SearchState> emit) {
    final newFromCurrency = event.isFromCurrency
        ? event.currency
        : state.fromCurrency;
    final newToCurrency = event.isFromCurrency
        ? state.toCurrency
        : event.currency;

    emit(
      state.copyWith(
        fromCurrency: newFromCurrency,
        toCurrency: newToCurrency,
        fromAmount: null,
        toAmount: null,
      ),
    );

    if (newFromCurrency != null && newToCurrency != null) {
      add(ExchangeRateChangedEvt(newFromCurrency, newToCurrency));
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount.toStringAsFixed(0);
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}
