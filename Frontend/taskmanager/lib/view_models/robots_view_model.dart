import 'package:taskmanager/services/robots_service.dart';
import '../model/robot.dart';

class RobotsViewModel{
  Robot currentRobot = Robot.empty();

  Future<List<Robot>> fetchRobots() async{
    return RobotsService.singleton.fetchRobots();
  }
}
