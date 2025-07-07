import 'package:flutter/material.dart';
import 'package:delivery/components/app_button.dart';
import 'package:delivery/components/input_textfield.dart';
import 'package:delivery/pages/home.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final userdetailsController = TextEditingController();
  final passController = TextEditingController();

  void userSignIn(BuildContext context) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 60),
                Text(
                  'Welcome to LEDGERCTRL',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
                const SizedBox(height: 10),
                InputTextfield(
                  controller: userdetailsController,
                  hintText: 'Simomutu8@gmail.com',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                InputTextfield(
                  controller: passController,
                  hintText: '@password123>;',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.blue[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () => userSignIn(context), // Pass context here
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}