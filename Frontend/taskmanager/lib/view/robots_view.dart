import 'package:flutter/material.dart';
import 'package:taskmanager/model/crop_db.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/widgets/add_robot_widget.dart';
import 'dart:async';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({Key? key}) : super(key: key);

  @override
  State<RobotsView> createState() => _RobotsViewState();
}

class _RobotsViewState extends State<RobotsView> {
  late List<Robot> robots;
  Task currentTask = Task("", 0.0);
  TextEditingController itemController = TextEditingController();
  final cropRobotDB = CropRobotDB();
  late TaskManager taskManager;
  late Robot currentRobot;
  late StreamController<List<Task>> queueController;
  late StreamController<List<Robot>> robotsController;
  late StreamController<Task> _taskController;
  late StreamController<Robot> _currentRobotController;

  @override
  void initState() {
    super.initState();
    queueController = StreamController<List<Task>>();
    robotsController = StreamController<List<Robot>>();
    _taskController = StreamController<Task>();
    _currentRobotController = StreamController<Robot>();

    fetchRobots().then((_) {
      setState(() {
        currentRobot = (robots.isNotEmpty ? robots[0] : null)!;
        currentTask = currentRobot.currentTask ?? Task("", 0.0);
      });
      _taskController.add(currentTask);
      _currentRobotController.add(currentRobot);
    });
  }

  Future<void> fetchRobots() async {
    robots = await cropRobotDB.fetchAllRobots();
    taskManager = TaskManager(robots: robots);
    robotsController.add(robots);
  }

  void setCurrentRobot(Robot robot) {
    setState(() {
      currentRobot = robot;
    });
    _currentRobotController.add(currentRobot);
  }

  @override
  void dispose() {
    queueController.close();
    robotsController.close();
    _taskController.close();
    _currentRobotController.close();
    super.dispose();
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
            const SizedBox(height: 20), // Add some spacing
            StreamBuilder<Robot>(
              stream: _currentRobotController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                } else {
                  return const Text('Loading...'); // Optional: Show a loading indicator
                }
              },
            ),
            const SizedBox(height: 20), // Add some spacing
            SizedBox(
              width: MediaQuery.of(context).size.width, // Full width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<Task>(
                    stream: _taskController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text('Tasca actual: ${snapshot.data!.taskName == "" ? "Cap" : snapshot.data!.taskName}'),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CircularProgressIndicator(
                                value: snapshot.data!.completionPercentage / 100,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                                backgroundColor: Colors.grey,
                                strokeWidth: 10.0,
                              ),
                            ),
                            Text('${snapshot.data!.completionPercentage}% completat'),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<List<Task>>(
                      stream: queueController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].taskName),
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
                    onPressed: () async {
                      TaskManager tmTemp = taskManager;
                      List<Robot> robots = await cropRobotDB.fetchAllRobots();
                      Robot robot = robots[0];
                      final updatedTaskManager = await Navigator.pushNamed(
                        context,
                        '/add_task',
                        arguments: {
                          'tmTemp': tmTemp,
                          'robot': robot,
                        },
                      ) as TaskManager?;

                      if (updatedTaskManager != null) {
                        setState(() {
                          taskManager = updatedTaskManager;
                        });
                        fetchRobots();
                      }
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
                    return RobotPage(robots: snapshot.data!, onRobotSelected: setCurrentRobot);
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
