import 'package:flutter/material.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/view/crop_view.dart';
import 'package:taskmanager/services/database_service.dart';
import 'package:taskmanager/services/robots_service.dart';
import 'package:taskmanager/view/add_task_view.dart';
import 'package:taskmanager/view/connection_page_view.dart';
import 'package:taskmanager/view/lg_actions_view.dart';
import 'package:taskmanager/view/maps_view.dart';
import 'package:taskmanager/view/robots_view.dart';


import 'model/robot.dart';
import 'view/main_view.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseService.singleton.initializeDatabase();
  await RobotsService.singleton.initialize();
}

Future<void> main() async {
  await initializeApp();
  runApp(MaterialApp(
    home: const MainView(),
    routes: {
      '/add_task': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final tmTemp = args['tmTemp'] as TaskManager;
        final robot = args['robot'] as Robot;
        return AddTaskView(taskManager: tmTemp, robot: robot);
      },
      '/crop_page': (context) => const CropView(),
      '/robot_page': (context) => const RobotsView(),
      '/settings_page': (context) => const ConnectionPageView(),
      '/lg_actions': (context) => const LGActionsView(),
      '/maps_view': (context) => const MapsView(),
    },
  ));
}
