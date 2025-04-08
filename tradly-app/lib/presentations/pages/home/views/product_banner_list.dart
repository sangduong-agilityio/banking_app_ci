import 'package:flutter/widgets.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class ProductBannerList extends StatelessWidget {
  const ProductBannerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 16,
            ),
            child: SizedBox(
              width: 300,
              child: TACard(
                title: 'READY TO DELIVER TO\nYOUR HOME',
                textButton: 'START SHOPPING',
                image: Image.asset('assets/images/vegetable.png'),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
