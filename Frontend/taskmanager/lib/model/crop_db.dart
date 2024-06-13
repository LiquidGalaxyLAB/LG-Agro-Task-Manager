import 'package:sqflite_common/sqlite_api.dart';
import 'package:taskmanager/model/robot.dart';
import 'package:taskmanager/services/database_service.dart';

import 'crop.dart';

class CropRobotDB {
  final tableName = 'crops';
  final robotTableName = 'robots';

  // Les crops tindran les dates de plantament, etc com a un text amb format "num1-num2"
  // Aquest text després es parsejarà per llegir
  Future<void> createCropTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "cropName"  TEXT NOT NULL,
      "plantingFortnight" TEXT NOT NULL,
      "transplantingFortnight" TEXT,
      "harvestingFortnight" TEXT NOT NULL,
      PRIMARY KEY ("cropName")
    );""");
  }

  Future<void> createRobotTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $robotTableName (
      "robotNumber"  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "robotName" TEXT NOT NULL,
      "serialCode" TEXT NOT NULL,
      "robotIP" TEXT NOT NULL
    );""");
  }

  // Afegir una entrada a la taula
  Future<int> createCrop({
    required String cropName,
    required String plantingDate,
    required String harvestingDate,
    required String transplantingDate
  }) async {
    final database = await (await DataBaseService.getInstance()).database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (cropName, plantingFortnight, 
      transplantingFortnight, harvestingFortnight) VALUES (?, ?, ?, ?)''',
      [cropName, plantingDate, transplantingDate, harvestingDate],
    );
  }

  Future<int> createRobot({
    required String robotName,
    required String serialCode,
    required String robotIP
  }) async {
    final database = await (await DataBaseService.getInstance()).database;
    return await database.rawInsert(
      '''INSERT INTO $robotTableName (robotName, serialCode, robotIP) VALUES (?,?,?)''',
      [robotName, serialCode, robotIP],
    );
  }

  Future<List<Crop>> fetchAllCrops() async {
    final database = await (await DataBaseService.getInstance()).database;
    final crops = await database
        .rawQuery('''SELECT * FROM $tableName ORDER BY cropName''');
    return crops.map((crop) => Crop.fromSqfliteDatabase(crop)).toList();
  }

  Future<List<Robot>> fetchAllRobots() async {
    final database = await (await DataBaseService.getInstance()).database;
    final robots = await database
        .rawQuery('''SELECT * FROM $robotTableName ORDER BY robotNumber''');
    return robots.map((robot) => Robot.fromSqfliteDatabase(robot)).toList();
  }

  // Actualitzar una entrada a la taula
  Future<int> updateCrop({
    required String cropName,
    String? plantingDate,
    String? transplantingDate,
    String? harvestingDate
  }) async {
    final database = await (await DataBaseService.getInstance()).database;
    return await database.update(
      tableName,
      {
        if (plantingDate != null) 'plantingFortnight': plantingDate,
        if (transplantingDate != null) 'transplantingFortnight': transplantingDate,
        if (harvestingDate != null) 'harvestingFortnight': harvestingDate,
      },
      where: 'cropName = ?',
      whereArgs: [cropName],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  // Eliminar una entrada a la taula
  Future<void> deleteCrop(String cropName) async {
    final database = await (await DataBaseService.getInstance()).database;
    await database.delete(
      tableName,
      where: 'cropName = ?',
      whereArgs: [cropName],
    );
  }
}
