class Plant {
  final int _id;
  final String _name;
  final String? _note;
  final String? _plantClass;
  final String? _familyCommon;
  final String? _familyScientific;
  final bool _isCustom;

  Plant({
    required int id,
    required String name,
    String? note,
    required String plantClass,
    required String familyCommon,
    required String familyScientific,
    required bool isCustom,
  }) : _id = id,
       _name = name,
       _note = note,
       _plantClass = plantClass,
       _familyCommon = familyCommon,
       _familyScientific = familyScientific,
       _isCustom = isCustom;

  int get id => _id;
  String get name => _name;
  String? get note => _note;
  String? get plantClass => _plantClass;
  String? get familyCommon => _familyCommon;
  String? get familyScientific => _familyScientific;
  bool get isCustom => _isCustom;
}
