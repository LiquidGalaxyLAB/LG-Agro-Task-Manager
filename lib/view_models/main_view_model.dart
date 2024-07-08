import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../model/crop.dart';
import '../services/database_service.dart';

class MainViewModel {
  int currentFortnight = 0;
  List<Crop> cropsInCurrentFortnight = [];
  late Isar isar;

  Future<Isar> _getDataBase() async => DataBaseService.singleton.getDatabase();

  void fetchCrops() async {
    isar = await _getDataBase();
    List<Crop> crops = await isar.crops.where().findAll();
    currentFortnight = _getCurrentFortnight();
    cropsInCurrentFortnight = _filterCropsInCurrentFortnight(crops);
  }

  Future<void> initializeDatabase() async {
    fetchCrops();
  }

  int _getCurrentFortnight() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return (dayOfYear / 15).ceil();
  }

  bool _isInCurrentFortnight(String dateRange) {
    List<String> dates = dateRange.split('-');
    if (dates.length != 2) return false;

    int? start = int.tryParse(dates[0]);
    int? end = int.tryParse(dates[1]);

    if (start == null || end == null) return false;
    return start <= currentFortnight && currentFortnight <= end;
  }

  List<Crop> _filterCropsInCurrentFortnight(List<Crop> crops) {
    return crops.where((crop) {
      return _isInCurrentFortnight(crop.plantationDates) ||
          _isInCurrentFortnight(crop.transplantingDates) ||
          _isInCurrentFortnight(crop.harvestingDates);
    }).toList();
  }

  String getTaskText(Crop crop) {
    if (_isInCurrentFortnight(crop.plantationDates)) {
      return "It's Planting time!";
    } else if (_isInCurrentFortnight(crop.transplantingDates)) {
      return "It's Transplanting time!";
    } else if (_isInCurrentFortnight(crop.harvestingDates)) {
      return "It's Harvesting time!";
    } else {
      return "";
    }
  }
}
