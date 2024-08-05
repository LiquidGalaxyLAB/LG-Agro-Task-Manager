import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/robots_service.dart';
import 'package:taskmanager/utils/logger.dart';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsViewModel extends ChangeNotifier {
  Robot currentRobot = Robot.empty();
  late List<Task>? remainingTasks;
  late TaskManager taskManager;
  late List<Robot> robots;

  RobotsViewModel() {
    create();
  }

  Future<void> create() async {
    robots = await fetchRobots();
    setCurrentRobotInit();
    setCurrentTask();
  }

  void setCurrentRobot(Robot robot) {
    currentRobot = robot;
    notifyListeners();
  }

  void fetchTaskManager() {
    taskManager = RobotsService.singleton.taskManager;
  }

  void setCurrentTask() {
    fetchTaskManager();
    RobotsService.singleton.taskManager = taskManager;
    if (currentRobot.currentTask != null) {
      remainingTasks = taskManager.getRobot(currentRobot.name)?.remainingTasks;
      if (currentRobot.currentTask!.completionPercentage >= 100) {
        currentRobot.currentTask = remainingTasks?[0];
        remainingTasks?.removeAt(0);
        taskManager.getRobot(currentRobot.name)?.remainingTasks.removeAt(0);
        currentRobot.taskSimulation();
      }
    } else {
      currentRobot.currentTask =
          taskManager.getRobot(currentRobot.name)?.currentTask;
      currentRobot.remainingTasks =
          taskManager.getRobot(currentRobot.name)!.remainingTasks;
    }
    Logger.printInDebug(
        "Task manager rebut al Robots viewModel! Current Robot: ${currentRobot.name}, Current Task = ${currentRobot.currentTask?.taskName}, Remaining Tasks: ${currentRobot.remainingTasks}");
    notifyListeners();
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
    robots = await fetchRobots();
    notifyListeners();
  }

  Future<void> setCurrentRobotInit() async {
    robots = await fetchRobots();
    if (robots.isNotEmpty) {
      currentRobot = robots[0];
      RobotsService.singleton.changeTempCurrentRobot(robots[0]);
      notifyListeners();
    }
  }

  Future<void> deleteRobot() async {
    await RobotsService.singleton.deleteRobot(currentRobot.id);
    robots = await fetchRobots();
    if (robots.isNotEmpty) {
      currentRobot = robots[0];
      RobotsService.singleton.changeTempCurrentRobot(robots[0]);
    } else {
      currentRobot = Robot.empty();
    }
    notifyListeners();
  }

  Task? fetchCurrentTask() {
    taskManager = RobotsService.singleton.getTaskManager();
    Robot? currentRobot2 = taskManager.getRobot(currentRobot.name);
    if (currentRobot2 != null && currentRobot2.currentTask != null) {
      currentRobot = currentRobot2;
      notifyListeners();
      return currentRobot.currentTask;
    } else {
      return null;
    }
  }

  Future<void> simulateTask() async {
    await currentRobot.taskSimulation();
    notifyListeners();
  }

  List<Task> fetchRemainingTasks() {
    return currentRobot.remainingTasks;
  }

  void visualizeTask() {
    String field = currentRobot.field;
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
