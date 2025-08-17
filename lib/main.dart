import 'package:delivery/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery/pages/splash.dart';
import 'package:delivery/pages/home.dart';
import 'package:delivery/pages/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',

      // ✅ Light Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        cardColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,     // all normal text = black
          displayColor: Colors.black,  // all headings/titles = black
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
      ),

      // ✅ Dark Theme (everything dark background, all text white)
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black, // dark background
        cardColor: Colors.grey.shade900, // dark cards
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,     // all normal text = white
          displayColor: Colors.white,  // all headings/titles = white
        ),
        iconTheme: const IconThemeData(color: Colors.white), // icons white
        cardTheme: const CardThemeData(
          color: Color(0xFF212121), // very dark card
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Color(0xFF424242)), // subtle border
          ),
        ),
      ),

      themeMode: themeProvider.themeMode, // controlled by provider

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const Login(),
      },
    );
  }
}
