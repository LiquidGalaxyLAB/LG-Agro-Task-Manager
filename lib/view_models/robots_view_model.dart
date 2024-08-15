import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/lg_service.dart';
import 'package:taskmanager/services/robots_service.dart';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsViewModel extends ChangeNotifier {
  TaskManager taskManager = RobotsService.singleton.getTaskManager();

  void setCurrentRobot(Robot robot) {
    taskManager.setCurrentRobot(robot);
  }

  Robot getCurrentRobot() {
    return taskManager.currentRobot;
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
  }

  Future<void> deleteRobot() async {
    await RobotsService.singleton.deleteRobot(taskManager.currentRobot.id);
    taskManager.deleteRobot(taskManager.currentRobot.id);
  }

  List<Task> fetchRemainingTasks() {
    return taskManager.currentRobot.remainingTasks;
  }

  void visualizeTask() {
    String field = taskManager.currentRobot.field;
    String country;
    String city = field.split(' ')[0];
    if (city == 'Seròs' || city == 'Anaquela' || city == 'Soria') {
      country = "Espanya";
    } else {
      country = "India";
    }
    RobotsService.singleton.goToLocation(field, country);
  }

  Future<void> sendTaskKML() async {
    if (taskManager.currentRobot.currentTask != null) {
      await LGService.instance.sendTaskKML(
          taskManager.currentRobot.name,
          taskManager.currentRobot.currentTask!.taskName,
          taskManager.currentRobot.field);
    }
  }
}
