import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import '../model/crop_db.dart';

class DataBaseService {
  static DataBaseService? singleton;
  final Database _database;

  DataBaseService._internal(this._database);

  static Future<DataBaseService> getInstance() async {
    if (singleton == null) {
      final io
          .Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      String dbPath = p.join(appDocumentsDir.path, "databases", "crop.db");
      var db = await databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await DataBaseService._onCreate(db, version);
          },
        ),
      );
      singleton = DataBaseService._internal(db);
    }
    return singleton!;
  }

  Future<Database> get database async {
    return _database;
  }

  String get fullPath {
    return inMemoryDatabasePath;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await CropRobotDB().createCropTable(db);
    await CropRobotDB().createRobotTable(db);
  }
}
