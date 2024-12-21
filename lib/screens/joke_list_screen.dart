import 'package:flutter/material.dart';
import '../models/joke.dart';

class JokeListScreen extends StatelessWidget {
  final String type;
  final List<Joke> jokes;
  final Function(Joke) addToFavorites;

  JokeListScreen({
    required this.type,
    required this.jokes,
    required this.addToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Jokes'),
      ),
      body: jokes.isEmpty
          ? Center(
        child: Text(
          'No jokes found.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
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
                icon: Icon(Icons.favorite_border, color: Colors.teal),
                onPressed: () {
                  addToFavorites(joke);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to favorites!')),
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
