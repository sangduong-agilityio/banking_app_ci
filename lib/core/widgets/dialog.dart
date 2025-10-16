import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';

/// A standard dialog widget that can be used to display a message to the user.
///
/// This dialog has a title, content, and two buttons for confirming or canceling an action.
class BADialog extends StatelessWidget {
  /// Creates a [BADialog] widget.
  const BADialog({
    required this.title,
    required this.content,
    this.confirmButton,
    this.confirmCancel,
    this.onAccept,
    this.onCancel,
    super.key,
  });

  /// The callback that is called when the accept button is tapped.
  final VoidCallback? onAccept;

  /// The callback that is called when the cancel button is tapped.
  final VoidCallback? onCancel;

  /// The title of the dialog.
  final String? title;

  /// The content of the dialog.
  final String? content;

  /// The text to display on the confirm button.
  final String? confirmButton;

  /// The text to display on the cancel button.
  final String? confirmCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? '',
        style: context.headlineMedium,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content ?? '',
        style: context.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(confirmCancel ?? '', style: context.bodyMedium),
            ),
            TextButton(
              onPressed: onAccept,
              child: Text(
                confirmButton ?? '',
                style: context.bodyMedium?.copyWith(
                  color: context.colorScheme.primaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A dialog widget that allows the user to select an item from a list.
///
/// This dialog can also include a search bar to filter the list.
class BASelectorDialog<T> extends StatefulWidget {
  /// Creates a [BASelectorDialog] widget.
  const BASelectorDialog({
    super.key,
    required this.title,
    required this.items,
    required this.value,
    required this.label,
    required this.onSelected,
    this.selectedValue,
    this.enableSearch = true,
    this.enableDivider = true,
    this.searchFilter,
    this.onSearchChanged,
  });

  /// The title of the dialog.
  final String title;

  /// The list of items to display.
  final List<T> items;

  /// The currently selected value.
  final String? selectedValue;

  /// A function that returns the value of an item.
  final String Function(T) value;

  /// A function that returns the label of an item.
  final String Function(T) label;

  /// Whether to enable the search bar.
  final bool enableSearch;

  /// Whether to enable the divider between items.
  final bool enableDivider;

  /// A function that filters the items based on the search query.
  final bool Function(T, String)? searchFilter;

  /// The callback that is called when an item is selected.
  final void Function(T) onSelected;

  /// The callback that is called when the search query changes.
  final void Function(String)? onSearchChanged;

  @override
  State<BASelectorDialog<T>> createState() => _BASelectorDialogState<T>();
}

/// The state for a [BASelectorDialog] widget.
class _BASelectorDialogState<T> extends State<BASelectorDialog<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.enableSearch && _query.isNotEmpty
        ? widget.items
              .where(
                (e) => widget.searchFilter != null
                    ? widget.searchFilter!(e, _query)
                    : widget
                          .label(e)
                          .toLowerCase()
                          .contains(_query.toLowerCase()),
              )
              .toList()
        : widget.items;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search field
                if (widget.enableSearch)
                  BATextField(
                    hint: S.current.searchTitle,
                    hintTextStyle: context.titleSmall?.copyWith(
                      color: context.colorScheme.onTertiary,
                    ),
                    prefixIcon: SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: BAAssets.search(
                          color: context.colorScheme.scrim,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _query = value ?? '');
                      if (widget.onSearchChanged != null) {
                        widget.onSearchChanged!(value ?? '');
                      }
                    },
                  ),

                if (widget.enableSearch) const SizedBox(height: 16),
                // List items
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(child: Text(S.current.noItemsFoundTitle))
                      : widget.enableDivider
                      ? ListView.separated(
                          itemCount: filteredItems.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey.withAlpha(102),
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final itemValue = widget.value(item);
                            final isSelected =
                                itemValue == widget.selectedValue;
                            return _buildListTile(context, item, isSelected);
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final itemValue = widget.value(item);
                            final isSelected =
                                itemValue == widget.selectedValue;
                            return _buildListTile(context, item, isSelected);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a list tile for an item.
  Widget _buildListTile(BuildContext context, T item, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.label(item),
        style: context.titleMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected
              ? context.colorScheme.secondary
              : context.colorScheme.inverseSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: context.colorScheme.secondary)
          : null,
      onTap: () {
        widget.onSelected(item);
        // Navigator.pop(context);
      },
    );
  }
}
