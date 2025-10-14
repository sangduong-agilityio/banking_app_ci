import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_transfer_data.dart';

class MockTransferBloc extends Mock implements TransferBloc {}

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
