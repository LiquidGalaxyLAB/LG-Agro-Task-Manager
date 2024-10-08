import 'package:isar/isar.dart';
import 'package:taskmanager/services/database_service.dart';
import '../model/crop.dart';

class CropViewModel {
  Future<List<Crop>>? futureCrops;
  late Isar isar;

  void initializeDatabase() {
    isar = DataBaseService.singleton.getDatabase();
  }

  void fetchCrops() {
    isar = DataBaseService.singleton.getDatabase();
    futureCrops = isar.crops.where().findAll();
  }

  Future<Isar> _getDataBase() async => DataBaseService.singleton.getDatabase();

  Future<void> createCrop(String cropName, String plantingDate, String harvestingDate, String transplantingDate) async {
    final isar = await _getDataBase();
    await isar.writeTxn(() async {
      await isar.crops.put(Crop(
        cropName: cropName,
        plantationDates: plantingDate,
        harvestingDates: harvestingDate,
        transplantingDates: transplantingDate,
      )); // insert & update
    });
    fetchCrops();
  }

  Future<List<Crop>>? getFutureCrops() {
    return futureCrops;
  }

  Future<int> searchByCropName(String cropName) async {
    final isar = await _getDataBase();
    final crop = await isar.crops.filter().cropNameEqualTo(cropName).findFirst();
    if(crop == null) {
      return -1;
    } else {
      return crop.id;
    }
  }

  Future<void> deleteCrops(String cropName) async {
    int id = await searchByCropName(cropName);
    if(id != -1) {
      await isar.writeTxn(() async{
        await isar.crops.delete(id);
      });
    }
  }
}
