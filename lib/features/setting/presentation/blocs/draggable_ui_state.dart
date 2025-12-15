import 'package:banking_app/features/setting/presentation/widgets/draggable_ui_demo.dart';

enum DraggableUITab { table, grid, kanban }

final class DraggableUIState {
  const DraggableUIState({
    this.tableItems = const [],
    this.gridItems = const [],
    this.kanbanColumns = const {},
    this.currentTab = DraggableUITab.table,
  });

  final List<TaskItem> tableItems;
  final List<TaskItem> gridItems;
  final Map<String, List<TaskItem>> kanbanColumns;
  final DraggableUITab currentTab;

  DraggableUIState copyWith({
    List<TaskItem>? tableItems,
    List<TaskItem>? gridItems,
    Map<String, List<TaskItem>>? kanbanColumns,
    DraggableUITab? currentTab,
  }) {
    return DraggableUIState(
      tableItems: tableItems ?? this.tableItems,
      gridItems: gridItems ?? this.gridItems,
      kanbanColumns: kanbanColumns ?? this.kanbanColumns,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
