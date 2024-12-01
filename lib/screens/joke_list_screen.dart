import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke.dart';

class JokeListScreen extends StatelessWidget {
  final String type;
  final ApiService apiService = ApiService();

  JokeListScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type jokes'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: apiService.getJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final jokes = snapshot.data!;
          return ListView.builder(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
