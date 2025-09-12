import 'dart:math' as math;
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
      _fromAmountController.text = widget.initialAmount!.toString();
    }
  }

  bool get isExchangeEnabled {
    final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    final toAmount = double.tryParse(_toAmountController.text) ?? 0;
    return fromAmount > 0 && toAmount > 0;
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
            title: S.current.searchSelectedCurrencyTitle,
            currencies: state.currencies ?? [],
            selectedCurrency: isFromCurrency
                ? state.fromCurrency ?? ''
                : state.toCurrency ?? '',
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

  void _updateController(TextEditingController controller, double? amount) {
    final newText = amount != null ? FormatterUtils.formatAmount(amount) : '';

    if (controller.text == newText) return;

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SearchBloc>()
        ..add(
          ExchangeInitializeEvt(
            widget.initialFromCurrency,
            widget.initialToCurrency,
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
            _updateController(_fromAmountController, state.fromAmount);
            _updateController(_toAmountController, state.toAmount);
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
                          currency: state.fromCurrency ?? '',
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
                          currency: state.toCurrency ?? '',
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
                                angle: _swapAnimation.value * math.pi,
                                child: child,
                              );
                            },
                            child: BAAssets.swap(),
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
