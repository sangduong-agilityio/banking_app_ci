import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/features/bill_payment/blocs/bill_payment_bloc.dart';
import 'package:get_it/get_it.dart';

import '../mocks/mock_bill_payment_bloc.dart';

void setupBillPaymentServiceLocator(MockBillPaymentBloc mockBloc) {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<BillPaymentBloc>()) {
    getIt.unregister<BillPaymentBloc>();
  }
  locator.registerFactory<BillPaymentBloc>(() => mockBloc);
}

void cleanupBillPaymentServiceLocator() {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<BillPaymentBloc>()) {
    getIt.unregister<BillPaymentBloc>();
  }
}
