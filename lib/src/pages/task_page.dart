import 'package:flutter/material.dart';
import 'package:tasklist_app/objectbox.g.dart';
import 'package:tasklist_app/src/models/group_model.dart';
import 'package:tasklist_app/src/models/task_model.dart';
import 'package:tasklist_app/src/utils/snackbar_util.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key, required this.group, required this.store})
      : super(key: key);
  final Group group;
  final Store store;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final textController = TextEditingController();
  final _tasks = <Task>[];
  String? errorMessaje;

  @override
  void initState() {
    _tasks.addAll(List.from(widget.group.tasks));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.red,
            splashColor: Colors.red,
            icon: const Icon(
              Icons.delete_forever_outlined,
              size: 30,
            ),
            onPressed: () => _onDeleteGroup(widget.group),
            tooltip: 'Eliminar Categoría',
          ),
        ],
        title: Text(
          widget.group.name,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                fontFamily: 'Yanone',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Producto...',
                errorText: errorMessaje,
                errorStyle: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Yanone',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 90),
              child: MaterialButton(
                onPressed: _onSave,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                elevation: 10,
                color: Colors.deepPurple,
                splashColor: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/compra.png',
                        color: Colors.yellow,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Crear Compra',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Yanone',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "No se han creado Productos para comprar",
                        style: TextStyle(fontFamily: 'Yanone', fontSize: 22),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return ListTile(
                          title: Text(
                            task.descripcion,
                            style: TextStyle(
                                fontFamily: 'Yanone',
                                fontSize: 24,
                                decoration: task.completada
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          leading: Checkbox(
                            value: task.completada,
                            onChanged: (val) => _onUpdate(index, val!),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_outlined),
                            color: Colors.red,
                            splashColor: Colors.red,
                            tooltip: 'Eliminar Producto',
                            onPressed: () => _onDelete(task),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 15,
        backgroundColor: Colors.deepPurple,
        splashColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        tooltip: 'Eliminar todos los Productos',
        child: const Icon(
          Icons.delete_sweep_outlined,
          size: 25,
          color: Colors.yellow,
        ),
        onPressed: () => _onDeletedTasks(widget.group),
      ),
    );
  }

  void _onSave() {
    final descripcion = textController.text.trim();
    if (descripcion.isNotEmpty) {
      textController.clear();
      final task = Task(descripcion: descripcion);
      task.group.target = widget.group;
      widget.store.box<Task>().put(task);
      setState(() {
        errorMessaje = null;
      });
      _reloadTasks();
    } else {
      setState(() {
        errorMessaje = '* El Nombre es requerido';
      });
    }
  }

  void _reloadTasks() {
    _tasks.clear();
    QueryBuilder<Task> builder = widget.store.box<Task>().query();
    builder.link(Task_.group, Group_.id.equals(widget.group.id));
    Query<Task> query = builder.build();
    List<Task> tasksResult = query.find();
    setState(() {
      _tasks.addAll(tasksResult);
    });
    query.close();
  }

  void _onDelete(Task task) {
    widget.store.box<Task>().remove(task.id);
    _reloadTasks();
  }

  void _onUpdate(int index, bool completed) {
    final task = _tasks[index];
    task.completada = completed;
    widget.store.box<Task>().put(task);
    _reloadTasks();
  }

  void _onDeleteGroup(Group group) {
    widget.store.box<Group>().remove(group.id);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      snackBarUtil(
        'La Categoría fue eliminada con éxito!',
        Colors.green,
        const Icon(
          Icons.check_circle_outline,
          color: Colors.black,
        ),
      ),
    );
  }

  void _onDeletedTasks(Group group) {
    QueryBuilder<Task> builder = widget.store.box<Task>().query();
    builder.link(Task_.group, Group_.id.equals(widget.group.id));
    Query<Task> query = builder.build();
    List<Task> tasksResult = query.find();
    if (tasksResult.isNotEmpty) {
      setState(() {
        for (var task in tasksResult) {
          _onDelete(task);
        }
      });
      query.close();
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtil(
          'Todas los Productos fueron eliminados con éxito!',
          Colors.green,
          const Icon(
            Icons.check_circle_outline,
            color: Colors.black,
          ),
        ),
      );
      _reloadTasks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtil(
          'No existen Productos para eliminar!',
          Colors.red,
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.black,
          ),
        ),
      );
    }
  }
}
