import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mis_2/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/notification_service.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

final NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await notificationService.initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
        appBarTheme: AppBarTheme(
          color: Colors.teal,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.teal[600]),
          headlineSmall: TextStyle(
            color: Colors.teal[800],
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Dynamically choose the home screen based on the authentication state
      home: AuthGate(),
    );
  }
}

// AuthGate widget to handle user authentication state
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Check if the user is signed in
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          notificationService.scheduleJokeNotification();
          return MainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
