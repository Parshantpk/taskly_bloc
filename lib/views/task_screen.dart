import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_bloc/bloc/task_bloc.dart';
import 'package:task_bloc/views/add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            return Container();
          }
          if (state is GetTasksState) {
            return TasksView(state: state);
          }
          if (state is LoadingState) {
            return const CircularProgressIndicator();
          } else {
            return const Text('Something Went Wrong!');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddTaskScreen(
              newTask: true,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TasksView extends StatelessWidget {
  const TasksView({super.key, required this.state});
  final GetTasksState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.task.length,
      itemBuilder: (BuildContext context, int index) {
        print(state.task.length);
        final task = state.task[index];
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            task.timeStamp.toString(),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                 // var isDone = task.isDone;
                  BlocProvider.of<TaskBloc>(context).add(TaskToggleEvent(
                      title: task.title,
                      timeStamp: task.timeStamp,
                      isDone: task.isDone,
                      index: index));
                  print(task.isDone);
                },

                icon: Icon(
                  task.isDone
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank_outlined,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddTaskScreen(
                        task: task,
                        index: index,
                        newTask: false,
                      );
                    }));
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                onPressed: () {
                  BlocProvider.of<TaskBloc>(context)
                      .add(TaskDeleteEvent(index: index));
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
          // onTap: () {
          //   task.isDone = !task.done;
          //   _box!.putAt(
          //     _index,
          //     task.toMap(),
          //   );
          //   setState(() {});
          // },
          // onLongPress: () {
          //   setState(() {
          //     _box!.deleteAt(_index);
          //   });
          // },
        );
      },
    );
    ;
  }
}
