import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskmanager/model/task_manager.dart';
import 'package:taskmanager/pages/crop_page.dart';
import 'package:taskmanager/services/database_service.dart';
import 'package:taskmanager/view/add_task_view.dart';
import 'package:taskmanager/view/connection_page_view.dart';
import 'package:taskmanager/view/robots_view.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

import 'model/robot.dart';
import 'view/main_view.dart';

Future<void> main() async {
  // Ensuring that plugin services are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the sqflite ffi
  sqfliteFfiInit();

  // Setting the database factory to FFI
  databaseFactory = databaseFactoryFfi;

  // Initialize the database service
  await DataBaseService.getInstance();

  runApp(MaterialApp(
    home: const MainView(),
    routes: {
      '/add_task': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final tmTemp = args['tmTemp'] as TaskManager;
        final robot = args['robot'] as Robot;
        return AddTaskView(taskManager: tmTemp, robot: robot);
      },
      '/crop_page': (context) => const CropsPage(),
      '/robot_page': (context) => const RobotsView(),
      '/settings_page': (context) => const ConnectionPageView(),
    },
  ));
}
