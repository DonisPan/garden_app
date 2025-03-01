import 'package:flutter/material.dart';
import 'package:garden_app/models/supabase.dart';
import 'package:garden_app/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Clear previous errors
    });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      _errorMessage = validate(email, password);

      if (_errorMessage != null) {
        return;
      }

      // TODO: Implement authentication logic here (e.g., Supabase, Firebase)
      String? response = await SupabaseService().login(email, password);
      if (response != null) {
        setState(() {
          _errorMessage = response;          
        });
      } else {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
      // print("Logging in with $email");
    }

    String? validate(String email, String password) {
      if (email.isEmpty || password.isEmpty) {        
        return "Email and password cannot be empty.";
      }

      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
        return "Invalid email format.";
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Display error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            // 🔹 Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
