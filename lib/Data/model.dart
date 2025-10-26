class AuthModel {
  final String email;
  final String password;

  const AuthModel({
    required this.email,
    required this.password,
  });

  // Factory constructor for creating from JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Email validation
  bool get isEmailValid {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password validation (minimum 6 characters)
  bool get isPasswordValid {
    return password.length >= 6;
  }

  // Check if both email and password are valid
  bool get isValid {
    return isEmailValid && isPasswordValid;
  }

  // Copy with method for immutability
  AuthModel copyWith({
    String? email,
    String? password,
  }) {
    return AuthModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'AuthModel(email: $email, password: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthModel &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
