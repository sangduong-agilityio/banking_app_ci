import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_transfer_data.dart';

/// Mock class for TransferBloc
class MockTransferBloc extends Mock implements TransferBloc {}

/// Setup fallback values for mocktail
/// Call this in setUpAll() before using MockTransferBloc
void setupTransferBlocFallbacks() {
  // Initialize event
  registerFallbackValue(TransferInitializeEvt());
  // Selection events - use null for optional parameters
  registerFallbackValue(SelectAccountEvt(MockTransferData.mockAccount1));
  registerFallbackValue(SelectCardEvt(MockTransferData.mockCard1));
  registerFallbackValue(
    SelectBeneficiaryEvt(MockTransferData.mockBeneficiaries.first),
  );
  // Transfer type selection
  registerFallbackValue(const SelectTransferTypeEvt(TransferType.cardNumber));
  registerFallbackValue(SelectBankEvt(MockTransferData.mockBank1));
  registerFallbackValue(SelectBranchEvt(MockTransferData.mockBranch1));
  // Update events
  registerFallbackValue(const UpdateTransferDetailsEvt());
  registerFallbackValue(
    AddNewBeneficiaryEvt(MockTransferData.mockBeneficiary1),
  );
  // Confirmation events
  registerFallbackValue(const ConfirmTransferEvt());
  registerFallbackValue(const SendOtpEvt(transferId: ''));
  registerFallbackValue(
    const ConfirmTransferWithOtpEvt(otpCode: '', transferId: ''),
  );
  registerFallbackValue(const ConfirmWithBiometricEvt());
}
