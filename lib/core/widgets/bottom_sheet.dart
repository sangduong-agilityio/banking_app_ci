import 'package:banking_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef OnItemSelected<T> = void Function(T item);
typedef SearchFilter<T> = bool Function(T item, String query);

class BASelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final OnItemSelected<T>? onItemSelected;
  final bool enableSearch;
  final SearchFilter<T>? searchFilter;

  const BASelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onItemSelected,
    this.enableSearch = false,
    this.searchFilter,
  });

  @override
  State<BASelectionSheet<T>> createState() => _BASelectionSheetState<T>();
}

class _BASelectionSheetState<T> extends State<BASelectionSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty || widget.searchFilter == null) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items
            .where((item) => widget.searchFilter!(item, query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Text(widget.title, style: context.displaySmall),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),

          if (widget.enableSearch)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

          SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredItems.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return InkWell(
                  onTap: () {
                    if (widget.onItemSelected != null) {
                      widget.onItemSelected!(item);
                    }
                    Navigator.pop(context);
                    HapticFeedback.selectionClick();
                  },
                  child: widget.itemBuilder(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
