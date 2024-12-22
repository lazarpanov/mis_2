import 'package:flutter/material.dart';
import '../models/joke.dart';

class FavoriteJokesScreen extends StatefulWidget {
  final List<Joke> favoriteJokes;
  final Function(Joke) removeFromFavorites;

  FavoriteJokesScreen({
    required this.favoriteJokes,
    required this.removeFromFavorites,
  });

  @override
  _FavoriteJokesScreenState createState() => _FavoriteJokesScreenState();
}

class _FavoriteJokesScreenState extends State<FavoriteJokesScreen> {
  late List<Joke> displayedFavorites;

  @override
  void initState() {
    super.initState();
    displayedFavorites = List.from(widget.favoriteJokes);
  }

  void removeJoke(Joke joke) {
    setState(() {
      displayedFavorites.remove(joke);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jokes'),
      ),
      body: displayedFavorites.isEmpty
          ? Center(
        child: Text(
          'No favorites yet!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: displayedFavorites.length,
        itemBuilder: (context, index) {
          final joke = displayedFavorites[index];
          return Card(
            child: ListTile(
              title: Text(
                joke.setup,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                joke.punchline,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  removeJoke(joke);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed from favorites!')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
