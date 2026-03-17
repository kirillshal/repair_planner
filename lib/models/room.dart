class Room {
  int? id;
  String name;
  double length;
  double width;
  String materialType;
  double wastePercentage;
  double calculatedArea;
  int? tilesNeeded;
  double? laminateNeeded;
  DateTime createdAt;

  Room({
    this.id,
    required this.name,
    required this.length,
    required this.width,
    required this.materialType,
    required this.wastePercentage,
    required this.calculatedArea,
    this.tilesNeeded,
    this.laminateNeeded,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'length': length,
      'width': width,
      'materialType': materialType,
      'wastePercentage': wastePercentage,
      'calculatedArea': calculatedArea,
      'tilesNeeded': tilesNeeded,
      'laminateNeeded': laminateNeeded,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      name: map['name'],
      length: map['length'],
      width: map['width'],
      materialType: map['materialType'],
      wastePercentage: map['wastePercentage'],
      calculatedArea: map['calculatedArea'],
      tilesNeeded: map['tilesNeeded'],
      laminateNeeded: map['laminateNeeded'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  static Map<String, dynamic> calculateMaterials({
    required double length,
    required double width,
    required String materialType,
    required double wastePercentage,
  }) {
    double area = length * width;
    double areaWithWaste = area * (1 + wastePercentage / 100);

    if (materialType == 'Плитка') {
      double tileArea = 0.09; // 30x30 см
      int tilesNeeded = (areaWithWaste / tileArea).ceil();
      return {
        'calculatedArea': area,
        'tilesNeeded': tilesNeeded,
        'laminateNeeded': null,
      };
    } else {
      return {
        'calculatedArea': area,
        'tilesNeeded': null,
        'laminateNeeded': double.parse((areaWithWaste).toStringAsFixed(2)),
      };
    }
  }
}