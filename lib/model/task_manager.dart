import 'package:taskmanager/model/robot.dart';
import 'package:taskmanager/model/task.dart';

import '../services/robots_service.dart';

class TaskManager {
  List<Robot> robots;
  Robot currentRobot = Robot.empty();
  Function(double)? _didUpdate;

  TaskManager({required this.robots});

  void addRobots(Robot r) {
    robots.add(r);
  }

  void deleteRobot(int id) {
    final robot = getRobotById(id);
    if (robot != null) {
      robots.remove(robot);
    }
    if (robots.isNotEmpty) {
      setCurrentRobot(robots[0]);
    } else {
      setCurrentRobot(Robot.empty());
    }
  }

  void addCallback(Function(double)? didUpdate) => _didUpdate = didUpdate;

  void addTaskToRobot(Task task, String robotName) {
    Robot? robot = robots.firstWhere((r) => r.name == robotName);
    robot.addTask(task);
  }

  Robot? getRobot(String robotName) {
    if (robots.isNotEmpty) return robots.firstWhere((r) => r.name == robotName);
    return null;
  }

  Robot? getRobotById(int id) {
    if (robots.isNotEmpty) return robots.firstWhere((r) => r.id == id);
    return null;
  }

  Future<List<Robot>> fetchRobots() async {
    return RobotsService.singleton.fetchRobots();
  }

  void setCurrentRobotInit(List<Robot> robots) {
    this.robots = robots;
    if (robots.isNotEmpty) {
      setCurrentRobot(robots[0]);
    }
  }

  void setCurrentRobot(Robot newRobot) {
    currentRobot.currentTask?.callback = null;
    currentRobot = newRobot;
    currentRobot.currentTask?.callback = _didUpdate;
  }
}
