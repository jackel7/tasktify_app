class User {
  final String email;
  final String userName;
  final DateTime createdAt;

  User({
    required this.email,
    required this.userName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userName': userName,
      'createdAt':
          createdAt.microsecondsSinceEpoch,
    };
  }

  factory User.fromMap(
    Map<String, dynamic> data,
  ) {
    return User(
      email: data['email'] ?? '',
      userName: data['userName'],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(
            data['createdAt'],
          ),
    );
  }
}
