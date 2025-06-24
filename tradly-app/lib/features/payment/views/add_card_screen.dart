import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/payment/models/order_model.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/form.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:tradly_app/widgets/text_field.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAScaffold(
      appBar: TAAppBar.checkout(
        title: 'Add Card',
        onBackPressed: () => Navigator.pop(context),
        backgroundColor: context.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.colorScheme.inverseSurface,
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
                              text: _nameController.text,
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
                          text: _cardNumberController.text,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TATitleLargeText(
                              text: 'Exp. Date',
                              color: context.colorScheme.onSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            TAHeadlineSmallText(
                              text: _expiryController.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TATitleLargeText(
                              text: 'CVC',
                              color: context.colorScheme.onSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            TAHeadlineSmallText(
                              text: _cvcController.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              color: context.colorScheme.surface,
              child: Form(
                key: _formKey,
                child: TAForm(
                    isValidated: (valid) => null,
                    spaceBetweenRow: 20,
                    textFields: [
                      TATextField(
                        label: 'Card Number',
                        controller: _cardNumberController,
                      ),
                      TATextField(
                        label: 'Name',
                        controller: _nameController,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TATextField(
                              label: 'Expries Date',
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TATextField(
                              label: 'CVC',
                              controller: _cvcController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: context.colorScheme.onPrimary,
        child: TAElevatedButton(
          text: 'Add Credit Card',
          backgroundColor: context.colorScheme.primary,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final newCard = PaymentMethod(
                id: DateTime.now().toString(),
                holderName: _nameController.text,
                cardNumber: _cardNumberController.text,
                expiryDate: _expiryController.text,
                cardType: 'MasterCard',
              );
              Navigator.pop(context, newCard);
            }
          },
        ),
      ),
    );
  }

  // String _formatCardNumber(String cardNumber) {
  //   final cleaned = cardNumber.replaceAll(' ', '');
  //   final buffer = StringBuffer();
  //   for (int i = 0; i < cleaned.length; i++) {
  //     if (i > 0 && i % 4 == 0) {
  //       buffer.write(' ');
  //     }
  //     buffer.write(cleaned[i]);
  //   }
  //   return buffer.toString();
  // }
}
