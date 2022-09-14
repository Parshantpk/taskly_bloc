import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)

class Task {

  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime timeStamp;
  @HiveField(2)
  final bool isDone;

  Task({required this.title, required this.timeStamp, required this.isDone});
}
