import 'package:taskmanager/model/robot.dart';
import 'package:taskmanager/model/task.dart';

class TaskManager {
  List<Robot> robots;

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
    return robots.firstWhere((r) => r.name == robotName);
  }
}
