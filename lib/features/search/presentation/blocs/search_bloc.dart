import 'dart:async';
import 'package:banking_app/core/data/services/exchange_cache_manager.dart';
import 'package:banking_app/core/common/utils/currency.dart';
import 'package:banking_app/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvt, SearchState> {
  SearchBloc({
    required this.repo,
    required ExchangeCacheManager cacheManager,
  })  : _cacheManager = cacheManager,
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

    // REMOVED: Immediate stream subscription
    // The connectivity stream will be subscribed to only when needed
  }

  final SearchRepository repo;
  final ExchangeCacheManager _cacheManager;

  Timer? _refreshTimer;
  StreamSubscription<bool>? _connectivitySub;

  /// Call this method to start listening to connectivity changes
  /// Only call this when the search screen is actually opened
  void startConnectivityListener(Stream<bool> connectivityStream) {
    if (_connectivitySub != null) return; // Already subscribed

    _connectivitySub = connectivityStream.listen((isOnline) {
      add(CheckConnectivityEvt(isOnline));
    });
  }

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
    } catch (e) {
      emit(state.copyWith(status: const SearchStatus.failure()));
    }
  }

  Future<void> _onInitializeExchangeRate(
    ExchangeRateInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (state.exchangeRates == null || state.exchangeRates!.isEmpty) {
      emit(state.copyWith(status: const SearchStatus.loading()));
    }

    try {
      final isFromCache = _cacheManager.isRateCacheValid;
      final exchangeRates = await repo.fetchExchangeRates();
      final lastUpdated = _cacheManager.rateCacheLastUpdated;

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: isFromCache,
          status: const SearchStatus.success(),
        ),
      );

      _startAutoRefreshTimer();
    } catch (e) {
      final cached = _cacheManager.getCachedRates();
      if (cached.isNotEmpty) {
        emit(
          state.copyWith(
            exchangeRates: cached,
            lastUpdated: _cacheManager.rateCacheLastUpdated,
            isFromCache: true,
            status: const SearchStatus.success(),
          ),
        );
        _startAutoRefreshTimer();
      } else {
        emit(state.copyWith(status: const SearchStatus.failure()));
      }
    }
  }

  Future<void> _onRefreshExchangeRate(
    ExchangeRateRefreshEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (event.forceRefresh ||
        state.exchangeRates == null ||
        state.exchangeRates!.isEmpty) {
      emit(state.copyWith(status: const SearchStatus.loading()));
    }

    try {
      final exchangeRates = await repo.fetchExchangeRates(
        forceRefresh: event.forceRefresh,
      );
      final lastUpdated = _cacheManager.rateCacheLastUpdated;

      emit(
        state.copyWith(
          exchangeRates: exchangeRates,
          lastUpdated: lastUpdated,
          isFromCache: false,
          status: const SearchStatus.success(),
        ),
      );
    } catch (e) {
      if (state.exchangeRates != null && state.exchangeRates!.isNotEmpty) {
        emit(state.copyWith(status: const SearchStatus.success()));
      } else {
        emit(state.copyWith(status: const SearchStatus.failure()));
      }
    }
  }

  Future<void> _onInitializeExchange(
    ExchangeInitializeEvt event,
    Emitter<SearchState> emit,
  ) async {
    if (state.currencies == null || state.currencies!.isEmpty) {
      emit(state.copyWith(status: const SearchStatus.loading()));
    }

    try {
      final currencies = await repo.fetchCurrencies();
      final defaultFrom =
          event.fromCurrency ??
          (currencies.isNotEmpty ? currencies.first.code : null);
      final defaultTo =
          event.toCurrency ??
          (currencies.length > 1 ? currencies[1].code : null);

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
    } catch (e) {
      final cachedCurrencies = _cacheManager.getCachedCurrencies();
      if (cachedCurrencies.isNotEmpty) {
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
          ),
        );

        if (defaultTo != null) {
          add(ExchangeRateChangedEvt(defaultFrom, defaultTo));
        }
      } else {
        emit(state.copyWith(status: const SearchStatus.failure()));
      }
    }
  }

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

      _cacheManager.cacheOfflineRate(
        from: event.fromCurrency,
        to: event.toCurrency,
        rate: rate,
      );

      final rateStatus =
          _cacheManager.hasOfflineRate(event.fromCurrency, event.toCurrency)
              ? ExchangeRateStatus.fresh
              : ExchangeRateStatus.stale;
      final lastUpdate = _cacheManager.rateCacheLastUpdated;

      emit(
        state.copyWith(
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          exchangeRate: rate,
          exchangeRateStatus: rateStatus,
          lastExchangeRateUpdate: lastUpdate,
        ),
      );
      _recalculateAmounts(emit, rate);
    } catch (e) {
      if (state.exchangeRateRequestId != requestId) return;

      final cachedRate = _cacheManager.getOfflineRate(
        event.fromCurrency,
        event.toCurrency,
      );
      if (cachedRate != null) {
        final rateStatus =
            _cacheManager.hasOfflineRate(event.fromCurrency, event.toCurrency)
                ? ExchangeRateStatus.fresh
                : ExchangeRateStatus.stale;
        final lastUpdate = _cacheManager.rateCacheLastUpdated;

        emit(
          state.copyWith(
            fromCurrency: event.fromCurrency,
            toCurrency: event.toCurrency,
            exchangeRate: cachedRate,
            exchangeRateStatus: rateStatus,
            lastExchangeRateUpdate: lastUpdate,
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
          ),
        );
      }
    }
  }

  Future<void> _onSwapCurrencies(
    SwapCurrenciesEvt event,
    Emitter<SearchState> emit,
  ) async {
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

    if (swapped.fromCurrency == null || swapped.toCurrency == null) return;

    final fromCurrency = swapped.fromCurrency!;
    final toCurrency = swapped.toCurrency!;
    final requestId = state.exchangeRateRequestId + 1;
    emit(state.copyWith(exchangeRateRequestId: requestId));

    try {
      final rate = await repo.convertCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: 1.0,
      );

      if (state.exchangeRateRequestId != requestId) return;

      _cacheManager.cacheOfflineRate(
        from: fromCurrency,
        to: toCurrency,
        rate: rate,
      );

      final rateStatus = _cacheManager.hasOfflineRate(fromCurrency, toCurrency)
          ? ExchangeRateStatus.fresh
          : ExchangeRateStatus.stale;

      emit(
        state.copyWith(
          exchangeRate: rate,
          exchangeRateStatus: rateStatus,
          lastExchangeRateUpdate: _cacheManager.rateCacheLastUpdated,
        ),
      );
    } catch (e) {
      if (state.exchangeRateRequestId != requestId) return;

      final cachedRate = _cacheManager.getOfflineRate(fromCurrency, toCurrency);
      if (cachedRate != null) {
        final rateStatus =
            _cacheManager.hasOfflineRate(fromCurrency, toCurrency)
                ? ExchangeRateStatus.fresh
                : ExchangeRateStatus.stale;

        emit(
          state.copyWith(
            exchangeRate: cachedRate,
            exchangeRateStatus: rateStatus,
            lastExchangeRateUpdate: _cacheManager.rateCacheLastUpdated,
          ),
        );
      }
    }
  }

  void _onConvertCurrency(ConvertCurrencyEvt event, Emitter<SearchState> emit) {
    final rate = state.exchangeRate;

    if (rate == null || rate <= 0) {
      emit(state.copyWith(clearAmounts: true));
      return;
    }

    if (event.amount <= 0) {
      emit(state.copyWith(clearAmounts: true));
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

  Future<void> _onCheckConnectivity(
    CheckConnectivityEvt event,
    Emitter<SearchState> emit,
  ) async {
    final previouslyOnline = state.isOnline;

    if (!event.isOnline && previouslyOnline) {
      emit(
        state.copyWith(
          isOnline: false,
          exchangeRateStatus: ExchangeRateStatus.stale,
        ),
      );
    } else {
      emit(state.copyWith(isOnline: event.isOnline));
    }

    if (event.isOnline && !previouslyOnline) {
      add(const ExchangeRateRefreshEvt(forceRefresh: true));

      if (state.fromCurrency != null && state.toCurrency != null) {
        add(ExchangeRateChangedEvt(state.fromCurrency!, state.toCurrency!));
      }
    }
  }

  void _recalculateAmounts(Emitter<SearchState> emit, double rate) {
    final newToAmount = CurrencyUtils.convertFromTo(state.fromAmount, rate);
    final newFromAmount = CurrencyUtils.convertToFrom(state.toAmount, rate);

    if (newToAmount != null) {
      emit(state.copyWith(toAmount: newToAmount));
    } else if (newFromAmount != null) {
      emit(state.copyWith(fromAmount: newFromAmount));
    }
  }

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
    _connectivitySub?.cancel();
    return super.close();
  }
}