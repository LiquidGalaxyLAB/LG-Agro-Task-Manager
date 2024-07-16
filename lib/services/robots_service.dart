import 'package:isar/isar.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/database_service.dart';
import 'package:taskmanager/services/lg_service.dart';

import '../model/robot.dart';

class RobotsService {

  late TaskManager taskManager;
  static RobotsService singleton = RobotsService();

  Isar _getDataBase() => DataBaseService.singleton.getDatabase();

  Future<List<Robot>> fetchRobots() async {
    final isar = _getDataBase();
    return isar.robots.where().findAll();
  }

  void setTaskManager(TaskManager tm){
    taskManager = tm;
  }

  Future<void> createRobot(String robotName, String serialCode, String robotIP ) async {
    final isar = _getDataBase();
    return await isar.writeTxn(() async {
      await isar.robots.put(Robot(name: robotName,
          serialNumber: serialCode,
          robotIP: robotIP)); // insert & update
    });
  }

  Future<void> initialize() async {
    final List<Robot> robots = await fetchRobots();
    taskManager = TaskManager(robots: robots);
  }

  Future<void> goToLocation(String name, String country) async {
    LGService.instance.displaySpecificKML(name, country);
  }

  TaskManager getTaskManager(){
    return taskManager;
  }
}
