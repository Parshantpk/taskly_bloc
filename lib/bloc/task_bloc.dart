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
  //   @override
  //   Stream<TaskState> mapEventToState(TaskEvent event) async* {
  //     if (event is TaskInitialEvent) {
  //       yield* _mapInitialEventToState();
  //     }
  //
  //     if (event is TaskAddEvent) {
  //       yield* _mapTaskAddEventToState(
  //         title: event.title,
  //         timeStamp: event.timeStamp,
  //         isDone: event.isDone,
  //       );
  //     }
  //
  //     if (event is TaskUpdateEvent) {
  //       yield* _mapTaskUpdateEventToState(
  //           title: event.title,
  //           timeStamp: event.timeStamp,
  //           index: event.index,
  //           isDone: event.isDone);
  //     }
  //
  //     if (event is TaskDeleteEvent) {
  //       yield* _mapTaskDeleteEventToState(index: event.index);
  //     }
  //   }
  // }
  // Stream Functions
  // _mapInitialEventToState() {
  //
  //   await _getTasks();
  //
  //   yield GetTasksState(task: _tasks);
  // }

  // _mapTaskAddEventToState({required String title,
  //   required DateTime timeStamp,
  //   required bool isDone}) async* {
  //   yield LoadingState();
  //   await _addToTask(title: title, timeStamp: timeStamp, isDone: isDone);
  //   yield GetTasksState(task: _tasks);
  // }

  // _mapTaskUpdateEventToState(
  //     {required String title,
  //     required DateTime timeStamp,
  //     required bool isDone,
  //     required int index}) async* {
  //   yield LoadingState();
  //   await _updateTask(
  //       newTitle: title,
  //       newTimeStamp: timeStamp,
  //       newIsDone: isDone,
  //       index: index);
  //   yield GetTasksState(task: _tasks);
  // }

  // _mapTaskDeleteEventToState({required int index}) async* {
  //   yield LoadingState();
  //   await _removeFromTasks(index: index);
  //   _tasks.sort((a, b) {
  //     var aDate = a.title;
  //     var bDate = b.title;
  //     return aDate.compareTo(bDate);
  //   });
  //   yield GetTasksState(task: _tasks);
  // }

  // Helper Functions
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
