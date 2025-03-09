import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_remote_repositary.dart';
import 'package:garden_app/viewmodels/login_viewmodel.dart';
import 'package:garden_app/views/register.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthRepositaryRemote()),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
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
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email field
                    _buildTextField(
                      controller: viewModel.emailController,
                      hintText: "Your email...",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Password field
                    _buildTextField(
                      controller: viewModel.passwordController,
                      hintText: "Your password...",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),

                    // Error message
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

                    // Login button
                    _buildLoginButton(viewModel, context),

                    const SizedBox(height: 10),

                    // Bottom buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Back",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              ),
                          child: const Text(
                            "Create an account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
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

  Widget _buildLoginButton(LoginViewModel viewModel, BuildContext context) {
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
        onPressed: viewModel.isLoading ? null : () => viewModel.login(context),
        child:
            viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Login", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
