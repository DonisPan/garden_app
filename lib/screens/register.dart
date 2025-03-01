import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameField = TextEditingController();
  final TextEditingController _surnameField = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {

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
                "Register",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Go back button
                  Expanded(
                    child: Container(
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
                      controller: _nameField,
                      // keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Your name",
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
                  ),
                const SizedBox(height: 15),

                  // Register button
                  Expanded(
                    child: Container(
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
                      controller: _surnameField,
                      // keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Your surname",
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
                  ),
                const SizedBox(height: 15),
                ],
              ),

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
                  onPressed: _register,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}