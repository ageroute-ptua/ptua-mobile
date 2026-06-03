class Enquete {
  final int? id; // L'ID auto-incrémenté de SQLite
  final String idEnquete; // Ex: ENQ-2023-001
  final String? enqueteur;
  final DateTime? dateEnquete;
  final String? communeCode;
  final String? quartierCode;
  final String? contact;
  final String? projetCode;
  final String? sectionCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus; // 'local', 'syncing', 'synced'
  final String? deviceId;
  final String? photoPath; // Nouveau champ : Chemin de la photo locale
  final String? signaturePath; // Nouveau champ : Chemin de la signature locale

  Enquete({
    this.id,
    required this.idEnquete,
    this.enqueteur,
    this.dateEnquete,
    this.communeCode,
    this.quartierCode,
    this.contact,
    this.projetCode,
    this.sectionCode,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
    this.photoPath,
    this.signaturePath,
  });

  // Depuis SQLite vers Dart
  factory Enquete.fromMap(Map<String, dynamic> map) {
    return Enquete(
      id: map['id'],
      idEnquete: map['idEnquete'],
      enqueteur: map['enqueteur'],
      dateEnquete: map['dateEnquete'] != null ? DateTime.parse(map['dateEnquete']) : null,
      communeCode: map['communeCode'],
      quartierCode: map['quartierCode'],
      contact: map['contact'],
      projetCode: map['projetCode'],
      sectionCode: map['sectionCode'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'],
      deviceId: map['deviceId'],
      photoPath: map['photoPath'],
      signaturePath: map['signaturePath'],
    );
  }

  // Depuis Dart vers SQLite ou JSON (API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idEnquete': idEnquete,
      'enqueteur': enqueteur,
      'dateEnquete': dateEnquete?.toIso8601String(),
      'communeCode': communeCode,
      'quartierCode': quartierCode,
      'contact': contact,
      'projetCode': projetCode,
      'sectionCode': sectionCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
      'photoPath': photoPath,
      'signaturePath': signaturePath,
    };
  }

  // Méthode copyWith pour immutabilité
  Enquete copyWith({
    int? id,
    String? idEnquete,
    String? enqueteur,
    DateTime? dateEnquete,
    String? communeCode,
    String? quartierCode,
    String? contact,
    String? projetCode,
    String? sectionCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    String? deviceId,
    String? photoPath,
    String? signaturePath,
  }) {
    return Enquete(
      id: id ?? this.id,
      idEnquete: idEnquete ?? this.idEnquete,
      enqueteur: enqueteur ?? this.enqueteur,
      dateEnquete: dateEnquete ?? this.dateEnquete,
      communeCode: communeCode ?? this.communeCode,
      quartierCode: quartierCode ?? this.quartierCode,
      contact: contact ?? this.contact,
      projetCode: projetCode ?? this.projetCode,
      sectionCode: sectionCode ?? this.sectionCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      photoPath: photoPath ?? this.photoPath,
      signaturePath: signaturePath ?? this.signaturePath,
    );
  }
}
