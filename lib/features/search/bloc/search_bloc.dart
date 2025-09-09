import 'package:banking_app/core/utils/helpers.dart';
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
      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
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
    final currencies = await repo.fetchCurrencies();
    emit(
      state.copyWith(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        currencies: currencies,
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
      _recalculateAmounts(emit, 1.0);
      return;
    }

    try {
      final rate = await repo.convertCurrency(
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        amount: 1.0,
      );

      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: rate,
        ),
      );

      _recalculateAmounts(emit, rate);
    } catch (e) {
      final fallbackRate = DefaultRates.getRate(
        event.fromCurrency,
        event.toCurrency,
      );

      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: fallbackRate,
        ),
      );

      _recalculateAmounts(emit, fallbackRate ?? 0);
    }
  }

  void _recalculateAmounts(Emitter<SearchState> emit, double rate) {
    if (rate <= 0) return;

    final currentFromAmount = state.fromAmount;
    final currentToAmount = state.toAmount;

    if (currentFromAmount != null && currentFromAmount > 0) {
      final newToAmount = double.parse(
        (currentFromAmount * rate).toStringAsFixed(2),
      );
      emit(state.copyWith(toAmount: newToAmount));
    } else if (currentToAmount != null && currentToAmount > 0) {
      final newFromAmount = double.parse(
        (currentToAmount / rate).toStringAsFixed(2),
      );
      emit(state.copyWith(fromAmount: newFromAmount));
    }
  }

  void _onConvertCurrency(ConvertCurrencyEvt event, Emitter<SearchState> emit) {
    final rate = state.exchangeRate;
    if (rate == null || rate <= 0) return;

    if (event.isFromAmount) {
      final toAmount = event.amount > 0 ? event.amount * rate : null;
      emit(state.copyWith(fromAmount: event.amount, toAmount: toAmount));
    } else {
      final fromAmount = event.amount > 0 ? event.amount / rate : null;
      emit(state.copyWith(fromAmount: fromAmount, toAmount: event.amount));
    }
  }

  void _onSwapCurrencies(SwapCurrenciesEvt event, Emitter<SearchState> emit) {
    if (state.fromCurrency == null || state.toCurrency == null) return;

    final newFromCurrency = state.toCurrency!;
    final newToCurrency = state.fromCurrency!;

    final newFromAmount = state.toAmount;
    final newToAmount = state.fromAmount;

    final newExchangeRate =
        state.exchangeRate != null && state.exchangeRate! > 0
        ? 1 / state.exchangeRate!
        : state.exchangeRate;

    emit(
      state.copyWith(
        fromCurrency: newFromCurrency,
        toCurrency: newToCurrency,
        fromAmount: newFromAmount,
        toAmount: newToAmount,
        exchangeRate: newExchangeRate,
      ),
    );

    if (newFromAmount != null && newFromAmount > 0 && newExchangeRate != null) {
      final recalculatedToAmount = double.parse(
        (newFromAmount * newExchangeRate).toStringAsFixed(2),
      );
      emit(state.copyWith(toAmount: recalculatedToAmount));
    }
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
}
