import 'package:taskmanager/services/crop_service.dart';

import '../model/crop.dart';

class CropDetailViewModel {
  int _getCurrentFortnight() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysPassed = now.difference(startOfYear).inDays;

    return (daysPassed ~/ 15) + 1;
  }

  bool isSelected(int index, String dates) {
    final dateValues = dates.split('-');
    final start = int.tryParse(dateValues[0]) ?? 0;
    final end = int.tryParse(dateValues[1]) ?? 0;

    return index + 1 >= start && index + 1 <= end;
  }

  bool isInCurrentFortnight(int index) {
    return index + 1 == _getCurrentFortnight();
  }

  Future<void> updateCrop(int cropID, String cropName, String plantingDate,
      String harvestingDate, String transplantingDate) async {
    await CropService.singleton.updateCrop(
        cropID, cropName, plantingDate, harvestingDate, transplantingDate);
  }

  String getCropPlantationDate(Crop crop) {
    return CropService.singleton.getCropPlantationDate(crop);
  }

  String getCropTransplantingDate(Crop crop) {
    return CropService.singleton.getCropTransplantingDate(crop);
  }

  String getCropHarvestingDate(Crop crop) {
    return CropService.singleton.getCropHarvestingDate(crop);
  }

  int searchCropID(String cropName) {
    return CropService.singleton.getCropID(cropName);
  }
}
