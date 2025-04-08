import 'package:flutter/material.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 93,
      width: 93,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: CenteredApiImage(
                src: '',
                text: 'sss',
              ),
            );
          },
          itemCount: 8),
    );
  }
}
