import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/api_services.dart';
import 'joke_list_screen.dart';
import 'random_joke_screen.dart';
import 'favorite_jokes_screen.dart';
import '../models/joke.dart';
import '../services/notification_service.dart'; // Import NotificationService
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService apiService = ApiService();
  List<String> jokeTypes = [];
  List<Joke> favoriteJokes = []; // List to store favorite jokes
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
    notificationService = NotificationService(); // Initialize NotificationService
    notificationService.initNotification(); // Initialize notifications

    // Request permission for notifications
    notificationService.requestPermissions();
  }

  void fetchJokeTypes() async {
    try {
      final types = await apiService.getJokeTypes();
      setState(() {
        jokeTypes = types;
      });
    } catch (e) {
      print('Error fetching joke types: $e');
    }
  }

  void addToFavorites(Joke joke) {
    setState(() {
      if (!favoriteJokes.contains(joke)) {
        favoriteJokes.add(joke);
      }
    });
  }

  void removeFromFavorites(Joke joke) {
    setState(() {
      favoriteJokes.remove(joke);
    });
  }

  // Function to handle sign out
  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen after sign out
  }

  // Function to send a test notification
  Future<void> sendTestNotification() async {
    final now = DateTime.now();
    final scheduledDate = now.add(const Duration(seconds: 5)); // Notification in 5 seconds

    // Schedule a notification using NotificationService
    await notificationService.notificationsPlugin.zonedSchedule(
      1, // Notification ID
      'Test Notification',
      'This is a test notification.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          channelDescription: 'Channel for testing notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Show a snack bar with a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification scheduled in 5 seconds!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = _auth.currentUser;

    // If no user is logged in, show login prompt
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Joke Categories'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Please log in to view jokes'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RandomJokeScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoriteJokesScreen(
                    favoriteJokes: favoriteJokes,
                    removeFromFavorites: removeFromFavorites,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: sendTestNotification, // Trigger test notification
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: signOut, // Sign out functionality
          ),
        ],
      ),
      body: jokeTypes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          final type = jokeTypes[index];
          return Card(
            child: ListTile(
              title: Text(
                type,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.teal),
              onTap: () async {
                final jokes = await apiService.getJokesByType(type);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JokeListScreen(
                      type: type,
                      jokes: jokes,
                      addToFavorites: addToFavorites,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
