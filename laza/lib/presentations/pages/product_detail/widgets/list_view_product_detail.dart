import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/presentations/widgets/images.dart';

class ListViewProductDetail extends StatelessWidget {
  const ListViewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 77.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: LSImage(
                width: 77.w,
                height: 77.h,
                borderRadius: 10,
                imageUrl: Assets.images.dataImage.path,
              ),
            );
          },
        ),
      ),
    );
  }
}
