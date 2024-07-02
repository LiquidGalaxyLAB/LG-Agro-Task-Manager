import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskmanager/model/crop.dart';

class DataBaseService {
  static DataBaseService singleton = DataBaseService();
  late Isar _database;

  DataBaseService();

  Future<void> initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    _database = await Isar.open(
      [CropSchema],
      directory: dir.path,
    );
  }

  Future<Isar> getDatabase() async {
    return _database;
  }
}
