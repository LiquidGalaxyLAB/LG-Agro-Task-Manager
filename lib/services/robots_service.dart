import 'package:taskmanager/model/task_manager.dart';

import '../model/robot.dart';
import '../model/crop_db.dart';

class RobotsService{

  final CropRobotDB _cropRobotDB = CropRobotDB();
  late TaskManager taskManager;
  static RobotsService singleton = RobotsService();

  Future<List<Robot>> fetchRobots() async {
    return await _cropRobotDB.fetchAllRobots();
  }

  void setTaskManager(TaskManager tm){
    taskManager = tm;
  }

  Future<void> createRobot(String robotName, String serialCode, String robotIP ) async {
    _cropRobotDB.createRobot(robotName: robotName, serialCode: serialCode, robotIP: robotIP);
  }

  Future<void> initialize() async {
    final List<Robot> robots = await fetchRobots();
    taskManager = TaskManager(robots: robots);
  }

  TaskManager getTaskManager(){
    return taskManager;
  }
}
