import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_transfer_bloc.dart';
import '../mocks/mock_transfer_data.dart';

/// Creates initial  with optional overrides
TransferState createInitialTransferState({
  List<AccountModel>? accounts,
  List<CardModel>? cards,
  List<BankModel>? banks,
  List<BranchModel>? branches,
  List<BeneficiaryModel>? beneficiaries,
  TransferStatus? status,
  String? errorMessage,
}) {
  return TransferState(
    accounts: accounts ?? MockTransferData.mockAccounts,
    cards: cards ?? MockTransferData.mockCards,
    banks: banks ?? MockTransferData.mockBanks,
    branches: branches ?? MockTransferData.mockBranches,
    beneficiaries: beneficiaries ?? MockTransferData.mockBeneficiaries,
    status: status ?? const TransferStatusInitial(),
    errorMessage: errorMessage,
  );
}

void setupMockBloc(MockTransferBloc mockBloc, TransferState state) {
  when(() => mockBloc.state).thenReturn(state);
  when(() => mockBloc.stream).thenAnswer((_) => Stream.value(state));
  when(() => mockBloc.add(any())).thenReturn(null);
  when(() => mockBloc.close()).thenAnswer((_) async {});
}

void setupServiceLocator(MockTransferBloc mockBloc) {
  final getIt = GetIt.instance;

  if (getIt.isRegistered<TransferBloc>()) {
    getIt.unregister<TransferBloc>();
  }

  getIt.registerFactory<TransferBloc>(() => mockBloc);
}

void cleanupServiceLocator() {
  final getIt = GetIt.instance;

  if (getIt.isRegistered<TransferBloc>()) {
    getIt.unregister<TransferBloc>();
  }
}
