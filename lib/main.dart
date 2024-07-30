import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assegura't d'importar provider
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/services/database_service.dart';
import 'package:taskmanager/services/robots_service.dart';
import 'package:taskmanager/view/add_task_view.dart';
import 'package:taskmanager/view/connection_page_view.dart';
import 'package:taskmanager/view/crop_view.dart';
import 'package:taskmanager/view/lg_actions_view.dart';
import 'package:taskmanager/view/maps_view.dart';
import 'package:taskmanager/view/robots_view.dart';

import 'model/robot.dart';
import 'view/main_view.dart';
import 'view_models/robots_view_model.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseService.singleton.initializeDatabase();
  await RobotsService.singleton.initialize();
}

Future<void> main() async {
  await initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RobotsViewModel()),
      ],
      child: const TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainView(),
      routes: {
        '/add_task': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final tmTemp = args['tmTemp'] as TaskManager;
          final robot = args['robot'] as Robot;
          return AddTaskView(taskManager: tmTemp, robot: robot);
        },
        '/crop_page': (context) => const CropView(),
        '/robot_page': (context) => const RobotsView(),
        '/settings_page': (context) => const ConnectionPageView(),
        '/lg_actions': (context) => const LGActionsView(),
        '/maps_view': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final field = args['field'] as String;
          return MapsView(field: field);
        }
      },
    );
  }
}
