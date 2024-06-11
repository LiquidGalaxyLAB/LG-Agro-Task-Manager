import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import '../model/crop_db.dart';

class DataBaseService {
  final Database _database;
  static late DataBaseService singleton;

  DataBaseService(this._database);

  Database get database {
    return _database;
  }

  String get fullPath {
    return inMemoryDatabasePath;
  }

  static void initialize() async {
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "crop.db");
    var db = await databaseFactoryFfi.openDatabase(dbPath);
    singleton = DataBaseService(db);
  }

  Future<void> create(Database database, int version) async {
    await CropRobotDB().createCropTable(database);
    await CropRobotDB().createRobotTable(database);
  }
}
