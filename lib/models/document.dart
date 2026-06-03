class Document {
  final int? idDocument;
  final String idPap;
  final String codeTypeDoc; // ex: 'PHOTO_PAP', 'PIECE_RECTO', 'PIECE_VERSO'
  final String cheminFichier;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Document({
    this.idDocument,
    required this.idPap,
    required this.codeTypeDoc,
    required this.cheminFichier,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      idDocument: map['idDocument'],
      idPap: map['idPap'],
      codeTypeDoc: map['codeTypeDoc'],
      cheminFichier: map['cheminFichier'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idDocument': idDocument,
      'idPap': idPap,
      'codeTypeDoc': codeTypeDoc,
      'cheminFichier': cheminFichier,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  Document copyWith({String? syncStatus}) {
    return Document(
      idDocument: idDocument,
      idPap: idPap,
      codeTypeDoc: codeTypeDoc,
      cheminFichier: cheminFichier,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
