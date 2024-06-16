import 'dart:ffi';

import 'package:taskmanager/model/crop.dart';
import 'package:taskmanager/model/crop_db.dart';
import 'package:taskmanager/model/robot.dart';
import 'package:taskmanager/model/task.dart';
import 'package:taskmanager/services/database_service.dart';

class TaskManager{
  List<Robot> robots;

  TaskManager({
    required this.robots
  });

  void addRobots(Robot r){
    robots.add(r);
  }

  void removeRobots(Robot r){
    robots.remove(r);
  }

  void addTaskToRobot(Task task, Robot robot){
    robot.addTask(task);
  }

}