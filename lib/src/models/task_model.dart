import 'package:objectbox/objectbox.dart';
import 'package:tasklist_app/src/models/group_model.dart';

@Entity()
class Task {
  int id = 0;
  String descripcion;
  bool completada = false;

  final group = ToOne<Group>();

  Task({required this.descripcion});
}
