import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_bloc/task_database/task_database.dart';
import '../models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskDatabase _taskDatabase;
  List<Task> _tasks = [];

  TaskBloc(this._taskDatabase) : super(TaskInitial()) {
    on<TaskInitialEvent>(_mapInitialEventToState);
    on<TaskAddEvent>(_mapTaskAddEventToState);
    on<TaskUpdateEvent>(_mapTaskUpdateEventToState);
    on<TaskDeleteEvent>(_mapTaskDeleteEventToState);
    on<TaskToggleEvent>(_mapTaskToggleEventToState);
  }
  Future<void> _getTasks() async {
    await _taskDatabase.getAllTasks().then((value) {
      _tasks = value;
    });
  }

  Future<void> _addToTask(
      {required String title,
      required DateTime timeStamp,
      required bool isDone}) async {
    await _taskDatabase
        .addToBox(Task(title: title, timeStamp: timeStamp, isDone: isDone));
    await _getTasks();
  }

  Future<void> _updateTask(
      {required int index,
      required String newTitle,
      required DateTime newTimeStamp,
      required bool newIsDone}) async {
    await _taskDatabase.updateTask(index,
        Task(title: newTitle, timeStamp: newTimeStamp, isDone: newIsDone));
    await _getTasks();
  }

  Future<void> _removeFromTasks({required int index}) async {
    await _taskDatabase.deleteFromBox(index);
    await _getTasks();
  }

  Future<void> _toggleTask(
      {required int index,
      required String newTitle,
      required DateTime newTimeStamp,
      required bool newIsDone}) async {
    newIsDone = !newIsDone;
    print(newIsDone);
    await _taskDatabase.toggleTask(index,
        Task(title: newTitle, timeStamp: newTimeStamp, isDone: newIsDone));
    await _getTasks();
  }

  FutureOr<void> _mapInitialEventToState(
      TaskInitialEvent event, Emitter<TaskState> emitter) async {
    emitter(LoadingState());
    await _getTasks();
    emitter(GetTasksState(task: _tasks));
  }

  FutureOr<void> _mapTaskAddEventToState(
      TaskAddEvent event, Emitter<TaskState> emitter) async {
    String title = event.title;
    DateTime timeStamp = event.timeStamp;
    bool isDone = event.isDone;
    emitter(LoadingState());
    await _addToTask(title: title, timeStamp: timeStamp, isDone: isDone);
    emitter(GetTasksState(task: _tasks));
  }

  FutureOr<void> _mapTaskUpdateEventToState(
      TaskUpdateEvent event, Emitter<TaskState> emitter) async {
    String title = event.title;
    DateTime timeStamp = event.timeStamp;
    bool isDone = event.isDone;
    int index = event.index;
    emitter(LoadingState());
    await _updateTask(
        index: index,
        newTitle: title,
        newTimeStamp: timeStamp,
        newIsDone: isDone);
    emitter(GetTasksState(task: _tasks));
  }

  FutureOr<void> _mapTaskDeleteEventToState(
      TaskDeleteEvent event, Emitter<TaskState> emitter) async {
    int index = event.index;
    emitter(LoadingState());
    await _removeFromTasks(index: index);
    emitter(GetTasksState(task: _tasks));
  }

  FutureOr<void> _mapTaskToggleEventToState(
      TaskToggleEvent event, Emitter<TaskState> emitter) async {
    String title = event.title;
    DateTime timeStamp = event.timeStamp;
    bool isDone = event.isDone;
    int index = event.index;
    await _toggleTask(index: index, newTitle: title, newTimeStamp: timeStamp, newIsDone: isDone);
    emitter(LoadingState());
    emitter(GetTasksState(task: _tasks));
  }
}
