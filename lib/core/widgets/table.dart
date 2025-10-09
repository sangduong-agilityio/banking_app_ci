import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A generic data table widget that can be used to display a list of items in a table format.
class BADataTable<T> extends StatelessWidget {
  /// Creates a [BADataTable] widget.
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

  /// The list of column configurations.
  final List<TableColumn> columns;

  /// The list of data items to display.
  final List<T> data;

  /// The builder function to create the row content from a data item.
  final Widget Function(BuildContext context, T item, List<TableColumn> columns)
  itemBuilder;

  /// The padding around the entire table.
  final EdgeInsets padding;

  /// The padding for each item row.
  final EdgeInsets itemPadding;

  /// Whether to show dividers between rows.
  final bool showDividers;

  /// The color of the dividers.
  final Color? dividerColor;

  /// The custom style for the header text.
  final TextStyle? headerStyle;

  /// The callback that is called when an item is tapped.
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

  /// Builds the header of the table.
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

  /// Builds a single data row of the table.
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

/// A class that represents a column in the data table.
class TableColumn {
  /// Creates a [TableColumn] object.
  const TableColumn({
    required this.title,
    required this.flex,
    this.alignment = TextAlign.left,
    this.headerStyle,
  });

  /// The title of the column.
  final String title;

  /// The flex value for the column width.
  final int flex;

  /// The text alignment of the column.
  final TextAlign alignment;

  /// The custom header style for the column.
  final TextStyle? headerStyle;
}

/// A generic row builder for simple tables.
class BATableRow extends StatelessWidget {
  /// Creates a [BATableRow] widget.
  const BATableRow({
    super.key,
    required this.values,
    required this.columns,
    this.valueStyles,
  });

  /// The list of values to display in the row.
  final List<String> values;

  /// The list of column configurations.
  final List<TableColumn> columns;

  /// The list of custom text styles for the values.
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
