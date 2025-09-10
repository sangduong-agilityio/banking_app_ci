import 'package:banking_app/core/utils/currency.dart';
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

  /// Initialize and fetch interest rates
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

  /// Fetch list of exchange rates
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

  /// Initialize exchange screen:
  /// Fetch currencies
  /// Pick default from/to currencies
  Future<void> _onInitializeExchange(
    ExchangeInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: const SearchStatus.loading()));
    try {
      final currencies = await repo.fetchCurrencies();
      final defaultFrom = currencies.isNotEmpty ? currencies.first.code : null;
      final defaultTo = currencies.length > 1 ? currencies[1].code : null;

      emit(
        state.copyWith(
          currencies: currencies,
          fromCurrency: defaultFrom,
          toCurrency: defaultTo,
          status: const SearchStatus.success(),
        ),
      );

      if (defaultFrom != null && defaultTo != null) {
        add(ExchangeRateChangedEvt(defaultFrom, defaultTo));
      }
    } catch (_) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  /// Fetch exchange rate when user changes
  /// "from currency" or "to currency"
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
    } catch (_) {
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

  /// Recalculate amounts based on the current exchange rate
  void _recalculateAmounts(Emitter<SearchState> emit, double rate) {
    final newToAmount = CurrencyUtils.convertFromTo(state.fromAmount, rate);
    final newFromAmount = CurrencyUtils.convertToFrom(state.toAmount, rate);

    if (newToAmount != null) {
      emit(state.copyWith(toAmount: newToAmount));
    } else if (newFromAmount != null) {
      emit(state.copyWith(fromAmount: newFromAmount));
    }
  }

  /// Handle user input for converting currencies
  void _onConvertCurrency(ConvertCurrencyEvt event, Emitter<SearchState> emit) {
    final rate = state.exchangeRate;
    if (rate == null || rate <= 0) return;

    if (event.isFromAmount) {
      final toAmount = CurrencyUtils.convertFromTo(event.amount, rate);
      emit(state.copyWith(fromAmount: event.amount, toAmount: toAmount));
    } else {
      final fromAmount = CurrencyUtils.convertToFrom(event.amount, rate);
      emit(state.copyWith(fromAmount: fromAmount, toAmount: event.amount));
    }
  }

  /// Swap "from" and "to" currencies
  void _onSwapCurrencies(SwapCurrenciesEvt event, Emitter<SearchState> emit) {
    final swapped = CurrencyUtils.swap(
      fromCurrency: state.fromCurrency,
      toCurrency: state.toCurrency,
      fromAmount: state.fromAmount,
      toAmount: state.toAmount,
      exchangeRate: state.exchangeRate,
    );

    emit(
      state.copyWith(
        fromCurrency: swapped.fromCurrency,
        toCurrency: swapped.toCurrency,
        fromAmount: swapped.fromAmount,
        toAmount: swapped.toAmount,
        exchangeRate: swapped.exchangeRate,
      ),
    );

    if (swapped.fromAmount != null &&
        swapped.fromAmount! > 0 &&
        swapped.exchangeRate != null) {
      final recalculatedToAmount = CurrencyUtils.convertFromTo(
        swapped.fromAmount,
        swapped.exchangeRate ?? 0,
      );
      emit(state.copyWith(toAmount: recalculatedToAmount));
    }
  }

  /// Handle selecting currency (from or to)
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
