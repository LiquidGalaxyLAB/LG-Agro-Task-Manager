class Crop {
  String cropName;
  String plantationDates;
  String transplantingDates;
  String harvestingDates;

  Crop(
      {required this.cropName,
      required this.plantationDates,
      required this.transplantingDates,
      required this.harvestingDates});

  (int, int) datesToInt(String typeOf) {
    if (typeOf == 'p') {
      final date = plantationDates.split('-');
      return (int.parse(date[0]), int.parse(date[1]));
    }

    //Transplanting dates pot ser buit, per representar que no n'hi ha
    if (typeOf == 't' && transplantingDates != '0-0') {
      final date = transplantingDates.split('-');
      return (int.parse(date[0]), int.parse(date[1]));
    }
    if (typeOf == 'h') {
      final date = harvestingDates.split('-');
      return (int.parse(date[0]), int.parse(date[1]));
    }
    //0, 0 és el que rebrem si no tenim valor a transplantingDates, per representar inexistència
    return (0, 0);
  }

  factory Crop.fromSqfliteDatabase(Map<String, dynamic> map) => Crop(
        cropName: map['cropName'] ?? '',
        plantationDates: map['plantingFortnight'] ?? '',
        transplantingDates: map['transplantingFortnight'] != ''
            ? map['transplantingFortnight']
            : '0-0',
        harvestingDates: map['harvestingFortnight'],
      );
}
