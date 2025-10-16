import 'dart:math' as math;
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/search/presentation/blocs/search_bloc.dart';
import 'package:banking_app/features/search/presentation/blocs/search_event.dart';
import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/presentation/widgets/currency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen for converting currencies with offline support.
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
  bool _hasShownStaleWarning = false;
  bool _userEditingFromAmount = false;
  bool _userEditingToAmount = false;

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

    _fromAmountController.addListener(_onFromAmountChanged);
    _toAmountController.addListener(_onToAmountChanged);
  }

  void _onFromAmountChanged() {
    _userEditingFromAmount = _fromAmountController.text.isNotEmpty;
  }

  void _onToAmountChanged() {
    _userEditingToAmount = _toAmountController.text.isNotEmpty;
  }

  bool get isExchangeEnabled {
    final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    final toAmount = double.tryParse(_toAmountController.text) ?? 0;
    return fromAmount > 0 && toAmount > 0;
  }

  @override
  void dispose() {
    _fromAmountController.removeListener(_onFromAmountChanged);
    _toAmountController.removeListener(_onToAmountChanged);
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

  Future<void> _swapCurrencies(BuildContext context) async {
    await _swapAnimationController.forward();
    if (context.mounted) {
      context.read<SearchBloc>().add(const SwapCurrenciesEvt());
    }
    await _swapAnimationController.reverse();
  }

  void _updateController(
    TextEditingController controller,
    double? amount, {
    required bool userIsEditing,
  }) {
    // Force clear when amount is null
    if (amount == null) {
      if (controller.text.isNotEmpty) {
        controller.clear();
      }
      return;
    }

    // Don't update if user is actively editing
    if (userIsEditing) {
      return;
    }

    final newText = FormatterUtils.formatAmount(amount);
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
          body: Column(
            children: [
              BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (prev, curr) => prev.isOnline != curr.isOnline,
                builder: (context, state) {
                  if (!state.isOnline) {
                    return Material(
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade700,
                              Colors.orange.shade600,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.current.offline_text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    S.current.searchUsingCachedRates,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(230),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Retry button
                            TextButton.icon(
                              onPressed: () {
                                context.read<SearchBloc>().add(
                                  const ExchangeRateRefreshEvt(
                                    forceRefresh: true,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.orange.shade700,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: Text(
                                S.current.searchRetryButton,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Main content
              Expanded(
                child: BlocConsumer<SearchBloc, SearchState>(
                  listenWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.fromAmount != curr.fromAmount ||
                      prev.toAmount != curr.toAmount ||
                      prev.exchangeRateStatus != curr.exchangeRateStatus,
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

                    _updateController(
                      _fromAmountController,
                      state.fromAmount,
                      userIsEditing: _userEditingFromAmount,
                    );
                    _updateController(
                      _toAmountController,
                      state.toAmount,
                      userIsEditing: _userEditingToAmount,
                    );

                    if (state.exchangeRateStatus == ExchangeRateStatus.stale &&
                        !_hasShownStaleWarning) {
                      _hasShownStaleWarning = true;
                    }

                    if (state.exchangeRateStatus == ExchangeRateStatus.fresh) {
                      _hasShownStaleWarning = false;
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _userEditingFromAmount = false;
                        _userEditingToAmount = false;
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            BAAssets.exchangeMoney(),
                            const SizedBox(height: 24),

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
                                  _userEditingFromAmount =
                                      value?.isNotEmpty ?? false;
                                  final amount =
                                      double.tryParse(value ?? '') ?? 0;
                                  context.read<SearchBloc>().add(
                                    ConvertCurrencyEvt(
                                      amount,
                                      isFromAmount: true,
                                    ),
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
                                  _userEditingToAmount =
                                      value?.isNotEmpty ?? false;
                                  final amount =
                                      double.tryParse(value ?? '') ?? 0;
                                  context.read<SearchBloc>().add(
                                    ConvertCurrencyEvt(
                                      amount,
                                      isFromAmount: false,
                                    ),
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

                              exchangeRate: state.exchangeRate != null
                                  ? S.current.searchExchangeRate(
                                      state.fromCurrency ?? '',
                                      FormatterUtils.formatAmount(
                                        state.exchangeRate ?? 0,
                                      ),
                                      state.toCurrency ?? '',
                                    )
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
            ],
          ),
        ),
      ),
    );
  }
}
