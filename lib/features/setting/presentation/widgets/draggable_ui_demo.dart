import 'package:banking_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/widgets/layouts/app_bar.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/setting/presentation/blocs/draggable_ui_cubit.dart';
import 'package:banking_app/features/setting/presentation/blocs/draggable_ui_state.dart';

class DraggableUIDemo extends StatefulWidget {
  const DraggableUIDemo({super.key});

  @override
  State<DraggableUIDemo> createState() => _DraggableUIDemoState();
}

class _DraggableUIDemoState extends State<DraggableUIDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DraggableUICubit(),
      child: BAScaffold(
        appBar: BAAppBar(
          title: 'Draggable UI Demo',
          titleColor: context.colorScheme.onPrimary,
          alignment: BAAppBarAlignment.left,
          iconColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.secondary,
        ),
        body: BlocBuilder<DraggableUICubit, DraggableUIState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.secondary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: context.colorScheme.onPrimary,
                    unselectedLabelColor: context.colorScheme.secondary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.secondary,
                          context.colorScheme.secondary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    tabs: const [
                      Tab(
                        text: 'Table',
                        icon: Icon(Icons.table_rows, size: 20),
                      ),
                      Tab(text: 'Grid', icon: Icon(Icons.dashboard, size: 20)),
                      Tab(
                        text: 'Kanban',
                        icon: Icon(Icons.view_kanban, size: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTableView(context, state),
                      _buildGridView(context, state),
                      _buildKanbanView(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Table view with draggable rows
  Widget _buildTableView(BuildContext context, DraggableUIState state) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: state.tableItems.length,
      onReorder: (oldIndex, newIndex) {
        context.read<DraggableUICubit>().reorderTableItems(oldIndex, newIndex);
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: child,
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final item = state.tableItems[index];
        return _buildTableRow(context, item, index);
      },
    );
  }

  Widget _buildTableRow(BuildContext context, TaskItem item, int index) {
    return Container(
      key: ValueKey(item.id),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.secondary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.drag_handle,
                color: context.colorScheme.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: context.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: context.bodySmall?.copyWith(
                      color: context.colorScheme.secondary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildPriorityChip(item.priority)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatusChip(item.status ?? 'Pending')),
          ],
        ),
      ),
    );
  }

  /// Grid view with draggable items
  Widget _buildGridView(BuildContext context, DraggableUIState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: _ReorderableGridView(
        itemCount: state.gridItems.length,
        crossAxisCount: 3,
        onReorder: (oldIndex, newIndex) {
          context.read<DraggableUICubit>().reorderGridItems(oldIndex, newIndex);
        },
        items: state.gridItems,
      ),
    );
  }

  /// Kanban board view with draggable cards between columns
  Widget _buildKanbanView(BuildContext context, DraggableUIState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: state.kanbanColumns.entries
            .map((entry) => _buildKanbanColumn(context, entry.key, entry.value))
            .toList(),
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    String title,
    List<TaskItem> items,
  ) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.secondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getColumnColor(title).withOpacity(0.15),
                  _getColumnColor(title).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getColumnColor(title).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getColumnIcon(title),
                    color: _getColumnColor(title),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getColumnColor(title),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getColumnColor(title),
                        _getColumnColor(title).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getColumnColor(title).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: DragTarget<TaskItem>(
              onWillAccept: (data) => data != null,
              onAccept: (data) {
                context.read<DraggableUICubit>().moveKanbanCard(data, title);
              },
              builder: (context, candidateData, rejectedData) {
                final isReceiving = candidateData.isNotEmpty;
                return Container(
                  decoration: BoxDecoration(
                    color: isReceiving
                        ? _getColumnColor(title).withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildKanbanCard(context, items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(BuildContext context, TaskItem item) {
    return LongPressDraggable<TaskItem>(
      data: item,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 250,
          child: _buildKanbanCardContent(context, item, isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildKanbanCardContent(context, item),
      ),
      child: _buildKanbanCardContent(context, item),
    );
  }

  Widget _buildKanbanCardContent(
    BuildContext context,
    TaskItem item, {
    bool isDragging = false,
  }) {
    return Container(
      key: ValueKey(item.id),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.secondary.withOpacity(
              isDragging ? 0.2 : 0.08,
            ),
            blurRadius: isDragging ? 12 : 6,
            offset: Offset(0, isDragging ? 4 : 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: context.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.drag_indicator,
                  color: context.colorScheme.secondary.withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            _buildPriorityChip(item.priority),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        priority,
        style: context.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: context.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getColumnColor(String columnName) {
    switch (columnName) {
      case 'To Do':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getColumnIcon(String columnName) {
    switch (columnName) {
      case 'To Do':
        return Icons.pending_actions;
      case 'In Progress':
        return Icons.autorenew;
      case 'Done':
        return Icons.check_circle;
      default:
        return Icons.label;
    }
  }
}

/// Data model for task items
class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.status,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final String? status;
}

/// Custom ReorderableGridView widget
class _ReorderableGridView extends StatefulWidget {
  const _ReorderableGridView({
    required this.itemCount,
    required this.crossAxisCount,
    required this.onReorder,
    required this.items,
  });

  final int itemCount;
  final int crossAxisCount;
  final void Function(int oldIndex, int newIndex) onReorder;
  final List<TaskItem> items;

  @override
  State<_ReorderableGridView> createState() => _ReorderableGridViewState();
}

class _ReorderableGridViewState extends State<_ReorderableGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return _buildGridItem(item, index);
      },
    );
  }

  Widget _buildGridItem(TaskItem item, int index) {
    return DragTarget<int>(
      onWillAccept: (data) => data != null && data != index,
      onAccept: (oldIndex) {
        widget.onReorder(oldIndex, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isReceiving = candidateData.isNotEmpty;
        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 120,
              height: 140,
              child: _buildGridItemContent(item, isDragging: true),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildGridItemContent(item),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isReceiving
                  ? Border.all(color: context.colorScheme.secondary, width: 2)
                  : null,
            ),
            child: _buildGridItemContent(item),
          ),
        );
      },
    );
  }

  Widget _buildGridItemContent(TaskItem item, {bool isDragging = false}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.secondary.withOpacity(
              isDragging ? 0.2 : 0.08,
            ),
            blurRadius: isDragging ? 12 : 6,
            offset: Offset(0, isDragging ? 4 : 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getPriorityColor(item.priority).withOpacity(0.2),
                    _getPriorityColor(item.priority).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt,
                color: _getPriorityColor(item.priority),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: context.bodySmall?.copyWith(
                color: context.colorScheme.secondary.withOpacity(0.6),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(item.priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getPriorityColor(item.priority),
                  width: 1,
                ),
              ),
              child: Text(
                item.priority,
                style: context.labelSmall?.copyWith(
                  color: _getPriorityColor(item.priority),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
