class Sante {
  final int? idSante;
  final String idPap; // Associé au PAP (et donc implicitement au ménage du PAP en DB locale)
  final int? distanceDomSante;
  final bool? isAssurance;
  final int? nbrPersCouvAssurance;
  final String? assureur;
  final double? tauxCouverture;
  final int? nbrPersMalade;
  final String? typeSoinMen;
  final String? justifReponse;
  final int? periodeAnMalade;
  final String? autreTauxCouverture;
  final String? autreTypeSoin;
  final String? autreJustifTypeSoin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Sante({
    this.idSante,
    required this.idPap,
    this.distanceDomSante,
    this.isAssurance,
    this.nbrPersCouvAssurance,
    this.assureur,
    this.tauxCouverture,
    this.nbrPersMalade,
    this.typeSoinMen,
    this.justifReponse,
    this.periodeAnMalade,
    this.autreTauxCouverture,
    this.autreTypeSoin,
    this.autreJustifTypeSoin,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory Sante.fromMap(Map<String, dynamic> map) {
    return Sante(
      idSante: map['idSante'],
      idPap: map['idPap'],
      distanceDomSante: map['distanceDomSante'],
      isAssurance: map['isAssurance'] == 1,
      nbrPersCouvAssurance: map['nbrPersCouvAssurance'],
      assureur: map['assureur'],
      tauxCouverture: map['tauxCouverture'],
      nbrPersMalade: map['nbrPersMalade'],
      typeSoinMen: map['typeSoinMen'],
      justifReponse: map['justifReponse'],
      periodeAnMalade: map['periodeAnMalade'],
      autreTauxCouverture: map['autreTauxCouverture'],
      autreTypeSoin: map['autreTypeSoin'],
      autreJustifTypeSoin: map['autreJustifTypeSoin'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idSante': idSante,
      'idPap': idPap,
      'distanceDomSante': distanceDomSante,
      'isAssurance': isAssurance == true ? 1 : 0,
      'nbrPersCouvAssurance': nbrPersCouvAssurance,
      'assureur': assureur,
      'tauxCouverture': tauxCouverture,
      'nbrPersMalade': nbrPersMalade,
      'typeSoinMen': typeSoinMen,
      'justifReponse': justifReponse,
      'periodeAnMalade': periodeAnMalade,
      'autreTauxCouverture': autreTauxCouverture,
      'autreTypeSoin': autreTypeSoin,
      'autreJustifTypeSoin': autreJustifTypeSoin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  Sante copyWith({String? syncStatus}) {
    return Sante(
      idSante: idSante,
      idPap: idPap,
      distanceDomSante: distanceDomSante,
      isAssurance: isAssurance,
      nbrPersCouvAssurance: nbrPersCouvAssurance,
      assureur: assureur,
      tauxCouverture: tauxCouverture,
      nbrPersMalade: nbrPersMalade,
      typeSoinMen: typeSoinMen,
      justifReponse: justifReponse,
      periodeAnMalade: periodeAnMalade,
      autreTauxCouverture: autreTauxCouverture,
      autreTypeSoin: autreTypeSoin,
      autreJustifTypeSoin: autreJustifTypeSoin,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
