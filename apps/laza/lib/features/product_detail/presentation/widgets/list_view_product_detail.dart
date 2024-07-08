import 'package:flutter/material.dart';
import 'package:laza/core/widgets/images.dart';

class LSListViewProductDetail extends StatelessWidget {
  const LSListViewProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 77,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(
                right: 15,
              ),
              child: LSImage(
                  width: 77,
                  height: 77,
                  borderRadius: 10,
                  imageUrl: 'https://picsum.photos/seed/picsum/200/300'),
            );
          },
        ),
      ),
    );
  }
}
