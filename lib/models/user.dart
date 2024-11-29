class User {
  final String userId;

  User({
    required this.userId,
  });

  Map<String, Object?> toMap() {
    return {
      'userId': userId,
    };
  }
}
