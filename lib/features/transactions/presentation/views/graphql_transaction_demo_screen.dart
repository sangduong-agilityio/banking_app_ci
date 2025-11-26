import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transactions/presentation/blocs/graphql/graphql_transaction_bloc.dart';
import 'package:banking_app/features/transactions/presentation/blocs/graphql/graphql_transaction_event.dart';
import 'package:banking_app/features/transactions/presentation/blocs/graphql/graphql_transaction_state.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';

class GraphQLTransactionDemoScreen extends StatelessWidget {
  const GraphQLTransactionDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GraphQLTransactionBloc>(
      create: (_) => locator<GraphQLTransactionBloc>()..add(const LoadTransactionsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GraphQL Transactions Demo'),
        ),
        body: BlocBuilder<GraphQLTransactionBloc, GraphQLTransactionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? 'Unknown error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      if (state.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red.shade50,
                          child: SelectableText(
                            state.errorMessage!,
                            style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GraphQLTransactionBloc>().add(const RefreshTransactionsEvent());
              },
              child: ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  final tx = state.transactions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on, color: tx.amount > 0 ? Colors.green : Colors.red),
                      title: Text('Amount: ${tx.amount.toStringAsFixed(2)}'),
                      subtitle: Text('Status: ${tx.status.name}'),
                      trailing: Text(tx.createdAt?.toString().substring(0, 10) ?? ''),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => TransactionDetailDialog(transaction: tx),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.search),
          label: const Text('Search'),
          onPressed: () async {
            final query = await showDialog<String>(
              context: context,
              builder: (context) => _SearchDialog(),
            );
            if (query != null && query.isNotEmpty) {
              context.read<GraphQLTransactionBloc>().add(SearchTransactionsEvent(query));
            }
          },
        ),
      ),
    );
  }
}

class TransactionDetailDialog extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailDialog({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Transaction Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${transaction.id}'),
          Text('Amount: ${transaction.amount.toStringAsFixed(2)}'),
          Text('Type: ${transaction.type.name}'),
          Text('Status: ${transaction.status.name}'),
          Text('Recipient: ${transaction.recipientName ?? '-'}'),
          Text('Created: ${transaction.createdAt?.toString() ?? '-'}'),
          if (transaction.description != null)
            Text('Description: ${transaction.description}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _SearchDialog extends StatefulWidget {
  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Transactions'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter search query'),
        onChanged: (val) => setState(() => query = val),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(query),
          child: const Text('Search'),
        ),
      ],
    );
  }
}
