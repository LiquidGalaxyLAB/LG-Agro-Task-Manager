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

  void addTaskToRobot(Task task, String name){
    for(int i = 0; i < robots.length; ++i){
      if (robots[i].name == name) robots[i].addTask(task);
    }
  }

  Robot? getRobot(String robotName){
    for(int i = 0; i < robots.length; ++i){
      if (robots[i].name == robotName) return robots[i];
    }
    return null;
  }

}