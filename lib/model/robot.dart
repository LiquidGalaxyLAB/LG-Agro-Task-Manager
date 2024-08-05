import 'package:isar/isar.dart';
import 'package:taskmanager/model/task.dart';

part 'robot.g.dart';

@collection
class Robot {
  Id id = Isar.autoIncrement;
  String name;
  String serialNumber;
  String robotIP;
  String field;
  @ignore
  Task? currentTask;
  @ignore
  List<Task> remainingTasks = [];

  Robot(
      {required this.name,
      required this.serialNumber,
      required this.robotIP,
      required this.field}) {
    _checkAndAssignTask();
  }

  factory Robot.empty() {
    return Robot(
        name: 'empty', serialNumber: '9999', robotIP: '9999', field: 'Seròs 1');
  }

  Future<void> taskSimulation() async {
    await currentTask?.simulateCompletion();
    currentTask = null;
    _checkAndAssignTask();
  }

  void addTask(Task t) {
    remainingTasks.add(t);
    _checkAndAssignTask();
  }

  void setCurrentTask(Task t) {
    currentTask = t;
  }

  void _checkAndAssignTask() {
    if (currentTask == null && remainingTasks.isNotEmpty) {
      currentTask = remainingTasks[0];
      remainingTasks.removeAt(0);
    }
  }
}
