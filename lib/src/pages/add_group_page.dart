import 'package:flutter/material.dart';
import 'package:tasklist_app/src/models/group_model.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  Color selectedColor = Colors.primaries.first;
  final textController = TextEditingController();
  String? errorMessaje;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.38,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: selectedColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/tareas.png'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Yanone',
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          errorText: errorMessaje,
                          errorStyle: TextStyle(
                              color: Colors.red.shade300,
                              fontFamily: 'Yanone',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          hintText: 'Nombre del Categoría',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'Seleccione el Color:',
                        style: TextStyle(
                          fontFamily: 'Yanone',
                          fontSize: 23,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: Colors.primaries.length,
                        itemBuilder: (context, index) {
                          final color = Colors.primaries[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: InkWell(
                              onTap: () => {
                                setState(() {
                                  selectedColor = color;
                                })
                              },
                              child: CircleAvatar(
                                backgroundColor: color,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        elevation: 12,
                        color: Colors.deepPurple,
                        splashColor: Colors.blueGrey,
                        onPressed: _onSave,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/guardar.png',
                                color: Colors.yellow,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Crear Categoría',
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSave() {
    final name = textController.text.trim();
    if (name.isEmpty) {
      setState(() {
        errorMessaje = '* El Nombre es requerido';
      });
      return;
    } else {
      setState(() {
        errorMessaje = null;
      });
    }
    final result = Group(name: name, color: selectedColor.value);
    Navigator.of(context).pop(result);
  }
}
