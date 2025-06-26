import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/configs/constants.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/order_history/states/order_history_bloc.dart';
import 'package:tradly_app/features/order_history/states/order_history_state.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/images.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/text.dart';
import 'package:intl/date_symbol_data_local.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en', null);
    return TAScaffold(
      appBar: TAAppBar(
        centerTitle: false,
        toolbarHeight: TAAppBarSize.small,
        title: TADisplaySmallText(
          text: S.current.orderHistoryTitle,
          fontWeight: FontWeight.w700,
        ),
        trailing: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
            TAAssets.cart(),
          ],
        ),
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return const NotFoundScreen();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TAHeadlineLargeText(
                      text: S.current.orderTransactionsTitle,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.inverseSurface,
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TATitleLargeText(
                        text: dateTimeFormat(DateTime.now()),
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TAImageRectangle(
                                  borderRadius: 5,
                                  product.imageUrl,
                                  width: 40,
                                  height: 40,
                                  boxFit: BoxFit.cover,
                                ),
                                SizedBox(width: 22),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TATitleLargeText(
                                      text: product.title,
                                      color: context.colorScheme.inverseSurface,
                                    ),
                                    SizedBox(height: 3),
                                    TAHeadlineSmallText(
                                      text: product.price,
                                      fontWeight: FontWeight.w700,
                                      color: context.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 25),
                              ),
                              child: Text(
                                S.current.orderHistoryDeliveredButton,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
