import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BADropdown<T> extends StatelessWidget {
  const BADropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = '',
    this.validator,
    this.enabled = true,
    this.icon,
    this.itemBuilder,
    this.displayText,
    this.height,
  });

  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String hint;
  final String? Function(T?)? validator;
  final bool enabled;
  final Widget? icon;
  final Widget Function(T item)? itemBuilder;
  final String Function(T item)? displayText;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: BAAppColors.textDisabled),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          focusColor: BAAppColors.borderFocus,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              hint,
              style: context.titleSmall?.copyWith(
                color: context.colorScheme.onTertiary,
              ),
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down),
          ),
          isExpanded: true,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                    itemBuilder?.call(item) ??
                    Text(
                      displayText?.call(item) ?? item.toString(),
                      style: context.bodyMedium,
                    ),
              ),
            );
          }).toList(),
          onChanged: enabled && items.isNotEmpty ? onChanged : null,
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((T item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayText?.call(item) ?? item.toString(),
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

// Payment Method Model
class PaymentMethod {
  final String id;
  final String displayName;
  final String cardNumber;
  final String type;
  final IconData icon;

  PaymentMethod({
    required this.id,
    required this.displayName,
    required this.cardNumber,
    required this.type,
    required this.icon,
  });
}

class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});
}

class PaymentMethodDropdown extends StatelessWidget {
  const PaymentMethodDropdown({
    super.key,
    required this.paymentMethods,
    required this.onChanged,
    this.selectedMethod,
    this.enabled = true,
  });

  final List<PaymentMethod> paymentMethods;
  final ValueChanged<PaymentMethod?> onChanged;
  final PaymentMethod? selectedMethod;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BADropdown<PaymentMethod>(
      items: paymentMethods,
      value: selectedMethod,
      hint: 'Select payment method',
      onChanged: onChanged,
      enabled: enabled,
      height: 60,
      itemBuilder: (method) => Row(
        children: [
          Icon(method.icon, size: 24, color: context.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  method.displayName,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  method.cardNumber,
                  style: context.bodySmall?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      displayText: (method) => '${method.displayName} - ${method.cardNumber}',
    );
  }
}
