import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/payment/models/order_model.dart';
import 'package:tradly_app/features/payment/states/payment_option_bloc.dart';
import 'package:tradly_app/features/payment/states/payment_option_event.dart';
import 'package:tradly_app/features/payment/states/payment_option_state.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/text.dart';

class PaymentOptionScreen extends StatefulWidget {
  const PaymentOptionScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentOptionBloc(),
      child: TAScaffold(
        appBar: TAAppBar.checkout(
          title: 'Payment Option',
          onBackPressed: () => Navigator.pop(context),
          backgroundColor: context.colorScheme.primary,
        ),
        body: BlocBuilder<PaymentOptionBloc, PaymentOptionState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  AddPaymentMethod(),
                  const SizedBox(height: 6),
                  PaymentOption(),
                  const SizedBox(height: 16),
                  CurrentLocation(
                    product: widget.product,
                  ),
                  const SizedBox(height: 11),
                  PriceDetail(
                    product: widget.product,
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          color: context.colorScheme.onPrimary,
          child: TAElevatedButton(
            text: S.current.checkoutCheckoutButton,
            backgroundColor: context.colorScheme.primary,
            onPressed: () {
              // context.pushNamed(TAPaths.orderSuccess.name,
              //     extra: widget.product);
            },
          ),
        ),
      ),
    );
  }
}

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentOptionBloc, PaymentOptionState>(
      builder: (context, state) {
        final paymentMethods = state.paymentMethods ?? [];
        return Container(
          color: context.colorScheme.onPrimary,
          height: 241,
          child: Column(
            children: [
              paymentMethods.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 9,
                        top: 16,
                        bottom: 16,
                      ),
                      child: SizedBox(
                        height: 146,
                        child: _paymentCardList(paymentMethods),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 26,
                      ),
                      child: SizedBox(
                        height: 146,
                        child: _addPaymentCard(context),
                      ),
                    ),
              const SizedBox(height: 9),
              _buildPageIndicators(paymentMethods.length),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentCardList(List<PaymentMethod> paymentMethods) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: paymentMethods.length + 1,
      itemBuilder: (context, index) {
        if (index == paymentMethods.length) {
          return _addPaymentCard(context);
        } else {
          return _paymentCardAttachment(paymentMethods[index]);
        }
      },
    );
  }

  Widget _paymentCardAttachment(PaymentMethod method) {
    return Container(
      height: 146,
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TATitleLargeText(
                    text: 'Holder name',
                    color: context.colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  TAHeadlineSmallText(
                    text: method.holderName ?? '',
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              Image.asset(
                height: 40,
                Assets.images.imgMastercard.path,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TATitleLargeText(
                text: 'Card number',
                color: context.colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
              TAHeadlineLargeText(
                text: method.cardNumber ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addPaymentCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await context.pushNamed(TAPaths.addCard.name);

        if (result != null && result is PaymentMethod) {
          context.read<PaymentOptionBloc>().add(
                PaymentOptionAddEvt(
                  paymentMethod: PaymentMethod(
                    id: result.id,
                    holderName: result.holderName,
                    cardNumber: result.cardNumber,
                    expiryDate: result.expiryDate,
                    cardType: result.cardType,
                  ),
                ),
              );
        }
      },
      child: Container(
        height: 146,
        width: 246,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Add Payment Method',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int itemCount) {
    const int defaultIndicators = 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        defaultIndicators,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0 ? const Color(0xFF4A9B8E) : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

class PaymentOption extends StatefulWidget {
  const PaymentOption({super.key});

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  String selectedPaymentType = 'debit_credit';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _paymentOption('debit_credit', 'Debit / Credit Card'),
        _paymentOption('netbanking', 'Netbanking'),
        _paymentOption('cash_delivery', 'Cash on Delivery'),
        _paymentOption('wallet', 'Wallet'),
      ],
    );
  }

  Widget _paymentOption(String value, String title) {
    return Container(
      color: context.colorScheme.onPrimary,
      child: Column(
        children: [
          Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: selectedPaymentType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentType = newValue!;
                  });
                },
                activeColor: context.colorScheme.primary,
              ),
              TATitleLargeText(
                text: title,
                color: context.colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurrentLocation extends StatelessWidget {
  const CurrentLocation({
    super.key,
    required this.product,
  });
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      color: context.colorScheme.onPrimary,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TATitleLargeText(
                text: '${product.title}, ${product.zipCode}',
                color: context.colorScheme.onSurface,
              ),
              SizedBox(height: 5),
              TATitleLargeText(
                text: '${product.city}, ${product.state} ',
                color: context.colorScheme.onSecondary,
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {
              context.pushNamed(
                TAPaths.addAddress.name,
                // extra: state.product,
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              minimumSize: const Size(100, 25),
              side: BorderSide(
                color: context.colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: TATitleMediumText(
              text: S.current.productDetailLocationChangeButton,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceDetail extends StatelessWidget {
  const PriceDetail({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: context.colorScheme.onPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TATitleLargeText(
            text: 'Price Details',
            color: context.colorScheme.onSurface,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TATitleLargeText(
                text: 'Total Price',
                color: context.colorScheme.onSecondary,
              ),
              TATitleLargeText(
                text: '\$${product.price}',
                color: context.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
