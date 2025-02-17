class User {
  final String username;
  final String email;
  final String phone;
  final String homestate;
  final String profilePictureBlob;

  // List of JSON objects
  final List<dynamic> badges;
  final List<dynamic> gems;
  final List<dynamic> interests;

  final int gemsFound;
  final int badgesFound;
  final int citiesFound;
  final int statesFound;

  const User({
    required this.username,
    required this.email,
    required this.phone,
    required this.homestate,
    required this.profilePictureBlob,
    required this.badges,
    required this.gems,
    required this.interests,
    required this.gemsFound,
    required this.badgesFound,
    required this.citiesFound,
    required this.statesFound,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      homestate: json['homestate'],
      profilePictureBlob: json['profilePictureBlob'],
      badges: json['badges'],
      gems: json['gems'],
      interests: json['interests'],
      gemsFound: json['gemsFound'],
      badgesFound: json['badgesFound'],
      citiesFound: json['citiesFound'],
      statesFound: json['statesFound'],
    );
  }

  Map<String, dynamic> toJson(String password, String oldPassword) {

    if (password == '') {
      return {
        'username': username,
        'email': email,
        'phone': phone,
        'homestate': homestate,
        'interests': interests.map((interest) => interest['name']).toList(),
      };
    }

    return {
      'username': username,
      'email': email,
      'phone': phone,
      'homestate': homestate,
      'interests': interests.map((interest) => interest['name']).toList(),
      'password': password,
      'oldPassword': oldPassword,
    };
  }
} 