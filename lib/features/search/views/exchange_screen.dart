import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/search/bloc/search_bloc.dart';
import 'package:banking_app/features/search/bloc/search_event.dart';
import 'package:banking_app/features/search/bloc/search_state.dart';
import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/widgets/curreny_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({
    super.key,
    this.initialFromCurrency,
    this.initialToCurrency,
    this.initialAmount,
  });

  final String? initialFromCurrency;
  final String? initialToCurrency;
  final double? initialAmount;

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  late AnimationController _swapAnimationController;
  late Animation<double> _swapAnimation;

  @override
  void initState() {
    super.initState();
    _swapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _swapAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.initialAmount != null) {
      _fromAmountController.text = widget.initialAmount.toString();
    }
  }

  bool get isExchangeEnabled {
    final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    final toAmount = double.tryParse(_toAmountController.text) ?? 0;
    return fromAmount > 0 || toAmount > 0;
  }

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    _swapAnimationController.dispose();
    super.dispose();
  }

  void _showCurrencySelector(BuildContext context, bool isFromCurrency) {
    final bloc = context.read<SearchBloc>();
    final state = bloc.state;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          child: CurrencySelector(
            title: 'Select the currency',
            currencies: state.currencies ?? [],
            selectedCurrency: isFromCurrency
                ? state.fromCurrency ?? 'USD'
                : state.toCurrency ?? 'VND',
            onCurrencySelected: (currency) {
              context.read<SearchBloc>().add(
                SelectCurrencyEvt(isFromCurrency, currency),
              );
              Navigator.pop(dialogContext);
            },
          ),
        );
      },
    );
  }

  Future<void> _swapCurrencies(BuildContext context) async {
    await _swapAnimationController.forward();
    context.read<SearchBloc>().add(SwapCurrenciesEvt());
    await _swapAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()
        ..add(
          ExchangeInitializeEvt(
            widget.initialFromCurrency ?? 'USD',
            widget.initialToCurrency ?? 'VND',
          ),
        ),
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.searchExchangeTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocListener<SearchBloc, SearchState>(
          listenWhen: (prev, curr) =>
              prev.fromAmount != curr.fromAmount ||
              prev.toAmount != curr.toAmount ||
              prev.fromCurrency != curr.fromCurrency ||
              prev.toCurrency != curr.toCurrency,
          listener: (context, state) {
            _fromAmountController.text = state.fromAmount != null
                ? AmountFormatter.formatAmount(state.fromAmount ?? 0)
                : '';
            _toAmountController.text = state.toAmount != null
                ? AmountFormatter.formatAmount(state.toAmount ?? 0)
                : '';
          },
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      BAAssets.exchangeMoney(),
                      const SizedBox(height: 16),
                      ExchangeBox(
                        isButtonEnabled: isExchangeEnabled,
                        fromCard: CurrencyCard(
                          label: S.current.searchFormTitle,
                          currency: state.fromCurrency ?? 'USD',
                          controller: _fromAmountController,
                          onCurrencyTap: () =>
                              _showCurrencySelector(context, true),
                          onChanged: (value) {
                            final amount = double.tryParse(value ?? '') ?? 0;
                            context.read<SearchBloc>().add(
                              ConvertCurrencyEvt(amount, isFromAmount: true),
                            );
                          },
                        ),
                        toCard: CurrencyCard(
                          label: S.current.searchToTitle,
                          currency: state.toCurrency ?? 'VND',
                          controller: _toAmountController,
                          onCurrencyTap: () =>
                              _showCurrencySelector(context, false),
                          onChanged: (value) {
                            final amount = double.tryParse(value ?? '') ?? 0;
                            context.read<SearchBloc>().add(
                              ConvertCurrencyEvt(amount, isFromAmount: false),
                            );
                          },
                        ),
                        swapButton: GestureDetector(
                          onTap: () => _swapCurrencies(context),
                          child: AnimatedBuilder(
                            animation: _swapAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _swapAnimation.value * 3.14,
                                child: child,
                              );
                            },
                            child: const Icon(
                              Icons.swap_vert,
                              size: 28,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        exchangeRate:
                            (state.fromAmount != null && state.fromAmount! > 0)
                            ? '1 ${state.fromCurrency ?? ''} = ${state.exchangeRate?.toStringAsFixed(2) ?? '--'} ${state.toCurrency ?? ''}'
                            : null,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CurrencySelector extends StatelessWidget {
  final String title;
  final List<CurrencyModel> currencies;
  final String selectedCurrency;
  final Function(String) onCurrencySelected;

  const CurrencySelector({
    super.key,
    required this.title,
    required this.currencies,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency.code == selectedCurrency;
                  return InkWell(
                    onTap: () => onCurrencySelected(currency.code),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: currency.code,
                                    style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? context.colorScheme.secondary
                                          : context.colorScheme.onSurface
                                                .withOpacity(0.7),
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ( ${currency.name} )",
                                    style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? context.colorScheme.secondary
                                          : context.colorScheme.onSurface
                                                .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: context.colorScheme.secondary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
