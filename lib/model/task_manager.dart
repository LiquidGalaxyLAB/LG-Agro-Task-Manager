import 'package:taskmanager/model/robot.dart';
import 'package:taskmanager/model/task.dart';

import '../services/robots_service.dart';

class TaskManager {
  List<Robot> robots;
  Robot currentRobot = Robot.empty();
  late List<Task>? remainingTasks;

  TaskManager({required this.robots});

  void addRobots(Robot r) {
    robots.add(r);
  }

  void removeRobots(Robot r) {
    robots.remove(r);
  }

  void addTaskToRobot(Task task, String robotName) {
    Robot? robot = robots.firstWhere((r) => r.name == robotName);
    robot.addTask(task);
  }

  Robot? getRobot(String robotName) {
    if (robots.isNotEmpty) return robots.firstWhere((r) => r.name == robotName);
    return null;
  }

  void setCurrentTask() {
    RobotsService.singleton.taskManager = this;
    if (currentRobot.currentTask != null) {
      remainingTasks = currentRobot.remainingTasks;
      if (currentRobot.currentTask!.completionPercentage >= 100) {
        currentRobot.currentTask = remainingTasks?[0];
        remainingTasks?.removeAt(0);
        currentRobot.remainingTasks.removeAt(0);
        currentRobot.taskSimulation();
      }
    }
    //Logger.printInDebug(
    //"Task manager rebut al Robots viewModel! Current Robot: ${currentRobot.name}, Current Task = ${currentRobot.currentTask?.taskName}, Remaining Tasks: ${currentRobot.remainingTasks}");
  }

  Future<List<Robot>> fetchRobots() async {
    return RobotsService.singleton.fetchRobots();
  }

  Future<void> setCurrentRobotInit() async {
    robots = await fetchRobots();
    if (robots.isNotEmpty) {
      currentRobot = robots[0];
      RobotsService.singleton.changeTempCurrentRobot(robots[0]);
    }
  }

  Future<void> create() async {
    robots = await fetchRobots();
    setCurrentRobotInit();
    setCurrentTask();
  }

  Task? fetchCurrentTask() {
    Robot? currentRobot2 = getRobot(currentRobot.name);
    if (currentRobot2 != null && currentRobot2.currentTask != null) {
      currentRobot = currentRobot2;
      return currentRobot.currentTask;
    } else {
      return null;
    }
  }
}
