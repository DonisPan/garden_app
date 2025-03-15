class Profile {
  String _name;
  String _surname;

  Profile({required String name, required String surname})
    : _name = name,
      _surname = surname;

  String get name => _name;
  String get surname => _surname;
  set name(String par) => _name = par;
  set surname(String par) => _surname = par;
}
