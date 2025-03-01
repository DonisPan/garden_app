import 'package:flutter/material.dart';
import 'package:garden_app/models/supabase.dart';
import 'package:garden_app/screens/home.dart';
import 'package:garden_app/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    setState(() { _errorMessage = null; }); // reset error message

      String email = _emailField.text.trim();
      String password = _passwordField.text.trim();
      _errorMessage = validate(email, password); // validate error message

      if (_errorMessage != null) { return; } // only try to login when there is no error

      String? response = await SupabaseService().login(email, password);
      if (response != null) {
        setState(() { _errorMessage = response; }); // update error message
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        ); // redirect to home page after successfull login
      }
    }

    String? validate(String email, String password) {
      if (email.isEmpty || password.isEmpty) {        
        return "Email and password cannot be empty.";
      }

      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
        return "Invalid email format.";
      }

      return null;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Email field
              Container(
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 216, 216, 216),
                      blurRadius: 30,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailField,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Your email...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 216, 216, 216),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password field
              Container(
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 216, 216, 216),
                      blurRadius: 30,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordField,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Your password...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 216, 216, 216),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              // Login button
              Container(
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 216, 216, 216),
                      blurRadius: 30,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 10),

              // Bottom buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Go back button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),

                  // Register button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
