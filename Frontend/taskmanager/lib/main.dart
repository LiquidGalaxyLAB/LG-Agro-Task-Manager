import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskmanager/pages/crop_page.dart';
import 'package:taskmanager/services/database_service.dart';
import 'package:taskmanager/view/add_task_view.dart';
import 'package:taskmanager/view/robots_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;


import 'view/main_view.dart';

Future<void> main() async {

  DataBaseService.initialize(dbService)

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: const MainView(),
    routes: {
      '/add_task': (context) => const AddTaskView(),
      '/crop_page': (context) => const CropsPage(),
      '/robot_page' : (context) => const RobotsView(),
    },
  ));
}
