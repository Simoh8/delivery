import 'package:flutter/material.dart';
import 'package:delivery/pages/splash.dart';
import 'package:delivery/pages/home.dart';
import 'package:delivery/pages/login.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const Login(),
      },
    );
  }
}
