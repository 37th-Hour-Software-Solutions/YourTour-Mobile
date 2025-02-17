import 'package:lucid_validation/lucid_validation.dart';

class EmailValidator extends LucidValidator<String> {

  EmailValidator() {
    ruleFor((email) => email, key: 'email')
      .notEmpty(message: 'Please enter your email')
      .validEmail(message: 'Please enter a valid email');
  }
}