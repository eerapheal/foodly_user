class CheckStore {
  /// Method to check if the input string is a valid food ID
  /// A valid food ID is 24 characters long and contains both letters and numbers.
  static bool isValidStoreId(String input) {
    // Check if the length of the input is exactly 24 characters
    if (input.length != 24) {
      return false;
    }

    // Check if the input contains at least one letter and one number
    bool hasLetter = input.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = input.contains(RegExp(r'[0-9]'));

    // Return true if both conditions are met
    return hasLetter && hasNumber;
  }
}
