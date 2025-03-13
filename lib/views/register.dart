import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:garden_app/viewmodels/register_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  Future<void> _selectProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    var status = await Permission.photos.request();

    if (status.isGranted) {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final file = File(pickedImage.path);
        Provider.of<RegisterViewModel>(
          context,
          listen: false,
        ).setProfilePicture(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(AuthRemoteRepository()),
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // profile picture
                      Center(
                        child: GestureDetector(
                          onTap: () => _selectProfilePicture(context),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                viewModel.profilePicture != null
                                    ? FileImage(viewModel.profilePicture!)
                                    : null,
                            child:
                                viewModel.profilePicture == null
                                    ? const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // name and surname
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              controller: viewModel.nameController,
                              hintText: "Your name",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInputField(
                              controller: viewModel.surnameController,
                              hintText: "Your surname",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // email
                      _buildInputField(
                        controller: viewModel.emailController,
                        hintText: "Your email...",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      _buildInputField(
                        controller: viewModel.passwordController,
                        hintText: "Your password...",
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),

                      // Error Message
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 10),
                          child: Text(
                            viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      // Register Button
                      _buildRegisterButton(viewModel, context),

                      const SizedBox(height: 10),

                      // Bottom Buttons (Back)
                      Row(
                        children: [
                          TextButton(
                            onPressed:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
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

  Widget _buildRegisterButton(
    RegisterViewModel viewModel,
    BuildContext context,
  ) {
    return Container(
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
        onPressed:
            viewModel.isLoading ? null : () => viewModel.register(context),
        child:
            viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Register", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
