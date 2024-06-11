import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/model/crop_db.dart';
import 'package:taskmanager/model/task.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/services/api_service.dart';

import '../model/robot.dart';
import '../widgets/add_robot_widget.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({super.key});

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  List<String> queue = [];
  List<Robot> robots = [];
  Task currentTask = Task("", 0.0);
  TextEditingController itemController = TextEditingController();
  final cropRobotDB = CropRobotDB();

  @override
  void initState() {
    super.initState();
    fetchQueue();
    fetchRobots();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchQueue();
    fetchRobots();
  }

  void fetchRobots() async{
    List<Robot> tempRobots = await cropRobotDB.fetchAllRobots();
    setState(()  {
      robots = tempRobots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Robots view'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width, // Full width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Tasca actual: ${currentTask.taskName == "" ? "Cap" : currentTask.taskName}'),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(
                      value: currentTask.completionPercentage / 100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.teal),
                      backgroundColor: Colors.grey,
                      strokeWidth: 10.0,
                    ),
                  ),
                  Text('${currentTask.completionPercentage}% completat'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: queue.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(queue[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RobotPage(robots: robots),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return AddRobotWidget(
                onSubmit: (robotName, robotIP, robotSN) async {
                  await cropRobotDB.createRobot(
                    robotName: robotName,
                    robotIP: robotIP,
                    serialCode: robotSN,
                  );
                  //if (!mounted) return;
                  await cropRobotDB.fetchAllRobots();
                  Navigator.of(context).pop();
                },
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> fetchQueue() async {
    try {
      final queueList = await APIService.singleton.sendRequest('get_queue');
      setState(() {
        queue = List<String>.from(queueList);
      });

      final Task taskGetter =
          await APIService.singleton.askCurrentTask('get_current_task');
      setState(() {
        currentTask.setName(taskGetter.taskName);
        currentTask.setComplete(taskGetter.completionPercentage);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetchQueue: $e');
      }
    }
  }
}
