import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_bloc/bloc/task_bloc.dart';
import 'package:task_bloc/models/task_model.dart';
import 'package:task_bloc/task_database/task_database.dart';
import 'package:task_bloc/views/task_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(BlocProvider(
    create: (context) => TaskBloc(TaskDatabase()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(TaskInitialEvent());
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TaskScreen(),
    );
  }
}
