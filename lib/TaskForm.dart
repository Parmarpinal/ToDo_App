import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/database/myDatabase.dart';
import 'package:todo_app/home.dart';

class TaskForm extends StatefulWidget {
  Map<String, dynamic>? map;

  TaskForm({this.map});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  GlobalKey<FormState> key1 = GlobalKey();
  var nameController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.map != null) {
      nameController.text = widget.map!['taskName'];
      dateController.text = widget.map!['dueDate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Enter your task",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: key1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter task";
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.abc,
                          size: 22,
                        ),
                        prefixIconColor: Colors.grey,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 4)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.red, width: 3)),
                        labelText: "Task",
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter date";
                        }
                      },
                      controller: dateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          size: 20,
                        ),
                        prefixIconColor: Colors.grey,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 4)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                            BorderSide(color: Colors.red, width: 3)),
                        labelText: "Due date",
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w800),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formatedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            dateController.text = formatedDate;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (key1.currentState!.validate()) {
                          if (widget.map == null) {
                            await addData().then(
                                (value){
                                  Navigator.of(context).pop(true);
                                });
                          } else {
                            await updateData().then(
                                (value){
                                  Navigator.of(context).pop(true);
                                });
                          }
                        }
                      },
                      child: (widget.map == null)
                          ? Text(
                              "Add",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          : Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.inversePrimary),
                        padding: MaterialStatePropertyAll(EdgeInsets.only(
                            bottom: 15, top: 15, left: 25, right: 25)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> addData() async {
    Map<String, dynamic> map = {};
    map['taskName'] = nameController.text.toString();
    map['dueDate'] = dateController.text.toString();
    int id = await MyDatabase().addTask(map);
  }

  Future<void> updateData() async {
    Map<String, dynamic> map = {};
    map['taskId'] = widget.map!['taskId'];
    map['taskName'] = nameController.text.toString();
    map['dueDate'] = dateController.text.toString();
    map['isDone'] = 0;
    int id = await MyDatabase().updateTask(map);
  }
}
