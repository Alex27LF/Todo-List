import 'package:flutter/material.dart';
import 'package:tasklist_app/src/models/group_model.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({Key? key, required this.group, required this.onTap})
      : super(key: key);
  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final descripcion = group.tasksDescription();
    final isCompleted = group.isCompleted();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(2, 5), // changes position of shadow
              ),
            ],
            color: isCompleted ? Colors.green : Color(group.color),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  group.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Yanone',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (descripcion.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Yanone',
                      fontWeight: FontWeight.w100,
                    ),
                  )
                ],
                if (isCompleted) ...[
                  const SizedBox(height: 10),
                  Image.asset('assets/img/completo.png')
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
