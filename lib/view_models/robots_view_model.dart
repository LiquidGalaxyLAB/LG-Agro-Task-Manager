import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsViewModel extends ChangeNotifier {
  TaskManager taskManager = RobotsService.singleton.getTaskManager();

  RobotsViewModel() {
    taskManager.setCurrentRobotInit();
    taskManager.setCurrentTask();
  }

  void setCurrentRobot(Robot robot) {
    taskManager.currentRobot = robot;
    notifyListeners();
  }

  Robot getCurrentRobot() {
    return taskManager.currentRobot;
  }

  void setCurrentTask() {
    taskManager.setCurrentTask();
  }

  getRobots() {
    return taskManager.robots;
  }

  void fetchTaskManager() {
    taskManager = RobotsService.singleton.taskManager;
  }

  Future<List<Robot>> fetchRobots() async {
    return RobotsService.singleton.fetchRobots();
  }

  TaskManager getTaskManager() {
    taskManager = RobotsService.singleton.getTaskManager();
    return taskManager;
  }

  void setTaskManager(TaskManager tm) {
    taskManager = tm;
  }

  Future<void> createRobot(String robotName, String robotIP,
      String serialNumber, String field) async {
    await RobotsService.singleton
        .createRobot(robotName, robotIP, serialNumber, field);
    taskManager.robots = await fetchRobots();
    notifyListeners();
  }

  Future<void> deleteRobot() async {
    await RobotsService.singleton.deleteRobot(taskManager.currentRobot.id);
    await taskManager.fetchRobots();
    if (taskManager.robots.isNotEmpty) {
      taskManager.currentRobot = taskManager.robots[0];
      RobotsService.singleton.changeTempCurrentRobot(taskManager.robots[0]);
    } else {
      taskManager.currentRobot = Robot.empty();
    }
    notifyListeners();
  }

  Future<void> simulateTask() async {
    await taskManager.currentRobot.taskSimulation();
    notifyListeners();
  }

  List<Task> fetchRemainingTasks() {
    return taskManager.currentRobot.remainingTasks;
  }

  void visualizeTask() {
    String field = taskManager.currentRobot.field;
    String country;
    String city = field.split(' ')[0];
    if (city == 'Seròs' || city == 'Anaquela del Ducado' || city == 'Soria') {
      country = "Espanya";
    } else {
      country = "India";
    }
    RobotsService.singleton.goToLocation(field, country);
  }
}
