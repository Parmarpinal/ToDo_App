import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/CompleteTasks.dart';
import 'package:todo_app/IncompleteTasks.dart';
import 'package:todo_app/TaskForm.dart';
import 'package:todo_app/database/myDatabase.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: DropdownMenu(
            onSelected: (task) {
              if (task == 'completed') {
                isCompleted = true;
              } else {
                isCompleted = false;
              }
              setState(() {});
            },
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: InputBorder.none,
            ),
            hintText: "Remaining Tasks",
            textStyle: TextStyle(fontSize: 20),
            dropdownMenuEntries: [
              DropdownMenuEntry(
                  value: 'incompleted',
                  label: 'Remaining Tasks',
                  style: ButtonStyle(
                      textStyle:
                          MaterialStatePropertyAll(TextStyle(fontSize: 16))),
                  enabled: true),
              DropdownMenuEntry(
                  value: 'completed',
                  label: 'Completed Tasks',
                  style: ButtonStyle(
                      textStyle:
                          MaterialStatePropertyAll(TextStyle(fontSize: 16)))),
            ]),
      ),
      body: (isCompleted) ? CompleteTasks() : IncompleteTasks(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => TaskForm(
              map: null,
            ),
          ))
              .then((value) {
            if (value == true) {
              setState(() {});
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
