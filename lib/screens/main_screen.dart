import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'joke_list_screen.dart';
import 'random_joke_screen.dart';
import 'favorite_jokes_screen.dart';
import '../models/joke.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService apiService = ApiService();
  List<String> jokeTypes = [];
  List<Joke> favoriteJokes = []; // List to store favorite jokes

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

  @override
  Widget build(BuildContext context) {
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
