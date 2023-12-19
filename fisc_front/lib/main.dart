import 'package:flutter/material.dart';
import 'login_page.dart'; // Assuming you have a LoginPage
import 'dashboard_page.dart'; // The file where your DashboardScreen is defined

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner:
          false, // Assuming the user starts at the LoginPage
      routes: {
        '/dashboard': (context) => DashboardPage(), // Route for DashboardScreen
      },
    );
  }
}
