import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/core/routes/app_router.dart';
import 'package:tradly_app/core/service/notification_service.dart';
import 'package:tradly_app/data/models/product_model.dart';
import 'package:tradly_app/presentations/layouts/app_bar.dart';
import 'package:tradly_app/presentations/layouts/scaffold.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_event.dart';
import 'package:tradly_app/presentations/pages/product_detail/states/product_detail_state.dart';
import 'package:tradly_app/presentations/widgets/button.dart';
import 'package:tradly_app/presentations/widgets/dialog.dart';
import 'package:tradly_app/presentations/widgets/images.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final supabase = Supabase.instance.client;
  final notiService = NotificationService();

  @override
  void initState() {
    super.initState();
    notiService.initializeFirebaseMessaging();
    notiService.init();
  }

  Future<void> _onGetNotification() async {
    final status = await Permission.notification.status;
    if (status.isGranted || status.isLimited) {
      if (!mounted) return;
      context.read<ProductDetailBloc>().add(
            ProductDetailCheckoutEvt(product: widget.product),
          );
      context.goNamed(
        TAPaths.orderHistory.name,
        extra: widget.product,
      );
    } else if (status.isDenied) {
      final result = await Permission.notification.request();
      if (result.isGranted || result.isLimited) {
        if (!mounted) return;
        context
            .read<ProductDetailBloc>()
            .add(ProductDetailCheckoutEvt(product: widget.product));
        context.goNamed(
          TAPaths.orderHistory.name,
          extra: widget.product,
        );
      } else {
        return;
      }
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;

      _showNotificationPermissionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TAScaffold(
          appBar: TAAppBar.checkout(
            title: S.current.checkoutTitle,
            onBackPressed: () => Navigator.pop(context),
            backgroundColor: context.colorScheme.primary,
          ),
          body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(TAPaths.addAddress.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        color: context.colorScheme.onPrimary,
                        child: state.hasAddress
                            ? Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TATitleLargeText(
                                        text:
                                            '${state.product?.title}, ${state.product?.zipCode}',
                                        color: context.colorScheme.onSurface,
                                      ),
                                      SizedBox(height: 5),
                                      TATitleLargeText(
                                        text:
                                            '${state.product?.city}, ${state.product?.state} ',
                                        color: context.colorScheme.onSecondary,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  OutlinedButton(
                                    onPressed: () {
                                      context.pushNamed(
                                        TAPaths.addAddress.name,
                                        extra: state.product,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          context.colorScheme.primary,
                                      minimumSize: const Size(100, 25),
                                      side: BorderSide(
                                        color: context.colorScheme.primary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                    ),
                                    child: TATitleMediumText(
                                      text: S.current
                                          .productDetailLocationChangeButton,
                                      color: context.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: TATitleLargeText(
                                  text: S.current.checkoutAddNewAddressTitle,
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: context.colorScheme.onPrimary,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                TAImageRectangle(
                                  widget.product.imageUrl,
                                  borderRadius: 5,
                                  width: 100,
                                  height: 100,
                                  boxFit: BoxFit.cover,
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TATitleLargeText(
                                      text: widget.product.title,
                                      color: context.colorScheme.onSurface,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        TATitleLargeText(
                                          text: widget.product.newPrice ?? '',
                                          color: context.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 5),
                                        TATitleLargeText(
                                          text: widget.product.price,
                                          color: context.colorScheme.onSurface,
                                        ),
                                        const SizedBox(width: 5),
                                        TATitleLargeText(
                                          text: S.current
                                              .productDetailDiscountTitle,
                                          color: context.colorScheme.onSurface,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    TATitleMediumText(
                                      text:
                                          S.current.productDetailQuantityTitle,
                                      color: context.colorScheme.onSurface,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(color: Colors.grey[300]),
                          TextButton(
                            onPressed: () {},
                            child: TATitleLargeText(
                              text: S.current.storeRemoveButton,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      width: double.infinity,
                      color: context.colorScheme.onPrimary,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TAHeadlineMediumText(
                                  text: S.current.checkoutPriceDetailsTitle,
                                  fontWeight: FontWeight.w600,
                                  color: context.colorScheme.onSurface,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TATitleLargeText(
                                      text:
                                          S.current.checkoutPriceItemTitle('1'),
                                      color: context.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TATitleLargeText(
                                      text: widget.product.newPrice ?? '',
                                      color: context.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TATitleLargeText(
                                      text: S.current.checkoutDeliveryFreeTitle,
                                      color: context.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TATitleLargeText(
                                      text: S.current.checkoutInforTitle,
                                      color: context.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TAHeadlineMediumText(
                                  text: S.current.checkoutTotalAmountTitle,
                                  fontWeight: FontWeight.w600,
                                  color: context.colorScheme.onSurface,
                                ),
                                TATitleLargeText(
                                  text: widget.product.newPrice ?? '',
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
              onPressed: _onGetNotification,
            ),
          ),
        ),
      ],
    );
  }

  Future _showNotificationPermissionDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return TADialog(
          title: S.current.tradlyAppTitle,
          content: S.current.tradlyAppContent,
          confirmButton: S.current.tradlySettingButton,
          confirmCancel: S.current.tradlyCancelButton,
          onAccept: () {
            openAppSettings();
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
