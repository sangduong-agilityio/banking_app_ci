import 'package:banking_app/features/search/states/search_bloc.dart';
import 'package:banking_app/features/search/states/search_event.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchBloc extends Mock implements SearchBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void setupSearchFallbacks() {
  registerFallbackValue(ExchangeRateInitializeEvt());
  registerFallbackValue(ExchangeRateRefreshEvt(forceRefresh: true));
  registerFallbackValue(InterestRateInitializeEvt());
  registerFallbackValue(ExchangeInitializeEvt(null, null));
  registerFallbackValue(SelectCurrencyEvt(true, 'USD'));
  registerFallbackValue(SwapCurrenciesEvt());
  registerFallbackValue(ConvertCurrencyEvt(0, isFromAmount: true));
  registerFallbackValue(ExchangeRateChangedEvt('USD', 'EUR'));
}
