import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/view_models/robots_view_model.dart';
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
  TextEditingController itemController = TextEditingController();
  late StreamController<List<Task>> queueController;
  late StreamController<List<Robot>> robotsController;
  late StreamController<Task> _taskController;
  late StreamController<Robot> _currentRobotController;
  RobotsViewModel viewModel = RobotsViewModel();
  late List<Robot> robots;

  @override
  void initState() {
    super.initState();
    queueController = StreamController<List<Task>>();
    robotsController = StreamController<List<Robot>>();
    _taskController = StreamController<Task>();
    _currentRobotController = StreamController<Robot>();

    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await viewModel.setCurrentRobotInit();
    viewModel.setCurrentTask();

    _taskController.add(viewModel.currentTask!);
    _currentRobotController.add(viewModel.currentRobot);

    robots = await viewModel.fetchRobots();
    robotsController.add(robots);

    List<Task> initialQueue = viewModel.currentRobot.remainingTasks ?? [];
    queueController.add(initialQueue);
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
                      robots = await viewModel.fetchRobots();
                      Robot robot = robots[0];
                      TaskManager tmTemp = viewModel.getTaskManager();
                      Navigator.pushNamed(
                        context,
                        '/add_task',
                        arguments: {
                          'tmTemp': tmTemp,
                          'robot': robot,
                        },
                      );
                      robots = await viewModel.fetchRobots();
                      robotsController.add(robots);
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
                    return RobotPage(robots: snapshot.data!, onRobotSelected: (robot){
                      viewModel.setCurrentRobot(robot);
                      _currentRobotController.add(robot);
                      viewModel.setCurrentTask();
                      _taskController.add(viewModel.currentTask!);
                      queueController.add(viewModel.currentRobot.remainingTasks ?? []);
                    });
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
                  await viewModel.createRobot(robotName, robotSN, robotIP);
                  robots = await viewModel.fetchRobots();
                  robotsController.add(robots);// Actualitzar la llista de robots després d'afegir-ne un
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
