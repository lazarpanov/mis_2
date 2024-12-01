class JokeType {
  final String type;

  JokeType({required this.type});

  factory JokeType.fromJson(String json) {
    return JokeType(type: json);
  }
}
