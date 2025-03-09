import 'package:flutter/cupertino.dart';
import 'package:garden_app/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;
  LoginViewModel(this.repository);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners(); // Notify UI to update loading state

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    _errorMessage = validate(email, password);

    if (_errorMessage == null) {
      String? response = await repository.login(email, password);
      if (response != null) {
        _errorMessage = response;
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }

    _isLoading = false;
    notifyListeners(); // Notify UI of the new state
  }

  String? validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return "Email and password cannot be empty.";
    }

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      return "Invalid email format.";
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
