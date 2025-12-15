import 'package:banking_app/features/setting/presentation/widgets/draggable_ui_demo.dart';

/// Mock data for draggable UI demo
class MockDraggableItems {
  /// Generate table items
  static List<TaskItem> generateTableItems() {
    return List.generate(
      8,
      (index) => TaskItem(
        id: 'table-$index',
        title: 'Task ${index + 1}',
        description: 'Description for task ${index + 1}',
        priority: ['Low', 'Medium', 'High'][index % 3],
        status: ['Pending', 'In Progress', 'Done'][index % 3],
      ),
    );
  }

  /// Generate grid items
  static List<TaskItem> generateGridItems() {
    return List.generate(
      12,
      (index) => TaskItem(
        id: 'grid-$index',
        title: 'Item ${index + 1}',
        description: 'Grid item ${index + 1}',
        priority: ['Low', 'Medium', 'High'][index % 3],
      ),
    );
  }

  /// Generate kanban columns with tasks
  static Map<String, List<TaskItem>> generateKanbanColumns() {
    return {
      'To Do': List.generate(
        4,
        (index) => TaskItem(
          id: 'todo-$index',
          title: 'Task ${index + 1}',
          description: 'Todo task ${index + 1}',
          priority: ['Low', 'Medium', 'High'][index % 3],
        ),
      ),
      'In Progress': List.generate(
        3,
        (index) => TaskItem(
          id: 'progress-$index',
          title: 'Task ${index + 5}',
          description: 'In progress task ${index + 5}',
          priority: ['Low', 'Medium', 'High'][index % 3],
        ),
      ),
      'Done': List.generate(
        2,
        (index) => TaskItem(
          id: 'done-$index',
          title: 'Task ${index + 8}',
          description: 'Done task ${index + 8}',
          priority: ['Low', 'Medium', 'High'][index % 3],
        ),
      ),
    };
  }
}
