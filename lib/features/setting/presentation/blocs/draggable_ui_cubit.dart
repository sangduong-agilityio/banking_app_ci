import 'package:banking_app/features/setting/presentation/widgets/draggable_ui_demo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/setting/data/models/mock_draggable_items.dart';
import 'package:banking_app/features/setting/presentation/blocs/draggable_ui_state.dart';

class DraggableUICubit extends Cubit<DraggableUIState> {
  DraggableUICubit() : super(_createInitialState());

  static DraggableUIState _createInitialState() {
    return DraggableUIState(
      tableItems: MockDraggableItems.generateTableItems(),
      gridItems: MockDraggableItems.generateGridItems(),
      kanbanColumns: MockDraggableItems.generateKanbanColumns(),
    );
  }

  /// Reorder items in table view
  void reorderTableItems(int oldIndex, int newIndex) {
    final items = List<TaskItem>.from(state.tableItems);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    emit(state.copyWith(tableItems: items));
  }

  /// Reorder items in grid view
  void reorderGridItems(int oldIndex, int newIndex) {
    final items = List<TaskItem>.from(state.gridItems);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    emit(state.copyWith(gridItems: items));
  }

  /// Move kanban card between columns
  void moveKanbanCard(TaskItem item, String targetColumn) {
    final newColumns = Map<String, List<TaskItem>>.from(state.kanbanColumns);

    // Remove from all columns
    newColumns.forEach((key, value) {
      value.removeWhere((task) => task.id == item.id);
    });

    // Add to target column
    if (newColumns.containsKey(targetColumn)) {
      newColumns[targetColumn] = [...newColumns[targetColumn]!, item];
    }

    emit(state.copyWith(kanbanColumns: newColumns));
  }

  /// Change current tab
  void changeTab(DraggableUITab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  /// Reset to initial state
  void reset() {
    emit(_createInitialState());
  }
}
