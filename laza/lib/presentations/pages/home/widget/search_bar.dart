import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/themes/colors.dart';
import 'package:laza/presentations/widgets/icons.dart';
import 'package:laza/providers/product_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Create a StateProvider to store the search query
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

  /// Controller of editing text
  final TextEditingController? controller;

  /// Function trigger when onChanged
  final Function(String)? onChanged;

  /// Function trigger when submit
  final Function(String)? onSubmitted;

  /// Function on Tap icon
  final Function()? onTapIcon;

  /// Function tap open view suggestion
  final VoidCallback? onTap;

  /// FocusNode of search bar
  final FocusNode? focusNode;

  /// Custom icon
  final Widget? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWithTablet = MediaQuery.of(context).size.width;

    /// Get the search query notifier and current search query
    final searchQueryNotifier = ref.read(searchQueryProvider.notifier);
    final searchQuery = ref.read(searchQueryProvider);

    /// Create a TextEditingController with the current search query
    final TextEditingController textController =
        controller ?? TextEditingController(text: searchQuery);

    /// Initialize speech to text
    final speechToText = stt.SpeechToText();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWithTablet > 600 ? 650.w : 280.w,
          height: 50.h,
          child: SearchBar(
            onTap: onTap,
            focusNode: focusNode,
            controller: textController,
            onChanged: (value) {
              searchQueryNotifier.state = value;
              if (onChanged != null) onChanged!(value);
              ref.read(productsNotifierProvider.notifier).search(value);
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
          height: 50,
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
