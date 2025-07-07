import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/home/models/product_model.dart';
import 'package:tradly_app/features/store/models/store_model.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/widgets/icons.dart';
import 'package:tradly_app/widgets/images.dart';
import 'package:tradly_app/widgets/text.dart';

class TACardProduct extends StatelessWidget {
  const TACardProduct({
    super.key,
    required this.product,
    this.onTapProduct,
    this.height,
    this.width,
    this.label,
    this.hint,
  });

  final ProductModel product;
  final void Function()? onTapProduct;
  final double? height;
  final double? width;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final isGalleryImage = File(product.imageUrl).existsSync();
    final isValidImage =
        isGalleryImage && File(product.imageUrl).lengthSync() > 0;

    return Semantics(
      label: label,
      hint: hint,
      container: true,
      child: GestureDetector(
        onTap: onTapProduct,
        child: SizedBox(
          height: height ?? 200,
          width: width ?? 160,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Image of ${product.title}',
                    child: isValidImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.file(
                              File(product.imageUrl),
                              width: width ?? double.infinity,
                              height: height ?? 130,
                              fit: BoxFit.cover,
                            ),
                          )
                        : TAImageRectangle(
                            product.imageUrl,
                            isBorderTop: true,
                            width: width ?? double.infinity,
                            height: height ?? 130,
                            boxFit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11, right: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Semantics(
                        excludeSemantics: true,
                        child: TATitleLargeText(
                          text: product.title,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Semantics(
                            excludeSemantics: true,
                            child: TAImageCircle(
                              radius: 10,
                              Assets.images.imgTradly.path,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Semantics(
                              child: TATitleLargeText(
                                text: product.brand ?? '',
                                fontWeight: FontWeight.w500,
                                color: context.colorScheme.outline,
                              ),
                            ),
                          ),
                          Semantics(
                            excludeSemantics: true,
                            label: product.newPrice != null
                                ? 'Discount price: \$${product.price}'
                                : 'No discount available',
                            child: TALabelLargeText(
                              decoration: TextDecoration.combine([
                                TextDecoration.lineThrough,
                              ]),
                              text: product.newPrice != null
                                  ? '\$${product.newPrice}'
                                  : '',
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Semantics(
                            excludeSemantics: true,
                            label: 'Original price: \$${product.price}',
                            child: TATitleLargeText(
                              text: '\$${product.price}',
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TACardStoreFollow extends StatelessWidget {
  const TACardStoreFollow({
    super.key,
    required this.stores,
    this.height,
    this.width,
    this.onTap,
  });

  final StoreModel stores;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 200,
      width: width ?? 160,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  TAImageRectangle(
                    stores.imageUrl ?? '',
                    isBorderTop: true,
                    width: width ?? double.infinity,
                    height: height ?? 75,
                    boxFit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 40,
                    left: 40,
                    child: TAImageCircle(
                      radius: 32,
                      stores.logoStore ?? '',
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              TATitleLargeText(
                text: stores.storeName,
                color: context.colorScheme.onSurface,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 25),
                    backgroundColor: context.colorScheme.primary,
                  ),
                  child: TATitleMediumText(
                    text: S.current.homeFollowButton,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TAPhotoUpload extends StatelessWidget {
  const TAPhotoUpload({
    super.key,
    required this.imageFiles,
    required this.maxPhotos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  final List<File> imageFiles;
  final int maxPhotos;
  final VoidCallback onAddPhoto;
  final void Function(int index) onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildAddPhotoBox(context),
            );
          } else {
            return _buildPhotoBox(imageFiles[index - 1], index - 1, context);
          }
        },
      ),
    );
  }

  Widget _buildAddPhotoBox(BuildContext context) {
    return GestureDetector(
      onTap: onAddPhoto,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TAIcons.add(),
            TATitleLargeText(
              text: 'Add Photo',
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
            TALabelLargeText(
              text: 'Max $maxPhotos photos',
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBox(File imageFile, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemovePhoto(index),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      context.colorScheme.onSecondaryContainer.withAlpha(150),
                  shape: BoxShape.circle,
                ),
                child: TAIcons.close(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
