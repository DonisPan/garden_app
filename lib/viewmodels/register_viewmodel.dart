import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  RegisterViewModel({required this.authRepository});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? profilePicture;

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // update profile picture
  void setProfilePicture(File file) {
    profilePicture = file;
    notifyListeners();
  }

  // validation
  String? validate(String name, String surname, String email, String password) {
    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty) {
      return "All fields are required.";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      return "Invalid email format.";
    }
    return null;
  }

  Future<void> register(BuildContext context) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    _errorMessage = validate(name, surname, email, password);
    if (_errorMessage != null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final String? response = await authRepository.register(
      email,
      password,
      name,
      surname,
    );
    if (response != null) {
      _errorMessage = response;
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
