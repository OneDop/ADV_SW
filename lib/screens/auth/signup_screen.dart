import 'package:flutter/material.dart';
import 'package:advsw/screens/auth/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final Color primaryTeal = const Color(0xFF004253);
  final Color grayText = const Color(0xFF6E797C);
  final Color bgColor = const Color(0xFFF2F4F6);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                SizedBox(height: 16),
                Text('Welcome to NAME',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
                ),
                SizedBox(height: 5),
                Text(
                  'yap yap yap yap',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                      boxShadow:[ BoxShadow(color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: Offset(0, 8))
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildLabel(label: "FIRST NAME"),
                      BuildTextField(
                        controller: _firstNameController,
                        hint: "First Name",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BuildLabel(label: "LAST NAME"),
                      BuildTextField(
                        controller: _lastNameController,
                        hint: "Last Name",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BuildLabel(label: "EMAIL ADDRESS"),
                      BuildTextField(
                        controller: _emailController,
                        hint: "name@moqam.com",
                        icon: Icons.mail_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BuildLabel(label: "PASSWORD"),
                      BuildTextField(
                        controller: _passwordController,
                        hint: "••••••••",
                        icon: Icons.lock_outline,
                        ispassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (value.length < 6) {
                            return 'At least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BuildLabel(label: "CONFIRM PASSWORD"),
                      BuildTextField(
                        controller: _confirmPasswordController,
                        hint: "••••••••",
                        icon: Icons.lock_clock_outlined,
                        ispassword: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryTeal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ", style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Log In", style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
