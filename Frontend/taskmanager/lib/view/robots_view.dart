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
  const RobotsView({Key? key}) : super(key: key);

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  List<String> queue = [];
  List<Robot> robots = [];
  Task currentTask = Task("", 0.0);
  TextEditingController itemController = TextEditingController();
  final cropRobotDB = CropRobotDB();

  late StreamController<List<String>> queueController;
  late StreamController<List<Robot>> robotsController;

  @override
  void initState() {
    super.initState();
    queueController = StreamController<List<String>>();
    robotsController = StreamController<List<Robot>>();
    fetchInitialData();
  }

  @override
  void dispose() {
    queueController.close();
    robotsController.close();
    super.dispose();
  }

  void fetchInitialData() async {
    try {
      // Fetch initial data
      await fetchQueue();
      await fetchRobots();

      // Set up periodic updates
      const updateInterval = Duration(seconds: 4);
      Timer.periodic(updateInterval, (_) async {
        await fetchQueue();
        await fetchRobots();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetchInitialData: $e');
      }
    }
  }

  Future<void> fetchRobots() async {
    List<Robot> tempRobots = await cropRobotDB.fetchAllRobots();
    robotsController.add(tempRobots);
  }

  Future<void> fetchQueue() async {
    List<String> tempQueue = await APIService.singleton.sendRequest('get_queue');
    queueController.add(tempQueue);

    Task taskGetter = await APIService.singleton.askCurrentTask('get_current_task');
    setState(() {
      currentTask.setName(taskGetter.taskName);
      currentTask.setComplete(taskGetter.completionPercentage);
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
                    child: StreamBuilder<List<String>>(
                      stream: queueController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index]),
                              );
                            },
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_task');
                    },
                    child: const Text('Afegeix tasques'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Robot>>(
                stream: robotsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RobotPage(robots: snapshot.data!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
                  await fetchRobots(); // Actualitzar la llista de robots després d'afegir-ne un
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
}
