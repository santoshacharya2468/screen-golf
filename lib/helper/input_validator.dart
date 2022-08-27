import 'package:massageapp/get_localization.dart';

class InputValidators {
  static final RegExp nameRegExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);

  static final RegExp numberReg = new RegExp(r'(^(?:[+0]9)?[0-9]{8,14}$)');
  static final RegExp passwordReg = new RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  static final emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static String? validatePassword(String? password,
      {int minCharacter = 8, bool isRegEx = false}) {
    if (isRegEx) {
      if (passwordReg.hasMatch(password ?? '')) {
        return null;
      } else {
        return 'Password should be the combination of uppercase and lowercase letter,number, special character and minimun lenght of 8';
      }
    }

    return password!.isEmpty
        ? translator.required
        : password.length < minCharacter
            ? '${translator.minimum} $minCharacter ${translator.characters}'
            : null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return translator.required;
    return !emailRegEx.hasMatch(email) ? translator.invalidEmail : null;
  }

  static String? validateEmailOrPhone(String? emailOrPhone) {
    if (emailOrPhone == null || emailOrPhone.isEmpty) return translator.required;
    var emailValidationResult = validateEmail(emailOrPhone);
    if (emailValidationResult == null) {
      return null;
    }
    var phoneValidationResult = validatePhoneNumber(emailOrPhone);
    if (phoneValidationResult == null) {
      return null;
    }
    return 'Invalid Email or Phone';
  }

  static String? validatePhoneNumber(String? number) {
    return number == null || number.isEmpty
        ? translator.required
        : numberReg.hasMatch(number)
            ? null
            : translator.invalid;
  }

  static String? validateNoOfClients(String? clientsNo) {
    return clientsNo == null || clientsNo.isEmpty
        ? translator.register
        : isNumeric(clientsNo)
            ? null
            : translator.invalid;
  }

  static String? validateName(String? name, {int minLength = 3}) {
    print(nameRegExp.hasMatch(name ?? ''));
    return name == null || name.isEmpty
        ? translator.required
        : null;
  }

  static String? validateNoEmpty(String? value,
      [int minLength = 1, String fieldName = 'This']) {
    if (value == null || value.isEmpty)
      return  '${translator.required}';
    else if (value.length < minLength)
      return '${translator.minimum} $minLength ${translator.characters}  ${translator.required}';
    return null;
  }

  static String? validateUserName(String? username) {
    if (username == null || username.isEmpty) {
      return translator.required;
    } else if (username.length < 6) {
      return '${translator.minimum}:6 ${translator.characters}';
    }
    return null;
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  try {
    double.parse(s);
    return true;
  } catch (e) {
    return false;
  }
}
