import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'joke_list_screen.dart';
import 'random_joke_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService apiService = ApiService();
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke types'),
        actions: [
          IconButton(
            icon: Icon(Icons.sentiment_very_satisfied),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RandomJokeScreen()),
              );
            },
          )
        ],
      ),
      body: jokeTypes.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JokeListScreen(type: type),
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
