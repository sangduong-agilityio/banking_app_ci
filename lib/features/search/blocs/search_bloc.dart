import 'dart:async';
import 'package:banking_app/core/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/services/offline_exchange_service.dart';
import 'package:banking_app/core/utils/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../repositories/search_repository.dart';

class SearchBloc extends Bloc<SearchEvt, SearchState> {
  SearchBloc({
    required this.repo,
    required ExchangeRateCacheService cacheService,
    required OfflineExchangeService offlineService,
  }) : _cacheService = cacheService,
       super(const SearchState()) {
    on<InterestRateInitializeEvt>(_onInitializeInterestRate);
    on<ExchangeRateInitializeEvt>(_onInitializeExchangeRate);
    on<ExchangeRateRefreshEvt>(_onRefreshExchangeRate);
    on<ExchangeInitializeEvt>(_onInitializeExchange);
    on<ExchangeRateChangedEvt>(_onExchangeRateChanged);
    on<ConvertCurrencyEvt>(_onConvertCurrency);
    on<SwapCurrenciesEvt>(_onSwapCurrencies);
    on<SelectCurrencyEvt>(_onSelectCurrency);
  }

  final SearchRepository repo;
  final ExchangeRateCacheService _cacheService;
  Timer? _refreshTimer;

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

  /// Initialize and fetch interest rates
  Future<void> _onInitializeExchangeRate(
    ExchangeRateInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: const SearchStatus.loading()));

    try {
      final isFromCache = _cacheService.isCacheValid();
      final exchangeRates = await repo.fetchExchangeRates();
      final lastUpdated = _cacheService.getLastUpdatedTime();

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: isFromCache,
          status: const SearchStatus.success(),
        ),
      );

      /// Start auto-refresh timer
      _startAutoRefreshTimer();
    } catch (_) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  /// Refresh exchange rates, either forced or from cache
  Future<void> _onRefreshExchangeRate(
    ExchangeRateRefreshEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (!event.forceRefresh && state.exchangeRates != null) {
    } else {
      emit(state.copyWith(status: const SearchStatus.loading()));
    }

    try {
      final exchangeRates = await repo.fetchExchangeRates(
        forceRefresh: event.forceRefresh,
      );
      final lastUpdated = _cacheService.getLastUpdatedTime();

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: false,
          status: const SearchStatus.success(),
        ),
      );
    } catch (_) {
      if (state.exchangeRates != null) {
        emit(state.copyWith(status: const SearchStatus.success()));
      } else {
        emit(state.copyWith(status: const SearchStatus.failure()));
      }
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

  /// Fetches the exchange rate when the user changes the \"from\" or \"to\" currency.
  ///
  /// This method first checks if the selected currencies are the same, in which case
  /// the exchange rate is set to 1.0. Otherwise, it attempts to fetch the exchange
  /// rate from the repository.
  ///
  /// If the fetch is successful, the new rate is cached using the `OfflineExchangeService`.
  /// If the fetch fails, the method checks for a cached rate in the `OfflineExchangeService`.
  ///
  /// The status of the exchange rate (fresh, stale, or no data) is also determined
  /// and updated in the state.
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
          exchangeRateStatus: ExchangeRateStatus.fresh,
          lastExchangeRateUpdate: DateTime.now(),
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

      final rateStatus = repo.getRateStatus(
        event.fromCurrency,
        event.toCurrency,
      );

      final lastUpdate = repo.getLastRateUpdate(
        event.fromCurrency,
        event.toCurrency,
      );

      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: rate,
          exchangeRateStatus: rateStatus,
          lastExchangeRateUpdate: lastUpdate ?? DateTime.now(),
        ),
      );

      _recalculateAmounts(emit, rate);
    } catch (error) {
      /// Failed to fetch exchange rate
      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: null,
          exchangeRateStatus: ExchangeRateStatus.noData,
          lastExchangeRateUpdate: null,
        ),
      );
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
    if (rate == null || rate <= 0) {
      return;
    }

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

  /// Start a timer to auto-refresh exchange rates every 5 minutes
  void _startAutoRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!isClosed) {
        add(const ExchangeRateRefreshEvt());
      }
    });
  }
}
