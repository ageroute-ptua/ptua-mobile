class PhotoBatiment {
  final int? id;
  final String? idPap;
  final String? photoBati;
  final String? photoBatiUrl;
  final DateTime? createdAt;
  final String syncStatus;
  final String? deviceId;

  PhotoBatiment({
    this.id,
    required this.idPap,
    this.photoBati,
    this.photoBatiUrl,
    this.createdAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory PhotoBatiment.fromMap(Map<String, dynamic> map) {
    return PhotoBatiment(
      id: map['id'],
      idPap: map['idPap'],
      photoBati: map['photoBati']?.toString(),
      photoBatiUrl: map['photoBatiUrl']?.toString(),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPap': idPap,
      'photoBati': photoBati,
      'photoBatiUrl': photoBatiUrl,
      'createdAt': createdAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }
}
