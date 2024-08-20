import 'package:flutter/material.dart';
import 'package:laza/core/constant/constants.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'size.dart';

class ListViewSizeProduct extends StatelessWidget {
  ListViewSizeProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tabletScreen = context.mediaQueryData.size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: tabletScreen > 600 ? 120.h : 60.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 13,
              ),
              child: LSSize(
                size: Constants.sizes[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
