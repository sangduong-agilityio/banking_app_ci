import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_cubit.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_state.dart';
import 'package:banking_app/features/setting/data/models/transaction.dart';
import 'package:intl/intl.dart';

class OptimisticUIDemo extends StatefulWidget {
  const OptimisticUIDemo({super.key});

  @override
  State<OptimisticUIDemo> createState() => _OptimisticUIDemoState();
}

class _OptimisticUIDemoState extends State<OptimisticUIDemo> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OptimisticCubit(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'Optimistic UI Demo',
          titleColor: context.colorScheme.onPrimary,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.secondary,
        ),
        body: BlocConsumer<OptimisticCubit, OptimisticState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == OptimisticStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: context.colorScheme.error,
                  duration: const Duration(seconds: 4),
                ),
              );
            } else if (state.status == OptimisticStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transfer completed successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildBalanceCard(context, state),
                      const SizedBox(height: 32),
                      _buildActionButtons(context, state),
                      const SizedBox(height: 32),
                      _buildTransactionsList(context, state),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, OptimisticState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.secondary.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₫${NumberFormat('#,##0').format(state.balance.toInt())}',
            style: context.textTheme.displaySmall?.copyWith(
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vietnamese Dong',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.secondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OptimisticState state) {
    final isLoading = state.status == OptimisticStatus.loading;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : () => _showTransferDialog(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: context.colorScheme.primary.withOpacity(
                0.5,
              ),
            ),
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.send, size: 20),
            label: Text(
              isLoading ? 'Processing...' : 'Send 100,000₫',
              style: context.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _transferWithResult(context, true),
                icon: const Icon(Icons.check, size: 18),
                label: Text(
                  'Success',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _transferWithResult(context, false),
                icon: const Icon(Icons.close, size: 18),
                label: Text(
                  'Failure',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              context.read<OptimisticCubit>().reset();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Reset',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(BuildContext context, OptimisticState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction History',
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (state.transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: context.colorScheme.secondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions yet',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.secondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tx = state.transactions[index];
              return _TransactionCard(transaction: tx);
            },
          ),
      ],
    );
  }

  Future<void> _showTransferDialog(BuildContext context) async {
    final recipientController = TextEditingController();

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Send Money',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(
                hintText: 'Recipient name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Amount: ₫100,000',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (recipientController.text.isNotEmpty) {
                context.read<OptimisticCubit>().transferMoney(
                  100000,
                  recipientController.text,
                );
                Navigator.of(ctx).pop();
              }
            },
            child: Text(
              'Send',
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _transferWithResult(BuildContext context, bool isSuccess) async {
    const recipientName = 'Test Recipient';
    context.read<OptimisticCubit>().transferMoney(
      100000,
      recipientName,
      forceSuccess: isSuccess,
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context);
    final statusIcon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.recipientName,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat(
                    'HH:mm:ss dd/MM/yyyy',
                  ).format(transaction.timestamp),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.secondary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-₫${NumberFormat('#,##0').format(transaction.amount.toInt())}',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(transaction.status),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return Icons.schedule;
      case TransactionStatus.completed:
        return Icons.check_circle;
      case TransactionStatus.failed:
        return Icons.error;
    }
  }
}
