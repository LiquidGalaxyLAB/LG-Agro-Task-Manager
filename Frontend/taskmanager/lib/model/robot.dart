import 'package:taskmanager/services/api_service.dart';

class Robot{
  int robotNumber;
  String name;
  String serialNumber;
  String robotIP;
  List<String> remainingTasks = [];

  Robot({
    required this.robotNumber,
    required this.name,
    required this.serialNumber,
    required this.robotIP});

  Future<void> updateTasks() async {
    final queueList = await APIService.singleton.sendRequest('get_queue');
    remainingTasks = List<String>.from(queueList);
  }

  factory Robot.fromSqfliteDatabase(Map<String, dynamic> map) => Robot(
    robotNumber: map['robotNumber'],
    name: map['robotName'],
    serialNumber: map['serialCode'],
    robotIP: map['robotIP'],
  );

}