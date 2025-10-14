import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_state.dart';
import 'package:banking_app/features/bill_payment/presentation/views/bill_payment_option_screen.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// A screen that displays the available bill payment categories (e.g., electricity, water, internet).
class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  /// Navigates to the payment option screen for the selected bill type.
  void _navigateToOptionScreen(BuildContext context, BillType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<BillPaymentBloc>()
            ..add(BillPaymentInitializeEvt(type)),
          child: PaymentOptionScreen(billType: type),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<BillPaymentBloc>(),
      child: LoaderOverlay(
        child: BAScaffold(
          appBar: BAAppBar(
            title: S.current.payBillTitle,
            titleColor: context.colorScheme.scrim,
            alignment: BAAppBarAlignment.left,
            iconColor: context.colorScheme.scrim,
          ),
          body: BlocBuilder<BillPaymentBloc, BillPaymentState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardCategorySelected(
                    category: S.current.payBillElectricTitle,
                    categoryName: S.current.payBillElectricDescription,
                    imageUrl: BAAssets.electric(),
                    onTap: () =>
                        _navigateToOptionScreen(context, BillType.electric),
                  ),
                  CardCategorySelected(
                    category: S.current.payBillWaterTitle,
                    categoryName: S.current.payBillWaterDescription,
                    imageUrl: BAAssets.water(),
                    onTap: () =>
                        _navigateToOptionScreen(context, BillType.water),
                  ),
                  CardCategorySelected(
                    category: S.current.payBillInternetTitle,
                    categoryName: S.current.payBillInternetDescription,
                    imageUrl: BAAssets.internet(),
                    onTap: () =>
                        _navigateToOptionScreen(context, BillType.internet),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
