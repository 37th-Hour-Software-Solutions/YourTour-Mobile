class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String phone;
  final String homestate;
  final List<String> interests;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    required this.homestate,
    required this.interests,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
    'phone': phone,
    'homestate': homestate,
    'interests': interests,
  };
} 