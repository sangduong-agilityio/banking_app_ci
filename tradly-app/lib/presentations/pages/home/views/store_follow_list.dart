import 'package:flutter/material.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/widgets/card.dart';

class StoreFollowList extends StatelessWidget {
  const StoreFollowList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return TACardStoreFollow(
            storeName: S.current.homeStoreToFolowTitle,
            imagePath: 'assets/images/shopping.png',
          );
        },
      ),
    );
  }
}
