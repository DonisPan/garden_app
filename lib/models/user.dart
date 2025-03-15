class User {
  final String _name;
  final String _surname;

  User({required String name, required String surname})
    : _name = name,
      _surname = surname;

  get name => _name;
  get surname => _surname;
}
