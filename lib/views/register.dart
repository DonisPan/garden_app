import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:garden_app/repositories/auth_repository.dart';
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
    return ChangeNotifierProvider<RegisterViewModel>(
      create:
          (_) => RegisterViewModel(
            authRepository: Provider.of<AuthRepository>(context, listen: false),
          ),
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // password
                    _buildInputField(
                      controller: viewModel.passwordController,
                      hintText: "Your password...",
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    // error message
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
                    // register button
                    _buildRegisterButton(viewModel, context),
                    const SizedBox(height: 10),
                    // bottom button
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Back",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  // register button
  Widget _buildRegisterButton(
    RegisterViewModel viewModel,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.black,
        ),
        onPressed:
            viewModel.isLoading ? null : () => viewModel.register(context),
        child:
            viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  "Register",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
      ),
    );
  }
}
