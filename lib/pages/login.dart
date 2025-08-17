import 'package:flutter/material.dart';
import 'package:delivery/components/app_button.dart';
import 'package:delivery/components/input_textfield.dart';
import 'package:delivery/pages/home.dart';
import 'package:delivery/services/session_manager.dart';
import 'package:delivery/services/location_service.dart';
import 'package:delivery/services/ApiService.dart';
import 'package:delivery/constants/app_constants.dart';

import '../services/ApiService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userdetailsController = TextEditingController();
  final passController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> userSignIn(BuildContext context) async {
    final String user = userdetailsController.text.trim();
    final String password = passController.text.trim();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Logging in..."),
          ],
        ),
      ),
    );

    try {
      final response = await ApiService.rawPost(
        AppConstants.loginEndpoint,
        {
          "usr": user,
          "passwd": password,
        },
      );

      Navigator.of(context).pop(); // close loader

      if (response['message'] != null &&
          response['message']['success_key'] == 1) {
        final sid = response['sid'];
        final apiKey = response['message']['api_key'] ?? '';
        final apiSecret = response['message']['api_secret'] ?? '';
        final username = response['message']['username'] ?? user;
        final email = response['message']['email'] ?? '';

        // ✅ Save session immediately after login
        await SessionManager.saveSession(
          sid: sid,
          apiKey: apiKey,
          apiSecret: apiSecret,
          username: username,
          email: email,
        );

        // 🔍 Now check if user is enabled
        try {
          final endpoint = "/api/resource/User/$username";
          debugPrint("Fetching user info from: $endpoint");

          final userInfo = await ApiService.get(endpoint);
          debugPrint("User info response: $userInfo");

          if (userInfo['data']?['enabled'] == 0) {
            _showErrorDialog(context, "Your account is disabled. Contact admin.");
            return;
          }
        } catch (e) {
          debugPrint("Error fetching user info: $e");
          _showErrorDialog(context, "Could not verify user status. Try again.");
          return;
        }

        if (!context.mounted) return;

        await LocationService.requestPermissionIfNeeded();

        // ✅ Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        final errorMessage =
            response['message']?['message'] ?? 'Login failed.';
        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      Navigator.of(context).pop(); // close loader if still open
      _showErrorDialog(context, "Network error. Could not reach the server.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
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
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () => userSignIn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
