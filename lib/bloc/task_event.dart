part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//inital event
class TaskInitialEvent extends TaskEvent {}

//add event
class TaskAddEvent extends TaskEvent {
  final String title;
  final DateTime timeStamp;
  final bool isDone;

  TaskAddEvent(
      {required this.title, required this.timeStamp, required this.isDone});
}

//edit event
class TaskUpdateEvent extends TaskEvent {
  final String title;
  final DateTime timeStamp;
  final bool isDone;
  final int index;

  TaskUpdateEvent(
      {required this.title,
      required this.timeStamp,
      required this.isDone,
      required this.index});
}

//delete event
class TaskDeleteEvent extends TaskEvent {
  final int index;

  TaskDeleteEvent({required this.index});
}

//toggle event
class TaskToggleEvent extends TaskEvent {
  final String title;
  final DateTime timeStamp;
  final bool isDone;
  final int index;

  TaskToggleEvent(
      {required this.title,
      required this.timeStamp,
      required this.isDone,
      required this.index});
}
