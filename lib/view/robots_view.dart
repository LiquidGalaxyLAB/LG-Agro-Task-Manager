import 'package:flutter/material.dart';
import 'package:taskmanager/pages/robot_page.dart';
import 'package:taskmanager/view_models/robots_view_model.dart';
import 'package:taskmanager/widgets/add_robot_widget.dart';
import 'dart:async';

import '../model/robot.dart';
import '../model/task.dart';

class RobotsView extends StatefulWidget {
  const RobotsView({super.key});

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
  late StreamSubscription _periodicSubscription;

  final Color myGreen = const Color(0xFF3E9671);

  @override
  void initState() {
    super.initState();
    queueController = StreamController<List<Task>>.broadcast();
    robotsController = StreamController<List<Robot>>.broadcast();
    _taskController = StreamController<Task>.broadcast();
    _currentRobotController = StreamController<Robot>.broadcast();

    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await viewModel.setCurrentRobotInit();
    viewModel.setCurrentTask();

    if (viewModel.currentRobot.currentTask != null) _taskController.add(viewModel.currentRobot.currentTask!);
    _currentRobotController.add(viewModel.currentRobot);
    robots = await viewModel.fetchRobots();
    robotsController.add(robots);

    List<Task> initialQueue = viewModel.currentRobot.remainingTasks;
    queueController.add(initialQueue);

    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    _periodicSubscription = Stream.periodic(const Duration(seconds: 2)).listen((_) async {
      if (queueController.isClosed || robotsController.isClosed ||
          _taskController.isClosed || _currentRobotController.isClosed) return;
      viewModel.fetchTaskManager();

      robots = await viewModel.fetchRobots();
      robotsController.add(robots);

      Task? currentTask = viewModel.fetchCurrentTask();
      if (currentTask != null) _taskController.add(currentTask);

      List<Task> remainingTasks = viewModel.fetchRemainingTasks();
      queueController.add(remainingTasks);

      // S'hauria de modificar quan i com simulo la tasca: massa rapidesa porta
      // a que es recarregui malament i a més a més arriba un punt en que deixa de simular
      await viewModel.simulateTask();
    });
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
      theme: ThemeData.dark().copyWith(
        primaryColor: myGreen,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.dark(
          primary: myGreen,
          secondary: myGreen,
        ),
      ),
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
            const SizedBox(height: 20),
            StreamBuilder<Robot>(
              stream: _currentRobotController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: myGreen,
                    ),
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<Task>(
                    stream: _taskController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              'Current Task: ${snapshot.data!.taskName.isEmpty ? "Cap" : snapshot.data!.taskName}',
                              style: TextStyle(color: myGreen),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: CircularProgressIndicator(
                                value: snapshot.data!.completionPercentage / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(myGreen),
                                backgroundColor: Colors.grey,
                                strokeWidth: 10.0,
                              ),
                            ),
                            Text(
                              '${snapshot.data!.completionPercentage}% completat',
                              style: TextStyle(color: myGreen),
                            ),
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
                                title: Text(
                                  snapshot.data![index].taskName,
                                  style: TextStyle(color: Colors.white),
                                ),
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
                      Navigator.pushNamed(
                        context,
                        '/add_task',
                        arguments: {
                          'tmTemp': viewModel.getTaskManager(),
                          'robot': robot,
                        },
                      );
                      robots = await viewModel.fetchRobots();
                      robotsController.add(robots);

                      viewModel.fetchTaskManager();
                      Task? currentTask = viewModel.fetchCurrentTask();
                      if (currentTask != null) _taskController.add(currentTask);
                      queueController.add(viewModel.fetchRemainingTasks());
                    },style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                    child: const Text(
                        'Add tasks',
                        style: TextStyle(
                            color: Colors.black),
                        )
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: () async {
                        viewModel.visualizeTask();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: myGreen),
                      child: const Text(
                        'Visualize',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Robot>>(
                stream: robotsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RobotPage(
                      robots: snapshot.data!,
                      onRobotSelected: (robot) {
                        viewModel.fetchTaskManager();
                        viewModel.setCurrentRobot(robot);
                        _currentRobotController.add(robot);
                        viewModel.setCurrentTask();
                        if (viewModel.currentRobot.currentTask != null) {
                          _taskController.add(viewModel.currentRobot.currentTask!);
                        }
                        queueController.add(viewModel.currentRobot.remainingTasks);
                      },
                    );
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
                  robotsController.add(robots);
                  Navigator.of(context).pop();
                },
              );
            }));
          },
          backgroundColor: myGreen,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
