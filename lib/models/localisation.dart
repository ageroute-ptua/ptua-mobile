class Localisation {
  final int? idLocalisation;
  final String idEnquete;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? precisionGps;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;

  Localisation({
    this.idLocalisation,
    required this.idEnquete,
    this.latitude,
    this.longitude,
    this.altitude,
    this.precisionGps,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
  });

  factory Localisation.fromMap(Map<String, dynamic> map) {
    return Localisation(
      idLocalisation: map['idLocalisation'],
      idEnquete: map['idEnquete'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      altitude: map['altitude'],
      precisionGps: map['precisionGps'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idLocalisation': idLocalisation,
      'idEnquete': idEnquete,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'precisionGps': precisionGps,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  Localisation copyWith({String? syncStatus}) {
    return Localisation(
      idLocalisation: idLocalisation,
      idEnquete: idEnquete,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      precisionGps: precisionGps,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
