part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

// initial state
class TaskInitial extends TaskState {}

//loading state
class LoadingState extends TaskState {}

//edit task state
class UpdateTaskState extends TaskState {
  final Task task;

  const UpdateTaskState({required this.task});
}

//get task state
class GetTasksState extends TaskState {
  final List<Task> task;

  const GetTasksState({required this.task});
}

// new task
class NewTaskState extends TaskState {}
