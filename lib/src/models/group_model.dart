import 'package:objectbox/objectbox.dart';
import 'package:tasklist_app/src/models/task_model.dart';

@Entity()
class Group {
  int id = 0;
  String name;
  int color;

  @Backlink()
  final tasks = ToMany<Task>();

  Group({required this.name, required this.color});

  String tasksDescription() {
    final tasksCompleted = tasks.where((task) => task.completada).length;
    if (tasks.isEmpty) {
      return '';
    }

    return '$tasksCompleted de ${tasks.length}';
  }

  bool isCompleted() {
    final tasksCompleted = tasks.where((task) => task.completada).length;
    if (tasks.isNotEmpty && tasksCompleted == tasks.length) {
      return true;
    }
    return false;
  }
}
