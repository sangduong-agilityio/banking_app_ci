import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/common/utils/responsive.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/common/utils/formatters.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:flutter/material.dart';

class TransferSuccessScreen extends StatefulWidget {
  final double amount;
  final String beneficiaryName;

  const TransferSuccessScreen({
    super.key,
    required this.amount,
    required this.beneficiaryName,
  });

  @override
  State<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      appBar: BAAppBar(
        title: S.current.transferConfirmTitle,
        titleColor: context.colorScheme.scrim,
        alignment: BAAppBarAlignment.left,
        iconColor: context.colorScheme.scrim,
      ),

      // NEW APPROACH: CustomMultiChildLayout
      body: SizedBox.expand(
        child: CustomMultiChildLayout(
          delegate: _TransferSuccessLayoutDelegate(context),
          children: [
            // Illustration
            LayoutId(
              id: _SuccessSlot.illustration,
              child: BAAssets.transferSuccess(),
            ),

            // Success title
            LayoutId(
              id: _SuccessSlot.title,
              child: Text(
                S.current.payBillTransactionSuccess,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.secondary,
                ),
              ),
            ),

            // Description with amount and beneficiary
            LayoutId(
              id: _SuccessSlot.description,
              child: SelectionContainer.disabled(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                    children: [
                      TextSpan(
                        text: S.current.transferSuccessDescription,
                        style: context.titleSmall?.copyWith(
                          color: context.colorScheme.scrim,
                        ),
                      ),
                      TextSpan(
                        text:
                            '\$${FormatterUtils.formatAmount(widget.amount)} ',
                        style: context.titleSmall?.copyWith(
                          color: context.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: S.current.transferToLabel.toLowerCase(),
                        style: context.titleSmall?.copyWith(
                          color: context.colorScheme.scrim,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.beneficiaryName}!',
                        style: context.titleSmall?.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Confirm button
            LayoutId(
              id: _SuccessSlot.confirmButton,
              child: BAElevatedButton(
                height: 44,
                text: S.current.payBillConfirmButton,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),

      // OLD APPROACH: SingleChildScrollView
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 25),
      //       BAAssets.transferSuccess(),
      //       const SizedBox(height: 30),
      //       Text(
      //         S.current.payBillTransactionSuccess,
      //         style: context.titleMedium?.copyWith(
      //           fontWeight: FontWeight.w600,
      //           color: context.colorScheme.secondary,
      //         ),
      //       ),
      //       const SizedBox(height: 24),
      //       SelectionContainer.disabled(
      //         child: RichText(
      //           textAlign: TextAlign.center,
      //           text: TextSpan(
      //             style: DefaultTextStyle.of(context).style.copyWith(
      //               fontSize: 16,
      //               decoration: TextDecoration.none,
      //             ),
      //             children: [
      //               TextSpan(
      //                 text: S.current.transferSuccessDescription,
      //                 style: context.titleSmall?.copyWith(
      //                   color: context.colorScheme.scrim,
      //                 ),
      //               ),
      //               TextSpan(
      //                 text: '\$${FormatterUtils.formatAmount(widget.amount)} ',
      //                 style: context.titleSmall?.copyWith(
      //                   color: context.colorScheme.error,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               TextSpan(
      //                 text: S.current.transferToLabel.toLowerCase(),
      //                 style: context.titleSmall?.copyWith(
      //                   color: context.colorScheme.scrim,
      //                 ),
      //               ),
      //               TextSpan(
      //                 text: ' ${widget.beneficiaryName}!',
      //                 style: context.titleSmall?.copyWith(
      //                   color: context.colorScheme.secondary,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 55),
      //       BAElevatedButton(
      //         height: 44,
      //         text: S.current.payBillConfirmButton,
      //         onPressed: () {
      //           Navigator.popUntil(context, (route) => route.isFirst);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _TransferSuccessLayoutDelegate extends MultiChildLayoutDelegate {
  final BuildContext context;

  _TransferSuccessLayoutDelegate(this.context);

  @override
  void performLayout(Size size) {
    final centerX = size.width / 2;

    // Illustration at top
    if (hasChild(_SuccessSlot.illustration)) {
      final illustrationSize = layoutChild(
        _SuccessSlot.illustration,
        BoxConstraints.loose(Size(size.width, 300)),
      );
      positionChild(
        _SuccessSlot.illustration,
        Offset(
          centerX - illustrationSize.width / 2,
          BAResponsive.value(context, mobile: 20, tablet: 40),
        ),
      );
    }

    // Title below illustration
    if (hasChild(_SuccessSlot.title)) {
      final titleSize = layoutChild(
        _SuccessSlot.title,
        BoxConstraints.loose(Size(size.width - 48, 50)),
      );
      positionChild(
        _SuccessSlot.title,
        Offset(
          centerX - titleSize.width / 2,
          BAResponsive.value(context, mobile: 350, tablet: 400),
        ),
      );
    }

    // Description below title
    if (hasChild(_SuccessSlot.description)) {
      final descriptionSize = layoutChild(
        _SuccessSlot.description,
        BoxConstraints.loose(Size(size.width - 48, 100)),
      );
      positionChild(
        _SuccessSlot.description,
        Offset(
          centerX - descriptionSize.width / 2,
          BAResponsive.value(context, mobile: 400, tablet: 450),
        ),
      );
    }

    // Confirm button at bottom
    if (hasChild(_SuccessSlot.confirmButton)) {
      layoutChild(
        _SuccessSlot.confirmButton,
        BoxConstraints.tight(Size(size.width - 48, 44)),
      );
      positionChild(
        _SuccessSlot.confirmButton,
        Offset(24, BAResponsive.value(context, mobile: 495, tablet: 550)),
      );
    }
  }

  @override
  bool shouldRelayout(_TransferSuccessLayoutDelegate oldDelegate) => false;
}

// Enum for layout slots
enum _SuccessSlot { illustration, title, description, confirmButton }
