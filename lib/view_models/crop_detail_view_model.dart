import 'package:isar/isar.dart';
import 'package:taskmanager/services/database_service.dart';
import '../model/crop.dart';

class CropDetailViewModel {

  Future<Isar> _getDatabase() async => await DataBaseService.singleton.getDatabase();

  Future<int> searchByCropName(String cropName) async {
    final isar = await _getDatabase();
    final crop = await isar.crops.filter().cropNameEqualTo(cropName).findFirst();
    if(crop == null) return -1;
    else {
      return crop.id;
    }
  }

  Future<void> updateCrop(int id, String cropName, String plantingDate,
      String harvestingDate, String transplantingDate) async {
    final isar = await _getDatabase();
      await isar.writeTxn(() async {
        final crop = await isar.crops.get(id);
        if (crop != null) {
          crop.cropName = cropName;
          crop.plantationDates = plantingDate;
          crop.harvestingDates = harvestingDate;
          crop.transplantingDates = transplantingDate;
          await isar.crops.put(crop); // insert & update
        }
      });
  }
}
