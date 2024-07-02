import 'package:isar/isar.dart';
import 'package:taskmanager/services/database_service.dart';
import '../model/crop.dart';

class CropDetailViewModel {

  Future<Isar> _getDatabase() async => await DataBaseService.singleton.getDatabase();

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
