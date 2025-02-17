import 'package:lucid_validation/lucid_validation.dart';

class PhoneValidator extends LucidValidator<String> {

  PhoneValidator() {
    ruleFor((phone) => phone, key: 'phone')
      .notEmpty(message: 'Please enter your phone number')
      .matchesPattern(r'^\d{10}$', message: 'Please enter a valid phone number in the format 1234567890');
  }
}
