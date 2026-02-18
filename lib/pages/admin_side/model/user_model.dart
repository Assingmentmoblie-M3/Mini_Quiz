class User {
  final int userId;
  final String email;
  final int roleId;
  final bool status;
  final DateTime createdAt;
  User({
    required this.userId,
    required this.email,
    required this.roleId,
    required this.status,
    required this.createdAt,
  });

  // from JSON (API → Flutter)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      roleId: json['role_id'],
      status: json['status'] == true || json['status'] == 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // to JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'role_id': roleId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
