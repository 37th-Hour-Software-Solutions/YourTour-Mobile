import 'package:lucid_validation/lucid_validation.dart';

class UsernameValidator extends LucidValidator<String> {

  UsernameValidator() {
    ruleFor((username) => username, key: 'username')
      .notEmpty(message: 'Please enter your username')
      .minLength(3, message: 'Username must be at least 3 characters')
      .maxLength(20, message: 'Username must be at most 20 characters')
      .matchesPattern(r'^[a-zA-Z0-9_]+$', message: 'Username can only contain letters, numbers, and underscores');
  }
}
