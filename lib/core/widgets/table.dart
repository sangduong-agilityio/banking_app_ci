import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class BADataTable<T> extends StatelessWidget {
  const BADataTable({
    super.key,
    required this.columns,
    required this.data,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(24),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.showDividers = true,
    this.dividerColor,
    this.headerStyle,
    this.onItemTap,
  });

  /// List of column configurations
  final List<TableColumn> columns;

  /// List of data items to display
  final List<T> data;

  /// Builder function to create row content from data item
  final Widget Function(BuildContext context, T item, List<TableColumn> columns)
  itemBuilder;

  /// Padding around the entire table
  final EdgeInsets padding;

  /// Padding for each item row
  final EdgeInsets itemPadding;

  /// Whether to show dividers between rows
  final bool showDividers;

  /// Color for dividers
  final Color? dividerColor;

  /// Custom style for header text
  final TextStyle? headerStyle;

  /// Callback when an item is tapped
  final Function(T item, int index)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(context),

        // Data rows
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _buildDataRow(context, data[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        children: columns.map((column) {
          return Expanded(
            flex: column.flex,
            child: Text(
              column.title,
              textAlign: column.alignment,
              style:
                  headerStyle ??
                  context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.inverseSurface,
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, T item, int index) {
    return Column(
      children: [
        InkWell(
          onTap: onItemTap != null ? () => onItemTap!(item, index) : null,
          child: Padding(
            padding: itemPadding,
            child: itemBuilder(context, item, columns),
          ),
        ),
        if (showDividers && index < data.length - 1)
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
            color: dividerColor ?? Colors.grey[300],
          ),
      ],
    );
  }
}

/// Configuration for a table column
class TableColumn {
  const TableColumn({
    required this.title,
    required this.flex,
    this.alignment = TextAlign.left,
    this.headerStyle,
  });

  /// Column title
  final String title;

  /// Flex value for column width
  final int flex;

  /// Text alignment
  final TextAlign alignment;

  /// Custom header style
  final TextStyle? headerStyle;
}

/// Generic row builder for simple 3-column tables
class BATableRow extends StatelessWidget {
  const BATableRow({
    super.key,
    required this.values,
    required this.columns,
    this.valueStyles,
  });

  final List<String> values;
  final List<TableColumn> columns;
  final List<TextStyle?>? valueStyles;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(columns.length, (index) {
        if (index >= values.length) return const SizedBox();

        return Expanded(
          flex: columns[index].flex,
          child: Text(
            values[index],
            textAlign: columns[index].alignment,
            style:
                valueStyles?[index] ??
                context.titleMedium?.copyWith(color: context.colorScheme.scrim),
          ),
        );
      }),
    );
  }
}
