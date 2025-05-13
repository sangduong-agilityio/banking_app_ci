import 'package:flutter/material.dart';
import 'package:tradly_app/core/extensions/context_extensions.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/presentations/widgets/text.dart';
import 'package:tradly_app/presentations/pages/browse/states/browse_event.dart';

class TABottomSheet extends StatefulWidget {
  final SortOrder initialSortOrder;
  final Function(SortOrder) onApply;

  const TABottomSheet({
    super.key,
    required this.initialSortOrder,
    required this.onApply,
  });

  @override
  State<TABottomSheet> createState() => _TABottomSheetState();
}

class _TABottomSheetState extends State<TABottomSheet> {
  late SortOrder selectedSortOrder;

  @override
  void initState() {
    super.initState();
    selectedSortOrder = widget.initialSortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 24),
            child: TAHeadlineMediumText(
              text: S.current.browseSortbyTitle,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
          _sortOption(
            context: context,
            title: S.current.browsePriceLowToHighTitle,
            isSelected: selectedSortOrder == SortOrder.lowToHigh,
            onTap: () {
              setState(() {
                selectedSortOrder = SortOrder.lowToHigh;
              });
            },
          ),
          const SizedBox(height: 16),
          _sortOption(
            context: context,
            title: S.current.browsePriceHighToLowTitle,
            isSelected: selectedSortOrder == SortOrder.highToLow,
            onTap: () {
              setState(() {
                selectedSortOrder = SortOrder.highToLow;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: TAHeadlineMediumText(
                  text: S.current.browseCancelButton,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onApply(selectedSortOrder);
                  Navigator.pop(context);
                },
                child: TAHeadlineMediumText(
                  text: S.current.browseApplyButton,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sortOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = context.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? selectedColor : context.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            TAHeadlineSmallText(
              text: title,
              fontWeight: FontWeight.w500,
              color:
                  isSelected ? selectedColor : context.colorScheme.onSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
