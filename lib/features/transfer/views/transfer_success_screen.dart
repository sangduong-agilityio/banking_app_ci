import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BAScaffold(
        appBar: BAAppBar(
          title: S.current.transferConfirmTitle,
          titleColor: context.colorScheme.scrim,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.scrim,
        ),
        body: BlocConsumer<TransferBloc, TransferState>(
          listener: (context, state) {
            state.status.maybeWhen(
              loading: () => context.loaderOverlay.show(),
              success: () {
                if (context.mounted) context.loaderOverlay.hide();
              },
              failure: () {
                context.loaderOverlay.hide();
                BASnackBar.buildErrorSnackbar(
                  context,
                  state.errorMessage ?? '',
                );
              },
              orElse: () => context.loaderOverlay.hide(),
            );
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  BAAssets.transferSuccess(),
                  const SizedBox(height: 30),
                  Text(
                    S.current.payBillTransactionSuccess,
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: DefaultTextStyle.of(
                        context,
                      ).style.copyWith(fontSize: 16),
                      children: [
                        TextSpan(
                          text: S.current.transferSuccessDescription,
                          style: TextStyle(color: context.colorScheme.scrim),
                        ),
                        TextSpan(
                          text:
                              '\$${FormatterUtils.formatAmount(state.amount ?? 0)} ',
                          style: TextStyle(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: S.current.transferToLabel.toLowerCase(),
                          style: TextStyle(color: context.colorScheme.scrim),
                        ),
                        TextSpan(
                          text: ' ${state.selectedBeneficiary?.name ?? ''}!',
                          style: TextStyle(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 55),
                  BAElevatedButton(
                    height: 44,
                    text: S.current.payBillConfirmButton,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
