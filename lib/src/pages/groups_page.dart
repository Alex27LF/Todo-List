import 'package:flutter/material.dart';
import 'package:tasklist_app/objectbox.g.dart';
import 'package:tasklist_app/src/models/group_model.dart';
import 'package:tasklist_app/src/pages/add_group_page.dart';
import 'package:tasklist_app/src/pages/task_page.dart';
import 'package:tasklist_app/src/utils/snackbar_util.dart';
import 'package:tasklist_app/src/widgets/group_item_widget.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final _groups = <Group>[];
  late final Store _store;
  late final Box<Group> _groupsBox;

  @override
  void initState() {
    _loadStore();
    super.initState();
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lista de Compras"),
        actions: [
          InkWell(
            splashColor: Colors.red,
            child: Image.asset(
              'assets/img/eliminar.png',
              color: Colors.red,
            ),
            onTap: () => _onDeleteGroups(),
          ),
        ],
      ),
      body: _groups.isEmpty
          ? const Center(
              child: Text(
                "No se han creado Categorías",
                style: TextStyle(fontFamily: 'Yanone', fontSize: 22),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return GroupItem(onTap: () => _goToTasks(group), group: group);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 15,
        backgroundColor: Colors.deepPurple,
        splashColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        onPressed: _addGroup,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/agregar.png',
              color: Colors.yellow,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5),
            const Text(
              'Agregar Categoría',
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
    );
  }

  Future<void> _addGroup() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddGroupPage(),
    );

    if (result != null && result is Group) {
      _groupsBox.put(result);
      _loadGroups();
    }
  }

  Future<void> _loadStore() async {
    _store = await openStore();
    _groupsBox = _store.box<Group>();
    _loadGroups();
  }

  void _loadGroups() {
    _groups.clear();
    setState(() {
      _groups.addAll(_groupsBox.getAll());
    });
  }

  Future<void> _goToTasks(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TasksPage(group: group, store: _store),
      ),
    );

    _loadGroups();
  }

  void _onDeleteGroups() {
    if (_store.box<Group>().count() != 0) {
      setState(() {
        _store.box<Group>().removeAll();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtil(
          'Todas las Categorías fueron eliminadas con éxito!',
          Colors.green,
          const Icon(
            Icons.check_circle_outline,
            color: Colors.black,
          ),
        ),
      );
      _loadGroups();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarUtil(
          'No existen Categorías para eliminar!',
          Colors.redAccent,
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.black,
          ),
        ),
      );
    }
  }
}
