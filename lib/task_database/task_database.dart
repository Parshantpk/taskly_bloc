import 'package:hive/hive.dart';
import 'package:task_bloc/models/task_model.dart';

class TaskDatabase {
  String _boxName = 'tasks';

  //open a box
  Future<Box<Task>> taskBox() async {
    var box = await Hive.openBox<Task>(_boxName);
    return box;
  }

  //get all tasks
  Future<List<Task>> getAllTasks() async {
    final box = await taskBox();
    List<Task> tasks = box.values.toList();
    return tasks;
  }

  //add task in box
  Future<void> addToBox(Task task) async {
    final box = await taskBox();
    await box.add(task);
  }

  //delete a task from box
  Future<void> deleteFromBox(int index) async {
    final box = await taskBox();
    await box.deleteAt(index);
  }

  //delete all tasks from box
  Future<void> deleteAll() async {
    final box = await taskBox();
    await box.clear();
  }

  //update a task
  Future<void> updateTask(int index, Task task) async {
    final box = await taskBox();
    await box.putAt(index, task);
  }

  Future<void> toggleTask(int index, Task task)async {
    final box = await taskBox();
    await box.putAt(index, task);
  }
}
