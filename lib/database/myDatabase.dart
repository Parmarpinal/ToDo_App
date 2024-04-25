import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase{
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'toDoDatabase.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "toDoDatabase.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets/database', 'toDoDatabase'
          '.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }
  
  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> data = await db.rawQuery("select * from Tasks");
    return data;
  }

  Future<int> addTask(Map<String, dynamic> map) async {
    Database db= await initDatabase();
    int noOfRaw = await db.insert('Tasks', map);
    return noOfRaw;
  }

  Future<List<Map<String, dynamic>>> getIncompleteTasks() async {
    Database db= await initDatabase();
    List<Map<String, dynamic>> tasks = await db.query('Tasks',where: 'isDone = ?',whereArgs: [0]);
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getCompleteTasks() async {
    Database db= await initDatabase();
    List<Map<String, dynamic>> tasks = await db.query('Tasks',where: 'isDone = ?',whereArgs: [1]);
    return tasks;
  }

  Future<int> delete(int id) async {
    Database db= await initDatabase();
    int noOfRaw = await db.delete('Tasks',where: 'taskId = ?',whereArgs: [id]);
    return noOfRaw;
  }

  Future<int> updateTask(Map<String, dynamic> map) async {
    Database db= await initDatabase();
    int noOfRaw =await db.update('Tasks',map, where: 'taskId = ?', whereArgs: [map['taskId']]);
    return noOfRaw;
  }
}