import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_bloc/bloc/task_bloc.dart';
import 'package:task_bloc/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key? key, required this.newTask, this.task, this.index})
      : super(key: key);

  final bool newTask;
  final Task? task;
  final int? index;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late DateTime _dateTime;
  late String _newTaskContent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.newTask ? 'New Task' : 'Edit Task',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Add Task',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextField(
              onChanged: (_value) {
                setState(() {
                  _newTaskContent = _value;
                  print(_newTaskContent);
                });
              },
              decoration: const InputDecoration(
                hintText: 'Task Title',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print(
                      'change $date in time zone ${date.timeZoneOffset.inHours}');
                }, onConfirm: (date) {
                  _dateTime = date;
                  print('confirm $date');
                }, currentTime: DateTime.now());
              },
              child: const Text('Select Date/Time'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.newTask
              ? BlocProvider.of<TaskBloc>(context).add(
                  TaskAddEvent(
                      title: _newTaskContent,
                      timeStamp: _dateTime,
                      isDone: false),
                )
              : BlocProvider.of<TaskBloc>(context).add(
                  TaskUpdateEvent(
                      title: _newTaskContent,
                      timeStamp: _dateTime,
                      isDone: false,
                      index: widget.index!),
                );
          Navigator.pop(context);
        },
        label: Text(widget.newTask ? 'ADD' : 'UPDATE'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
