import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/features/account/presentation/blocs/account_and_card_cubit.dart';
import 'package:banking_app/features/account/presentation/blocs/account_and_card_state.dart';
import 'package:banking_app/features/chat/tools/fetch_balance_tool.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext extends Mock implements BuildContext {}
class MockAccountAndCardCubit extends Mock implements AccountAndCardCubit {}

void main() {
  late FetchBalanceFromAssistantTool tool;
  late MockBuildContext context;
  late MockAccountAndCardCubit accountCubit;

  const testAccount = AccountModel(
    userId: 'user1',
    id: 'account1',
    accountNumber: '1234567890',
    availableBalance: 1000.0,
    branch: 'Test Branch',
    accountType: 'Savings',
    bankId: 'bank1',
  );

  setUp(() {
    context = MockBuildContext();
    accountCubit = MockAccountAndCardCubit();
    
    // Reset and register the mock cubit
    locator.reset();
    locator.registerSingleton<AccountAndCardCubit>(accountCubit);
    
    tool = FetchBalanceFromAssistantTool();

    // Setup default state with test account
    when(() => accountCubit.state).thenReturn(
      const AccountAndCardState().copyWith(
        accounts: [testAccount],
      ),
    );

    // Mock context.mounted to always return true for simplicity
    when(() => context.mounted).thenReturn(true);
  });

  group('FetchBalanceFromAssistantTool', () {
    test('should return success with balance when account exists', () async {
      final result = await tool.execute(context, {
        'accountNumber': '1234567890',
      });

      expect(result['success'], true);
      expect(result['balance'], 1000.0);
      expect(
        result['message'],
        '💰 Your balance is \$1000.00',
      );
    });

    test('should return error when accountNumber is null', () async {
      final result = await tool.execute(context, {
        'accountNumber': null,
      });

      expect(result['success'], false);
      expect(result['message'], 'Account number is required');
    });

    test('should return error when account is not found', () async {
      final result = await tool.execute(context, {
        'accountNumber': '9999999999',
      });

      expect(result['success'], false);
      expect(result['message'], contains('Unable to fetch balance'));
      expect(result['message'], contains('Account not found'));
    });
  });
}