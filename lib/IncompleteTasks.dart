import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/TaskForm.dart';
import 'package:todo_app/database/myDatabase.dart';

class IncompleteTasks extends StatefulWidget {
  const IncompleteTasks({super.key});

  @override
  State<IncompleteTasks> createState() => _IncompleteTasksState();
}

class _IncompleteTasksState extends State<IncompleteTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MyDatabase().copyPasteAssetFileToRoot(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: MyDatabase().getIncompleteTasks(),
              builder: (context, snapshotList) {
                if (snapshotList.hasData) {
                  if (snapshotList.data!.length == 0) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: Image.asset('assets/images/rest.jpg',
                              width: MediaQuery.of(context).size.width * 0.5),
                        ),
                        Text(
                          'Nothing to do',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ));
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          shadowColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          elevation: 8,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                              leading: InkWell(
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                  ),
                                  onTap: () async {
                                    await updateTaskCompleted(
                                            snapshotList.data![index])
                                        .then((value) {
                                      setState(() {});
                                    });
                                  }),
                              title: Text(
                                snapshotList.data![index]['taskName'],
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => TaskForm(
                                            map: snapshotList.data![index],
                                          ),
                                        ))
                                            .then((value) {
                                          if (value == true) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green.shade600,
                                        size: 23,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text(
                                                "Alert !",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              content: Text(
                                                "Are you sure want to delete??",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await MyDatabase().delete(
                                                          snapshotList
                                                                  .data![index]
                                                              ['taskId']);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Okay",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 23,
                                      )),
                                ],
                              ),
                              subtitle: Text(
                                DateTime.parse(snapshotList.data![index]
                                                ['dueDate'])
                                            .compareTo(DateTime.now()) ==
                                        0
                                    ? 'Last day'
                                    : DateTime.parse(snapshotList.data![index]
                                                ['dueDate'])
                                            .isAfter(DateTime.now())
                                        ? ((DateTime.parse(snapshotList.data![
                                                                    index]
                                                                ['dueDate'])
                                                            .difference(
                                                                DateTime.now()))
                                                        .inDays +
                                                    1)
                                                .toString() +
                                            " days"
                                        : 'Out dated',
                                style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.w600),
                              )
                              // Text(
                              //         ((DateTime.parse(snapshotList.data![index]
                              //                                 ['dueDate'])
                              //                             .difference(
                              //                                 DateTime.now()))
                              //                         .inDays +
                              //                     1) <=
                              //                 0
                              //             ? 'Out dated'
                              //             : ((DateTime.parse(snapshotList.data![
                              //                                         index]
                              //                                     ['dueDate'])
                              //                                 .difference(
                              //                                     DateTime.now()))
                              //                             .inDays +
                              //                         1)
                              //                     .toString() +
                              //                 " days",
                              //         style: TextStyle(
                              //             color: Colors.red.shade900,
                              //             fontWeight: FontWeight.w600),
                              //       ),
                              ),
                        );
                      },
                      itemCount: snapshotList.data!.length,
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: Text("Error in coping !!!"));
          }
        },
      ),
    );
  }

  Future<void> updateTaskCompleted(Map<String, dynamic> map) async {
    Map<String, dynamic> m1 = {};
    m1['taskId'] = map['taskId'].toString();
    m1['taskName'] = map['taskName'].toString();
    m1['dueDate'] = map['dueDate'].toString();
    m1['isDone'] = 1;

    int id = await MyDatabase().updateTask(m1);
  }
}
