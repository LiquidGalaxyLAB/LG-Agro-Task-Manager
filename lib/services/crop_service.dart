import 'package:isar/isar.dart';

import '../model/crop.dart';
import 'database_service.dart';

class CropService {

  Isar _getDataBase() => DataBaseService.singleton.getDatabase();
  static CropService singleton = CropService();

  List<Crop> getCrops() {
    final isar = _getDataBase();
    return isar.crops.where().findAllSync();
  }

  Future<void> updateCrop(int id, String cropName, String plantingDate,
      String harvestingDate, String transplantingDate) async {
    final isar = _getDataBase();
    await isar.writeTxn(() async {
      final crop = await isar.crops.get(id);
      if (crop != null) {
        crop.cropName = cropName;
        crop.plantationDates = plantingDate;
        crop.harvestingDates = harvestingDate;
        crop.transplantingDates = transplantingDate;
        await isar.crops.put(crop);
      }
    });
  }

  int getCropID(String cropName){
    final isar = _getDataBase();
    Crop? c = isar.crops.filter().cropNameEqualTo(cropName).findFirstSync();
    return c?.id ?? 0;
  }

  String getCropPlantationDate(Crop crop) {
    final isar = _getDataBase();
    Crop? newCrop = isar.crops.filter().idEqualTo(crop.id).findFirstSync();
    return newCrop?.plantationDates ?? "1-1";
  }

  String getCropTransplantingDate(Crop crop) {
    final isar = _getDataBase();
    Crop? newCrop = isar.crops.filter().idEqualTo(crop.id).findFirstSync();
    return newCrop?.transplantingDates ?? "1-1";
  }

  String getCropHarvestingDate(Crop crop) {
    final isar = _getDataBase();
    Crop? newCrop = isar.crops.filter().idEqualTo(crop.id).findFirstSync();
    return newCrop?.harvestingDates ?? "1-1";
  }

}
