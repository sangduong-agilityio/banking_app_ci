import 'dart:async';
import 'package:banking_app/core/data/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/common/utils/currency.dart';
import 'package:banking_app/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvt, SearchState> {
  SearchBloc({required this.repo, required CacheManager cacheManager})
    : _cacheManager = cacheManager,
      super(const SearchState()) {
    on<InterestRateInitializeEvt>(_onInitializeInterestRate);
    on<ExchangeRateInitializeEvt>(_onInitializeExchangeRate);
    on<ExchangeRateRefreshEvt>(_onRefreshExchangeRate);
    on<ExchangeInitializeEvt>(_onInitializeExchange);
    on<ExchangeRateChangedEvt>(_onExchangeRateChanged);
    on<ConvertCurrencyEvt>(_onConvertCurrency);
    on<SwapCurrenciesEvt>(_onSwapCurrencies);
    on<SelectCurrencyEvt>(_onSelectCurrency);
    on<CheckConnectivityEvt>(_onCheckConnectivity);
  }

  final SearchRepository repo;
  final CacheManager _cacheManager;
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

  /// Initialize and fetch exchange rates
  Future<void> _onInitializeExchangeRate(
    ExchangeRateInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: const SearchStatus.loading()));

    try {
      final isFromCache = _cacheManager.isExchangeRateCacheValid();
      final exchangeRates = await repo.fetchExchangeRates();
      final lastUpdated = _cacheManager.getLastUpdatedExchangeRateTime();

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: isFromCache,
          status: const SearchStatus.success(),
        ),
      );

      _startAutoRefreshTimer();
    } catch (_) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  /// Refresh exchange rates
  Future<void> _onRefreshExchangeRate(
    ExchangeRateRefreshEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (!event.forceRefresh && state.exchangeRates != null) {
      // Skip loading state if we have data and it's not a forced refresh
    } else {
      emit(state.copyWith(status: const SearchStatus.loading()));
    }

    try {
      final exchangeRates = await repo.fetchExchangeRates(
        forceRefresh: event.forceRefresh,
      );
      final lastUpdated = _cacheManager.getLastUpdatedExchangeRateTime();

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: false,
          status: const SearchStatus.success(),
          isOnline: true,
        ),
      );
    } catch (_) {
      if (state.exchangeRates != null) {
        emit(
          state.copyWith(status: const SearchStatus.success(), isOnline: false),
        );
      } else {
        emit(
          state.copyWith(status: const SearchStatus.failure(), isOnline: false),
        );
      }
    }
  }

  /// Initialize exchange screen
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
          isOnline: true,
        ),
      );

      if (defaultFrom != null && defaultTo != null) {
        add(ExchangeRateChangedEvt(defaultFrom, defaultTo));
      }
    } catch (_) {
      // Try to load cached currencies
      final cachedCurrencies = _cacheManager.getCachedCurrencies();
      if (cachedCurrencies != null && cachedCurrencies.isNotEmpty) {
        final defaultFrom = cachedCurrencies.first.code;
        final defaultTo = cachedCurrencies.length > 1
            ? cachedCurrencies[1].code
            : null;

        emit(
          state.copyWith(
            currencies: cachedCurrencies,
            fromCurrency: defaultFrom,
            toCurrency: defaultTo,
            status: const SearchStatus.success(),
            isOnline: false,
          ),
        );

        if (defaultTo != null) {
          add(ExchangeRateChangedEvt(defaultFrom, defaultTo));
        }
      } else {
        emit(
          state.copyWith(status: const SearchStatus.failure(), isOnline: false),
        );
      }
    }
  }

  /// Fetches the exchange rate when currencies change
  Future<void> _onExchangeRateChanged(
    ExchangeRateChangedEvt event,
    Emitter<SearchState> emit,
  ) async {
    final requestId = state.exchangeRateRequestId + 1;
    emit(state.copyWith(exchangeRateRequestId: requestId));

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

      if (state.exchangeRateRequestId != requestId) return;

      _cacheManager.cacheRate(event.fromCurrency, event.toCurrency, rate);

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
          isOnline: true,
        ),
      );

      _recalculateAmounts(emit, rate);
    } catch (error) {
      if (state.exchangeRateRequestId != requestId) return;

      final cachedRate = _cacheManager.getCachedRate(
        event.fromCurrency,
        event.toCurrency,
      );

      if (cachedRate != null) {
        final rateStatus = _cacheManager.getRateStatus(
          event.fromCurrency,
          event.toCurrency,
        );
        final lastUpdate = _cacheManager.getLastUpdated(
          event.fromCurrency,
          event.toCurrency,
        );

        emit(
          state.copyWith(
            fromCurrency: event.fromCurrency,
            toCurrency: event.toCurrency,
            exchangeRate: cachedRate,
            exchangeRateStatus: rateStatus,
            lastExchangeRateUpdate: lastUpdate,
            isOnline: false,
          ),
        );
        _recalculateAmounts(emit, cachedRate);
      } else {
        emit(
          state.copyWith(
            fromCurrency: event.fromCurrency,
            toCurrency: event.toCurrency,
            exchangeRate: null,
            exchangeRateStatus: ExchangeRateStatus.noData,
            lastExchangeRateUpdate: null,
            isOnline: false,
          ),
        );
      }
    }
  }

  /// Check connectivity and retry if back online
  Future<void> _onCheckConnectivity(
    CheckConnectivityEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (event.isOnline && !state.isOnline) {
      // Just came back online, refresh data
      add(const ExchangeRateRefreshEvt(forceRefresh: true));

      // If we're on exchange screen, refresh the current rate
      if (state.fromCurrency != null && state.toCurrency != null) {
        add(ExchangeRateChangedEvt(state.fromCurrency!, state.toCurrency!));
      }
    }

    emit(state.copyWith(isOnline: event.isOnline));
  }

  /// Recalculate amounts based on exchange rate
  void _recalculateAmounts(Emitter<SearchState> emit, double rate) {
    final newToAmount = CurrencyUtils.convertFromTo(state.fromAmount, rate);
    final newFromAmount = CurrencyUtils.convertToFrom(state.toAmount, rate);

    if (newToAmount != null) {
      emit(state.copyWith(toAmount: newToAmount));
    } else if (newFromAmount != null) {
      emit(state.copyWith(fromAmount: newFromAmount));
    }
  }

  /// Handle currency conversion
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

  /// Swap currencies
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

  /// Handle currency selection
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

  /// Start auto-refresh timer
  void _startAutoRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!isClosed) {
        add(const ExchangeRateRefreshEvt());
      }
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
