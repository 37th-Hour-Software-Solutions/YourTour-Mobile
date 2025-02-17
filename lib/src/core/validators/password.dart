import 'package:lucid_validation/lucid_validation.dart';

class PasswordValidator extends LucidValidator<String> {

  PasswordValidator() {
    ruleFor((password) => password, key: 'password')
      .notEmpty(message: 'Please enter your password')
      .minLength(8, message: 'Password must be at least 8 characters')
      .mustHaveUppercase(message: 'Password must have at least one uppercase letter')
      .mustHaveLowercase(message: 'Password must have at least one lowercase letter')
      .mustHaveNumber(message: 'Password must have at least one number')
      .mustHaveSpecialCharacter(message: 'Password must have at least one special character');
  }
}
