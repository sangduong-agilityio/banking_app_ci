import 'dart:math' as math;
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/search/blocs/search_bloc.dart';
import 'package:banking_app/features/search/blocs/search_event.dart';
import 'package:banking_app/features/search/blocs/search_state.dart';
import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/widgets/currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen for converting currencies.
///
/// This screen allows the user to select two currencies, enter an amount, and
/// see the converted amount.
class ExchangeScreen extends StatefulWidget {
  /// Creates an [ExchangeScreen] object.
  const ExchangeScreen({
    super.key,
    this.initialFromCurrency,
    this.initialToCurrency,
    this.initialAmount,
  });

  /// The initial currency to convert from.
  final String? initialFromCurrency;

  /// The initial currency to convert to.
  final String? initialToCurrency;

  /// The initial amount to convert.
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

  /// Whether the exchange button should be enabled.
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

  /// Shows a dialog for selecting a currency.
  void _showCurrencySelector(BuildContext context, bool isFromCurrency) {
    final bloc = context.read<SearchBloc>();
    final state = bloc.state;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BASelectorDialog<CurrencyModel>(
          title: S.current.searchSelectedCurrencyTitle,
          items: state.currencies ?? [],
          selectedValue: isFromCurrency
              ? (state.fromCurrency ?? '')
              : (state.toCurrency ?? ''),
          value: (c) => c.code,
          label: (c) => "${c.code} (${c.name})",
          enableSearch: false,
          enableDivider: false,
          onSelected: (currency) {
            bloc.add(SelectCurrencyEvt(isFromCurrency, currency.code));
          },
        );
      },
    );
  }

  /// Swaps the \"from\" and \"to\" currencies with an animation.
  Future<void> _swapCurrencies(BuildContext context) async {
    await _swapAnimationController.forward();
    if (context.mounted) context.read<SearchBloc>().add(SwapCurrenciesEvt());
    await _swapAnimationController.reverse();
  }

  /// Updates the text of a [TextEditingController] with a formatted amount.
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
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.searchExchangeTitle,
            titleColor: context.colorScheme.scrim,
            alignment: BAAppBarAlignment.left,
            iconColor: context.colorScheme.scrim,
          ),
          body: BlocConsumer<SearchBloc, SearchState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status ||
                prev.fromAmount != curr.fromAmount ||
                prev.toAmount != curr.toAmount ||
                prev.fromCurrency != curr.fromCurrency ||
                prev.toCurrency != curr.toCurrency,
            listener: (context, state) {
              state.status.maybeWhen(
                loading: () => context.loaderOverlay.show(),
                success: () {
                  if (context.mounted) context.loaderOverlay.hide();
                },
                failure: () {
                  if (context.mounted) context.loaderOverlay.hide();
                },
                orElse: () {
                  if (context.mounted) context.loaderOverlay.hide();
                },
              );

              // Update the text controllers with the new amounts.
              _updateController(_fromAmountController, state.fromAmount);
              _updateController(_toAmountController, state.toAmount);

              // Show a warning if the exchange rate is stale.
              if (state.exchangeRateStatus == ExchangeRateStatus.stale) {
                _showOfflineWarning(context);
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      BAAssets.exchangeMoney(),
                      const SizedBox(height: 16),
                      // The main box for currency exchange.
                      ExchangeBox(
                        isButtonEnabled: isExchangeEnabled,
                        rateStatus: state.exchangeRateStatus,
                        lastRateUpdate: state.lastExchangeRateUpdate,
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
                            builder: (context, child) => Transform.rotate(
                              angle: _swapAnimation.value * math.pi,
                              child: child,
                            ),
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

  /// Shows a snackbar to warn the user that they are using an offline exchange rate.
  void _showOfflineWarning(BuildContext context) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.current.searchUsingOfflineExchangeTitle),
        backgroundColor: context.colorScheme.inversePrimary,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: S.current.searchRetryButton,
          textColor: context.colorScheme.onPrimary,
          onPressed: () {
            if (!context.mounted) return;
            final bloc = context.read<SearchBloc>();
            if (!bloc.isClosed &&
                bloc.state.fromCurrency != null &&
                bloc.state.toCurrency != null) {
              bloc.add(
                ExchangeRateChangedEvt(
                  bloc.state.fromCurrency ?? '',
                  bloc.state.toCurrency ?? '',
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
