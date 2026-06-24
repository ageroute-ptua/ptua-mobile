class EmployeCommercial {
  final int? id;
  final String? idPap;
  final String? employeurActCom;
  final String? nomPrenomEmpActCom;
  final String? typePieceEmp;
  final int? numPieceEmpActCom;
  final String? lieuResiEmpActCom;
  final String? contactEmpActCom;
  final String? salaireEmpActCom;
  final DateTime? createdAt;
  final String syncStatus;
  final String? deviceId;

  EmployeCommercial({
    this.id,
    required this.idPap,
    this.employeurActCom,
    this.nomPrenomEmpActCom,
    this.typePieceEmp,
    this.numPieceEmpActCom,
    this.lieuResiEmpActCom,
    this.contactEmpActCom,
    this.salaireEmpActCom,
    this.createdAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory EmployeCommercial.fromMap(Map<String, dynamic> map) {
    return EmployeCommercial(
      id: map['id'],
      idPap: map['idPap'],
      employeurActCom: map['employeurActCom']?.toString(),
      nomPrenomEmpActCom: map['nomPrenomEmpActCom']?.toString(),
      typePieceEmp: map['typePieceEmp']?.toString(),
      numPieceEmpActCom: map['numPieceEmpActCom'] as int?,
      lieuResiEmpActCom: map['lieuResiEmpActCom']?.toString(),
      contactEmpActCom: map['contactEmpActCom']?.toString(),
      salaireEmpActCom: map['salaireEmpActCom']?.toString(),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPap': idPap,
      'employeurActCom': employeurActCom,
      'nomPrenomEmpActCom': nomPrenomEmpActCom,
      'typePieceEmp': typePieceEmp,
      'numPieceEmpActCom': numPieceEmpActCom,
      'lieuResiEmpActCom': lieuResiEmpActCom,
      'contactEmpActCom': contactEmpActCom,
      'salaireEmpActCom': salaireEmpActCom,
      'createdAt': createdAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }
}
