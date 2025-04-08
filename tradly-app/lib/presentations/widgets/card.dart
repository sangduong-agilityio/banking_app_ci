import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/presentations/widgets/text.dart';

class TACard extends StatelessWidget {
  const TACard({
    super.key,
    this.title = '',
    this.textButton = '',
    this.image,
    this.onPressed,
  });

  final String title;
  final String textButton;
  final Widget? image;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: const AssetImage('assets/images/vegetable.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: TaTitleLargeText(
              text: title,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary,
              letterSpacing: 1.22,
              height: 16 / 14,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: context.colorScheme.onPrimary,
                    width: 1,
                  ),
                ),
              ),
              child: TaTitleMediumText(
                text: textButton,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CenteredApiImage extends StatelessWidget {
  const CenteredApiImage({
    required this.src,
    super.key,
    this.text,
  });

  final String? src;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src ?? 'assets/images/vegetable.png',
      imageBuilder: (context, imageProvider) => DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: TaTitleLargeText(
            text: text ?? '',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
