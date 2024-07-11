import 'package:flutter/material.dart';
import 'size.dart';

class ListViewSizeProduct extends StatelessWidget {
  ListViewSizeProduct({
    super.key,
  });

  final sizes = ["S", "M", "L", "XL", "2XL"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
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
              size: sizes[index],
            ),
          );
        },
      ),
    );
  }
}
