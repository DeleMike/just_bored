/// App's String methods
extension StringExtension on String {
  /// check if email is valid
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  /// check for a valid password
  bool get isValidPassword {
    final passwordRegExp = RegExp(r'(?=.{8,})'); // checks if password has 8 characters long
    return passwordRegExp.hasMatch(this);
  }

  /// check for a valid name
  bool get isValidName {
    return !isNumeric() && !contains(RegExp(r'(\d+)')); // is not numeric and does not contain numbers
  }

  /// check if a string is a number
  bool isNumeric() {
    return int.tryParse(this) != null;
  }
}
