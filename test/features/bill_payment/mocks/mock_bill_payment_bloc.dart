import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_event.dart';
import 'package:mocktail/mocktail.dart';

class MockBillPaymentBloc extends Mock implements BillPaymentBloc {}

void setupBillPaymentFallbacks() {
  registerFallbackValue(const BillPaymentInitializeEvt(BillType.electric));
  registerFallbackValue(
    SelectBillEvt(BillPaymentModel(id: 'b', billType: BillType.electric)),
  );
  registerFallbackValue(const UpdateBillDetailsEvt());
  registerFallbackValue(const SendOtpEvt(billId: ''));
  registerFallbackValue(
    const ConfirmBillPaymentWithOtpEvt(billId: '', otpCode: ''),
  );
  registerFallbackValue(
    PayBillEvt(
      bill: BillPaymentModel(id: 'b', billType: BillType.electric),
      paymentMethodId: 'pm1',
    ),
  );
}
