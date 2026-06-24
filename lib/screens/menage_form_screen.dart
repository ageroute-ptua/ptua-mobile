import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../models/menage.dart';
import '../services/database_helper.dart';

class MenageFormScreen extends StatefulWidget {
  final String idPap;
  const MenageFormScreen({super.key, required this.idPap});

  @override
  State<MenageFormScreen> createState() => _MenageFormScreenState();
}

class _MenageFormScreenState extends State<MenageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  final _nbrePersonnesController = TextEditingController();
  final _appartenanceOrgController = TextEditingController();
  final _montantRetraiteController = TextEditingController();

  String? _isChefMen = 'Oui';
  String? _typeMenage;
  
  String? _situationSocialeMenage;
  final _nomPrenomMenController = TextEditingController();
  String? _parenteMen;
  final _autreLienParenteController = TextEditingController();
  final _telephoneMenController = TextEditingController();

  String? _isPersonneVulMenage = 'Non';
  final _enfVulMenageController = TextEditingController();
  final _persAgeeVulMenageController = TextEditingController();
  final _handicapephysmentMenageController = TextEditingController();
  final _femGrossessMenageController = TextEditingController();
  final _orphelinMenageController = TextEditingController();
  final _femChefMenageController = TextEditingController();
  final _persMaladieMetaMenageController = TextEditingController();
  final _nbrePersVulnMenageController = TextEditingController();

  String? _isMembreOrganisation = 'Non';
  String? _typeOrganisation;
  final _declarationOrgQuartierController = TextEditingController();
  String? _statutAssociation;
  final _autreOrganisationController = TextEditingController();
  String? _typeRelaMemOrg;
  String? _avantageAssocOrg;

  String? _toucheRetraite = 'Non';
  
  String? _typeSanitaire = 'W-C Chasse';

  String? _indiqNbrEquip = 'Non';
  final _voitureController = TextEditingController();
  final _motoController = TextEditingController();
  final _veloController = TextEditingController();
  final _salonController = TextEditingController();
  final _televisionController = TextEditingController();
  final _radioController = TextEditingController();
  final _ordinateurController = TextEditingController();
  final _portableController = TextEditingController();
  final _cuisiniereController = TextEditingController();
  final _congelateurController = TextEditingController();
  final _ferController = TextEditingController();
  final _climController = TextEditingController();
  final _machineController = TextEditingController();
  final _biblioController = TextEditingController();

  void _saveMenage() async {
    if (_formKey.currentState!.validate()) {
      final menage = Menage(
        idPap: widget.idPap,
        nbrePersonnesMenage: int.tryParse(_nbrePersonnesController.text),
        isChefMen: _isChefMen == 'Oui',
        typeMenage: _typeMenage,
        appartenanceOrg: _appartenanceOrgController.text,
        isPersonneVulMenage: _isPersonneVulMenage == 'Oui',
        typeSanitaire: _typeSanitaire,
        isMembreOrganisation: _isMembreOrganisation == 'Oui',
        typeOrganisation: _typeOrganisation,
        toucheRetraite: _toucheRetraite == 'Oui',
        montantRetraite: double.tryParse(_montantRetraiteController.text),
        
        situationSocialeMenage: _situationSocialeMenage,
        nomPrenomMen: _nomPrenomMenController.text,
        parenteMen: _parenteMen,
        autreLienParente: _autreLienParenteController.text,
        telephoneMen: _telephoneMenController.text,
        
        enfVulMenage: int.tryParse(_enfVulMenageController.text),
        persAgeeVulMenage: int.tryParse(_persAgeeVulMenageController.text),
        handicapephysmentMenage: int.tryParse(_handicapephysmentMenageController.text),
        femGrossessMenage: int.tryParse(_femGrossessMenageController.text),
        orphelinMenage: int.tryParse(_orphelinMenageController.text),
        femChefMenage: int.tryParse(_femChefMenageController.text),
        persMaladieMetaMenage: int.tryParse(_persMaladieMetaMenageController.text),
        nbrePersVulnMenage: int.tryParse(_nbrePersVulnMenageController.text),
        
        declarationOrgQuartier: _declarationOrgQuartierController.text,
        statutAssociation: _statutAssociation,
        autreOrganisation: _autreOrganisationController.text,
        typeRelaMemOrg: _typeRelaMemOrg,
        avantageAssocOrg: _avantageAssocOrg,
        
        indiqNbrEquip: _indiqNbrEquip,
        voiture: int.tryParse(_voitureController.text),
        moto: int.tryParse(_motoController.text),
        velo: int.tryParse(_veloController.text),
        salon: int.tryParse(_salonController.text),
        television: int.tryParse(_televisionController.text),
        radio: int.tryParse(_radioController.text),
        ordinateur: int.tryParse(_ordinateurController.text),
        portable: int.tryParse(_portableController.text),
        cuisiniere: int.tryParse(_cuisiniereController.text),
        congelateur: int.tryParse(_congelateurController.text),
        fer: int.tryParse(_ferController.text),
        clim: int.tryParse(_climController.text),
        machine: int.tryParse(_machineController.text),
        biblio: int.tryParse(_biblioController.text),

        createdAt: DateTime.now(),
        syncStatus: 'local',
      );

      await _dbHelper.insertMenage(menage);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Infos Ménage sauvegardées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E224A))),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget _buildBoolField(String label, String? value, Function(String?) onChanged) {
    return PremiumSingleSelect<String>(
      value: value,
      label: label,
      icon: Icons.check_circle_outline,
      items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Ménage & Habitat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSectionCard(
                      title: 'Informations Générales',
                      children: [
                        _buildTextField(_nbrePersonnesController, 'Nombre total de personnes', isNumber: true, icon: Icons.group),
                        _buildBoolField('Êtes-vous chef de ménage ?', _isChefMen, (v) => setState(() => _isChefMen = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isChefMen == 'Non' ? Column(
                            children: [
                              PremiumSingleSelect<String>(
  value: _situationSocialeMenage,
  label: 'Situation sociale du Chef de ménage',
  icon: Icons.favorite,
  items: ['Célibataire', 'Marié(e)', 'Veuf(ve)', 'Divorcé(e)'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _situationSocialeMenage = v),
),
                              const SizedBox(height: 16),
                              _buildTextField(_nomPrenomMenController, 'Nom et Prénom du chef de ménage', icon: Icons.person),
                              PremiumSingleSelect<String>(
  value: _parenteMen,
  label: 'Lien de parenté avec le chef',
  icon: Icons.family_restroom,
  items: ['Conjoint(e)', 'Enfant', 'Frère/Sœur', 'Parent', 'Autre'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _parenteMen = v),
),
                              if (_parenteMen == 'Autre') Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: _buildTextField(_autreLienParenteController, 'Autre lien de parenté'),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(_telephoneMenController, 'Téléphone du chef de ménage', isNumber: true, icon: Icons.phone),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        PremiumSingleSelect<String>(
  value: _typeMenage,
  label: 'Type de Ménage',
  icon: Icons.home,
  items: [
                            'Ménage composé d\'une seule personne', 'Ménage composé d\'un couple sans enfant', 'Ménage composé d\'un couple et d\'enfants', 'Ménage monoparental', 'Ménage polygamique', 'Ménage comprenant la famille étendue'
                          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _typeMenage = v),
),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Vulnérabilités',
                      children: [
                        _buildBoolField('Y a-t-il des personnes vulnérables ?', _isPersonneVulMenage, (v) => setState(() => _isPersonneVulMenage = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isPersonneVulMenage == 'Oui' ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.only(bottom: 8.0), child: Text('Nombre pour chaque catégorie :', style: TextStyle(color: Colors.grey))),
                              _buildTextField(_enfVulMenageController, 'Enfants vulnérables', isNumber: true),
                              _buildTextField(_persAgeeVulMenageController, 'Personnes âgées vulnérables', isNumber: true),
                              _buildTextField(_handicapephysmentMenageController, 'Handicapés physiques/mentaux', isNumber: true),
                              _buildTextField(_femGrossessMenageController, 'Femmes en grossesse', isNumber: true),
                              _buildTextField(_orphelinMenageController, 'Orphelins', isNumber: true),
                              _buildTextField(_femChefMenageController, 'Femmes chefs de ménage', isNumber: true),
                              _buildTextField(_persMaladieMetaMenageController, 'Maladies métaboliques', isNumber: true),
                              _buildTextField(_nbrePersVulnMenageController, 'Total de personnes vulnérables', isNumber: true),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Vie Sociale & Équipements',
                      children: [
                        _buildBoolField('Faites-vous partie d\'une organisation ?', _isMembreOrganisation, (v) => setState(() => _isMembreOrganisation = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isMembreOrganisation == 'Oui' ? Column(
                            children: [
                              PremiumMultiSelect(
  initialValue: _typeOrganisation,
  label: "Type d\'organisation",
  icon: Icons.groups,
  items: const ['Mutuelle de développement', 'Association du quartier', 'Coopérative agricole', 'Autres'],
  onChanged: (v) => setState(() => _typeOrganisation = v),
),
                              if (_typeOrganisation == 'Autres') Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: _buildTextField(_autreOrganisationController, 'Autre organisation'),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(_declarationOrgQuartierController, 'Nom de l\'organisation'),
                              PremiumSingleSelect<String>(
  value: _statutAssociation,
  label: "Statut dans l\'organisation",
  icon: Icons.badge,
  items: ['Président', 'Secrétaire', 'Trésorier', 'Membre simple', 'Autre'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _statutAssociation = v),
),
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _typeRelaMemOrg,
  label: 'Relation avec les membres',
  icon: Icons.handshake,
  items: ['Très bonne', 'Bonne', 'Moyenne', 'Mauvaise'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _typeRelaMemOrg = v),
),
                              const SizedBox(height: 16),
                              PremiumMultiSelect(
  initialValue: _avantageAssocOrg,
  label: "Avantages tirés",
  icon: Icons.card_giftcard,
  items: const ['Financier', 'Matériel', 'Moral/Soutien', 'Aucun', 'Autre'],
  onChanged: (v) => setState(() => _avantageAssocOrg = v),
),
                              const SizedBox(height: 16),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        _buildBoolField('Le chef de ménage touche-t-il une retraite ?', _toucheRetraite, (v) => setState(() => _toucheRetraite = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _toucheRetraite == 'Oui' ? _buildTextField(_montantRetraiteController, 'Montant annuel (FCFA)', isNumber: true, icon: Icons.payments) : const SizedBox.shrink(),
                        ),
                        PremiumMultiSelect(
  initialValue: _typeSanitaire,
  label: 'Type de Sanitaire',
  icon: Icons.wc,
  items: const ['W-C Chasse', 'Latrine', 'Fosse Septique', 'Dans la nature'],
  onChanged: (v) => setState(() => _typeSanitaire = v),
),
                        const SizedBox(height: 16),
                        _buildBoolField('Indiquer le nombre d\'équipements ?', _indiqNbrEquip, (v) => setState(() => _indiqNbrEquip = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _indiqNbrEquip == 'Oui' ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.only(bottom: 8.0), child: Text('Nombre :', style: TextStyle(color: Colors.grey))),
                              _buildTextField(_voitureController, 'Voiture', isNumber: true, icon: Icons.directions_car),
                              _buildTextField(_motoController, 'Moto', isNumber: true, icon: Icons.two_wheeler),
                              _buildTextField(_veloController, 'Vélo', isNumber: true, icon: Icons.pedal_bike),
                              _buildTextField(_salonController, 'Salon', isNumber: true, icon: Icons.chair),
                              _buildTextField(_televisionController, 'Télévision', isNumber: true, icon: Icons.tv),
                              _buildTextField(_radioController, 'Radio', isNumber: true, icon: Icons.radio),
                              _buildTextField(_ordinateurController, 'Ordinateur', isNumber: true, icon: Icons.computer),
                              _buildTextField(_portableController, 'Portable', isNumber: true, icon: Icons.smartphone),
                              _buildTextField(_cuisiniereController, 'Cuisinière', isNumber: true, icon: Icons.microwave),
                              _buildTextField(_congelateurController, 'Congélateur', isNumber: true, icon: Icons.kitchen),
                              _buildTextField(_ferController, 'Fer à repasser', isNumber: true, icon: Icons.iron),
                              _buildTextField(_climController, 'Climatiseur', isNumber: true, icon: Icons.ac_unit),
                              _buildTextField(_machineController, 'Machine à laver', isNumber: true, icon: Icons.local_laundry_service),
                              _buildTextField(_biblioController, 'Bibliothèque', isNumber: true, icon: Icons.book),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: ElevatedButton(
                  onPressed: _saveMenage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1660B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
