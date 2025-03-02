import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garden_app/screens/login.dart';
import 'package:garden_app/models/supabase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  File? _profilePicture;
  Future<void> _selectProfilePicture() async {
    final picker = ImagePicker();

    var status = await Permission.photos.request(); // ask for permissions

    if (status.isGranted) {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _profilePicture = File(pickedImage.path);
        });
      }
    }
  }

  final TextEditingController _nameField = TextEditingController();
  final TextEditingController _surnameField = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  String? _errorMessage;
  Future<void> _register() async {
      setState(() { _errorMessage = null; }); // reset error message

      String name = _nameField.text.trim();
      String surname = _surnameField.text.trim();
      String email = _emailField.text.trim();
      String password = _passwordField.text.trim();
      // _errorMessage = validate(email, password); // validate error message

      if (_errorMessage != null) { return; } // only try to login when there is no error
      
      String? response = await SupabaseService().register(email, password, name, surname);
      if (response != null) {
        setState(() { _errorMessage = response; }); // update error message
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        ); // redirect to login page after successfull register
      }
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

              // 📸 Profile Picture Picker
              Center(
                child: GestureDetector(
                  onTap: _selectProfilePicture,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profilePicture != null ? FileImage(_profilePicture!) : null,
                    child: _profilePicture == null
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name & Surname Row
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(_nameField, "Your name"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(_surnameField, "Your surname"),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Email Field
              _buildInputField(_emailField, "Your email...", keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),

              // Password Field
              _buildInputField(_passwordField, "Your password...", isPassword: true),
              const SizedBox(height: 10),

              // 🔹 Display error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              // 🔹 Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _register,
                  child: const Text("Register", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Bottom Buttons (Back)
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper Function to Build Input Fields
  Widget _buildInputField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
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
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
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
    );
  }
}