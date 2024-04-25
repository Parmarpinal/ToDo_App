import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database/myDatabase.dart';

class CompleteTasks extends StatefulWidget {
  const CompleteTasks({super.key});

  @override
  State<CompleteTasks> createState() => _CompleteTasksState();
}

class _CompleteTasksState extends State<CompleteTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MyDatabase().copyPasteAssetFileToRoot(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: MyDatabase().getCompleteTasks(),
              builder: (context, snapshotList) {
                if (snapshotList.hasData) {
                  if (snapshotList.data!.length == 0) {
                    return Center(
                      child: Text(
                        'No completed task',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          shadowColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          elevation: 8,
                          margin: EdgeInsets.all(10),
                          // surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
                          child: ListTile(
                              leading: CircleAvatar(
                                  child: Icon(Icons.check),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              title: Text(
                                snapshotList.data![index]['taskName'],
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: IconButton(
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
                                                      snapshotList.data![index]
                                                          ['taskId']);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Okay",
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                      TextStyle(fontSize: 17),
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
                              subtitle: Text(
                                "Completed",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600),
                              )),
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
}
