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

  Future<void> initialize() async {
    final List<Robot> robots = await fetchRobots();
    taskManager = TaskManager(robots: robots);
  }
}
