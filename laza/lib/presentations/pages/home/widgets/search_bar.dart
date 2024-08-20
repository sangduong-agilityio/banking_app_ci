import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/themes/colors.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/product_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

final searchQueryProvider = StateProvider<String>((ref) => '');

class LSSearchBar extends ConsumerWidget {
  const LSSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapIcon,
    this.onTap,
    this.focusNode,
    this.icon,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTapIcon;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Widget? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabletScreen = context.mediaQueryData.size.width;
    final searchQueryNotifier = ref.read(searchQueryProvider.notifier);
    final searchQuery = ref.watch(searchQueryProvider);
    final TextEditingController textController =
        controller ?? TextEditingController(text: searchQuery);

    final speechToText = stt.SpeechToText();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: tabletScreen > 600 ? 650.w : 280.w,
          height: tabletScreen > 600 ? 70.w : 50.h,
          child: SearchBar(
            onTap: onTap,
            focusNode: focusNode,
            controller: textController,
            onChanged: (value) {
              searchQueryNotifier.state = value;
              if (onChanged != null) onChanged!(value);
              ref
                  .read(productsNotifierProvider(searchQuery).notifier)
                  .search(value);
            },
            backgroundColor: WidgetStateProperty.all(LSColors.grey200),
            textCapitalization: TextCapitalization.words,
            hintText: S.current.searchInput,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapIcon,
                child: icon ?? LSIcons.icSearch,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          height: tabletScreen > 600 ? 70.w : 50.h,
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: context.colorScheme.primary,
              onPressed: () async {
                bool available = await speechToText.initialize(
                  onStatus: (val) => ('onStatus: $val'),
                  onError: (val) => ('onError: $val'),
                );
                if (available) {
                  speechToText.listen(
                    onResult: (val) {
                      textController.text = val.recognizedWords;
                      searchQueryNotifier.state = val.recognizedWords;
                      ref
                          .read(productsNotifierProvider(
                                  searchQueryNotifier.state)
                              .notifier)
                          .search(val.recognizedWords);
                    },
                  );
                }
              },
              child: LSIcons.icVoice,
            ),
          ),
        )
      ],
    );
  }
}
