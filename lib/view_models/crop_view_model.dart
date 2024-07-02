import 'package:isar/isar.dart';
import 'package:taskmanager/services/database_service.dart';

import '../model/crop.dart';

class CropViewModel{
  late Future<List<Crop>>? futureCrops;
  late Isar isar;


  Future<void> initializeDatabase() async {
    isar = await DataBaseService.singleton.getDatabase();
  }

  Future<void> fetchCrops() async {
    futureCrops = isar.crops.where().findAll();
  }

  Future<Isar> _getDataBase() async => DataBaseService.singleton.getDatabase();

  Future<void >createCrop(String cropName, String plantingDate,
      String harvestingDate, String transplantingDate) async {
    final isar = await _getDataBase();
    return await isar.writeTxn(() async {
      await isar.crops.put(Crop(cropName: cropName,
          plantationDates: plantingDate,
          harvestingDates: harvestingDate,
          transplantingDates: transplantingDate)); // insert & update
    });
  }
}